package com.clinique.servlet.auth;

import java.io.IOException;
import jakarta.servlet.http.*;
import com.clinique.controller.UserController;
import com.clinique.dto.UserDTO;
import com.clinique.dto.PatientDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import java.util.Map;

@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    private final UserController userController = new UserController();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            Object userObj = session.getAttribute("user");
            if (userObj instanceof UserDTO) {
                UserDTO user = (UserDTO) userObj;
                String role = user.getRole();

                if ("ADMIN".equals(role)) {
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                    return;
                } else if ("PATIENT".equals(role)) {
                    resp.sendRedirect(req.getContextPath() + "/patient/dashboard");
                    return;
                } else if ("DOCTOR".equals(role)) {
                    resp.sendRedirect(req.getContextPath() + "/doctor/dashboard");
                    return;
                } else {
                    resp.sendRedirect(req.getContextPath() + "/dashboard");
                    return;
                }
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            Map<String, Object> result = userController.authenticate(req);

            if ((Boolean) result.get("success")) {
                Object userObj = result.get("user");
                if (userObj != null) {
                    UserDTO user = (UserDTO) userObj;

                    HttpSession session = req.getSession(true);

                    session.setAttribute("user", user);

                    String role = user.getRole();
                    if ("ADMIN".equals(role)) {
                        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                    } else if ("PATIENT".equals(role)) {
                        resp.sendRedirect(req.getContextPath() + "/patient/dashboard");
                    } else if ("DOCTOR".equals(role)) {
                        resp.sendRedirect(req.getContextPath() + "/doctor/dashboard");
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/dashboard");
                    }
                } else {
                    req.setAttribute("error", "Une erreur s'est produite lors de la connexion");
                    req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                }
            } else {
                req.setAttribute("error", result.get("error"));
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Une erreur s'est produite lors de la connexion: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}