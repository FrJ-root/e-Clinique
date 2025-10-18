package com.clinique.repository;

import com.clinique.enums.AvailabilityType;
import jakarta.persistence.EntityManager;
import com.clinique.entity.Availability;
import com.clinique.config.DBConnection;
import jakarta.persistence.TypedQuery;
import com.clinique.entity.Doctor;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.Optional;
import java.util.List;
import java.util.UUID;

public class AvailabilityRepository {

    public Optional<Availability> findById(UUID id) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            return Optional.ofNullable(em.find(Availability.class, id));
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Availability> findByDoctor(Doctor doctor) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Availability> q = em.createQuery(
                    "SELECT a FROM Availability a WHERE a.doctor = :doctor ORDER BY a.jour, a.heureDebut",
                    Availability.class);
            q.setParameter("doctor", doctor);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Availability> findByDoctorAndDate(Doctor doctor, LocalDate date) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Availability> dateQuery = em.createQuery(
                    "SELECT a FROM Availability a WHERE a.doctor = :doctor AND a.jour = :date ORDER BY a.heureDebut",
                    Availability.class);
            dateQuery.setParameter("doctor", doctor);
            dateQuery.setParameter("date", date);
            List<Availability> dateAvailabilities = dateQuery.getResultList();

            DayOfWeek dayOfWeek = date.getDayOfWeek();
            TypedQuery<Availability> weeklyQuery = em.createQuery(
                    "SELECT a FROM Availability a WHERE a.doctor = :doctor AND a.jourSemaine = :dayOfWeek " +
                            "AND a.type = :type ORDER BY a.heureDebut",
                    Availability.class);
            weeklyQuery.setParameter("doctor", doctor);
            weeklyQuery.setParameter("dayOfWeek", dayOfWeek);
            weeklyQuery.setParameter("type", AvailabilityType.REGULAR);

            List<Availability> result = dateQuery.getResultList();
            result.addAll(weeklyQuery.getResultList());
            return result;

        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Availability> findRegularByDoctor(Doctor doctor) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Availability> q = em.createQuery(
                    "SELECT a FROM Availability a WHERE a.doctor = :doctor AND a.type = :type " +
                            "ORDER BY a.jourSemaine, a.heureDebut",
                    Availability.class);
            q.setParameter("doctor", doctor);
            q.setParameter("type", AvailabilityType.REGULAR);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Availability> findExceptionalByDoctor(Doctor doctor) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            LocalDate today = LocalDate.now();
            LocalDate twoMonthsLater = today.plusMonths(2);

            TypedQuery<Availability> q = em.createQuery(
                    "SELECT a FROM Availability a WHERE a.doctor = :doctor AND a.type = :type " +
                            "AND a.jour >= :today AND a.jour <= :twoMonthsLater " +
                            "ORDER BY a.jour, a.heureDebut",
                    Availability.class);
            q.setParameter("doctor", doctor);
            q.setParameter("type", AvailabilityType.EXCEPTIONAL);
            q.setParameter("today", today);
            q.setParameter("twoMonthsLater", twoMonthsLater);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Availability> findAbsencesByDoctor(Doctor doctor) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            LocalDate today = LocalDate.now();

            TypedQuery<Availability> q = em.createQuery(
                    "SELECT a FROM Availability a WHERE a.doctor = :doctor AND a.type = :type " +
                            "AND a.jour >= :today ORDER BY a.jour, a.heureDebut",
                    Availability.class);
            q.setParameter("doctor", doctor);
            q.setParameter("type", AvailabilityType.ABSENCE);
            q.setParameter("today", today);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Availability save(Availability availability) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();

            if (availability.getId() == null) {
                System.out.println("Persisting new availability");
                em.persist(availability);
            } else {
                System.out.println("Merging existing availability with ID: " + availability.getId());
                availability = em.merge(availability);
            }

            em.flush();
            em.getTransaction().commit();
            return availability;
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) {
                System.err.println("Rolling back transaction due to: " + ex.getMessage());
                em.getTransaction().rollback();
            }
            ex.printStackTrace();
            throw new RuntimeException("Error saving availability: " + ex.getMessage(), ex);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public void delete(Availability availability) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            if (!em.contains(availability)) {
                availability = em.merge(availability);
            }
            em.remove(availability);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

}