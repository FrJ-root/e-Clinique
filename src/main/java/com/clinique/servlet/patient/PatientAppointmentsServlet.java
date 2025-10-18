package com.clinique.servlet.patient;

import java.io.IOException;
import com.clinique.controller.patient.PatientDashboardController;
import com.clinique.dto.PatientDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;

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

        for (Map.Entry<String, Object> entry : result.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }

        req.getRequestDispatcher("/WEB-INF/views/patient/appointments.jsp").forward(req, resp);
    }
}