package com.clinique.controller.doctor;

import com.clinique.dto.*;
import com.clinique.service.AppointmentService;
import com.clinique.service.AvailabilityService;
import com.clinique.service.DoctorService;
import com.clinique.enums.AppointmentStatus;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.WeekFields;
import java.util.*;
import java.util.stream.Collectors;

public class DoctorScheduleController {

    private final DoctorService doctorService;
    private final AppointmentService appointmentService;
    private final AvailabilityService availabilityService;

    public DoctorScheduleController() {
        this.doctorService = new DoctorService();
        this.appointmentService = new AppointmentService();
        this.availabilityService = new AvailabilityService();
    }

    public Map<String, Object> getScheduleData(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Session invalide");
                return result;
            }

            Object userObj = session.getAttribute("user");
            DoctorDTO doctor = null;

            if (userObj instanceof DoctorDTO) {
                doctor = (DoctorDTO) userObj;
            } else if (userObj instanceof UserDTO) {
                UserDTO userDTO = (UserDTO) userObj;
                if ("DOCTOR".equals(userDTO.getRole())) {
                    doctor = doctorService.findByUserId(userDTO.getId());
                }
            }

            if (doctor == null) {
                result.put("success", false);
                result.put("error", "Médecin non trouvé");
                return result;
            }

            // Determine the view type (daily or weekly)
            String viewType = request.getParameter("view");
            if (viewType == null) {
                viewType = "daily"; // Default to daily view
            }

            // Get the requested date or default to today
            LocalDate requestedDate = null;
            String dateStr = request.getParameter("date");

            if (dateStr != null && !dateStr.isEmpty()) {
                try {
                    requestedDate = LocalDate.parse(dateStr);
                } catch (Exception e) {
                    requestedDate = LocalDate.now();
                }
            } else {
                requestedDate = LocalDate.now();
            }

            // Set basic data
            result.put("success", true);
            result.put("doctor", doctor);
            result.put("currentDate", requestedDate);
            result.put("viewType", viewType);

            // Add formatted dates for display
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM yyyy", Locale.FRANCE);
            result.put("formattedDate", requestedDate.format(formatter));

            if ("daily".equals(viewType)) {
                // Get appointments for the day
                List<AppointmentDTO> dailyAppointments = appointmentService.getAppointmentsByDoctorAndDate(
                        doctor.getId(), requestedDate);

                // Filter and organize appointments by status
                Map<String, List<AppointmentDTO>> appointmentsByStatus = dailyAppointments.stream()
                        .collect(Collectors.groupingBy(app -> app.getStatut().toString()));

                result.put("appointments", dailyAppointments);
                result.put("appointmentsByStatus", appointmentsByStatus);
                result.put("upcomingAppointments", dailyAppointments.stream()
                        .filter(a -> a.getStatut() == AppointmentStatus.PLANNED)
                        .sorted(Comparator.comparing(a ->
                                LocalDateTime.of(a.getDate(), a.getHeureDebut())))
                        .collect(Collectors.toList()));

                // Get availabilities for the day
                List<TimeSlotDTO> availableTimeSlots = availabilityService.getAvailabilityForDate(
                        doctor.getId(), requestedDate);
                result.put("availableTimeSlots", availableTimeSlots);

                // Previous and next day for navigation
                result.put("previousDate", requestedDate.minusDays(1));
                result.put("nextDate", requestedDate.plusDays(1));

            } else if ("weekly".equals(viewType)) {
                // Calculate the first day of the week (Monday)
                LocalDate firstDayOfWeek = requestedDate.with(WeekFields.of(Locale.FRANCE).getFirstDayOfWeek());

                // Calculate the last day of the week (Sunday)
                LocalDate lastDayOfWeek = firstDayOfWeek.plusDays(6);

                // Format week range for display
                String weekRange = firstDayOfWeek.format(formatter) + " - " + lastDayOfWeek.format(formatter);
                result.put("weekRange", weekRange);

                // Create a map of days in the week
                Map<LocalDate, List<AppointmentDTO>> weeklySchedule = new LinkedHashMap<>();
                Map<LocalDate, String> formattedDays = new LinkedHashMap<>();
                DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("EEEE dd/MM", Locale.FRANCE);

                // Initialize the map with empty lists for each day
                for (int i = 0; i < 7; i++) {
                    LocalDate day = firstDayOfWeek.plusDays(i);
                    weeklySchedule.put(day, new ArrayList<>());
                    formattedDays.put(day, day.format(dayFormatter));
                }

                // Get appointments for the entire week
                List<AppointmentDTO> weeklyAppointments = appointmentService.getAppointmentsByDoctorAndDateRange(
                        doctor.getId(), firstDayOfWeek, lastDayOfWeek);

                // Organize appointments by day
                for (AppointmentDTO appointment : weeklyAppointments) {
                    LocalDate appointmentDate = appointment.getDate();
                    weeklySchedule.get(appointmentDate).add(appointment);
                }

                // Get all availabilities for the week
                Map<LocalDate, List<AvailabilityDTO>> weeklyAvailabilities = new LinkedHashMap<>();

                for (int i = 0; i < 7; i++) {
                    LocalDate day = firstDayOfWeek.plusDays(i);
                    // This will combine regular weekly and exceptional availabilities
                    List<AvailabilityDTO> dayAvailabilities = availabilityService.getAvailabilitiesForDate(doctor.getId(), day);
                    weeklyAvailabilities.put(day, dayAvailabilities);
                }

                // Previous and next week for navigation
                result.put("previousDate", firstDayOfWeek.minusWeeks(1));
                result.put("nextDate", firstDayOfWeek.plusWeeks(1));
                result.put("firstDayOfWeek", firstDayOfWeek);
                result.put("lastDayOfWeek", lastDayOfWeek);
                result.put("weeklySchedule", weeklySchedule);
                result.put("formattedDays", formattedDays);
                result.put("weeklyAppointments", weeklyAppointments);
                result.put("weeklyAvailabilities", weeklyAvailabilities);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            result.put("success", false);
            result.put("error", "Erreur lors du chargement de l'agenda: " + ex.getMessage());
        }

        return result;
    }
}