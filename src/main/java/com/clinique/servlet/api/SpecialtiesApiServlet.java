package com.clinique.servlet.api;

import com.clinique.dto.SpecialtyDTO;
import com.clinique.service.SpecialtyService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@WebServlet(name = "SpecialtiesApiServlet", urlPatterns = "/api/specialties")
public class SpecialtiesApiServlet extends HttpServlet {

    private final SpecialtyService specialtyService = new SpecialtyService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("\n====== SPECIALTIES API SERVLET CALLED ======");
        System.out.println("Time: " + new java.util.Date());

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        Map<String, Object> response = new HashMap<>();

        try {
            String departmentIdStr = req.getParameter("departmentId");
            System.out.println("Received departmentId: " + departmentIdStr);

            if (departmentIdStr == null || departmentIdStr.isEmpty()) {
                System.out.println("ERROR: departmentId is null or empty");
                response.put("success", false);
                response.put("error", "Department ID is required");
                String jsonResponse = gson.toJson(response);
                System.out.println("Sending error response: " + jsonResponse);
                resp.getWriter().write(jsonResponse);
                return;
            }

            UUID departmentId;
            try {
                departmentId = UUID.fromString(departmentIdStr);
                System.out.println("Parsed UUID: " + departmentId);
            } catch (IllegalArgumentException e) {
                System.out.println("ERROR: Invalid UUID format - " + e.getMessage());
                response.put("success", false);
                response.put("error", "Invalid department ID format");
                String jsonResponse = gson.toJson(response);
                System.out.println("Sending error response: " + jsonResponse);
                resp.getWriter().write(jsonResponse);
                return;
            }

            System.out.println("Calling specialtyService.getSpecialtiesByDepartment()...");
            List<SpecialtyDTO> specialties = specialtyService.getSpecialtiesByDepartment(departmentId);
            System.out.println("Service returned " + specialties.size() + " specialties");

            for (SpecialtyDTO spec : specialties) {
                System.out.println("  - " + spec.getNom() + " (ID: " + spec.getId() + ")");
            }

            response.put("success", true);
            response.put("specialties", specialties);

            String jsonResponse = gson.toJson(response);
            System.out.println("Sending success response with " + specialties.size() + " specialties");
            System.out.println("JSON Response: " + jsonResponse);
            resp.getWriter().write(jsonResponse);

        } catch (Exception e) {
            System.out.println("ERROR: Exception occurred - " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("error", "Error loading specialties: " + e.getMessage());
            String jsonResponse = gson.toJson(response);
            System.out.println("Sending error response: " + jsonResponse);
            resp.getWriter().write(jsonResponse);
        }

        System.out.println("====== END SPECIALTIES API SERVLET ======\n");
    }
}