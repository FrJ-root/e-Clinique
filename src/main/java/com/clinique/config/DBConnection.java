package com.clinique.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class DBConnection {

    private static final String PERSISTENCE_UNIT_NAME = "cliniquePU";
    private static EntityManagerFactory emf;

    static {
        try {
            emf = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
            System.out.println("EntityManagerFactory initialized successfully.");
        } catch (Exception e) {
            System.err.println("Failed to initialize EntityManagerFactory: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static EntityManager getEntityManager() {
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory is not initialized.");
        }
        return emf.createEntityManager();
    }

    public static void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
            System.out.println("EntityManagerFactory closed.");
        }
    }
}
