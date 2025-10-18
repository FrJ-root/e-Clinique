package com.clinique.dto;

import com.clinique.enums.AvailabilityStatus;
import com.clinique.enums.AvailabilityType;
import java.time.format.DateTimeFormatter;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Locale;
import java.util.UUID;

public class AvailabilityDTO {
    private UUID id;
    private String reason;
    private UUID doctorId;
    private LocalDate date;
    private LocalTime endTime;
    private DayOfWeek dayOfWeek;
    private LocalTime startTime;
    private AvailabilityType type = AvailabilityType.REGULAR;
    private AvailabilityStatus status = AvailabilityStatus.AVAILABLE;

    public UUID getId() {
        return id;
    }
    public void setId(UUID id) {
        this.id = id;
    }

    public AvailabilityType getType() {
        return type;
    }
    public void setType(AvailabilityType type) {
        this.type = type;
    }

    public void setType(String typeStr) {
        if (typeStr != null) {
            try {
                this.type = AvailabilityType.valueOf(typeStr);
            } catch (IllegalArgumentException e) {
                // Default to REGULAR if invalid
                this.type = AvailabilityType.REGULAR;
            }
        }
    }

    public String getReason() {
        return reason;
    }
    public void setReason(String reason) {
        this.reason = reason;
    }

    public UUID getDoctorId() {
        return doctorId;
    }
    public void setDoctorId(UUID doctorId) {
        this.doctorId = doctorId;
    }

    public LocalDate getDate() {
        return date;
    }
    public void setDate(LocalDate date) {
        this.date = date;
    }

    public DayOfWeek getDayOfWeek() {
        return dayOfWeek;
    }
    public void setDayOfWeek(DayOfWeek dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public LocalTime getStartTime() {
        return startTime;
    }
    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }
    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public AvailabilityStatus getStatus() {
        return status;
    }
    public void setStatus(AvailabilityStatus status) {
        this.status = status;
    }

    public String getFormattedDate() {
        if (date == null) return "";

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy", Locale.FRANCE);
        return date.format(formatter);
    }

    public String getFormattedStartTime() {
        if (startTime == null) return "";
        return startTime.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    public String getFormattedEndTime() {
        if (endTime == null) return "";
        return endTime.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    public String getDisplayTime() {
        return getFormattedStartTime() + " - " + getFormattedEndTime();
    }

    public String getFormattedDayOfWeek() {
        if (dayOfWeek == null) return "";

        switch (dayOfWeek) {
            case MONDAY: return "Lundi";
            case TUESDAY: return "Mardi";
            case WEDNESDAY: return "Mercredi";
            case THURSDAY: return "Jeudi";
            case FRIDAY: return "Vendredi";
            case SATURDAY: return "Samedi";
            case SUNDAY: return "Dimanche";
            default: return "";
        }
    }

}