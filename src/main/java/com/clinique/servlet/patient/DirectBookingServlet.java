package com.clinique.servlet.patient;

import com.clinique.dto.PatientDTO;
import com.clinique.service.DepartmentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "DirectBookingServlet", urlPatterns = "/patient/direct-booking")
public class DirectBookingServlet extends HttpServlet {

    private final DepartmentService departmentService = new DepartmentService();

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
        req.setAttribute("departments", departmentService.getDepartmentsWithDoctors());
        req.setAttribute("contextPath", req.getContextPath());
        req.getRequestDispatcher("/WEB-INF/views/patient/direct-booking.jsp").forward(req, resp);
    }
}