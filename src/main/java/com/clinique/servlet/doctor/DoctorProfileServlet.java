package com.clinique.servlet.doctor;

import com.clinique.controller.doctor.DoctorProfileController;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.annotation.WebServlet;
import com.clinique.service.DoctorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpSession;
import com.clinique.dto.DoctorDTO;
import com.clinique.dto.UserDTO;
import java.io.IOException;
import java.util.UUID;
import java.util.Map;

@WebServlet(name = "DoctorProfileServlet", urlPatterns = {"/doctor/profile", "/doctor/update-profile"})
public class DoctorProfileServlet extends HttpServlet {

    private final DoctorProfileController controller = new DoctorProfileController();

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

        Map<String, Object> profileData = controller.getProfileData(req);

        for (Map.Entry<String, Object> entry : profileData.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }

        req.getRequestDispatcher("/WEB-INF/views/doctor/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Object userObj = session.getAttribute("user");

        try {
            Map<String, Object> result = controller.updateProfile(req);

            if ((Boolean) result.get("success")) {
                if (result.containsKey("doctor")) {
                    session.setAttribute("user", result.get("doctor"));
                }
                session.setAttribute("successMessage", result.get("message"));
            } else {
                req.setAttribute("error", result.get("error"));
                if (result.containsKey("passwordError")) {
                    req.setAttribute("passwordError", result.get("passwordError"));
                }

                Map<String, Object> profileData = controller.getProfileData(req);
                for (Map.Entry<String, Object> entry : profileData.entrySet()) {
                    req.setAttribute(entry.getKey(), entry.getValue());
                }

                req.getRequestDispatcher("/WEB-INF/views/doctor/profile.jsp").forward(req, resp);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/doctor/profile");

        } catch (Exception e) {
            System.err.println("Error updating doctor profile: " + e.getMessage());
            e.printStackTrace();

            req.setAttribute("error", "Une erreur est survenue lors de la mise à jour du profil: " + e.getMessage());
            Map<String, Object> profileData = controller.getProfileData(req);
            for (Map.Entry<String, Object> entry : profileData.entrySet()) {
                req.setAttribute(entry.getKey(), entry.getValue());
            }
            req.getRequestDispatcher("/WEB-INF/views/doctor/profile.jsp").forward(req, resp);
        }
    }
}