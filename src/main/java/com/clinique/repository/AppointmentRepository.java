package com.clinique.repository;

import com.clinique.enums.AppointmentStatus;
import jakarta.persistence.EntityManager;
import com.clinique.entity.Availability;
import com.clinique.config.DBConnection;
import com.clinique.entity.Appointment;
import jakarta.persistence.TypedQuery;
import com.clinique.entity.Patient;
import com.clinique.entity.Doctor;
import java.time.LocalDateTime;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Optional;
import java.util.List;
import java.util.UUID;

public class AppointmentRepository {

    public Optional<Appointment> findById(UUID id) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            return Optional.ofNullable(em.find(Appointment.class, id));
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Appointment> findByPatient(Patient patient) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Appointment> q = em.createQuery("SELECT a FROM Appointment a WHERE a.patient = :patient ORDER BY a.date DESC, a.heureDebut DESC", Appointment.class);
            q.setParameter("patient", patient);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Appointment> findByPatientAndStatus(Patient patient, AppointmentStatus status) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Appointment> q = em.createQuery(
                    "SELECT a FROM Appointment a WHERE a.patient = :patient AND a.statut = :status ORDER BY a.date DESC, a.heureDebut DESC",
                    Appointment.class
            );
            q.setParameter("patient", patient);
            q.setParameter("status", status);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Appointment> findByDoctorAndDate(Doctor doctor, LocalDate date) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Appointment> q = em.createQuery(
                    "SELECT a FROM Appointment a WHERE a.doctor = :doctor AND a.date = :date AND a.statut <> :canceledStatus",
                    Appointment.class);
            q.setParameter("doctor", doctor);
            q.setParameter("date", date);
            q.setParameter("canceledStatus", AppointmentStatus.CANCELED);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Appointment> findOverlappingAppointments(Doctor doctor, LocalDate date, LocalTime startTime, LocalTime endTime) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Appointment> q = em.createQuery(
                    "SELECT a FROM Appointment a WHERE a.doctor = :doctor AND a.date = :date AND " +
                            "((a.heureDebut < :endTime AND a.heureFin > :startTime) OR " +
                            "(a.heureDebut = :startTime)) AND " +
                            "a.statut != :canceledStatus",
                    Appointment.class
            );
            q.setParameter("doctor", doctor);
            q.setParameter("date", date);
            q.setParameter("startTime", startTime);
            q.setParameter("endTime", endTime);
            q.setParameter("canceledStatus", AppointmentStatus.CANCELED);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Appointment save(Appointment appointment) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            System.out.println("Starting transaction...");
            em.getTransaction().begin();

            if (appointment.getId() == null) {
                System.out.println("Persisting new appointment");
                System.out.println("  Date: " + appointment.getDate());
                System.out.println("  Start: " + appointment.getHeureDebut());
                System.out.println("  End: " + appointment.getHeureFin());
                System.out.println("  Patient: " + (appointment.getPatient() != null ? appointment.getPatient().getId() : "NULL"));
                System.out.println("  Doctor: " + (appointment.getDoctor() != null ? appointment.getDoctor().getId() : "NULL"));
                System.out.println("  Status: " + appointment.getStatut());
                System.out.println("  Motif: " + appointment.getMotif());

                em.persist(appointment);
            } else {
                System.out.println("Merging existing appointment: " + appointment.getId());
                appointment = em.merge(appointment);
            }

            System.out.println("Flushing...");
            em.flush();

            System.out.println("Committing transaction...");
            em.getTransaction().commit();

