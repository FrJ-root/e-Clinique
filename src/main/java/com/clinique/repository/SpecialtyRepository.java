package com.clinique.repository;

import com.clinique.entity.Department;
import com.clinique.entity.Specialty;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import com.clinique.config.DBConnection;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class SpecialtyRepository {

    public Optional<Specialty> findById(UUID id) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            return Optional.ofNullable(em.find(Specialty.class, id));
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Optional<Specialty> findByCode(String code) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Specialty> q = em.createQuery("SELECT s FROM Specialty s WHERE s.code = :code", Specialty.class);
            q.setParameter("code", code);
            return Optional.ofNullable(q.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Specialty> findAll() {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Specialty> q = em.createQuery("SELECT s FROM Specialty s", Specialty.class);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Specialty save(Specialty specialty) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            if (specialty.getId() == null) {
                em.persist(specialty);
            } else {
                specialty = em.merge(specialty);
            }
            em.getTransaction().commit();
            return specialty;
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public boolean existsByDepartment(UUID departmentId) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(s) FROM Specialty s WHERE s.department.id = :departmentId",
                    Long.class);
            query.setParameter("departmentId", departmentId);
            return query.getSingleResult() > 0;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public void delete(Specialty specialty) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            if (!em.contains(specialty)) {
                specialty = em.merge(specialty);
            }
            em.remove(specialty);
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

    public List<Specialty> findByDepartment(Department department) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Specialty> query = em.createQuery(
                    "SELECT s FROM Specialty s WHERE s.department = :department ORDER BY s.nom",
                    Specialty.class
            );
            query.setParameter("department", department);
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<Specialty> findByDepartmentId(UUID departmentId) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Specialty> query = em.createQuery(
                    "SELECT s FROM Specialty s WHERE s.department.id = :departmentId ORDER BY s.nom",
                    Specialty.class
            );
            query.setParameter("departmentId", departmentId);
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

}