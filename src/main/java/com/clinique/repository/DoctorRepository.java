package com.clinique.repository;

import jakarta.persistence.NoResultException;
import jakarta.persistence.EntityManager;
import com.clinique.config.DBConnection;
import jakarta.persistence.TypedQuery;
import com.clinique.entity.Specialty;
import com.clinique.entity.Doctor;
import java.util.Optional;
import java.util.List;
import java.util.UUID;

public class DoctorRepository {

    public Optional<Doctor> findById(UUID id) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            return Optional.ofNullable(em.find(Doctor.class, id));
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Optional<Doctor> findByMatricule(String matricule) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Doctor> q = em.createQuery("SELECT d FROM Doctor d WHERE d.matricule = :matricule", Doctor.class);
            q.setParameter("matricule", matricule);
            return Optional.ofNullable(q.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Doctor> findBySpecialty(Specialty specialty) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Doctor> q = em.createQuery("SELECT d FROM Doctor d WHERE d.specialty = :specialty AND d.actif = true", Doctor.class);
            q.setParameter("specialty", specialty);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Doctor> findAll() {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Doctor> q = em.createQuery("SELECT d FROM Doctor d WHERE d.actif = true", Doctor.class);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Doctor save(Doctor doctor) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            System.out.println("Attempting to save doctor with ID: " + doctor.getId() +
                    ", Name: " + doctor.getNom() +
                    ", Email: " + doctor.getEmail() +
                    ", Titre: " + doctor.getTitre() +
                    ", Specialty: " + (doctor.getSpecialty() != null ? doctor.getSpecialty().getNom() : "none"));

            em.getTransaction().begin();
            if (doctor.getId() == null) {
                System.out.println("Persisting new doctor");
                em.persist(doctor);
            } else {
                System.out.println("Merging existing doctor");
                doctor = em.merge(doctor);
            }
            em.getTransaction().commit();
            System.out.println("Doctor saved successfully");
            return doctor;
        } catch (Exception ex) {
            System.err.println("Error saving doctor: " + ex.getMessage());
            ex.printStackTrace();
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public int countActiveDoctors() {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(d) FROM Doctor d WHERE d.actif = true", Long.class);
            return query.getSingleResult().intValue();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public boolean existsBySpecialty(UUID specialtyId) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(d) FROM Doctor d WHERE d.specialty.id = :specialtyId", Long.class);
            query.setParameter("specialtyId", specialtyId);
            return query.getSingleResult() > 0;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

}