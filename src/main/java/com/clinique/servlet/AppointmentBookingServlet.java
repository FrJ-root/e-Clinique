package com.clinique.servlet;

import java.io.IOException;
import com.clinique.controller.AppointmentBookingController;
import com.clinique.dto.PatientDTO;
import com.clinique.dto.UserDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;
import java.time.LocalDate;

@WebServlet(name = "AppointmentBookingServlet", urlPatterns = "/patient/book-appointment")
public class AppointmentBookingServlet extends HttpServlet {

    private final AppointmentBookingController controller = new AppointmentBookingController();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Object userObj = session.getAttribute("user");
        boolean isPatient = false;

        if (userObj instanceof PatientDTO) {
            isPatient = true;
        } else if (userObj instanceof UserDTO) {
            UserDTO user = (UserDTO) userObj;
            isPatient = "PATIENT".equals(user.getRole());
        }

        if (!isPatient) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès réservé aux patients");
            return;
        }

        String doctorId = req.getParameter("doctorId");
        if (doctorId == null || doctorId.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/patient/doctors");
            return;
        }

        String dateParam = req.getParameter("date");
        if (dateParam == null || dateParam.isEmpty()) {
            dateParam = LocalDate.now().toString();
        }

        req.setAttribute("selectedDate", dateParam);

        Map<String, Object> result = controller.getAvailableTimeSlots(req);

        for (Map.Entry<String, Object> entry : result.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }

        req.getRequestDispatcher("/WEB-INF/views/patient/appointments.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Object userObj = session.getAttribute("user");
        boolean isPatient = false;

        if (userObj instanceof PatientDTO) {
            isPatient = true;
        } else if (userObj instanceof UserDTO) {
            UserDTO user = (UserDTO) userObj;
            isPatient = "PATIENT".equals(user.getRole());
        }

        if (!isPatient) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès réservé aux patients");
            return;
        }

        Map<String, Object> result = controller.bookAppointment(req);

        if ((Boolean) result.get("success")) {
            session.setAttribute("successMessage", result.get("message"));
            resp.sendRedirect(req.getContextPath() + "/patient/appointments");
        } else {
            for (Map.Entry<String, Object> entry : result.entrySet()) {
                req.setAttribute(entry.getKey(), entry.getValue());
            }

            Map<String, Object> slotsResult = controller.getAvailableTimeSlots(req);
            for (Map.Entry<String, Object> entry : slotsResult.entrySet()) {
                req.setAttribute(entry.getKey(), entry.getValue());
            }

            req.getRequestDispatcher("/WEB-INF/views/patient/appointments.jsp").forward(req, resp);
        }
    }
}