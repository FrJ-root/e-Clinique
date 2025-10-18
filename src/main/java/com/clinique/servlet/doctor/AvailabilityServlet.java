package com.clinique.servlet.doctor;

import java.io.IOException;
import com.clinique.controller.doctor.AvailabilityController;
import com.clinique.dto.DoctorDTO;
import com.clinique.dto.UserDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;

@WebServlet(name = "AvailabilityServlet", urlPatterns = {"/doctor/availability", "/doctor/save-availability", "/doctor/delete-availability"})
public class AvailabilityServlet extends HttpServlet {

    private final AvailabilityController controller = new AvailabilityController();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Object userObj = session.getAttribute("user");
        boolean isDoctor = false;

        if (userObj instanceof DoctorDTO) {
            isDoctor = true;
        } else if (userObj instanceof UserDTO) {
            UserDTO user = (UserDTO) userObj;
            isDoctor = "DOCTOR".equals(user.getRole());
        }

        if (!isDoctor) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès réservé aux médecins");
            return;
        }

        Map<String, Object> result = controller.getAvailabilityData(req);

        for (Map.Entry<String, Object> entry : result.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }

        req.getRequestDispatcher("/WEB-INF/views/doctor/availability.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Object userObj = session.getAttribute("user");
        boolean isDoctor = false;

        if (userObj instanceof DoctorDTO) {
            isDoctor = true;
        } else if (userObj instanceof UserDTO) {
            UserDTO user = (UserDTO) userObj;
            isDoctor = "DOCTOR".equals(user.getRole());
        }

        if (!isDoctor) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès réservé aux médecins");
            return;
        }

        String path = req.getServletPath();
        Map<String, Object> result;

        if ("/doctor/save-availability".equals(path)) {
            result = controller.saveAvailability(req);
        } else if ("/doctor/delete-availability".equals(path)) {
            result = controller.deleteAvailability(req);
        } else {
            result = Map.of("success", false, "error", "Opération non supportée");
        }

        if ((Boolean) result.get("success")) {
            session.setAttribute("successMessage", result.get("message"));
            resp.sendRedirect(req.getContextPath() + "/doctor/availability");
        } else {
            req.setAttribute("error", result.get("error"));

            Map<String, Object> availabilityData = controller.getAvailabilityData(req);
            for (Map.Entry<String, Object> entry : availabilityData.entrySet()) {
                req.setAttribute(entry.getKey(), entry.getValue());
            }

            req.getRequestDispatcher("/WEB-INF/views/doctor/availability.jsp").forward(req, resp);
        }
    }
}