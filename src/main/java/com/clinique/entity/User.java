package com.clinique.entity;

import com.clinique.enums.Role;
import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue
    private UUID id;

    private String nom;
    private String email;

    @Enumerated(EnumType.STRING)
    private Role role;

    private boolean actif;
    private String password;

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public Role getRole() {
        return role;
    }
    public void setRole(Role role) {
        this.role = role;
    }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public boolean isActif() { return actif; }
    public void setActif(boolean actif) { this.actif = actif; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

}