package com.clinique.servlet.api;

import com.clinique.service.AvailabilityService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@WebServlet(name = "AvailableDatesApiServlet", urlPatterns = "/api/available-dates")
public class AvailableDatesApiServlet extends HttpServlet {

    private final AvailabilityService availabilityService = new AvailabilityService();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Object> response = new HashMap<>();

        try {
            String doctorIdStr = req.getParameter("doctorId");
            if (doctorIdStr == null || doctorIdStr.isEmpty()) {
                response.put("success", false);
                response.put("error", "Doctor ID is required");
                resp.setContentType("application/json");
                objectMapper.writeValue(resp.getOutputStream(), response);
                return;
            }

            UUID doctorId = UUID.fromString(doctorIdStr);

            LocalDate startDate = LocalDate.now();
            String startDateStr = req.getParameter("startDate");
            if (startDateStr != null && !startDateStr.isEmpty()) {
                try {
                    startDate = LocalDate.parse(startDateStr);
                } catch (DateTimeParseException e) {}
            }

            response.put("success", true);
            response.put("dates", availabilityService.generateAvailableDates(doctorId, 30));
            response.put("weekStart", startDate.toString());
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
        }

        resp.setContentType("application/json");
        objectMapper.writeValue(resp.getOutputStream(), response);
    }
}