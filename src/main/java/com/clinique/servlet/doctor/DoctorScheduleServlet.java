package com.clinique.servlet.doctor;

import com.clinique.controller.doctor.DoctorScheduleController;
import com.clinique.dto.DoctorDTO;
import com.clinique.dto.UserDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "DoctorScheduleServlet", urlPatterns = {"/doctor/schedule"})
public class DoctorScheduleServlet extends HttpServlet {

    private final DoctorScheduleController controller = new DoctorScheduleController();

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

        Map<String, Object> result = controller.getScheduleData(req);

        for (Map.Entry<String, Object> entry : result.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }

        req.getRequestDispatcher("/WEB-INF/views/doctor/schedule.jsp").forward(req, resp);
    }
}