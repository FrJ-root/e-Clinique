package com.clinique.entity;

import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "doctors")
public class Doctor extends User {

    @Column(nullable = false, unique = true)
    private String matricule;

    private String titre;

    @ManyToOne
    @JoinColumn(name = "specialty_id")
    private Specialty specialite;

    public String getMatricule() { return matricule; }
    public void setMatricule(String matricule) { this.matricule = matricule; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public Specialty getSpecialite() { return specialite; }
    public void setSpecialite(Specialty specialite) { this.specialite = specialite; }
}