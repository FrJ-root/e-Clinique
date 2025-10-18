package com.clinique.controller.doctor;

import com.clinique.dto.AppointmentDTO;
import com.clinique.dto.DoctorDTO;
import com.clinique.dto.UserDTO;
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

public class DoctorAppointmentsController {

    private final AppointmentService appointmentService;
    private final DoctorService doctorService;
    private final PatientService patientService;

    public DoctorAppointmentsController() {
        this.appointmentService = new AppointmentService();
        this.doctorService = new DoctorService();
        this.patientService = new PatientService();
    }

    public Map<String, Object> getAppointmentsData(HttpServletRequest request) {
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
            String filter = request.getParameter("filter");
            String dateRangeStr = request.getParameter("dateRange");
            LocalDate startDate = null;
            LocalDate endDate = null;

            if (dateRangeStr != null && !dateRangeStr.trim().isEmpty()) {
                String[] dates = dateRangeStr.split(" - ");
                if (dates.length == 2) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                    try {
                        startDate = LocalDate.parse(dates[0], formatter);
                        endDate = LocalDate.parse(dates[1], formatter);
                    } catch (Exception e) {
                        // Invalid date format, ignore
                    }
                }
            }

            // Default to today if no valid dates
            if (startDate == null || endDate == null) {
                startDate = LocalDate.now();
                endDate = startDate.plusDays(7); // Default to next 7 days
            }

            // Get appointments based on filter
            List<AppointmentDTO> appointments;
            if ("today".equals(filter)) {
                appointments = appointmentService.getAppointmentsByDoctorAndDate(doctor.getId(), LocalDate.now());
                result.put("filterTitle", "Rendez-vous d'aujourd'hui");
            } else if ("upcoming".equals(filter)) {
                appointments = appointmentService.findUpcomingByDoctor(doctor.getId());
                result.put("filterTitle", "Rendez-vous à venir");
            } else if ("past".equals(filter)) {
                appointments = appointmentService.findPastByDoctor(doctor.getId());
                result.put("filterTitle", "Rendez-vous passés");
            } else if ("dateRange".equals(filter) && startDate != null && endDate != null) {
                appointments = appointmentService.getAppointmentsByDoctorAndDateRange(doctor.getId(), startDate, endDate);
                result.put("filterTitle", "Rendez-vous du " + startDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) +
                        " au " + endDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
            } else {
                // Default to all appointments with more recent first
                appointments = appointmentService.getAllByDoctor(doctor.getId());
                result.put("filterTitle", "Tous les rendez-vous");
            }

            // Group appointments by status
            Map<AppointmentStatus, List<AppointmentDTO>> appointmentsByStatus = appointments.stream()
                    .collect(Collectors.groupingBy(AppointmentDTO::getStatut));

            // Count by status
            Map<String, Integer> countByStatus = new HashMap<>();
            countByStatus.put("PLANNED", appointmentsByStatus.getOrDefault(AppointmentStatus.PLANNED, Collections.emptyList()).size());
            countByStatus.put("DONE", appointmentsByStatus.getOrDefault(AppointmentStatus.DONE, Collections.emptyList()).size());
            countByStatus.put("CANCELED", appointmentsByStatus.getOrDefault(AppointmentStatus.CANCELED, Collections.emptyList()).size());
            countByStatus.put("TOTAL", appointments.size());

            // Set result data
            result.put("success", true);
            result.put("doctor", doctor);
            result.put("appointments", appointments);
            result.put("appointmentsByStatus", appointmentsByStatus);
            result.put("countByStatus", countByStatus);
            result.put("filter", filter != null ? filter : "all");
            result.put("startDate", startDate);
            result.put("endDate", endDate);

        } catch (Exception ex) {
            ex.printStackTrace();
            result.put("success", false);
            result.put("error", "Erreur lors du chargement des rendez-vous: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> updateAppointmentStatus(HttpServletRequest request) {
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

            // Get appointment ID and new status
            String appointmentIdStr = request.getParameter("appointmentId");
            String statusStr = request.getParameter("status");

            if (appointmentIdStr == null || statusStr == null) {
                result.put("success", false);
                result.put("error", "Paramètres manquants");
                return result;
            }

            UUID appointmentId;
            try {
                appointmentId = UUID.fromString(appointmentIdStr);
            } catch (IllegalArgumentException e) {
                result.put("success", false);
                result.put("error", "ID de rendez-vous invalide");
                return result;
            }

            AppointmentStatus newStatus;
            try {
                newStatus = AppointmentStatus.valueOf(statusStr);
            } catch (IllegalArgumentException e) {
                result.put("success", false);
                result.put("error", "Statut invalide");
                return result;
            }

            // Get optional note
            String note = request.getParameter("note");

            // Update appointment status
            AppointmentDTO updatedAppointment = appointmentService.updateAppointmentStatus(
                    appointmentId, doctor.getId(), newStatus, note);

            result.put("success", true);
            result.put("appointment", updatedAppointment);
            result.put("message", "Statut du rendez-vous mis à jour avec succès");

        } catch (Exception ex) {
            ex.printStackTrace();
            result.put("success", false);
            result.put("error", "Erreur lors de la mise à jour du statut: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> getAppointmentDetails(HttpServletRequest request) {
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

            // Get appointment ID
            String appointmentIdStr = request.getParameter("appointmentId");

            if (appointmentIdStr == null) {
                result.put("success", false);
                result.put("error", "ID de rendez-vous manquant");
                return result;
            }

            UUID appointmentId;
            try {
                appointmentId = UUID.fromString(appointmentIdStr);
            } catch (IllegalArgumentException e) {
                result.put("success", false);
                result.put("error", "ID de rendez-vous invalide");
                return result;
            }

            // Get appointment details
            AppointmentDTO appointment = appointmentService.getAppointment(appointmentId);

            // Security check - verify this appointment belongs to the doctor
            if (!appointment.getDoctorId().equals(doctor.getId())) {
                result.put("success", false);
                result.put("error", "Vous n'êtes pas autorisé à voir ce rendez-vous");
                return result;
            }

            // Get patient details (optional)
            result.put("success", true);
            result.put("appointment", appointment);

            // Try to get medical notes if present
            try {
                if (appointment.isHasMedicalNote()) {
                    result.put("medicalNote", appointmentService.getMedicalNote(appointmentId));
                }
            } catch (Exception e) {
                // Just log the error but continue
                System.err.println("Error retrieving medical note: " + e.getMessage());
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des détails: " + ex.getMessage());
        }

        return result;
    }
}