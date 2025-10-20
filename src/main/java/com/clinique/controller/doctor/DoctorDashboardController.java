package com.clinique.controller.doctor;

import com.clinique.dto.*;
import com.clinique.enums.AppointmentStatus;
import com.clinique.service.AppointmentService;
import com.clinique.service.AvailabilityService;
import com.clinique.service.DoctorService;
import com.clinique.service.PatientService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import com.clinique.dto.TimeSlotDTO;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

public class DoctorDashboardController {

    private final DoctorService doctorService;
    private final AppointmentService appointmentService;
    private final AvailabilityService availabilityService;
    private final PatientService patientService;

    public DoctorDashboardController() {
        this.doctorService = new DoctorService();
        this.appointmentService = new AppointmentService();
        this.availabilityService = new AvailabilityService();
        this.patientService = new PatientService();
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
            DoctorDTO doctor = null;

            if (userObj instanceof DoctorDTO) {
                doctor = (DoctorDTO) userObj;
            } else if (userObj instanceof UserDTO) {
                UserDTO userDTO = (UserDTO) userObj;
                if ("DOCTOR".equals(userDTO.getRole())) {
                    doctor = doctorService.findByUserId(userDTO.getId());
                    if (doctor != null) {
                        session.setAttribute("user", doctor);
                    }
                }
            }

            if (doctor == null) {
                result.put("success", false);
                result.put("error", "Médecin non trouvé");
                return result;
            }

            LocalDate today = LocalDate.now();
            LocalDate selectedDate = today;

            String dateParam = request.getParameter("date");
            if (dateParam != null && !dateParam.isEmpty()) {
                try {
                    selectedDate = LocalDate.parse(dateParam);
                } catch (Exception e) {
                    selectedDate = today;
                }
            }

            List<AppointmentDTO> todaysAppointments = appointmentService.findByDoctorAndDate(doctor.getId(), today);

            List<AppointmentDTO> upcomingAppointments = appointmentService.findUpcomingByDoctor(doctor.getId());

            List<AppointmentDTO> selectedDateAppointments = new ArrayList<>();
            if (!selectedDate.equals(today)) {
                selectedDateAppointments = appointmentService.findByDoctorAndDate(doctor.getId(), selectedDate);
            } else {
                selectedDateAppointments = todaysAppointments;
            }

            List<PatientDTO> recentPatients = patientService.findRecentPatientsByDoctor(doctor.getId(), 5);

            int completedToday = 0;
            int pendingToday = 0;
            int canceledToday = 0;

            for (AppointmentDTO appointment : todaysAppointments) {
                if (appointment.getStatut() == AppointmentStatus.DONE) {
                    completedToday++;
                } else if (appointment.getStatut() == AppointmentStatus.PLANNED) {
                    pendingToday++;
                } else if (appointment.getStatut() == AppointmentStatus.CANCELED) {
                    canceledToday++;
                }
            }

            List<TimeSlotDTO> availableSlots = availabilityService.getTimeSlotsForDate(doctor.getId(), selectedDate);
            result.put("success", true);
            result.put("doctor", doctor);
            result.put("today", today);
            result.put("selectedDate", selectedDate);
            result.put("todaysAppointments", todaysAppointments);
            result.put("upcomingAppointments", upcomingAppointments);
            result.put("selectedDateAppointments", selectedDateAppointments);
            result.put("recentPatients", recentPatients);
            result.put("completedToday", completedToday);
            result.put("pendingToday", pendingToday);
            result.put("canceledToday", canceledToday);
            result.put("availableSlots", availableSlots);
            result.put("currentDateTime", LocalDateTime.now());

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des données du tableau de bord: " + ex.getMessage());
        }

        return result;
    }

}