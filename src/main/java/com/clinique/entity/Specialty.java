package com.clinique.entity;

import jakarta.persistence.*;
import java.util.UUID;
import java.util.List;

@Entity
@Table(name = "specialties")
public class Specialty {

    @Id
    @GeneratedValue
    private UUID id;
    private String nom;
    private String description;
    @ManyToOne
    @JoinColumn(name = "department_id")
    private Department departement;

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Department getDepartement() { return departement; }
    public void setDepartement(Department departement) { this.departement = departement; }
}