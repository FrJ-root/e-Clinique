package com.clinique.servlet.doctor;

import com.clinique.dto.AppointmentDTO;
import com.clinique.dto.TimeSlotDTO;
import com.clinique.dto.UserDTO;
import com.clinique.service.AppointmentService;
import com.clinique.service.AvailabilityService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet(name = "DoctorScheduleServlet", urlPatterns = {"/doctor/schedule"})
public class DoctorScheduleServlet extends HttpServlet {

    private final AppointmentService appointmentService = new AppointmentService();
    private final AvailabilityService availabilityService = new AvailabilityService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserDTO user = (session != null) ? (UserDTO) session.getAttribute("user") : null;

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        UUID doctorId = user.getId();
        String viewType = req.getParameter("view");
        if (viewType == null) viewType = "daily";

        LocalDate currentDate;
        try {
            String dateParam = req.getParameter("date");
            currentDate = (dateParam != null && !dateParam.isEmpty())
                    ? LocalDate.parse(dateParam)
                    : LocalDate.now();
        } catch (Exception e) {
            currentDate = LocalDate.now();
        }

        // Navigation dates
        LocalDate previousDate = "weekly".equals(viewType) ? currentDate.minusWeeks(1) : currentDate.minusDays(1);
        LocalDate nextDate = "weekly".equals(viewType) ? currentDate.plusWeeks(1) : currentDate.plusDays(1);

        req.setAttribute("currentDate", currentDate);
        req.setAttribute("previousDate", previousDate);
        req.setAttribute("nextDate", nextDate);

        req.setAttribute("viewType", viewType);

        // Format date for display
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEEE d MMMM yyyy", Locale.FRENCH);
        req.setAttribute("formattedDate", currentDate.format(dateFormatter));

        // For daily view
        if ("daily".equals(viewType)) {
            List<AppointmentDTO> appointments = appointmentService.findByDoctorAndDate(doctorId, currentDate);
            req.setAttribute("appointments", appointments);

            // Available slots for the day
            List<TimeSlotDTO> availableTimeSlots = availabilityService.getAvailableTimeSlotsForBooking(doctorId, currentDate);
            req.setAttribute("availableTimeSlots", availableTimeSlots);

        } else { // weekly view
            // Build week range
            LocalDate weekStart = currentDate.with(DayOfWeek.MONDAY);
            LocalDate weekEnd = currentDate.with(DayOfWeek.SUNDAY);
            req.setAttribute("weekRange", weekStart.format(DateTimeFormatter.ofPattern("dd/MM")) + " - " + weekEnd.format(DateTimeFormatter.ofPattern("dd/MM")));

            // For each day, list appointments
            Map<LocalDate, List<AppointmentDTO>> weeklySchedule = new LinkedHashMap<>();
            Map<LocalDate, String> formattedDays = new LinkedHashMap<>();
            for (int i = 0; i < 7; i++) {
                LocalDate day = weekStart.plusDays(i);
                List<AppointmentDTO> dayAppts = appointmentService.findByDoctorAndDate(doctorId, day);
                weeklySchedule.put(day, dayAppts);
                formattedDays.put(day, day.format(DateTimeFormatter.ofPattern("EEE d MMM", Locale.FRENCH)));
            }
            req.setAttribute("weeklySchedule", weeklySchedule.entrySet());
            req.setAttribute("formattedDays", formattedDays);
        }

        // Next 5 upcoming appointments (for quick view)
        List<AppointmentDTO> upcomingAppointments = appointmentService.findUpcomingByDoctor(doctorId);
        req.setAttribute("upcomingAppointments", upcomingAppointments);

        req.getRequestDispatcher("/WEB-INF/views/doctor/schedule.jsp").forward(req, resp);
    }
}