            System.out.println("✓ Transaction committed successfully");
            return appointment;

        } catch (Exception ex) {
            System.err.println("✗ ERROR in save():");
            ex.printStackTrace();

            if (em.getTransaction().isActive()) {
                System.err.println("Rolling back transaction...");
                em.getTransaction().rollback();
            }

            throw new RuntimeException("Error while saving appointment: " + ex.getMessage(), ex);
        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }

    public List<Appointment> findUpcomingByDoctor(Doctor doctor) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            LocalDateTime now = LocalDateTime.now();
            TypedQuery<Appointment> q = em.createQuery(
                    "SELECT a FROM Appointment a WHERE a.doctor = :doctor AND " +
                            "((a.date > :currentDate) OR (a.date = :currentDate AND a.heureFin > :currentTime)) AND " +
                            "a.statut = :plannedStatus ORDER BY a.date ASC, a.heureDebut ASC",
                    Appointment.class);
            q.setParameter("doctor", doctor);
            q.setParameter("currentDate", now.toLocalDate());
            q.setParameter("currentTime", now.toLocalTime());
            q.setParameter("plannedStatus", AppointmentStatus.PLANNED);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public int countAll() {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(a) FROM Appointment a", Long.class);
            return query.getSingleResult().intValue();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public int countByDate(LocalDate date) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(a) FROM Appointment a WHERE a.date = :date", Long.class);
            query.setParameter("date", date);
            return query.getSingleResult().intValue();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Appointment> findByDate(LocalDate date) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Appointment> query = em.createQuery(
                    "SELECT a FROM Appointment a WHERE a.date = :date ORDER BY a.heureDebut",
                    Appointment.class);
            query.setParameter("date", date);
            return query.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public int countCancellationsSince(LocalDate since) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(a) FROM Appointment a WHERE a.date >= :since AND a.status = 'CANCELLED'",
                    Long.class);
            query.setParameter("since", since);
            return query.getSingleResult().intValue();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Appointment> findByDoctor(Doctor doctor) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Appointment> q = em.createQuery(
                    "SELECT a FROM Appointment a WHERE a.doctor = :doctor ORDER BY a.date DESC, a.heureDebut DESC",
                    Appointment.class);
            q.setParameter("doctor", doctor);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Appointment> findPastByDoctor(Doctor doctor, LocalDate currentDate, LocalTime currentTime) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Appointment> q = em.createQuery(
                    "SELECT a FROM Appointment a WHERE a.doctor = :doctor AND " +
                            "((a.date < :currentDate) OR (a.date = :currentDate AND a.heureFin <= :currentTime)) " +
                            "ORDER BY a.date DESC, a.heureDebut DESC",
                    Appointment.class);
            q.setParameter("doctor", doctor);
            q.setParameter("currentDate", currentDate);
            q.setParameter("currentTime", currentTime);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public boolean existsByDoctorAndDateAndTimeOverlap(Doctor doctor, LocalDate date, LocalTime startTime, LocalTime endTime) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(a) FROM Appointment a WHERE a.doctor = :doctor " +
                            "AND a.date = :date " +
                            "AND a.statut <> :canceledStatus " +
                            "AND ((a.heureDebut < :endTime AND a.heureFin > :startTime) OR " +
                            "(a.heureDebut = :startTime))",
                    Long.class);
            query.setParameter("doctor", doctor);
            query.setParameter("date", date);
            query.setParameter("startTime", startTime);
            query.setParameter("endTime", endTime);
            query.setParameter("canceledStatus", AppointmentStatus.CANCELED);
            return query.getSingleResult() > 0;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Availability> findByDoctorAndDayOfWeek(Doctor doctor, int dayOfWeek) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            DayOfWeek day = DayOfWeek.of(dayOfWeek);

            TypedQuery<Availability> query = em.createQuery(
                    "SELECT a FROM Availability a " +
                            "WHERE a.doctor = :doctor " +
                            "AND a.type = 'REGULAR' " +
                            "AND a.jourSemaine = :dayOfWeek " +
                            "ORDER BY a.heureDebut",
                    Availability.class
            );
            query.setParameter("doctor", doctor);
            query.setParameter("dayOfWeek", day);

            return query.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public boolean hasActiveAppointmentWithDoctor(Patient patient, Doctor doctor) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            LocalDate today = LocalDate.now();
            LocalTime now = LocalTime.now();

            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(a) FROM Appointment a " +
                            "WHERE a.patient = :patient " +
                            "AND a.doctor = :doctor " +
                            "AND a.statut = :plannedStatus " +
                            "AND ((a.date > :today) OR (a.date = :today AND a.heureDebut > :now))",
                    Long.class
            );

            query.setParameter("patient", patient);
            query.setParameter("doctor", doctor);
            query.setParameter("plannedStatus", AppointmentStatus.PLANNED);
            query.setParameter("today", today);
            query.setParameter("now", now);

            Long count = query.getSingleResult();

            System.out.println("Active appointments with doctor " + doctor.getNom() + ": " + count);

            return count > 0;

        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Appointment> getActiveAppointmentsWithDoctor(Patient patient, Doctor doctor) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            LocalDate today = LocalDate.now();
            LocalTime now = LocalTime.now();

            TypedQuery<Appointment> query = em.createQuery(
                    "SELECT a FROM Appointment a " +
                            "WHERE a.patient = :patient " +
                            "AND a.doctor = :doctor " +
                            "AND a.statut = :plannedStatus " +
                            "AND ((a.date > :today) OR (a.date = :today AND a.heureDebut > :now)) " +
                            "ORDER BY a.date ASC, a.heureDebut ASC",
                    Appointment.class
            );

            query.setParameter("patient", patient);
            query.setParameter("doctor", doctor);
            query.setParameter("plannedStatus", AppointmentStatus.PLANNED);
            query.setParameter("today", today);
            query.setParameter("now", now);

            return query.getResultList();

        } finally {
            if (em.isOpen()) em.close();
        }
    }

}