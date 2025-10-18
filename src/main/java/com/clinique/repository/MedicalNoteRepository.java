package com.clinique.repository;

import com.clinique.config.DBConnection;
import com.clinique.entity.MedicalNote;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class MedicalNoteRepository {

    public Optional<MedicalNote> findById(UUID id) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            return Optional.ofNullable(em.find(MedicalNote.class, id));
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public MedicalNote save(MedicalNote medicalNote) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            if (medicalNote.getId() == null) {
                em.persist(medicalNote);
            } else {
                medicalNote = em.merge(medicalNote);
            }
            em.getTransaction().commit();
            return medicalNote;
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public void delete(MedicalNote medicalNote) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            if (!em.contains(medicalNote)) {
                medicalNote = em.merge(medicalNote);
            }
            em.remove(medicalNote);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<MedicalNote> findByUpdatedAfter(LocalDateTime date) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<MedicalNote> query = em.createQuery(
                    "SELECT n FROM MedicalNote n WHERE n.updatedAt >= :date ORDER BY n.updatedAt DESC",
                    MedicalNote.class
            );
            query.setParameter("date", date);
            return query.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }
}