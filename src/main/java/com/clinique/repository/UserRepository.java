package com.clinique.repository;

import java.util.List;
import java.util.UUID;
import java.util.Optional;
import com.clinique.enums.Role;
import com.clinique.entity.User;
import jakarta.persistence.TypedQuery;
import com.clinique.config.DBConnection;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;

public class UserRepository {

    public List<User> findByRoleAndQuery(Role role, String query) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<User> q = em.createQuery(
                    "SELECT u FROM User u WHERE u.role = :role AND " +
                            "(LOWER(u.nom) LIKE LOWER(:query) OR LOWER(u.email) LIKE LOWER(:query)) " +
                            "ORDER BY u.nom", User.class);
            q.setParameter("role", role.toString());
            q.setParameter("query", "%" + query + "%");
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Optional<User> findByEmail(String email) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<User> q = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class);
            q.setParameter("email", email);
            return Optional.ofNullable(q.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<User> findRecentUsers(int limit) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u ORDER BY u.id DESC", User.class);
            query.setMaxResults(limit);
            return query.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<User> findByRole(Role role) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u WHERE u.role = :role ORDER BY u.nom", User.class);
            query.setParameter("role", role.toString());
            return query.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<User> search(String query) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<User> q = em.createQuery(
                    "SELECT u FROM User u WHERE " +
                            "LOWER(u.nom) LIKE LOWER(:query) OR LOWER(u.email) LIKE LOWER(:query) " +
                            "ORDER BY u.nom", User.class);
            q.setParameter("query", "%" + query + "%");
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Optional<User> findById(UUID id) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            return Optional.ofNullable(em.find(User.class, id));
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public User save(User user) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            if (user.getId() == null) {
                em.persist(user);
            } else {
                user = em.merge(user);
            }
            em.getTransaction().commit();
            return user;
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<User> findAll() {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u ORDER BY u.nom", User.class);
            return query.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

}