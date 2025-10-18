package com.clinique.servlet.admin;

import com.clinique.controller.admin.AdminConfigController;
import com.clinique.dto.UserDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "AdminSpecialtiesServlet", urlPatterns = {"/admin/specialties", "/admin/specialties/*"})
public class AdminSpecialtiesServlet extends HttpServlet {

    private final AdminConfigController controller = new AdminConfigController();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Object userObj = session.getAttribute("user");
        boolean isAdmin = false;

        if (userObj instanceof UserDTO) {
            UserDTO user = (UserDTO) userObj;
            isAdmin = "ADMIN".equals(user.getRole());
        }

        if (!isAdmin) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès réservé aux administrateurs");
            return;
        }

        Map<String, Object> specialtiesData = controller.getAllSpecialties(req);

        for (Map.Entry<String, Object> entry : specialtiesData.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/specialties.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Object userObj = session.getAttribute("user");
        boolean isAdmin = false;

        if (userObj instanceof UserDTO) {
            UserDTO user = (UserDTO) userObj;
            isAdmin = "ADMIN".equals(user.getRole());
        }

        if (!isAdmin) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès réservé aux administrateurs");
            return;
        }

        String pathInfo = req.getPathInfo();
        Map<String, Object> result;

        if (pathInfo == null) {
            result = controller.createSpecialty(req);
        } else if (pathInfo.equals("/update")) {
            result = controller.updateSpecialty(req);
        } else if (pathInfo.equals("/delete")) {
            result = controller.deleteSpecialty(req);
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action non reconnue");
            return;
        }

        if ((Boolean) result.get("success")) {
            session.setAttribute("successMessage", result.get("message"));
        } else {
            session.setAttribute("errorMessage", result.get("error"));
        }

        resp.sendRedirect(req.getContextPath() + "/admin/specialties");
    }
}