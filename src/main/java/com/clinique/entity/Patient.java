package com.clinique.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "patients")
public class Patient extends User {

    @Column(unique = true, nullable = false)
    private String cin;
    private String sang;
    private String sexe;
    private String adresse;
    private String telephone;
    private LocalDate naissance;

    public String getCin() { return cin; }
    public void setCin(String cin) { this.cin = cin; }

    public LocalDate getNaissance() { return naissance; }
    public void setNaissance(LocalDate naissance) { this.naissance = naissance; }

    public String getSexe() { return sexe; }
    public void setSexe(String sexe) { this.sexe = sexe; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getSang() { return sang; }
    public void setSang(String sang) { this.sang = sang; }

}