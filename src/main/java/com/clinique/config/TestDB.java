package com.clinique.config;

import com.clinique.entity.User;
import jakarta.persistence.EntityManager;

public class TestDB {
    public static void main(String[] args) {

        EntityManager em = null;

        try {
            em = DBConnection.getEntityManager();
            em.getTransaction().begin();

            em.createNativeQuery("SELECT 1").getSingleResult();

            em.getTransaction().commit();
            System.out.println("Connection successful");

        } catch (Exception e) {
            System.err.println("Database connection or transaction failed: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
            DBConnection.close();
        }
    }
}