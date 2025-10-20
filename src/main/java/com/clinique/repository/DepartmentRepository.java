package com.clinique.repository;

import com.clinique.entity.Department;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import com.clinique.config.DBConnection;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class DepartmentRepository {

    public Optional<Department> findById(UUID id) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            Department department = em.find(Department.class, id);
            System.out.println("DepartmentRepository: findById " + id + " result: " +
                    (department != null ? department.getNom() : "null"));
            return Optional.ofNullable(department);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Optional<Department> findByCode(String code) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Department> q = em.createQuery("SELECT d FROM Department d WHERE d.code = :code", Department.class);
            q.setParameter("code", code);
            return Optional.ofNullable(q.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Department> findAll() {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Department> q = em.createQuery("SELECT d FROM Department d", Department.class);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Department save(Department department) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            if (department.getId() == null) {
                em.persist(department);
            } else {
                department = em.merge(department);
            }
            em.getTransaction().commit();
            return department;
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Optional<Department> findByName(String name) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Department> query = em.createQuery(
                    "SELECT d FROM Department d WHERE LOWER(d.nom) = LOWER(:name)", Department.class);
            query.setParameter("name", name);

            try {
                Department department = query.getSingleResult();
                return Optional.of(department);
            } catch (NoResultException e) {
                return Optional.empty();
            }
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public void delete(Department department) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            if (!em.contains(department)) {
                department = em.merge(department);
            }
            em.remove(department);
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

    public List<Department> findByActive(boolean active) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Department> query = em.createQuery(
                    "SELECT d FROM Department d WHERE d.actif = :active ORDER BY d.nom",
                    Department.class);
            query.setParameter("active", active);
            return query.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

}