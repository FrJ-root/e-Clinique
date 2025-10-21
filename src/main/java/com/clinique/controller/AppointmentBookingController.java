package com.clinique.controller;


import com.clinique.service.AvailabilityService;
import com.clinique.service.AppointmentService;
import com.clinique.utils.AppointmentValidator;
import jakarta.servlet.http.HttpServletRequest;
import java.time.format.DateTimeParseException;
import com.clinique.service.DoctorService;
import jakarta.servlet.http.HttpSession;
import com.clinique.dto.AppointmentDTO;
import com.clinique.dto.TimeSlotDTO;
import com.clinique.dto.PatientDTO;
import com.clinique.dto.DoctorDTO;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.UUID;
import java.util.List;
import java.util.Map;

public class AppointmentBookingController {

    private final DoctorService doctorService;
    private final AvailabilityService availabilityService;
    private final AppointmentService appointmentService;

    public AppointmentBookingController() {
        this.doctorService = new DoctorService();
        this.availabilityService = new AvailabilityService();
        this.appointmentService = new AppointmentService();
    }

    public Map<String, Object> getAvailableTimeSlots(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Session invalide");
                return result;
            }

            String doctorIdStr = request.getParameter("doctorId");
            String dateStr = request.getParameter("date");

            if (doctorIdStr == null || dateStr == null) {
                result.put("success", false);
                result.put("error", "ID du docteur et date requis");
                return result;
            }

            UUID doctorId = UUID.fromString(doctorIdStr);
            LocalDate date;
            try {
                date = LocalDate.parse(dateStr);
            } catch (DateTimeParseException e) {
                result.put("success", false);
                result.put("error", "Format de date invalide");
                return result;
            }

            DoctorDTO doctor = doctorService.findById(doctorId);
            if (doctor == null) {
                result.put("success", false);
                result.put("error", "Docteur non trouvé");
                return result;
            }

            List<TimeSlotDTO> availableSlots = availabilityService.getAvailableTimeSlotsForBooking(doctorId, date);
            List<LocalDate> availableDates = availabilityService.generateAvailableDates(doctorId, 30);

            result.put("minBookingHours", 2);
            result.put("currentTime", LocalDateTime.now());
            result.put("minValidTime", AppointmentValidator.getMinimumValidAppointmentTime());

            result.put("success", true);
            result.put("doctor", doctor);
            result.put("date", dateStr);
            result.put("selectedDate", date);
            result.put("availableDates", availableDates);
            result.put("timeSlots", availableSlots);

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            ex.printStackTrace();
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des créneaux disponibles");
        }

        return result;
    }

    public Map<String, Object> bookAppointment(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Session invalide");
                return result;
            }

            Object userObj = session.getAttribute("user");
            if (!(userObj instanceof PatientDTO)) {
                result.put("success", false);
                result.put("error", "Accès réservé aux patients");
                return result;
            }

            PatientDTO patient = (PatientDTO) userObj;
            UUID patientId = patient.getId();

            String doctorIdStr = request.getParameter("doctorId");
            String dateStr = request.getParameter("date");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String motif = request.getParameter("motif");

            if (doctorIdStr == null || dateStr == null || startTimeStr == null || endTimeStr == null || motif == null) {
                result.put("success", false);
                result.put("error", "Tous les champs sont requis");
                return result;
            }

            UUID doctorId = UUID.fromString(doctorIdStr);
            LocalDate date = LocalDate.parse(dateStr);
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalTime endTime;

            if (!AppointmentValidator.isValidAppointmentTime(date, startTime)) {
                result.put("success", false);
                result.put("error", AppointmentValidator.getMinimumBookingTimeMessage());
                return result;
            }

            try {
                date = LocalDate.parse(dateStr);
                startTime = LocalTime.parse(startTimeStr);
                endTime = LocalTime.parse(endTimeStr);
            } catch (DateTimeParseException e) {
                result.put("success", false);
                result.put("error", "Format de date ou d'heure invalide");
                return result;
            }

            AppointmentDTO appointment = appointmentService.bookAppointment(
                    patientId, doctorId, date, startTime, endTime, motif);

            result.put("success", true);
            result.put("appointment", appointment);
            result.put("message", "Rendez-vous réservé avec succès");

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la réservation du rendez-vous");
        }

        return result;
    }

}