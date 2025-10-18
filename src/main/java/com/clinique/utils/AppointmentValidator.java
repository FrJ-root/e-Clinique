package com.clinique.utils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;

public class AppointmentValidator {

    /**
     * Minimum required hours in advance for booking appointments
     */
    private static final int MIN_HOURS_IN_ADVANCE = 2;

    /**
     * Check if appointment time is valid (at least MIN_HOURS_IN_ADVANCE hours in the future)
     *
     * @param appointmentDate The date of the appointment
     * @param appointmentTime The start time of the appointment
     * @return true if the appointment can be booked, false otherwise
     */
    public static boolean isValidAppointmentTime(LocalDate appointmentDate, LocalTime appointmentTime) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime appointmentDateTime = LocalDateTime.of(appointmentDate, appointmentTime);

        // Calculate hours between now and appointment
        long hoursDifference = ChronoUnit.HOURS.between(now, appointmentDateTime);

        // Appointment must be at least MIN_HOURS_IN_ADVANCE hours in the future
        return hoursDifference >= MIN_HOURS_IN_ADVANCE;
    }

    /**
     * Get the minimum valid appointment time based on current time
     *
     * @return LocalDateTime representing the earliest valid appointment time
     */
    public static LocalDateTime getMinimumValidAppointmentTime() {
        return LocalDateTime.now().plusHours(MIN_HOURS_IN_ADVANCE);
    }

    /**
     * Check if the given date is today
     *
     * @param date The date to check
     * @return true if date is today, false otherwise
     */
    public static boolean isToday(LocalDate date) {
        return date.equals(LocalDate.now());
    }

    /**
     * Format error message about minimum booking time
     *
     * @return Formatted error message
     */
    public static String getMinimumBookingTimeMessage() {
        return "Les rendez-vous doivent être pris au moins " + MIN_HOURS_IN_ADVANCE + " heures à l'avance";
    }
}