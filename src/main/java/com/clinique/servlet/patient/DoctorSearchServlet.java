package com.clinique.servlet.patient;

import com.clinique.controller.DoctorSearchController;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpSession;
import com.clinique.dto.PatientDTO;
import com.clinique.dto.UserDTO;
import java.io.IOException;
import java.util.Map;

@WebServlet(name = "DoctorSearchServlet", urlPatterns = {"/patient/doctors", "/patient/doctor-details"})
public class DoctorSearchServlet extends HttpServlet {

    private final DoctorSearchController controller = new DoctorSearchController();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Object userObj = session.getAttribute("user");
        boolean isPatient = false;

        if (userObj instanceof PatientDTO) {
            isPatient = true;
        } else if (userObj instanceof UserDTO) {
            UserDTO user = (UserDTO) userObj;
            isPatient = "PATIENT".equals(user.getRole());
        }

        if (!isPatient) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès réservé aux patients");
            return;
        }

        String pathInfo = req.getServletPath();

        if ("/patient/doctor-details".equals(pathInfo)) {
            handleDoctorDetails(req, resp);
        } else {
            handleDoctorSearch(req, resp);
        }
    }

    private void handleDoctorSearch(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Object> formData = controller.getSearchFormData(req);

        for (Map.Entry<String, Object> entry : formData.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }

        String specialtyId = req.getParameter("specialtyId");
        String departmentId = req.getParameter("departmentId");

        Map<String, Object> searchResult;

        if (specialtyId != null && !specialtyId.isEmpty()) {
            searchResult = controller.searchDoctorsBySpecialty(req);
        } else if (departmentId != null && !departmentId.isEmpty()) {
            searchResult = controller.searchDoctorsByDepartment(req);
        } else {
            searchResult = controller.getAllDoctors(req);
        }

        for (Map.Entry<String, Object> entry : searchResult.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }

        req.getRequestDispatcher("/WEB-INF/views/patient/doctor-search.jsp").forward(req, resp);
    }

    private void handleDoctorDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Object> result = controller.getDoctorDetails(req);
        for (Map.Entry<String, Object> entry : result.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }
        req.getRequestDispatcher("/WEB-INF/views/patient/doctor-details.jsp").forward(req, resp);
    }

}