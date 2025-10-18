package com.clinique.controller.doctor;

import com.clinique.dto.*;
import com.clinique.service.AppointmentService;
import com.clinique.service.DoctorService;
import com.clinique.service.PatientService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.*;
import java.util.stream.Collectors;

public class DoctorPatientsController {

    private final PatientService patientService;
    private final DoctorService doctorService;
    private final AppointmentService appointmentService;

    public DoctorPatientsController() {
        this.patientService = new PatientService();
        this.doctorService = new DoctorService();
        this.appointmentService = new AppointmentService();
    }

    public Map<String, Object> getPatientsData(HttpServletRequest request) {
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

            // Get search parameters
            String searchTerm = request.getParameter("search");
            String filter = request.getParameter("filter");

            // Fetch doctor's patients
            List<PatientDTO> allPatients = patientService.findPatientsByDoctor(doctor.getId());
            List<PatientDTO> filteredPatients;

            // Apply search and filters
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String searchLower = searchTerm.toLowerCase();
                filteredPatients = allPatients.stream()
                        .filter(p -> p.getNom().toLowerCase().contains(searchLower) ||
                                (p.getEmail() != null && p.getEmail().toLowerCase().contains(searchLower)) ||
                                (p.getTelephone() != null && p.getTelephone().contains(searchLower)))
                        .collect(Collectors.toList());

                result.put("searchTerm", searchTerm);
                result.put("searchResults", filteredPatients.size());
            } else {
                filteredPatients = allPatients;
            }

            // Apply additional filters
            if ("recent".equals(filter)) {
                // Get patients with recent appointments (last 30 days)
                filteredPatients = patientService.findRecentPatientsByDoctor(doctor.getId(), 30);
                result.put("filterTitle", "Patients récents (30 derniers jours)");
            } else if ("frequent".equals(filter)) {
                // Get patients with most appointments
                filteredPatients = patientService.findMostFrequentPatientsByDoctor(doctor.getId(), 20);
                result.put("filterTitle", "Patients les plus fréquents");
            } else {
                result.put("filterTitle", "Tous mes patients");
            }

            result.put("filter", filter != null ? filter : "all");

            // Get appointment count for each patient
            Map<UUID, Integer> appointmentCounts = new HashMap<>();
            for (PatientDTO patient : filteredPatients) {
                int count = appointmentService.countAppointmentsByDoctorAndPatient(
                        doctor.getId(), patient.getId());
                appointmentCounts.put(patient.getId(), count);
            }

            // Get statistics
            int totalPatients = allPatients.size();
            int newPatientsThisMonth = patientService.countNewPatientsByDoctorSince(
                    doctor.getId(), 30);
            int activePatients = (int) allPatients.stream()
                    .filter(PatientDTO::isActif)
                    .count();

            // Set result data
            result.put("success", true);
            result.put("doctor", doctor);
            result.put("patients", filteredPatients);
            result.put("totalPatients", totalPatients);
            result.put("newPatientsThisMonth", newPatientsThisMonth);
            result.put("activePatients", activePatients);
            result.put("appointmentCounts", appointmentCounts);

        } catch (Exception ex) {
            ex.printStackTrace();
            result.put("success", false);
            result.put("error", "Erreur lors du chargement des patients: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> getPatientDetails(HttpServletRequest request) {
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

            // Get patient ID
            String patientIdStr = request.getParameter("id");

            if (patientIdStr == null) {
                result.put("success", false);
                result.put("error", "ID de patient manquant");
                return result;
            }

            UUID patientId;
            try {
                patientId = UUID.fromString(patientIdStr);
            } catch (IllegalArgumentException e) {
                result.put("success", false);
                result.put("error", "ID de patient invalide");
                return result;
            }

            // Get patient details
            PatientDTO patient = patientService.findPatientById(patientId);

            if (patient == null) {
                result.put("success", false);
                result.put("error", "Patient non trouvé");
                return result;
            }

            // Check if this doctor has treated this patient
            boolean hasAccess = patientService.checkDoctorHasAccessToPatient(doctor.getId(), patientId);
            if (!hasAccess) {
                result.put("success", false);
                result.put("error", "Vous n'avez pas accès à ce dossier patient");
                return result;
            }

            // Get appointment history between this doctor and patient
            List<AppointmentDTO> appointments = appointmentService.getAppointmentsByDoctorAndPatient(
                    doctor.getId(), patientId);

            // Get medical history (notes)
            List<MedicalNoteDTO> medicalNotes = appointmentService.getMedicalNotesByDoctorAndPatient(
                    doctor.getId(), patientId);

            // Count upcoming and past appointments
            int upcomingCount = 0;
            int pastCount = 0;

            for (AppointmentDTO appointment : appointments) {
                if (appointmentService.isAppointmentUpcoming(appointment)) {
                    upcomingCount++;
                } else {
                    pastCount++;
                }
            }

            result.put("success", true);
            result.put("patient", patient);
            result.put("appointments", appointments);
            result.put("medicalNotes", medicalNotes);
            result.put("upcomingAppointments", upcomingCount);
            result.put("pastAppointments", pastCount);
            result.put("totalAppointments", appointments.size());

        } catch (Exception ex) {
            ex.printStackTrace();
            result.put("success", false);
            result.put("error", "Erreur lors du chargement des détails du patient: " + ex.getMessage());
        }

        return result;
    }

}