package com.clinique.service;

import com.clinique.repository.AvailabilityRepository;
import com.clinique.repository.AppointmentRepository;
import com.clinique.repository.DoctorRepository;
import com.clinique.utils.AppointmentValidator;
import com.clinique.mapper.AvailabilityMapper;
import com.clinique.enums.AvailabilityStatus;
import com.clinique.enums.AppointmentStatus;
import com.clinique.enums.AvailabilityType;
import jakarta.persistence.EntityManager;
import com.clinique.dto.AvailabilityDTO;
import com.clinique.entity.Availability;
import com.clinique.config.DBConnection;
import com.clinique.entity.Appointment;
import jakarta.persistence.TypedQuery;
import com.clinique.dto.TimeSlotDTO;
import java.util.stream.Collectors;
import com.clinique.entity.Doctor;
import java.time.LocalDateTime;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

public class AvailabilityService {

    private final DoctorRepository doctorRepository;
    private final AppointmentRepository appointmentRepository;
    private final AvailabilityRepository availabilityRepository;

    private static final LocalTime WORKDAY_START = LocalTime.of(9, 0);
    private static final LocalTime WORKDAY_END = LocalTime.of(17, 0);
    private static final int SLOT_DURATION_MINUTES = 30;
    private static class TimeRange {
        LocalTime start;
        LocalTime end;

        TimeRange(LocalTime start, LocalTime end) {
            this.start = start;
            this.end = end;
        }
    }

    public AvailabilityService() {
        this.doctorRepository = new DoctorRepository();
        this.appointmentRepository = new AppointmentRepository();
        this.availabilityRepository = new AvailabilityRepository();
    }

    private boolean isTimeSlotBooked(Doctor doctor, LocalDate date, LocalTime startTime, LocalTime endTime) {
        return appointmentRepository.existsByDoctorAndDateAndTimeOverlap(doctor, date, startTime, endTime);
    }

    public List<LocalDate> generateAvailableDates(UUID doctorId, int daysAhead) {
        Optional<Doctor> doctorOpt = doctorRepository.findById(doctorId);
        if (doctorOpt.isEmpty()) {
            throw new IllegalArgumentException("Docteur non trouvé");
        }

        LocalDate today = LocalDate.now();
        List<LocalDate> availableDates = new ArrayList<>();

        for (int i = 0; i < daysAhead; i++) {
            LocalDate date = today.plusDays(i);
            if (date.getDayOfWeek().getValue() < 6) {
                availableDates.add(date);
            }
        }

        Doctor doctor = doctorOpt.get();
        List<Availability> absences = availabilityRepository.findAbsencesByDoctor(doctor);

        availableDates.removeIf(date ->
                absences.stream().anyMatch(absence -> absence.getJour().equals(date))
        );

        return availableDates;
    }

    private boolean isOverlapping(LocalTime start1, LocalTime end1, LocalTime start2, LocalTime end2) {
        return !end1.isBefore(start2) && !end2.isBefore(start1);
    }

