package com.clinique.repository;

import com.clinique.entity.SystemSetting;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import com.clinique.config.DBConnection;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class SystemSettingRepository {

    public Optional<SystemSetting> findById(UUID id) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            return Optional.ofNullable(em.find(SystemSetting.class, id));
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public Optional<SystemSetting> findByKey(String key) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<SystemSetting> q = em.createQuery(
                    "SELECT s FROM SystemSetting s WHERE s.settingKey = :key",
                    SystemSetting.class);
            q.setParameter("key", key);
            try {
                return Optional.of(q.getSingleResult());
            } catch (NoResultException e) {
                return Optional.empty();
            }
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<SystemSetting> findAll() {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<SystemSetting> q = em.createQuery(
                    "SELECT s FROM SystemSetting s",
                    SystemSetting.class);
            return q.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public SystemSetting save(SystemSetting setting) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            if (setting.getId() == null) {
                em.persist(setting);
            } else {
                setting = em.merge(setting);
            }
            em.getTransaction().commit();
            return setting;
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public void delete(SystemSetting setting) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            if (!em.contains(setting)) {
                setting = em.merge(setting);
            }
            em.remove(setting);
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