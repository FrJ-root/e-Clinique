package com.clinique.service;

import com.clinique.config.DBConnection;
import com.clinique.dto.PatientDTO;
import com.clinique.entity.Appointment;
import com.clinique.entity.Doctor;
import com.clinique.entity.Patient;
import com.clinique.mapper.PatientMapper;
import com.clinique.repository.DoctorRepository;
import com.clinique.repository.PatientRepository;
import com.clinique.repository.UserRepository;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.mindrot.jbcrypt.BCrypt;

public class PatientService {

    private final DoctorRepository doctorRepository = new DoctorRepository();
    private final PatientRepository patientRepository = new PatientRepository();
    private final UserRepository userRepository = new UserRepository();

    public PatientDTO register(PatientDTO dto) {
        if (dto.getEmail() == null || dto.getPassword() == null || dto.getNom() == null) {
            throw new IllegalArgumentException("Nom, email et mot de passe sont requis");
        }

        if (dto.getCin() == null || dto.getCin().trim().isEmpty()) {
            throw new IllegalArgumentException("CIN est requis");
        }

        if (userRepository.findByEmail(dto.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Un utilisateur avec cet e-mail existe déjà");
        }

        if (patientRepository.findByCin(dto.getCin()).isPresent()) {
            throw new IllegalArgumentException("Un patient avec ce CIN existe déjà");
        }

        String password = dto.getPassword();
        String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
        dto.setPassword(hashed);
        dto.setActif(true);
        dto.setRole("PATIENT");

        Patient patient = PatientMapper.toEntity(dto);
        Patient saved = patientRepository.save(patient);

        return PatientMapper.toDTO(saved);
    }

    public PatientDTO register(PatientDTO dto, String password) {
        dto.setPassword(password);
        return register(dto);
    }

    public int countActivePatients() {
        return patientRepository.countActivePatients();
    }

    public PatientDTO update(PatientDTO patientDTO) {
        Optional<Patient> patientOpt = patientRepository.findById(patientDTO.getId());
        if (patientOpt.isEmpty()) {
            throw new IllegalArgumentException("Patient not found");
        }

        Patient patient = patientOpt.get();
        patient.setNom(patientDTO.getNom());
        patient.setEmail(patientDTO.getEmail());

        Patient updatedPatient = patientRepository.save(patient);
        return PatientMapper.toDTO(updatedPatient);
    }

    public PatientDTO updateWithPassword(PatientDTO patientDTO, String newPassword) {
        Optional<Patient> patientOpt = patientRepository.findById(patientDTO.getId());
        if (patientOpt.isEmpty()) {
            throw new IllegalArgumentException("Patient not found");
        }

        Patient patient = patientOpt.get();
        patient.setNom(patientDTO.getNom());
        patient.setEmail(patientDTO.getEmail());

        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        patient.setPassword(hashedPassword);

        Patient updatedPatient = patientRepository.save(patient);
        return PatientMapper.toDTO(updatedPatient);
    }

    public PatientDTO findByCin(String cin) {
        Optional<Patient> patientOpt = patientRepository.findByCin(cin);
        return patientOpt.map(PatientMapper::toDTO).orElse(null);
    }

    public PatientDTO updatePatient(PatientDTO dto) {
        if (dto.getCin() == null || dto.getCin().trim().isEmpty()) {
            throw new IllegalArgumentException("CIN est requis pour la mise à jour");
        }

        // Check if patient exists
        Optional<Patient> existingOpt = patientRepository.findByCin(dto.getCin());
        if (existingOpt.isEmpty()) {
            throw new IllegalArgumentException("Patient non trouvé");
        }

        Patient existing = existingOpt.get();

        // If email is changed, check if new email is already in use
        if (!existing.getEmail().equals(dto.getEmail())) {
            if (userRepository.findByEmail(dto.getEmail()).isPresent()) {
                throw new IllegalArgumentException("Un utilisateur avec cet e-mail existe déjà");
            }
        }

        // Keep the same password if not provided
        if (dto.getPassword() == null || dto.getPassword().trim().isEmpty()) {
            dto.setPassword(existing.getPassword());
        } else {
            // Hash new password
            String hashed = BCrypt.hashpw(dto.getPassword(), BCrypt.gensalt());
            dto.setPassword(hashed);
        }

        // Ensure role remains PATIENT
        dto.setRole("PATIENT");
        dto.setActif(true);

        // Update patient
        Patient patient = PatientMapper.toEntity(dto);
        patient.setId(existing.getId()); // Ensure ID is preserved
        Patient updated = patientRepository.save(patient);

        return PatientMapper.toDTO(updated);
    }

    public PatientDTO findByUserId(UUID userId) {
        Optional<Patient> patientOpt = patientRepository.findByUserId(userId);
        return patientOpt.map(PatientMapper::toDTO).orElse(null);
    }

    public List<PatientDTO> findRecentPatientsByDoctor(UUID doctorId, int days) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        LocalDate startDate = LocalDate.now().minusDays(days);

        List<Patient> patients = new ArrayList<>();

        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                TypedQuery<Patient> query = em.createQuery(
                        "SELECT DISTINCT a.patient FROM Appointment a " +
                                "WHERE a.doctor = :doctor AND a.date >= :startDate " +
                                "ORDER BY a.date DESC",
                        Patient.class);
                query.setParameter("doctor", doctor);
                query.setParameter("startDate", startDate);
                patients = query.getResultList();
            } finally {
                if (em.isOpen()) em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return patients.stream()
                .map(PatientMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<PatientDTO> findPatientsByDoctor(UUID doctorId) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        List<Patient> patients = new ArrayList<>();

        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                // Find distinct patients who have had appointments with this doctor
                TypedQuery<Patient> query = em.createQuery(
                        "SELECT DISTINCT a.patient FROM Appointment a " +
                                "WHERE a.doctor = :doctor " +
                                "ORDER BY a.patient.nom, a.patient.prenom",
                        Patient.class);
                query.setParameter("doctor", doctor);
                patients = query.getResultList();
            } finally {
                if (em.isOpen()) em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return patients.stream()
                .map(PatientMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<PatientDTO> findMostFrequentPatientsByDoctor(UUID doctorId, int limit) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        // This is a more complex query that might require custom logic
        // Here we'll do it in Java rather than a complex JPQL query

        // First get all appointments for this doctor
        List<Appointment> appointments = new ArrayList<>();

        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                TypedQuery<Appointment> query = em.createQuery(
                        "SELECT a FROM Appointment a WHERE a.doctor = :doctor",
                        Appointment.class);
                query.setParameter("doctor", doctor);
                appointments = query.getResultList();
            } finally {
                if (em.isOpen()) em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Count appointments by patient
        Map<Patient, Long> appointmentCountByPatient = appointments.stream()
                .collect(Collectors.groupingBy(Appointment::getPatient, Collectors.counting()));

        // Sort by count (descending) and get top patients
        return appointmentCountByPatient.entrySet().stream()
                .sorted(Map.Entry.<Patient, Long>comparingByValue().reversed())
                .limit(limit)
                .map(entry -> PatientMapper.toDTO(entry.getKey()))
                .collect(Collectors.toList());
    }

    public int countNewPatientsByDoctorSince(UUID doctorId, int days) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        LocalDate startDate = LocalDate.now().minusDays(days);

        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                // Find patients whose first appointment with this doctor was in the last N days
                TypedQuery<Long> query = em.createQuery(
                        "SELECT COUNT(DISTINCT p) FROM Patient p " +
                                "WHERE p IN (" +
                                "    SELECT a.patient FROM Appointment a " +
                                "    WHERE a.doctor = :doctor AND a.date >= :startDate AND " +
                                "    NOT EXISTS (" +
                                "        SELECT 1 FROM Appointment a2 " +
                                "        WHERE a2.doctor = a.doctor AND a2.patient = a.patient " +
                                "        AND a2.date < :startDate" +
                                "    )" +
                                ")",
                        Long.class);
                query.setParameter("doctor", doctor);
                query.setParameter("startDate", startDate);
                return query.getSingleResult().intValue();
            } finally {
                if (em.isOpen()) em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean checkDoctorHasAccessToPatient(UUID doctorId, UUID patientId) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new IllegalArgumentException("Patient non trouvé"));

        try {
            EntityManager em = DBConnection.getEntityManager();
            try {
                // Check if there's at least one appointment between this doctor and patient
                TypedQuery<Long> query = em.createQuery(
                        "SELECT COUNT(a) FROM Appointment a " +
                                "WHERE a.doctor = :doctor AND a.patient = :patient",
                        Long.class);
                query.setParameter("doctor", doctor);
                query.setParameter("patient", patient);
                return query.getSingleResult() > 0;
            } finally {
                if (em.isOpen()) em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public PatientDTO findPatientById(UUID patientId) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new IllegalArgumentException("Patient non trouvé"));

        return PatientMapper.toDTO(patient);
    }

}