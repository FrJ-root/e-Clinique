package com.clinique.entity;

import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "staffs")
public class Staff extends User {

    @Column(nullable = false, unique = true)
    private String matricule;

    private String poste;

    private String bureau;

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getPoste() {
        return poste;
    }

    public void setPoste(String poste) {
        this.poste = poste;
    }

    public String getBureau() {
        return bureau;
    }

    public void setBureau(String bureau) {
        this.bureau = bureau;
    }
}