package com.clinique.servlet.patient;

import com.clinique.controller.AppointmentBookingController;
import com.clinique.dto.PatientDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "ProcessDirectBookingServlet", urlPatterns = "/patient/process-direct-booking")
public class ProcessDirectBookingServlet extends HttpServlet {

    private final AppointmentBookingController controller = new AppointmentBookingController();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        Map<String, Object> result = controller.bookAppointment(req);

        if ((Boolean) result.get("success")) {
            session.setAttribute("successMessage", result.get("message"));
            resp.sendRedirect(req.getContextPath() + "/patient/appointments");
        } else {
            req.setAttribute("error", result.get("error"));
            req.getRequestDispatcher("/patient/direct-booking").forward(req, resp);
        }
    }
}