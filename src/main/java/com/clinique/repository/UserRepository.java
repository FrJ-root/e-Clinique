package com.clinique.repository;

import com.clinique.entity.User;
import jakarta.persistence.TypedQuery;
import com.clinique.config.DBConnection;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;

import java.util.Optional;

public class UserRepository {

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

}