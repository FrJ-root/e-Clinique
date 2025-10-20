package com.clinique.servlet.api;

import com.clinique.service.DoctorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@WebServlet(name = "DoctorsApiServlet", urlPatterns = "/api/doctors")
public class DoctorsApiServlet extends HttpServlet {

    private final DoctorService doctorService = new DoctorService();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Object> response = new HashMap<>();

        try {
            String specialtyIdStr = req.getParameter("specialtyId");
            if (specialtyIdStr != null && !specialtyIdStr.isEmpty()) {
                UUID specialtyId = UUID.fromString(specialtyIdStr);
                response.put("success", true);
                response.put("doctors", doctorService.findBySpecialty(specialtyId));
            } else {
                response.put("success", true);
                response.put("doctors", doctorService.findAll());
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
        }

        resp.setContentType("application/json");
        objectMapper.writeValue(resp.getOutputStream(), response);
    }
}