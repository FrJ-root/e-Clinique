package com.clinique.servlet.auth;

import java.io.IOException;
import jakarta.servlet.http.*;
import com.clinique.controller.patient.PatientController;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import java.util.Map;

@WebServlet(name = "RegisterServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {

    private final PatientController patientController = new PatientController();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Map<String, Object> result = patientController.registerPatient(req);

        if ((Boolean) result.get("success")) {
            HttpSession session = req.getSession(true);
            session.setAttribute("successMessage", "Your Account is created successfully ^_-");
            resp.sendRedirect(req.getContextPath() + "/login");
        } else {
            req.setAttribute("error", result.get("error"));
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        }
    }
}