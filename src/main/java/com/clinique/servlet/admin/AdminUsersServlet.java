package com.clinique.servlet.admin;

import com.clinique.controller.admin.UserManagementController;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import com.clinique.service.SpecialtyService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpSession;
import com.clinique.dto.UserDTO;
import java.io.IOException;
import java.util.Map;
import java.util.UUID;

@WebServlet(name = "AdminUsersServlet", urlPatterns = {"/admin/users", "/admin/users/*"})
public class AdminUsersServlet extends HttpServlet {

    private final UserManagementController controller = new UserManagementController();
    private final SpecialtyService specialtyService = new SpecialtyService();

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

        String pathInfo = req.getPathInfo();

        if (pathInfo != null) {
            if (pathInfo.equals("/view")) {
                handleViewUser(req, resp);
                return;
            } else if (pathInfo.equals("/edit")) {
                handleEditUser(req, resp);
                return;
            } else if (pathInfo.equals("/get")) {
                handleGetUser(req, resp);
                return;
            }
        }

        // Default: list all users
        Map<String, Object> usersData = controller.getAllUsers(req);

        for (Map.Entry<String, Object> entry : usersData.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }

        // Add specialties for the doctor creation form
        req.setAttribute("specialties", specialtyService.findAll());

        req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
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

        if (pathInfo != null) {
            if (pathInfo.equals("/create")) {
                result = controller.createUser(req);
            } else if (pathInfo.equals("/update")) {
                result = controller.updateUser(req);
            } else if (pathInfo.equals("/reset-password")) {
                result = controller.resetPassword(req);
            } else if (pathInfo.equals("/deactivate")) {
                result = controller.deactivateUser(req);
            } else if (pathInfo.equals("/activate")) {
                result = controller.activateUser(req);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action non spécifiée");
            return;
        }

        if ((Boolean) result.get("success")) {
            session.setAttribute("successMessage", result.get("message"));

            // Check if we're coming from a user detail page
            String referer = req.getHeader("Referer");
            if (referer != null && referer.contains("/users/view")) {
                // The id parameter is required for redirect back to view page
                String userId = req.getParameter("id");
                resp.sendRedirect(req.getContextPath() + "/admin/users/view?id=" + userId);
            } else {
                // Otherwise go back to the users list
                resp.sendRedirect(req.getContextPath() + "/admin/users");
            }
        } else {
            session.setAttribute("errorMessage", result.get("error"));
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        }
    }

    private void handleGetUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Map<String, Object> userData = controller.getUserDetails(req);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        if ((Boolean) userData.get("success")) {
            resp.getWriter().write("{\"success\":true,\"user\":" + toJson(userData.get("user")) +
                    (userData.containsKey("doctor") ? ",\"doctor\":" + toJson(userData.get("doctor")) + "}" : "}"));
        } else {
            resp.getWriter().write("{\"success\":false,\"error\":\"" + userData.get("error") + "\"}");
        }
    }

    private void handleViewUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userIdStr = req.getParameter("id");
        if (userIdStr == null || userIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        try {
            UUID userId = UUID.fromString(userIdStr);
            Map<String, Object> userData = controller.getUserDetails(req);

            if ((Boolean) userData.get("success")) {
                for (Map.Entry<String, Object> entry : userData.entrySet()) {
                    if (!entry.getKey().equals("success")) {
                        req.setAttribute(entry.getKey(), entry.getValue());
                    }
                }

                req.setAttribute("viewUser", userData.get("user"));
                req.getRequestDispatcher("/WEB-INF/views/admin/view-user.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", userData.get("error"));
                resp.sendRedirect(req.getContextPath() + "/admin/users");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Erreur: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        }
    }

    private void handleEditUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userIdStr = req.getParameter("id");
        if (userIdStr == null || userIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        try {
            UUID userId = UUID.fromString(userIdStr);
            Map<String, Object> userData = controller.getUserDetails(req);

            if ((Boolean) userData.get("success")) {
                for (Map.Entry<String, Object> entry : userData.entrySet()) {
                    if (!entry.getKey().equals("success")) {
                        req.setAttribute(entry.getKey(), entry.getValue());
                    }
                }

                req.setAttribute("editUser", userData.get("user"));
                req.setAttribute("specialties", specialtyService.findAll());
                req.getRequestDispatcher("/WEB-INF/views/admin/edit-user.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", userData.get("error"));
                resp.sendRedirect(req.getContextPath() + "/admin/users");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Erreur: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        }
    }

    private String toJson(Object obj) {
        if (obj == null) return "null";
        if (obj instanceof UserDTO) {
            UserDTO user = (UserDTO) obj;
            return String.format("{\"id\":\"%s\",\"nom\":\"%s\",\"email\":\"%s\",\"role\":\"%s\",\"actif\":%b}",
                    user.getId(), user.getNom().replace("\"", "\\\""),
                    user.getEmail().replace("\"", "\\\""),
                    user.getRole(), user.isActif());
        }
        return "{}";
    }

}