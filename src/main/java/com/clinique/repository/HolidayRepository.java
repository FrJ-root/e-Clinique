package com.clinique.repository;

import com.clinique.entity.Holiday;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import com.clinique.config.DBConnection;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class HolidayRepository {

    public Optional<Holiday> findById(UUID id) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            return Optional.ofNullable(em.find(Holiday.class, id));
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Optional<Holiday> findByDate(LocalDate date) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Holiday> q = em.createQuery(
                    "SELECT h FROM Holiday h WHERE h.date = :date",
                    Holiday.class);
            q.setParameter("date", date);
            try {
                return Optional.of(q.getSingleResult());
            } catch (NoResultException e) {
                return Optional.empty();
            }
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Holiday> findAll() {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Holiday> q = em.createQuery(
                    "SELECT h FROM Holiday h ORDER BY h.date",
                    Holiday.class);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Holiday> findFutureHolidays() {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Holiday> q = em.createQuery(
                    "SELECT h FROM Holiday h WHERE h.date >= :today ORDER BY h.date",
                    Holiday.class);
            q.setParameter("today", LocalDate.now());
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Holiday save(Holiday holiday) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            if (holiday.getId() == null) {
                em.persist(holiday);
            } else {
                holiday = em.merge(holiday);
            }
            em.getTransaction().commit();
            return holiday;
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public void delete(Holiday holiday) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            if (!em.contains(holiday)) {
                holiday = em.merge(holiday);
            }
            em.remove(holiday);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

}