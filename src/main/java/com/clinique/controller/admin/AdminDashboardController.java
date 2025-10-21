package com.clinique.controller.admin;

import com.clinique.service.AppointmentService;
import jakarta.servlet.http.HttpServletRequest;
import com.clinique.service.PatientService;
import com.clinique.service.DoctorService;
import com.clinique.service.UserService;
import jakarta.servlet.http.HttpSession;
import com.clinique.dto.PatientDTO;
import com.clinique.dto.DoctorDTO;
import com.clinique.dto.UserDTO;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminDashboardController {

    private final UserService userService;
    private final DoctorService doctorService;
    private final PatientService patientService;
    private final AppointmentService appointmentService;

    public AdminDashboardController() {
        this.userService = new UserService();
        this.doctorService = new DoctorService();
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

            int totalDoctors = doctorService.countActiveDoctors();
            int totalPatients = patientService.countActivePatients();
            int totalAppointments = appointmentService.countTotalAppointments();
            int appointmentsToday = appointmentService.countAppointmentsByDate(LocalDate.now());

            double occupancyRate = appointmentService.calculateOccupancyRate(LocalDate.now());
            int cancellationsThisWeek = appointmentService.countCancellationsSince(LocalDate.now().minusWeeks(1));

            List<UserDTO> recentUsers = userService.findRecentUsers(5);

            List<Map<String, Object>> todaysAppointments = appointmentService.getTodaysAppointmentsSummary();

            result.put("success", true);
            result.put("totalDoctors", totalDoctors);
            result.put("totalPatients", totalPatients);
            result.put("totalAppointments", totalAppointments);
            result.put("appointmentsToday", appointmentsToday);
            result.put("occupancyRate", occupancyRate);
            result.put("cancellationsThisWeek", cancellationsThisWeek);
            result.put("recentUsers", recentUsers);
            result.put("todaysAppointments", todaysAppointments);

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des données du tableau de bord: " + ex.getMessage());
        }

        return result;
    }

}