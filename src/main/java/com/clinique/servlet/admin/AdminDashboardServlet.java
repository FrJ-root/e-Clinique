package com.clinique.servlet.admin;

import com.clinique.controller.admin.AdminDashboardController;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpSession;
import com.clinique.dto.UserDTO;
import java.io.IOException;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final AdminDashboardController controller = new AdminDashboardController();

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

        Map<String, Object> dashboardData = controller.getDashboardData(req);

        for (Map.Entry<String, Object> entry : dashboardData.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}