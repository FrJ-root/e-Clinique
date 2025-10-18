package com.clinique.service;

import com.clinique.config.DBConnection;
import com.clinique.repository.AvailabilityRepository;
import com.clinique.repository.AppointmentRepository;
import com.clinique.repository.DoctorRepository;
import com.clinique.mapper.AvailabilityMapper;
import com.clinique.enums.AvailabilityStatus;
import com.clinique.enums.AvailabilityType;
import com.clinique.dto.AvailabilityDTO;
import com.clinique.entity.Availability;
import com.clinique.entity.Appointment;
import com.clinique.dto.TimeSlotDTO;

import java.time.DayOfWeek;
import java.util.stream.Collectors;
import com.clinique.entity.Doctor;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Optional;
import java.util.List;
import java.util.UUID;

public class AvailabilityService {

    private final DoctorRepository doctorRepository;
    private final AppointmentRepository appointmentRepository;
    private final AvailabilityRepository availabilityRepository;

    private static final LocalTime WORKDAY_START = LocalTime.of(9, 0);
    private static final LocalTime WORKDAY_END = LocalTime.of(17, 0);
    private static final int SLOT_DURATION_MINUTES = 30;

    public AvailabilityService() {
        this.doctorRepository = new DoctorRepository();
        this.appointmentRepository = new AppointmentRepository();
        this.availabilityRepository = new AvailabilityRepository();
    }

    public List<TimeSlotDTO> generateAvailableTimeSlots(UUID doctorId, LocalDate date) {
        Optional<Doctor> doctorOpt = doctorRepository.findById(doctorId);
        if (doctorOpt.isEmpty()) {
            throw new IllegalArgumentException("Docteur non trouvé");
        }

        Doctor doctor = doctorOpt.get();
        if (!doctor.isActif()) {
            throw new IllegalArgumentException("Ce docteur n'est pas disponible actuellement");
        }

        List<Appointment> existingAppointments = appointmentRepository.findByDoctorAndDate(doctor, date);
        List<Availability> doctorAvailabilities = availabilityRepository.findByDoctorAndDate(doctor, date);

        boolean hasAbsence = doctorAvailabilities.stream().anyMatch(a -> a.getType() == AvailabilityType.ABSENCE);

        if (hasAbsence) {
            return new ArrayList<>();
        }

        List<TimeSlotDTO> availableSlots = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now();
        LocalTime currentTime = now.toLocalTime();
        LocalDate currentDate = now.toLocalDate();

        // If doctor has specific availabilities for this date, use those time ranges
        List<Availability> dateSpecificAvailabilities = doctorAvailabilities.stream()
                .filter(a -> a.getType() == AvailabilityType.EXCEPTIONAL ||
                        (a.getType() == AvailabilityType.REGULAR &&
                                a.getJourSemaine() == date.getDayOfWeek()))
                .collect(Collectors.toList());

        if (!dateSpecificAvailabilities.isEmpty()) {
            for (Availability avail : dateSpecificAvailabilities) {
                LocalTime startSlot = avail.getHeureDebut();

                while (startSlot.plusMinutes(SLOT_DURATION_MINUTES).isBefore(avail.getHeureFin()) ||
                        startSlot.plusMinutes(SLOT_DURATION_MINUTES).equals(avail.getHeureFin())) {

                    LocalTime endSlot = startSlot.plusMinutes(SLOT_DURATION_MINUTES);
                    boolean isAvailable = true;

                    // Check against existing appointments
                    for (Appointment appointment : existingAppointments) {
                        if (isOverlapping(startSlot, endSlot, appointment.getHeureDebut(), appointment.getHeureFin())) {
                            isAvailable = false;
                            break;
                        }
                    }

                    // Don't allow booking slots in the past or too close to current time
                    if (date.equals(currentDate) && startSlot.isBefore(currentTime.plusHours(2))) {
                        isAvailable = false;
                    }

                    if (isAvailable) {
                        TimeSlotDTO slot = new TimeSlotDTO();
                        slot.setStartTime(LocalDateTime.of(date, startSlot));
                        slot.setEndTime(LocalDateTime.of(date, endSlot));
                        slot.setAvailable(true);
                        availableSlots.add(slot);
                    }

                    startSlot = endSlot;
                }
            }
        } else {
            // Use default working hours if no specific availabilities
            LocalTime startTime = WORKDAY_START;

            while (startTime.plusMinutes(SLOT_DURATION_MINUTES).isBefore(WORKDAY_END) ||
                    startTime.plusMinutes(SLOT_DURATION_MINUTES).equals(WORKDAY_END)) {

                LocalTime endTime = startTime.plusMinutes(SLOT_DURATION_MINUTES);
                boolean isAvailable = true;

                for (Appointment appointment : existingAppointments) {
                    if (isOverlapping(startTime, endTime, appointment.getHeureDebut(), appointment.getHeureFin())) {
                        isAvailable = false;
                        break;
                    }
                }

                if (date.equals(currentDate) && startTime.isBefore(currentTime.plusHours(2))) {
                    isAvailable = false;
                }

                if (isAvailable) {
                    TimeSlotDTO slot = new TimeSlotDTO();
                    slot.setStartTime(LocalDateTime.of(date, startTime));
                    slot.setEndTime(LocalDateTime.of(date, endTime));
                    slot.setAvailable(true);
                    availableSlots.add(slot);
                }

                startTime = endTime;
            }
        }

        return availableSlots;
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

    public List<TimeSlotDTO> getAvailabilityForDate(UUID doctorId, LocalDate date) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        List<Availability> availabilities = availabilityRepository.findByDoctorAndDate(doctor, date);

        List<TimeSlotDTO> slots = new ArrayList<>();
        for (Availability availability : availabilities) {
            if (availability.getType() == AvailabilityType.ABSENCE) {
                continue;
            }

            TimeSlotDTO slot = new TimeSlotDTO();
            slot.setStartTime(LocalDateTime.of(date, availability.getHeureDebut()));
            slot.setEndTime(LocalDateTime.of(date, availability.getHeureFin()));
            slot.setAvailable(availability.getStatut() == AvailabilityStatus.AVAILABLE);
            slots.add(slot);
        }

        return slots;
    }

    public List<AvailabilityDTO> getAvailabilitiesForDate(UUID doctorId, LocalDate date) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        // Check for regular weekly availabilities
        DayOfWeek dayOfWeek = date.getDayOfWeek();
        List<Availability> regularAvailabilities = new ArrayList<>();

        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                // Find regular availabilities for this day of week
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

        // Get exceptional availabilities or absences for this specific date
        List<Availability> specificAvailabilities = new ArrayList<>();
        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                // Find exceptional availabilities for this specific date
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

        // Combine and convert to DTOs
        List<Availability> allAvailabilities = new ArrayList<>(regularAvailabilities);
        allAvailabilities.addAll(specificAvailabilities);

        return allAvailabilities.stream()
                .map(availability -> {
                    AvailabilityDTO dto = AvailabilityMapper.toDTO(availability);
                    // If it's a regular availability, set the date to the requested date
                    // since regular availabilities don't have a specific date
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

            // Ensure we're comparing enum to enum, not string to enum
            AvailabilityType type = availabilityDTO.getType();

            // Set appropriate fields based on availability type
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
            availability.setType(type); // Now both sides are AvailabilityType enums

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

}