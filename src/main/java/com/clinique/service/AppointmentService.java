package com.clinique.service;

import com.clinique.config.DBConnection;
import com.clinique.dto.AvailabilityDTO;
import com.clinique.dto.MedicalNoteDTO;
import com.clinique.dto.TimeSlotDTO;
import com.clinique.entity.*;
import com.clinique.mapper.AvailabilityMapper;
import com.clinique.mapper.MedicalNoteMapper;
import com.clinique.repository.AppointmentRepository;
import com.clinique.repository.AvailabilityRepository;
import com.clinique.repository.PatientRepository;
import com.clinique.repository.DoctorRepository;
import com.clinique.mapper.AppointmentMapper;
import com.clinique.enums.AppointmentStatus;
import com.clinique.dto.AppointmentDTO;

import java.util.stream.Collectors;

import com.clinique.utils.AppointmentValidator;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.time.*;
import java.util.*;

public class AppointmentService {

    private final AppointmentRepository appointmentRepository = new AppointmentRepository();
    private final PatientRepository patientRepository = new PatientRepository();
    private final DoctorRepository doctorRepository = new DoctorRepository();
    private final AvailabilityRepository availabilityRepository = new AvailabilityRepository();

    public AppointmentDTO bookAppointment(UUID patientId, UUID doctorId, LocalDate date, LocalTime startTime, LocalTime endTime, String motif) {

        Optional<Patient> patientOpt = patientRepository.findById(patientId);
        if (patientOpt.isEmpty()) {
            throw new IllegalArgumentException("Patient non trouvé");
        }

        Patient patient = patientOpt.get();
        if (!patient.isActif()) {
            throw new IllegalArgumentException("Le patient n'est pas actif");
        }

        Optional<Doctor> doctorOpt = doctorRepository.findById(doctorId);
        if (doctorOpt.isEmpty()) {
            throw new IllegalArgumentException("Docteur non trouvé");
        }

        Doctor doctor = doctorOpt.get();
        if (!doctor.isActif()) {
            throw new IllegalArgumentException("Le docteur n'est pas actif");
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime appointmentDateTime = LocalDateTime.of(date, startTime);

        if (appointmentDateTime.isBefore(now)) {
            throw new IllegalArgumentException("La date et l'heure du rendez-vous ne peuvent pas être dans le passé");
        }

        if (appointmentDateTime.isBefore(now.plusHours(2))) {
            throw new IllegalArgumentException("Les rendez-vous doivent être pris au moins 2 heures à l'avance");
        }

        List<Appointment> overlappingAppointments = appointmentRepository.findOverlappingAppointments(doctor, date, startTime, endTime);
        if (!overlappingAppointments.isEmpty()) {
            throw new IllegalArgumentException("Ce créneau est déjà réservé");
        }

        Appointment appointment = new Appointment();
        appointment.setDate(date);
        appointment.setHeureDebut(startTime);
        appointment.setHeureFin(endTime);
        appointment.setPatient(patient);
        appointment.setDoctor(doctor);
        appointment.setStatut(AppointmentStatus.PLANNED);
        appointment.setMotif(motif);

        Appointment saved = appointmentRepository.save(appointment);
        return AppointmentMapper.toDTO(saved);
    }

    public int countCancellationsSince(LocalDate since) {
        return appointmentRepository.countCancellationsSince(since);
    }

    public int countAppointmentsByDate(LocalDate date) {
        return appointmentRepository.countByDate(date);
    }

    public List<AppointmentDTO> findByDoctorAndDate(UUID doctorId, LocalDate date) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        List<Appointment> appointments = appointmentRepository.findByDoctorAndDate(doctor, date);
        return appointments.stream()
                .map(AppointmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public int countTotalAppointments() {
        return appointmentRepository.countAll();
    }

    public List<AppointmentDTO> findUpcomingByPatient(UUID patientId) {
        Optional<Patient> patientOpt = patientRepository.findById(patientId);
        if (patientOpt.isEmpty()) {
            throw new IllegalArgumentException("Patient non trouvé");
        }

        return appointmentRepository.findByPatientAndStatus(patientOpt.get(), AppointmentStatus.PLANNED)
                .stream()
                .filter(a -> a.getDate().isAfter(LocalDate.now()) ||
                        (a.getDate().isEqual(LocalDate.now()) && a.getHeureDebut().isAfter(LocalTime.now())))
                .map(AppointmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<AppointmentDTO> findUpcomingByDoctor(UUID doctorId) {
        try {
            Optional<Doctor> doctorOpt = doctorRepository.findById(doctorId);
            if (doctorOpt.isEmpty()) {
                throw new IllegalArgumentException("Docteur non trouvé");
            }

            Doctor doctor = doctorOpt.get();
            List<Appointment> appointments = appointmentRepository.findUpcomingByDoctor(doctor);

            return appointments.stream()
                    .map(appointment -> {
                        AppointmentDTO dto = AppointmentMapper.toDTO(appointment);
                        return dto;
                    })
                    .collect(Collectors.toList());
        } catch (Exception ex) {
            throw new RuntimeException("Erreur lors de la récupération des rendez-vous à venir", ex);
        }
    }

    public List<Map<String, Object>> getTodaysAppointmentsSummary() {
        LocalDate today = LocalDate.now();
        List<Appointment> appointments = appointmentRepository.findByDate(today);

        List<Map<String, Object>> summary = new ArrayList<>();
        for (Appointment appointment : appointments) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", appointment.getId());
            item.put("patientName", appointment.getPatient().getNom());
            item.put("doctorName", appointment.getDoctor().getNom());
            item.put("startTime", appointment.getHeureDebut());
            item.put("endTime", appointment.getHeureFin());
            item.put("status", appointment.getStatut());
            summary.add(item);
        }

        return summary;
    }

    public List<AppointmentDTO> findByPatient(UUID patientId) {
        Optional<Patient> patientOpt = patientRepository.findById(patientId);
        if (patientOpt.isEmpty()) {
            throw new IllegalArgumentException("Patient non trouvé");
        }

        return appointmentRepository.findByPatient(patientOpt.get())
                .stream()
                .map(AppointmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public AppointmentDTO cancelAppointment(UUID appointmentId) {
        Optional<Appointment> appointmentOpt = appointmentRepository.findById(appointmentId);
        if (appointmentOpt.isEmpty()) {
            throw new IllegalArgumentException("Rendez-vous non trouvé");
        }

        Appointment appointment = appointmentOpt.get();

        if (appointment.getStatut() != AppointmentStatus.PLANNED) {
            throw new IllegalArgumentException("Seuls les rendez-vous prévus peuvent être annulés");
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime appointmentDateTime = LocalDateTime.of(appointment.getDate(), appointment.getHeureDebut());

        if (appointmentDateTime.minusHours(12).isBefore(now)) {
            throw new IllegalArgumentException("Les rendez-vous ne peuvent être annulés que 12 heures à l'avance");
        }

        appointment.setStatut(AppointmentStatus.CANCELED);
        Appointment updated = appointmentRepository.save(appointment);

        return AppointmentMapper.toDTO(updated);
    }

    public AppointmentDTO getAppointment(UUID appointmentId) {
        Optional<Appointment> appointmentOpt = appointmentRepository.findById(appointmentId);
        if (appointmentOpt.isEmpty()) {
            throw new IllegalArgumentException("Rendez-vous non trouvé");
        }

        return AppointmentMapper.toDTO(appointmentOpt.get());
    }

    public double calculateOccupancyRate(LocalDate date) {
        int totalSlots = calculateTotalSlots(date);
        if (totalSlots == 0) return 0.0;

        int bookedSlots = appointmentRepository.countByDate(date);
        return (double) bookedSlots / totalSlots * 100.0;
    }

    private int calculateTotalSlots(LocalDate date) {
        return 50;
    }

    public List<AppointmentDTO> getAppointmentsByDoctorAndDate(UUID doctorId, LocalDate date) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        List<Appointment> appointments = appointmentRepository.findByDoctorAndDate(doctor, date);

        return appointments.stream()
                .map(AppointmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<AppointmentDTO> getAppointmentsByDoctorAndDateRange(UUID doctorId, LocalDate startDate, LocalDate endDate) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        List<Appointment> appointments = new ArrayList<>();

        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                // Find appointments in the date range
                TypedQuery<Appointment> q = em.createQuery(
                        "SELECT a FROM Appointment a WHERE a.doctor = :doctor " +
                                "AND a.jour >= :startDate AND a.jour <= :endDate " +
                                "ORDER BY a.jour, a.heureDebut",
                        Appointment.class);
                q.setParameter("doctor", doctor);
                q.setParameter("startDate", startDate);
                q.setParameter("endDate", endDate);
                appointments = q.getResultList();
            } finally {
                if (em.isOpen()) em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments.stream()
                .map(AppointmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<AppointmentDTO> getAllByDoctor(UUID doctorId) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        List<Appointment> appointments = appointmentRepository.findByDoctor(doctor);

        return appointments.stream()
                .sorted(Comparator.comparing(Appointment::getDate).reversed()
                        .thenComparing(Appointment::getHeureDebut))
                .map(AppointmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<AppointmentDTO> findPastByDoctor(UUID doctorId) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();

        List<Appointment> appointments = appointmentRepository.findPastByDoctor(doctor, today, now);

        return appointments.stream()
                .map(AppointmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public AppointmentDTO updateAppointmentStatus(UUID appointmentId, UUID doctorId, AppointmentStatus newStatus, String note) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new IllegalArgumentException("Rendez-vous non trouvé"));

        // Security check - verify this appointment belongs to the doctor
        if (!appointment.getDoctor().getId().equals(doctorId)) {
            throw new IllegalArgumentException("Vous n'êtes pas autorisé à modifier ce rendez-vous");
        }

        // Update appointment status
        appointment.setStatut(newStatus);

        // If a note was provided and status is DONE, create or update medical note
        if (newStatus == AppointmentStatus.DONE && note != null && !note.trim().isEmpty()) {
            MedicalNote medicalNote = appointment.getMedicalNote();
            if (medicalNote == null) {
                medicalNote = new MedicalNote();
                medicalNote.setAppointment(appointment);
            }
            medicalNote.setNote(note);
            appointment.setMedicalNote(medicalNote);
        }

        // Save changes
        Appointment updated = appointmentRepository.save(appointment);

        return AppointmentMapper.toDTO(updated);
    }

    public MedicalNoteDTO getMedicalNote(UUID appointmentId) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new IllegalArgumentException("Rendez-vous non trouvé"));

        MedicalNote medicalNote = appointment.getMedicalNote();
        if (medicalNote == null) {
            return null;
        }

        return MedicalNoteMapper.toDTO(medicalNote);
    }

    public List<AppointmentDTO> getCompletedAppointmentsByDoctor(UUID doctorId) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        List<Appointment> appointments = appointmentRepository.findByDoctor(doctor).stream()
                .filter(a -> a.getStatut() == AppointmentStatus.DONE)
                .sorted(Comparator.comparing(Appointment::getDate).reversed())
                .collect(Collectors.toList());

        return appointments.stream()
                .map(AppointmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<AppointmentDTO> getCompletedAppointmentsWithoutNotes(UUID doctorId) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        List<Appointment> appointments = appointmentRepository.findByDoctor(doctor).stream()
                .filter(a -> a.getStatut() == AppointmentStatus.DONE && a.getMedicalNote() == null)
                .sorted(Comparator.comparing(Appointment::getDate).reversed())
                .collect(Collectors.toList());

        return appointments.stream()
                .map(AppointmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<AppointmentDTO> getCompletedAppointmentsSince(UUID doctorId, LocalDate startDate) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        List<Appointment> appointments = appointmentRepository.findByDoctor(doctor).stream()
                .filter(a -> a.getStatut() == AppointmentStatus.DONE &&
                        !a.getDate().isBefore(startDate))
                .sorted(Comparator.comparing(Appointment::getDate).reversed())
                .collect(Collectors.toList());

        return appointments.stream()
                .map(AppointmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<AppointmentDTO> getCompletedAppointmentsByPatient(UUID doctorId, UUID patientId) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new IllegalArgumentException("Patient non trouvé"));

        List<Appointment> appointments = appointmentRepository.findByDoctor(doctor).stream()
                .filter(a -> a.getStatut() == AppointmentStatus.DONE &&
                        a.getPatient().getId().equals(patientId))
                .sorted(Comparator.comparing(Appointment::getDate).reversed())
                .collect(Collectors.toList());

        return appointments.stream()
                .map(AppointmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public int countAppointmentsByDoctorAndPatient(UUID doctorId, UUID patientId) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new IllegalArgumentException("Patient non trouvé"));

        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                TypedQuery<Long> query = em.createQuery(
                        "SELECT COUNT(a) FROM Appointment a " +
                                "WHERE a.doctor = :doctor AND a.patient = :patient",
                        Long.class);
                query.setParameter("doctor", doctor);
                query.setParameter("patient", patient);
                return query.getSingleResult().intValue();
            } finally {
                if (em.isOpen()) em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<AppointmentDTO> getAppointmentsByDoctorAndPatient(UUID doctorId, UUID patientId) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new IllegalArgumentException("Patient non trouvé"));

        List<Appointment> appointments = new ArrayList<>();

        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                TypedQuery<Appointment> query = em.createQuery(
                        "SELECT a FROM Appointment a " +
                                "WHERE a.doctor = :doctor AND a.patient = :patient " +
                                "ORDER BY a.date DESC, a.heureDebut DESC",
                        Appointment.class);
                query.setParameter("doctor", doctor);
                query.setParameter("patient", patient);
                appointments = query.getResultList();
            } finally {
                if (em.isOpen()) em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments.stream()
                .map(AppointmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<MedicalNoteDTO> getMedicalNotesByDoctorAndPatient(UUID doctorId, UUID patientId) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new IllegalArgumentException("Patient non trouvé"));

        List<MedicalNote> notes = new ArrayList<>();

        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                TypedQuery<MedicalNote> query = em.createQuery(
                        "SELECT n FROM MedicalNote n " +
                                "JOIN n.appointment a " +
                                "WHERE a.doctor = :doctor AND a.patient = :patient " +
                                "ORDER BY a.date DESC, a.heureDebut DESC",
                        MedicalNote.class);
                query.setParameter("doctor", doctor);
                query.setParameter("patient", patient);
                notes = query.getResultList();
            } finally {
                if (em.isOpen()) em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return notes.stream()
                .map(MedicalNoteMapper::toDTO)
                .collect(Collectors.toList());
    }

    public boolean isAppointmentUpcoming(AppointmentDTO appointment) {
        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();

        return appointment.getDate().isAfter(today) ||
                (appointment.getDate().isEqual(today) && appointment.getHeureDebut().isAfter(now));
    }

    public List<TimeSlotDTO> getAvailableTimeSlotsForBooking(UUID doctorId, LocalDate date) {
        // Call the original method to get all available slots
        List<TimeSlotDTO> allSlots = generateAvailableTimeSlots(doctorId, date);

        // Filter slots that are at least 2 hours in the future if the date is today
        if (date.equals(LocalDate.now())) {
            LocalDateTime minValidTime = AppointmentValidator.getMinimumValidAppointmentTime();

            return allSlots.stream()
                    .filter(slot -> {
                        // Convert the slot time to LocalDateTime for comparison
                        LocalTime slotTime = LocalTime.parse(slot.getStartTime());
                        LocalDateTime slotDateTime = LocalDateTime.of(date, slotTime);
                        return !slotDateTime.isBefore(minValidTime);
                    })
                    .collect(Collectors.toList());
        }

        // If date is in the future, return all slots
        return allSlots;
    }

    private List<AvailabilityDTO> getAvailabilityForDoctorAndDate(Doctor doctor, LocalDate date) {
        List<Availability> availabilities = availabilityRepository.findByDoctorAndDayOfWeek(
                doctor, date.getDayOfWeek().getValue());

        return availabilities.stream()
                .map(AvailabilityMapper::toDTO)
                .collect(Collectors.toList());
    }

    private boolean isTimeSlotBooked(Doctor doctor, LocalDate date, LocalTime start, LocalTime end) {
        return appointmentRepository.existsByDoctorAndDateAndTimeOverlap(doctor, date, start, end);
    }

}