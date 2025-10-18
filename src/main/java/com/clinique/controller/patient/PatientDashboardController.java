package com.clinique.controller.patient;

import com.clinique.dto.AppointmentDTO;
import com.clinique.dto.PatientDTO;
import com.clinique.dto.UserDTO;
import com.clinique.service.AppointmentService;
import com.clinique.service.PatientService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class PatientDashboardController {

    private final PatientService patientService;
    private final AppointmentService appointmentService;

    public PatientDashboardController() {
        this.patientService = new PatientService();
        this.appointmentService = new AppointmentService();
    }

    public Map<String, Object> getDashboardData(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Session invalide");
                return result;
            }

            Object userObj = session.getAttribute("user");
            UUID patientId = null;
            PatientDTO patientDTO = null;

            if (userObj instanceof PatientDTO) {
                patientDTO = (PatientDTO) userObj;
                patientId = patientDTO.getId();
            } else if (userObj instanceof UserDTO) {
                UserDTO userDTO = (UserDTO) userObj;
                if ("PATIENT".equals(userDTO.getRole())) {
                    patientDTO = patientService.findByUserId(userDTO.getId());
                    if (patientDTO != null) {
                        patientId = patientDTO.getId();
                        session.setAttribute("user", patientDTO);
                    }
                }
            }

            if (patientId == null) {
                result.put("success", false);
                result.put("error", "Données patient non trouvées");
                return result;
            }

            List<AppointmentDTO> upcomingAppointments = appointmentService.findUpcomingByPatient(patientId);

            List<AppointmentDTO> allAppointments = appointmentService.findByPatient(patientId);

            result.put("success", true);
            result.put("patient", patientDTO);
            result.put("upcomingAppointments", upcomingAppointments);
            result.put("allAppointments", allAppointments);

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des données du tableau de bord: " + ex.getMessage());
        }

        return result;
    }
}