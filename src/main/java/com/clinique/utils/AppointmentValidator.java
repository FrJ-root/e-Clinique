package com.clinique.utils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class AppointmentValidator {

    private static final int MIN_BOOKING_HOURS_ADVANCE = 2;

    public static boolean isValidAppointmentTime(LocalDate date, LocalTime startTime) {
        LocalDateTime appointmentDateTime = LocalDateTime.of(date, startTime);
        return !appointmentDateTime.isBefore(getMinimumValidAppointmentTime());
    }

    public static LocalDateTime getMinimumValidAppointmentTime() {
        return LocalDateTime.now().plusHours(MIN_BOOKING_HOURS_ADVANCE);
    }

    public static String getMinimumBookingTimeMessage() {
        return "Les rendez-vous doivent être pris au moins " + MIN_BOOKING_HOURS_ADVANCE +
                " heures à l'avance.";
    }

}