package com.clinique.servlet.doctor;

import com.clinique.controller.doctor.DoctorAppointmentsController;
import com.clinique.dto.DoctorDTO;
import com.clinique.dto.UserDTO;
import com.clinique.enums.AppointmentStatus;
import com.clinique.utils.JsonUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "DoctorAppointmentsServlet", urlPatterns = {
        "/doctor/appointments",
        "/doctor/appointments/update-status",
        "/doctor/appointments/details"
})
public class DoctorAppointmentsServlet extends HttpServlet {

    private final DoctorAppointmentsController controller = new DoctorAppointmentsController();

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

        String path = req.getServletPath();

        if ("/doctor/appointments/details".equals(path)) {
            Map<String, Object> result = controller.getAppointmentDetails(req);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(JsonUtils.toJson(result));
        } else {
            Map<String, Object> result = controller.getAppointmentsData(req);

            for (Map.Entry<String, Object> entry : result.entrySet()) {
                req.setAttribute(entry.getKey(), entry.getValue());
            }

            req.getRequestDispatcher("/WEB-INF/views/doctor/appointments.jsp").forward(req, resp);
        }
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

        if ("/doctor/appointments/update-status".equals(path)) {
            Map<String, Object> result = controller.updateAppointmentStatus(req);

            if ((Boolean) result.get("success")) {
                session.setAttribute("successMessage", result.get("message"));
            } else {
                session.setAttribute("errorMessage", result.get("error"));
            }

            String xRequestedWith = req.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(xRequestedWith)) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write(JsonUtils.toJson(result));
            } else {
                resp.sendRedirect(req.getContextPath() + "/doctor/appointments");
            }
        }
    }
}