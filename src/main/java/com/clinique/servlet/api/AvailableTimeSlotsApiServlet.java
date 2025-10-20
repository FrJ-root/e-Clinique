package com.clinique.servlet.api;

import com.clinique.service.AvailabilityService;
import com.clinique.utils.AppointmentValidator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@WebServlet(name = "AvailableTimeSlotsApiServlet", urlPatterns = "/api/available-time-slots")
public class AvailableTimeSlotsApiServlet extends HttpServlet {

    private final AvailabilityService availabilityService = new AvailabilityService();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Object> response = new HashMap<>();

        try {
            String doctorIdStr = req.getParameter("doctorId");
            String dateStr = req.getParameter("date");

            if (doctorIdStr == null || doctorIdStr.isEmpty() || dateStr == null || dateStr.isEmpty()) {
                response.put("success", false);
                response.put("error", "Doctor ID and date are required");
                resp.setContentType("application/json");
                objectMapper.writeValue(resp.getOutputStream(), response);
                return;
            }

            UUID doctorId = UUID.fromString(doctorIdStr);
            LocalDate date = LocalDate.parse(dateStr);

            response.put("success", true);
            response.put("timeSlots", availabilityService.getAvailableTimeSlotsForBooking(doctorId, date));
            response.put("minValidTime", AppointmentValidator.getMinimumValidAppointmentTime().toString());
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
        }

        resp.setContentType("application/json");
        objectMapper.writeValue(resp.getOutputStream(), response);
    }
}