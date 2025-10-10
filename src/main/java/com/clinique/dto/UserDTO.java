package com.clinique.dto;

import java.util.UUID;

public class UserDTO {
    private UUID id;
    private String nom;
    private String role;
    private String email;
    private boolean actif;
    private String password;

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public boolean isActif() { return actif; }
    public void setActif(boolean actif) { this.actif = actif; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

}