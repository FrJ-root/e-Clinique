package com.clinique.controller.doctor;

import com.clinique.service.AvailabilityService;
import jakarta.servlet.http.HttpServletRequest;
import java.time.format.DateTimeParseException;
import com.clinique.enums.AvailabilityStatus;
import com.clinique.enums.AvailabilityType;
import com.clinique.service.DoctorService;
import jakarta.servlet.http.HttpSession;
import com.clinique.dto.AvailabilityDTO;
import com.clinique.dto.DoctorDTO;
import com.clinique.dto.UserDTO;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

public class AvailabilityController {

    private final AvailabilityService availabilityService;
    private final DoctorService doctorService;

    private static final LocalTime WORKDAY_START = LocalTime.of(9, 0);
    private static final LocalTime WORKDAY_END = LocalTime.of(17, 0);

    public AvailabilityController() {
        this.availabilityService = new AvailabilityService();
        this.doctorService = new DoctorService();
    }

    public Map<String, Object> getAvailabilityData(HttpServletRequest request) {
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

            List<AvailabilityDTO> regularAvailabilities = availabilityService.getRegularAvailabilities(doctor.getId());
            List<AvailabilityDTO> exceptionalAvailabilities = availabilityService.getExceptionalAvailabilities(doctor.getId());
            List<AvailabilityDTO> absences = availabilityService.getAbsences(doctor.getId());

            result.put("success", true);
            result.put("doctor", doctor);
            result.put("regularAvailabilities", regularAvailabilities);
            result.put("exceptionalAvailabilities", exceptionalAvailabilities);
            result.put("absences", absences);
            result.put("daysOfWeek", DayOfWeek.values());

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des disponibilités: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> saveAvailability(HttpServletRequest request) {
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

            String typeStr = request.getParameter("availabilityType");
            if (typeStr == null || typeStr.isEmpty()) {
                result.put("success", false);
                result.put("error", "Type de disponibilité requis");
                return result;
            }

            typeStr = typeStr.toUpperCase();
            AvailabilityType availabilityType = AvailabilityType.REGULAR;
            try {
                availabilityType = AvailabilityType.valueOf(typeStr);
            } catch (IllegalArgumentException e) {
                result.put("success", false);
                result.put("error", "Type de disponibilité invalide");
                return result;
            }

            AvailabilityDTO availabilityDTO = new AvailabilityDTO();
            availabilityDTO.setDoctorId(doctor.getId());
            availabilityDTO.setType(availabilityType);
            availabilityDTO.setStatus(AvailabilityStatus.AVAILABLE);

            switch (availabilityType) {
                case REGULAR:
                    String dayOfWeekStr = request.getParameter("dayOfWeek");
                    if (dayOfWeekStr == null || dayOfWeekStr.isEmpty()) {
                        result.put("success", false);
                        result.put("error", "Jour de la semaine requis");
                        return result;
                    }

                    try {
                        DayOfWeek dayOfWeek = DayOfWeek.valueOf(dayOfWeekStr);
                        availabilityDTO.setDayOfWeek(dayOfWeek);
                    } catch (IllegalArgumentException e) {
                        result.put("success", false);
                        result.put("error", "Jour de semaine invalide");
                        return result;
                    }

                    String startTimeStr = request.getParameter("startTime");
                    String endTimeStr = request.getParameter("endTime");

                    if (startTimeStr == null || endTimeStr == null) {
                        result.put("success", false);
                        result.put("error", "Heures de début et de fin requises");
                        return result;
                    }

                    try {
                        LocalTime startTime = LocalTime.parse(startTimeStr);
                        LocalTime endTime = LocalTime.parse(endTimeStr);

                        if (endTime.isBefore(startTime) || endTime.equals(startTime)) {
                            result.put("success", false);
                            result.put("error", "L'heure de fin doit être après l'heure de début");
                            return result;
                        }

                        availabilityDTO.setStartTime(startTime);
                        availabilityDTO.setEndTime(endTime);
                    } catch (DateTimeParseException e) {
                        result.put("success", false);
                        result.put("error", "Format d'heure invalide");
                        return result;
                    }
                    break;

                case EXCEPTIONAL:
                    String dateStr = request.getParameter("date");
                    if (dateStr == null || dateStr.isEmpty()) {
                        result.put("success", false);
                        result.put("error", "Date requise");
                        return result;
                    }

                    try {
                        LocalDate date = LocalDate.parse(dateStr);
                        availabilityDTO.setDate(date);

                        if (date.isBefore(LocalDate.now())) {
                            result.put("success", false);
                            result.put("error", "La date ne peut pas être dans le passé");
                            return result;
                        }
                    } catch (DateTimeParseException e) {
                        result.put("success", false);
                        result.put("error", "Format de date invalide");
                        return result;
                    }

                    String exceptionalStartTimeStr = request.getParameter("startTime");
                    String exceptionalEndTimeStr = request.getParameter("endTime");

                    if (exceptionalStartTimeStr == null || exceptionalStartTimeStr.isEmpty() ||
                            exceptionalEndTimeStr == null || exceptionalEndTimeStr.isEmpty()) {
                        result.put("success", false);
                        result.put("error", "Heures de début et de fin requises pour disponibilité exceptionnelle");
                        return result;
                    }

                    try {
                        LocalTime startTime = LocalTime.parse(exceptionalStartTimeStr);
                        LocalTime endTime = LocalTime.parse(exceptionalEndTimeStr);

                        if (endTime.isBefore(startTime) || endTime.equals(startTime)) {
                            result.put("success", false);
                            result.put("error", "L'heure de fin doit être après l'heure de début");
                            return result;
                        }

                        availabilityDTO.setStartTime(startTime);
                        availabilityDTO.setEndTime(endTime);
                    } catch (DateTimeParseException e) {
                        result.put("success", false);
                        result.put("error", "Format d'heure invalide");
                        return result;
                    }
                    break;

                case ABSENCE:
                    String absenceDateStr = request.getParameter("date");
                    if (absenceDateStr == null || absenceDateStr.isEmpty()) {
                        result.put("success", false);
                        result.put("error", "Date requise");
                        return result;
                    }

                    try {
                        LocalDate date = LocalDate.parse(absenceDateStr);
                        availabilityDTO.setDate(date);

                        if (date.isBefore(LocalDate.now())) {
                            result.put("success", false);
                            result.put("error", "La date ne peut pas être dans le passé");
                            return result;
                        }
                    } catch (DateTimeParseException e) {
                        result.put("success", false);
                        result.put("error", "Format de date invalide");
                        return result;
                    }

                    String fullDayStr = request.getParameter("fullDayAbsence");
                    boolean isFullDay = fullDayStr != null && ("on".equals(fullDayStr) || "true".equals(fullDayStr));

                    System.out.println("fullDayStr value: " + fullDayStr);
                    System.out.println("isFullDay: " + isFullDay);

                    if (isFullDay) {
                        availabilityDTO.setStartTime(LocalTime.of(9, 0));
                        availabilityDTO.setEndTime(LocalTime.of(17, 0));
                    } else {
                        String absenceStartTimeStr = request.getParameter("startTime");
                        String absenceEndTimeStr = request.getParameter("endTime");

                        System.out.println("Start time: " + absenceStartTimeStr);
                        System.out.println("End time: " + absenceEndTimeStr);

                        if (absenceStartTimeStr == null || absenceStartTimeStr.isEmpty() ||
                                absenceEndTimeStr == null || absenceEndTimeStr.isEmpty()) {
                            result.put("success", false);
                            result.put("error", "Heures de début et de fin requises pour absence partielle");
                            return result;
                        }

                        try {
                            LocalTime startTime = LocalTime.parse(absenceStartTimeStr);
                            LocalTime endTime = LocalTime.parse(absenceEndTimeStr);

                            if (endTime.isBefore(startTime) || endTime.equals(startTime)) {
                                result.put("success", false);
                                result.put("error", "L'heure de fin doit être après l'heure de début");
                                return result;
                            }

                            availabilityDTO.setStartTime(startTime);
                            availabilityDTO.setEndTime(endTime);
                        } catch (DateTimeParseException e) {
                            result.put("success", false);
                            result.put("error", "Format d'heure invalide");
                            return result;
                        }
                    }

                    String reason = request.getParameter("reason");
                    availabilityDTO.setReason(reason);
                    availabilityDTO.setStatus(AvailabilityStatus.UNAVAILABLE);
                    break;
            }

            try {
                AvailabilityDTO saved = availabilityService.saveAvailability(availabilityDTO);
                result.put("success", true);
                result.put("availability", saved);
                result.put("message", "Disponibilité enregistrée avec succès");
            } catch (Exception e) {
                e.printStackTrace();
                result.put("success", false);
                result.put("error", "Erreur lors de l'enregistrement: " + e.getMessage());
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            result.put("success", false);
            result.put("error", "Erreur lors de l'enregistrement de la disponibilité: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> deleteAvailability(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            String availabilityIdStr = request.getParameter("availabilityId");
            if (availabilityIdStr == null || availabilityIdStr.isEmpty()) {
                result.put("success", false);
                result.put("error", "ID de disponibilité requis");
                return result;
            }

            UUID availabilityId = UUID.fromString(availabilityIdStr);

            boolean deleted = availabilityService.deleteAvailability(availabilityId);

            if (deleted) {
                result.put("success", true);
                result.put("message", "Disponibilité supprimée avec succès");
            } else {
                result.put("success", false);
                result.put("error", "Impossible de supprimer la disponibilité");
            }

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", "ID de disponibilité invalide");
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la suppression de la disponibilité: " + ex.getMessage());
        }

        return result;
    }

}