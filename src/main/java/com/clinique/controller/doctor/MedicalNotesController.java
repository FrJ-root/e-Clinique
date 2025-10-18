package com.clinique.controller.doctor;

import com.clinique.dto.AppointmentDTO;
import com.clinique.dto.DoctorDTO;
import com.clinique.dto.MedicalNoteDTO;
import com.clinique.dto.UserDTO;
import com.clinique.enums.AppointmentStatus;
import com.clinique.service.AppointmentService;
import com.clinique.service.DoctorService;
import com.clinique.service.MedicalNoteService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

public class MedicalNotesController {

    private final AppointmentService appointmentService;
    private final DoctorService doctorService;
    private final MedicalNoteService medicalNoteService;

    public MedicalNotesController() {
        this.appointmentService = new AppointmentService();
        this.doctorService = new DoctorService();
        this.medicalNoteService = new MedicalNoteService();
    }

    public Map<String, Object> getMedicalNotesData(HttpServletRequest request) {
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

            // Get filter parameter
            String filter = request.getParameter("filter");

            // Get appointments based on filter
            List<AppointmentDTO> completedAppointments;

            if ("pending".equals(filter)) {
                // Get completed appointments without medical notes
                completedAppointments = appointmentService.getCompletedAppointmentsWithoutNotes(doctor.getId());
                result.put("filterTitle", "Rendez-vous terminés sans notes médicales");
            } else if ("recent".equals(filter)) {
                // Get recent completed appointments (last 7 days)
                LocalDate startDate = LocalDate.now().minusDays(7);
                completedAppointments = appointmentService.getCompletedAppointmentsSince(doctor.getId(), startDate);
                result.put("filterTitle", "Notes médicales récentes (7 derniers jours)");
            } else if ("patient".equals(filter)) {
                // Get appointments for a specific patient
                String patientIdStr = request.getParameter("patientId");
                if (patientIdStr != null && !patientIdStr.isEmpty()) {
                    try {
                        UUID patientId = UUID.fromString(patientIdStr);
                        completedAppointments = appointmentService.getCompletedAppointmentsByPatient(doctor.getId(), patientId);
                        result.put("filterTitle", "Notes médicales du patient");
                        result.put("patientId", patientId);

                        // Try to get patient name
                        if (!completedAppointments.isEmpty()) {
                            result.put("patientName", completedAppointments.get(0).getPatientNom());
                        }
                    } catch (IllegalArgumentException e) {
                        completedAppointments = new ArrayList<>();
                        result.put("error", "ID de patient invalide");
                    }
                } else {
                    completedAppointments = new ArrayList<>();
                    result.put("error", "ID de patient manquant");
                }
            } else {
                // Default to all completed appointments
                completedAppointments = appointmentService.getCompletedAppointmentsByDoctor(doctor.getId());
                result.put("filterTitle", "Toutes les notes médicales");
            }

            // Count by category
            int totalWithNotes = 0;
            int totalWithoutNotes = 0;

            for (AppointmentDTO appointment : completedAppointments) {
                if (appointment.isHasMedicalNote()) {
                    totalWithNotes++;
                } else {
                    totalWithoutNotes++;
                }
            }

            // Set result data
            result.put("success", true);
            result.put("doctor", doctor);
            result.put("appointments", completedAppointments);
            result.put("totalWithNotes", totalWithNotes);
            result.put("totalWithoutNotes", totalWithoutNotes);
            result.put("filter", filter != null ? filter : "all");

        } catch (Exception ex) {
            ex.printStackTrace();
            result.put("success", false);
            result.put("error", "Erreur lors du chargement des notes médicales: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> getMedicalNoteDetails(HttpServletRequest request) {
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

            // Get appointment and medical note
            AppointmentDTO appointment = appointmentService.getAppointment(appointmentId);

            // Security check - verify this appointment belongs to the doctor
            if (!appointment.getDoctorId().equals(doctor.getId())) {
                result.put("success", false);
                result.put("error", "Vous n'êtes pas autorisé à voir ce rendez-vous");
                return result;
            }

            // Get medical note if exists
            MedicalNoteDTO medicalNote = null;
            if (appointment.isHasMedicalNote()) {
                medicalNote = appointmentService.getMedicalNote(appointmentId);
            }

            result.put("success", true);
            result.put("appointment", appointment);
            result.put("medicalNote", medicalNote);

        } catch (Exception ex) {
            ex.printStackTrace();
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des détails: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> saveOrUpdateMedicalNote(HttpServletRequest request) {
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

            // Get parameters
            String appointmentIdStr = request.getParameter("appointmentId");
            String noteContent = request.getParameter("noteContent");

            if (appointmentIdStr == null || noteContent == null) {
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

            // Check if the appointment exists and belongs to the doctor
            AppointmentDTO appointment = appointmentService.getAppointment(appointmentId);

            if (!appointment.getDoctorId().equals(doctor.getId())) {
                result.put("success", false);
                result.put("error", "Vous n'êtes pas autorisé à modifier ce rendez-vous");
                return result;
            }

            // Check if the appointment is completed
            if (appointment.getStatut() != AppointmentStatus.DONE) {
                // If not completed, mark it as completed
                appointmentService.updateAppointmentStatus(appointmentId, doctor.getId(), AppointmentStatus.DONE, null);
            }

            // Save or update the medical note
            MedicalNoteDTO savedNote = medicalNoteService.saveOrUpdateMedicalNote(appointmentId, noteContent);

            result.put("success", true);
            result.put("medicalNote", savedNote);
            result.put("message", "Note médicale enregistrée avec succès");

        } catch (Exception ex) {
            ex.printStackTrace();
            result.put("success", false);
            result.put("error", "Erreur lors de l'enregistrement de la note: " + ex.getMessage());
        }

        return result;
    }
}