package com.clinique.dto;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class TimeSlotDTO {
    private String startTime;
    private String endTime;
    private String displayTime;
    private boolean available;

    // Constructors
    public TimeSlotDTO() {}

    public TimeSlotDTO(LocalTime start, LocalTime end, boolean available) {
        // Format times as strings when storing in DTO
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        this.startTime = start.format(formatter);
        this.endTime = end.format(formatter);
        this.displayTime = start.format(formatter) + " - " + end.format(formatter);
        this.available = available;
    }

    public TimeSlotDTO(LocalTime startTime, LocalTime slotEnd) {
    }

    // Getters and setters
    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getDisplayTime() {
        return displayTime;
    }

    public void setDisplayTime(String displayTime) {
        this.displayTime = displayTime;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }
}