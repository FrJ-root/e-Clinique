package com.clinique.repository;

import com.clinique.entity.Doctor;
import jakarta.persistence.NoResultException;
import jakarta.persistence.EntityManager;
import com.clinique.config.DBConnection;
import jakarta.persistence.TypedQuery;
import com.clinique.entity.Patient;
import java.util.Optional;
import java.util.List;
import java.util.UUID;

public class PatientRepository {

    public Optional<Patient> findById(UUID id) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            return Optional.ofNullable(em.find(Patient.class, id));
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Optional<Patient> findByCin(String cin) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Patient> q = em.createQuery("SELECT p FROM Patient p WHERE p.cin = :cin", Patient.class);
            q.setParameter("cin", cin);
            return Optional.ofNullable(q.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Patient> findAll() {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Patient> q = em.createQuery("SELECT p FROM Patient p WHERE p.actif = true", Patient.class);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Patient save(Patient patient) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            if (patient.getId() == null) {
                em.persist(patient);
            } else {
                patient = em.merge(patient);
            }
            em.getTransaction().commit();
            return patient;
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public void softDelete(Patient patient) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            patient.setActif(false);
            em.merge(patient);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Optional<Patient> findByUserId(UUID userId) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            // Patient inherits from User, so the ID is the same
            return Optional.ofNullable(em.find(Patient.class, userId));
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Patient> findRecentByDoctor(Doctor doctor, int limit) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Patient> q = em.createQuery(
                    "SELECT DISTINCT a.patient FROM Appointment a WHERE a.doctor = :doctor " +
                            "ORDER BY MAX(a.date) DESC", Patient.class);
            q.setParameter("doctor", doctor);
            q.setMaxResults(limit);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public int countActivePatients() {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(p) FROM Patient p WHERE p.active = true", Long.class);
            return query.getSingleResult().intValue();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

}