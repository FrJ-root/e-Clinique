package com.clinique.servlet;

import java.io.IOException;
import jakarta.servlet.http.*;
import com.clinique.dto.UserDTO;
import com.clinique.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "RegisterServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String nom = req.getParameter("nom");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        if (role == null || role.isBlank()) role = "PATIENT";

        UserDTO dto = new UserDTO();
        dto.setNom(nom);
        dto.setEmail(email);
        dto.setPassword(password);
        dto.setRole(role);

        try {
            UserDTO registered = userService.register(dto);
            HttpSession session = req.getSession(true);
            session.setAttribute("user", registered);
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } catch (IllegalArgumentException ex) {
            req.setAttribute("error", ex.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        } catch (Exception ex) {
            req.setAttribute("error", "Erreur serveur, réessayez plus tard");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        }
    }
}