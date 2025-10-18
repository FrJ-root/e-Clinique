package com.clinique.controller.doctor;

import com.clinique.dto.*;
import com.clinique.enums.AppointmentStatus;
import com.clinique.service.AppointmentService;
import com.clinique.service.DoctorService;
import com.clinique.service.PatientService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

public class PatientHistoryController {

    private final PatientService patientService;
    private final DoctorService doctorService;
    private final AppointmentService appointmentService;

    public PatientHistoryController() {
        this.patientService = new PatientService();
        this.doctorService = new DoctorService();
        this.appointmentService = new AppointmentService();
    }

    public Map<String, Object> getPatientHistoryData(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Session invalide");
                return result;
            }

            Object userObj = session.getAttribute("user");
            DoctorDTO doctor = null;

            if (userObj instanceof DoctorDTO) {
                doctor = (DoctorDTO) userObj;
            } else if (userObj instanceof UserDTO) {
                UserDTO userDTO = (UserDTO) userObj;
                if ("DOCTOR".equals(userDTO.getRole())) {
                    doctor = doctorService.findByUserId(userDTO.getId());
                }
            }

            if (doctor == null) {
                result.put("success", false);
                result.put("error", "Médecin non trouvé");
                return result;
            }

            // Get filter parameters
            String timeFilter = request.getParameter("timeFilter");
            String dateRangeStr = request.getParameter("dateRange");
            String statusFilter = request.getParameter("statusFilter");
            LocalDate startDate = null;
            LocalDate endDate = null;

            // Parse date range if provided
            if (dateRangeStr != null && !dateRangeStr.trim().isEmpty()) {
                String[] dates = dateRangeStr.split(" - ");
                if (dates.length == 2) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                    try {
                        startDate = LocalDate.parse(dates[0], formatter);
                        endDate = LocalDate.parse(dates[1], formatter);
                    } catch (Exception e) {
                        // Invalid date format, use default
                    }
                }
            }

            // Default dates based on time filter if not explicitly provided
            if (startDate == null || endDate == null) {
                LocalDate today = LocalDate.now();

                if ("last7days".equals(timeFilter)) {
                    startDate = today.minusDays(7);
                    endDate = today;
                    result.put("filterTitle", "Historique des 7 derniers jours");
                } else if ("last30days".equals(timeFilter)) {
                    startDate = today.minusDays(30);
                    endDate = today;
                    result.put("filterTitle", "Historique des 30 derniers jours");
                } else if ("last3months".equals(timeFilter)) {
                    startDate = today.minusMonths(3);
                    endDate = today;
                    result.put("filterTitle", "Historique des 3 derniers mois");
                } else if ("last6months".equals(timeFilter)) {
                    startDate = today.minusMonths(6);
                    endDate = today;
                    result.put("filterTitle", "Historique des 6 derniers mois");
                } else if ("lastyear".equals(timeFilter)) {
                    startDate = today.minusYears(1);
                    endDate = today;
                    result.put("filterTitle", "Historique de l'année passée");
                } else if ("custom".equals(timeFilter) && startDate != null && endDate != null) {
                    // Custom date range already set
                    result.put("filterTitle", "Historique du " +
                            startDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) +
                            " au " +
                            endDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
                } else {
                    // Default to all history
                    startDate = today.minusYears(10); // Far in the past
                    endDate = today;
                    result.put("filterTitle", "Historique complet");
                }
            } else {
                // Custom date range with explicit dates
                result.put("filterTitle", "Historique du " +
                        startDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) +
                        " au " +
                        endDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
            }

            // Fetch appointments based on date range
            List<AppointmentDTO> appointments = appointmentService.getAppointmentsByDoctorAndDateRange(
                    doctor.getId(), startDate, endDate);

            // Apply status filter if present
            if (statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter)) {
                try {
                    AppointmentStatus status = AppointmentStatus.valueOf(statusFilter.toUpperCase());
                    appointments = appointments.stream()
                            .filter(a -> a.getStatut() == status)
                            .collect(Collectors.toList());

                    result.put("filterTitle", result.get("filterTitle") +
                            " - " + getStatusDisplayName(statusFilter));
                } catch (IllegalArgumentException e) {
                    // Invalid status, ignore filter
                }
            }

            // Group by patient
            Map<UUID, List<AppointmentDTO>> appointmentsByPatient = appointments.stream()
                    .collect(Collectors.groupingBy(AppointmentDTO::getPatientId));

            // Get patient details for each group
            Map<UUID, PatientDTO> patientMap = new HashMap<>();
            for (UUID patientId : appointmentsByPatient.keySet()) {
                PatientDTO patient = patientService.findPatientById(patientId);
                patientMap.put(patientId, patient);
            }

            // Count appointments by status
            Map<String, Long> countByStatus = appointments.stream()
                    .collect(Collectors.groupingBy(
                            a -> a.getStatut().toString(),
                            Collectors.counting()));

            // Prepare statistics
            int totalPatients = patientMap.size();
            int totalAppointments = appointments.size();
            double avgAppointmentsPerPatient = totalPatients > 0 ?
                    (double) totalAppointments / totalPatients : 0;

            // Set result data
            result.put("success", true);
            result.put("doctor", doctor);
            result.put("startDate", startDate);
            result.put("endDate", endDate);
            result.put("appointments", appointments);
            result.put("appointmentsByPatient", appointmentsByPatient);
            result.put("patients", patientMap);
            result.put("countByStatus", countByStatus);
            result.put("totalPatients", totalPatients);
            result.put("totalAppointments", totalAppointments);
            result.put("avgAppointmentsPerPatient", avgAppointmentsPerPatient);
            result.put("timeFilter", timeFilter != null ? timeFilter : "all");
            result.put("statusFilter", statusFilter != null ? statusFilter : "all");

        } catch (Exception ex) {
            ex.printStackTrace();
            result.put("success", false);
            result.put("error", "Erreur lors du chargement de l'historique: " + ex.getMessage());
        }

        return result;
    }

    private String getStatusDisplayName(String statusCode) {
        switch (statusCode.toUpperCase()) {
            case "PLANNED": return "Rendez-vous prévus";
            case "DONE": return "Rendez-vous terminés";
            case "CANCELED": return "Rendez-vous annulés";
            default: return "Tous les rendez-vous";
        }
    }
}