    public List<AvailabilityDTO> getRegularAvailabilities(UUID doctorId) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        List<Availability> regularAvailabilities = availabilityRepository.findRegularByDoctor(doctor);
        return regularAvailabilities.stream()
                .map(availability -> {
                    AvailabilityDTO dto = AvailabilityMapper.toDTO(availability);
                    dto.setType(AvailabilityType.REGULAR);
                    return dto;
                })
                .collect(Collectors.toList());
    }

    public List<AvailabilityDTO> getExceptionalAvailabilities(UUID doctorId) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        List<Availability> exceptionalAvailabilities = availabilityRepository.findExceptionalByDoctor(doctor);
        return exceptionalAvailabilities.stream()
                .map(availability -> {
                    AvailabilityDTO dto = AvailabilityMapper.toDTO(availability);
                    dto.setType(AvailabilityType.EXCEPTIONAL);
                    return dto;
                })
                .collect(Collectors.toList());
    }

    public List<AvailabilityDTO> getAbsences(UUID doctorId) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        List<Availability> absences = availabilityRepository.findAbsencesByDoctor(doctor);
        return absences.stream()
                .map(availability -> {
                    AvailabilityDTO dto = AvailabilityMapper.toDTO(availability);
                    dto.setType(AvailabilityType.ABSENCE);
                    return dto;
                })
                .collect(Collectors.toList());
    }

    public List<AvailabilityDTO> getAvailabilitiesForDate(UUID doctorId, LocalDate date) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        DayOfWeek dayOfWeek = date.getDayOfWeek();
        List<Availability> regularAvailabilities = new ArrayList<>();

        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                TypedQuery<Availability> q = em.createQuery(
                        "SELECT a FROM Availability a WHERE a.doctor = :doctor " +
                                "AND a.type = :type AND a.jourSemaine = :dayOfWeek " +
                                "ORDER BY a.heureDebut",
                        Availability.class);
                q.setParameter("doctor", doctor);
                q.setParameter("type", AvailabilityType.REGULAR);
                q.setParameter("dayOfWeek", dayOfWeek);
                regularAvailabilities = q.getResultList();
            } finally {
                if (em.isOpen()) em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        List<Availability> specificAvailabilities = new ArrayList<>();
        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                TypedQuery<Availability> q = em.createQuery(
                        "SELECT a FROM Availability a WHERE a.doctor = :doctor " +
                                "AND (a.type = :exceptional OR a.type = :absence) " +
                                "AND a.jour = :date ORDER BY a.heureDebut",
                        Availability.class);
                q.setParameter("doctor", doctor);
                q.setParameter("exceptional", AvailabilityType.EXCEPTIONAL);
                q.setParameter("absence", AvailabilityType.ABSENCE);
                q.setParameter("date", date);
                specificAvailabilities = q.getResultList();
            } finally {
                if (em.isOpen()) em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        List<Availability> allAvailabilities = new ArrayList<>(regularAvailabilities);
        allAvailabilities.addAll(specificAvailabilities);

        return allAvailabilities.stream()
                .map(availability -> {
                    AvailabilityDTO dto = AvailabilityMapper.toDTO(availability);
                    if (availability.getType() == AvailabilityType.REGULAR) {
                        dto.setDate(date);
                    }
                    return dto;
                })
                .collect(Collectors.toList());
    }

    public AvailabilityDTO saveAvailability(AvailabilityDTO availabilityDTO) {
        try {
            Doctor doctor = doctorRepository.findById(availabilityDTO.getDoctorId())
                    .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

            Availability availability = new Availability();

            if (availabilityDTO.getId() != null) {
                Optional<Availability> existingOpt = availabilityRepository.findById(availabilityDTO.getId());
                if (existingOpt.isPresent()) {
                    availability = existingOpt.get();
                }
            }

            AvailabilityType type = availabilityDTO.getType();

            if (type == AvailabilityType.REGULAR) {
                availability.setJourSemaine(availabilityDTO.getDayOfWeek());
                availability.setJour(null);
                availability.setStatut(AvailabilityStatus.AVAILABLE);
            } else if (type == AvailabilityType.EXCEPTIONAL) {
                availability.setJour(availabilityDTO.getDate());
                availability.setJourSemaine(null);
                availability.setStatut(AvailabilityStatus.AVAILABLE);
            } else if (type == AvailabilityType.ABSENCE) {
                availability.setJour(availabilityDTO.getDate());
                availability.setJourSemaine(null);
                availability.setStatut(AvailabilityStatus.UNAVAILABLE);
                availability.setRaison(availabilityDTO.getReason());
            }

            availability.setHeureDebut(availabilityDTO.getStartTime());
            availability.setHeureFin(availabilityDTO.getEndTime());
            availability.setDoctor(doctor);
            availability.setType(type);

            Availability saved = availabilityRepository.save(availability);

            AvailabilityDTO result = AvailabilityMapper.toDTO(saved);
            result.setReason(saved.getRaison());

            return result;
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("Error saving availability: " + ex.getMessage(), ex);
        }
    }

    public boolean deleteAvailability(UUID availabilityId) {
        Optional<Availability> availabilityOpt = availabilityRepository.findById(availabilityId);
        if (availabilityOpt.isEmpty()) {
            return false;
        }

        availabilityRepository.delete(availabilityOpt.get());
        return true;
    }

    public List<AvailabilityDTO> getAvailabilityForDate(UUID doctorId, LocalDate date) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        DayOfWeek dayOfWeek = date.getDayOfWeek();
        List<Availability> regularAvailabilities = new ArrayList<>();

        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                TypedQuery<Availability> q = em.createQuery(
                        "SELECT a FROM Availability a WHERE a.doctor = :doctor " +
                                "AND a.type = :type AND a.jourSemaine = :dayOfWeek " +
                                "ORDER BY a.heureDebut",
                        Availability.class);
                q.setParameter("doctor", doctor);
                q.setParameter("type", AvailabilityType.REGULAR);
                q.setParameter("dayOfWeek", dayOfWeek);
                regularAvailabilities = q.getResultList();
            } finally {
                if (em.isOpen()) em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        List<Availability> specificAvailabilities = new ArrayList<>();
        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                TypedQuery<Availability> q = em.createQuery(
                        "SELECT a FROM Availability a WHERE a.doctor = :doctor " +
                                "AND (a.type = :exceptional OR a.type = :absence) " +
                                "AND a.jour = :date ORDER BY a.heureDebut",
                        Availability.class);
                q.setParameter("doctor", doctor);
                q.setParameter("exceptional", AvailabilityType.EXCEPTIONAL);
                q.setParameter("absence", AvailabilityType.ABSENCE);
                q.setParameter("date", date);
                specificAvailabilities = q.getResultList();
            } finally {
                if (em.isOpen()) em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        List<Availability> allAvailabilities = new ArrayList<>(regularAvailabilities);
        allAvailabilities.addAll(specificAvailabilities);

        return allAvailabilities.stream()
                .map(availability -> {
                    AvailabilityDTO dto = AvailabilityMapper.toDTO(availability);
                    if (availability.getType() == AvailabilityType.REGULAR) {
                        dto.setDate(date);
                    }
                    return dto;
                })
                .collect(Collectors.toList());
    }

    public List<TimeSlotDTO> convertToTimeSlots(List<AvailabilityDTO> availabilities) {
        List<TimeSlotDTO> timeSlots = new ArrayList<>();

        for (AvailabilityDTO availability : availabilities) {
            if (availability.getStatus() != AvailabilityStatus.AVAILABLE) {
                continue;
            }

            TimeSlotDTO slot = new TimeSlotDTO();
            slot.setStartTime(availability.getStartTime().toString());
            slot.setEndTime(availability.getEndTime().toString());
            slot.setDisplayTime(availability.getStartTime().toString() + " - " + availability.getEndTime().toString());
            timeSlots.add(slot);
        }

        return timeSlots;
    }

    public List<TimeSlotDTO> getTimeSlotsForDate(UUID doctorId, LocalDate date) {
        List<AvailabilityDTO> availabilities = getAvailabilitiesForDate(doctorId, date);

        List<TimeSlotDTO> timeSlots = new ArrayList<>();

        for (AvailabilityDTO availability : availabilities) {
            if (availability.getStatus() != AvailabilityStatus.AVAILABLE) {
                continue;
            }

            LocalTime startTime = availability.getStartTime();
            LocalTime endTime = availability.getEndTime();

            while (startTime.plusMinutes(30).compareTo(endTime) <= 0) {
                LocalTime slotEndTime = startTime.plusMinutes(30);

                boolean isAvailable = !isTimeSlotBooked(
                        doctorRepository.findById(doctorId).orElseThrow(),
                        date,
                        startTime,
                        slotEndTime
                );

                if (isAvailable) {
                    TimeSlotDTO slot = new TimeSlotDTO();
                    slot.setStartTime(startTime.toString());
                    slot.setEndTime(slotEndTime.toString());
                    slot.setDisplayTime(startTime.toString() + " - " + slotEndTime.toString());
                    timeSlots.add(slot);
                }

                startTime = slotEndTime;
            }
        }

        return timeSlots;
    }

    public List<TimeSlotDTO> getAvailableTimeSlotsForBooking(UUID doctorId, LocalDate date) {
        System.out.println("\n=== Getting Available Time Slots ===");
        System.out.println("Doctor ID: " + doctorId);
        System.out.println("Date: " + date);
        System.out.println("Day of week: " + date.getDayOfWeek());

        List<TimeSlotDTO> allSlots = getAvailableTimeSlots(doctorId, date);
        System.out.println("Total slots found: " + allSlots.size());

        if (date.equals(LocalDate.now())) {
            LocalDateTime minValidTime = AppointmentValidator.getMinimumValidAppointmentTime();
            System.out.println("Filtering for today, min valid time: " + minValidTime);

            List<TimeSlotDTO> filteredSlots = allSlots.stream()
                    .filter(slot -> {
                        LocalTime slotTime = LocalTime.parse(slot.getStartTime());
                        LocalDateTime slotDateTime = LocalDateTime.of(date, slotTime);
                        boolean isValid = !slotDateTime.isBefore(minValidTime);
                        if (!isValid) {
                            System.out.println("  Filtered out slot: " + slot.getStartTime() + " (too soon)");
                        }
                        return isValid;
                    })
                    .collect(Collectors.toList());

            System.out.println("After filtering: " + filteredSlots.size() + " slots");
            return filteredSlots;
        }

        System.out.println("Returning all " + allSlots.size() + " slots\n");
        return allSlots;
    }

    public List<TimeSlotDTO> getAvailableTimeSlots(UUID doctorId, LocalDate date) {
        System.out.println("\n>>> getAvailableTimeSlots called <<<");
        System.out.println("Doctor ID: " + doctorId);
        System.out.println("Date: " + date);

        List<TimeSlotDTO> availableSlots = new ArrayList<>();

        try {
            Doctor doctor = doctorRepository.findById(doctorId)
                    .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

            int dayOfWeek = date.getDayOfWeek().getValue();

            List<Availability> availabilities = appointmentRepository.findByDoctorAndDayOfWeek(doctor, dayOfWeek);
            System.out.println("Found " + availabilities.size() + " availability records");

            if (availabilities.isEmpty()) {
                return availableSlots;
            }

            List<TimeRange> mergedPeriods = mergeAvailabilityPeriods(availabilities);
            System.out.println("Merged into " + mergedPeriods.size() + " periods");

            List<Appointment> appointments = appointmentRepository.findByDoctorAndDate(doctor, date);
            System.out.println("Found " + appointments.size() + " existing appointments");

            for (TimeRange period : mergedPeriods) {
                LocalTime startTime = period.start;
                LocalTime endTime = period.end;

                System.out.println("Generating slots for period: " + startTime + " - " + endTime);

                while (startTime.plusMinutes(30).compareTo(endTime) <= 0) {
                    LocalTime slotEndTime = startTime.plusMinutes(30);

                    boolean isAvailable = true;

                    for (Appointment appt : appointments) {
                        if (appt.getStatut() == AppointmentStatus.CANCELED) {
                            continue;
                        }

                        if ((startTime.isBefore(appt.getHeureFin()) && slotEndTime.isAfter(appt.getHeureDebut())) ||
                                startTime.equals(appt.getHeureDebut())) {
                            isAvailable = false;
                            break;
                        }
                    }

                    if (isAvailable) {
                        TimeSlotDTO slot = new TimeSlotDTO();
                        slot.setStartTime(startTime.toString());
                        slot.setEndTime(slotEndTime.toString());
                        slot.setDisplayTime(startTime.toString() + " - " + slotEndTime.toString());
                        availableSlots.add(slot);
                    }

                    startTime = slotEndTime;
                }
            }

            System.out.println("Total available slots: " + availableSlots.size());

        } catch (Exception e) {
            System.err.println("✗ ERROR in getAvailableTimeSlots:");
            e.printStackTrace();
        }

        return availableSlots;
    }

    private List<TimeRange> mergeAvailabilityPeriods(List<Availability> availabilities) {
        if (availabilities.isEmpty()) {
            return new ArrayList<>();
        }

        List<Availability> sorted = new ArrayList<>(availabilities);
        sorted.sort(Comparator.comparing(Availability::getHeureDebut));

        List<TimeRange> merged = new ArrayList<>();
        TimeRange current = new TimeRange(
                sorted.get(0).getHeureDebut(),
                sorted.get(0).getHeureFin()
        );

        for (int i = 1; i < sorted.size(); i++) {
            Availability avail = sorted.get(i);

            if (avail.getHeureDebut().compareTo(current.end) <= 0) {
                if (avail.getHeureFin().isAfter(current.end)) {
                    current.end = avail.getHeureFin();
                }
            } else {
                merged.add(current);
                current = new TimeRange(avail.getHeureDebut(), avail.getHeureFin());
            }
        }

        merged.add(current);

        return merged;
    }

}