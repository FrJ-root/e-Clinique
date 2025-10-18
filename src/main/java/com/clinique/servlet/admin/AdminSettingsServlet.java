package com.clinique.servlet.admin;

import com.clinique.controller.admin.AdminConfigController;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpSession;
import com.clinique.dto.UserDTO;
import java.io.IOException;
import java.util.Map;

@WebServlet(name = "AdminSettingsServlet", urlPatterns = {"/admin/settings", "/admin/settings/*"})
public class AdminSettingsServlet extends HttpServlet {

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

        Map<String, Object> settingsData = controller.getSettings(req);

        for (Map.Entry<String, Object> entry : settingsData.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/settings.jsp").forward(req, resp);
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

        if (pathInfo == null || pathInfo.equals("/save")) {
            result = controller.saveSettings(req);
        } else if (pathInfo.equals("/holiday/create")) {
            result = controller.createHoliday(req);
        } else if (pathInfo.equals("/holiday/update")) {
            result = controller.updateHoliday(req);
        } else if (pathInfo.equals("/holiday/delete")) {
            result = controller.deleteHoliday(req);
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action non reconnue");
            return;
        }

        if ((Boolean) result.get("success")) {
            session.setAttribute("successMessage", result.get("message"));
        } else {
            session.setAttribute("errorMessage", result.get("error"));
        }

        resp.sendRedirect(req.getContextPath() + "/admin/settings");
    }
}