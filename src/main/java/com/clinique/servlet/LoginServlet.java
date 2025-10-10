package com.clinique.servlet;

import com.clinique.dto.UserDTO;
import com.clinique.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            UserDTO authenticatedUser = userService.authenticate(email, password);
            HttpSession session = req.getSession(true);
            session.setAttribute("user", authenticatedUser);
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } catch (IllegalArgumentException ex) {
            req.setAttribute("error", ex.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace(); // 👈 log to Tomcat console
            req.setAttribute("error", "Erreur serveur. Veuillez réessayer plus tard.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}