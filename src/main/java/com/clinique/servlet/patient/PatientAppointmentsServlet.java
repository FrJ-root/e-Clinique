package com.clinique.servlet.patient;

import java.io.IOException;
import com.clinique.controller.patient.PatientDashboardController;
import com.clinique.dto.AppointmentDTO;
import com.clinique.dto.PatientDTO;
import com.clinique.enums.AppointmentStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "PatientAppointmentsServlet", urlPatterns = "/patient/appointments")
public class PatientAppointmentsServlet extends HttpServlet {

    private final PatientDashboardController controller = new PatientDashboardController();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Object userObj = session.getAttribute("user");
        if (!(userObj instanceof PatientDTO)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès réservé aux patients");
            return;
        }

        Map<String, Object> result = controller.getDashboardData(req);

        // Get all appointments
        List<AppointmentDTO> allAppointments = (List<AppointmentDTO>) result.get("allAppointments");

        if (allAppointments == null) {
            allAppointments = new ArrayList<>();
        }

        LocalDateTime now = LocalDateTime.now();

        // Separate upcoming and past appointments
        List<AppointmentDTO> upcomingAppointments = allAppointments.stream()
                .filter(appointment ->
                        appointment.getStatut() == AppointmentStatus.PLANNED &&
                                (appointment.getDate().isAfter(LocalDate.now()) ||
                                        (appointment.getDate().isEqual(LocalDate.now()) &&
                                                appointment.getHeureDebut().isAfter(LocalTime.now())))
                )
                .collect(Collectors.toList());

        List<AppointmentDTO> pastAppointments = allAppointments.stream()
                .filter(appointment ->
                        appointment.getStatut() == AppointmentStatus.DONE ||
                                appointment.getStatut() == AppointmentStatus.CANCELED ||
                                (appointment.getStatut() == AppointmentStatus.PLANNED &&
                                        (appointment.getDate().isBefore(LocalDate.now()) ||
                                                (appointment.getDate().isEqual(LocalDate.now()) &&
                                                        appointment.getHeureDebut().isBefore(LocalTime.now()))))
                )
                .collect(Collectors.toList());

        // Add attributes for the view
        req.setAttribute("upcomingAppointments", upcomingAppointments);
        req.setAttribute("pastAppointments", pastAppointments);

        // Add success message if available
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            req.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }

        // Forward to the appointment list view
        req.getRequestDispatcher("/WEB-INF/views/patient/appointments-list.jsp").forward(req, resp);
    }
}