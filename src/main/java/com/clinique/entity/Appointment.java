package com.clinique.entity;

import com.clinique.enums.StatutRendezVous;
import com.clinique.enums.TypeRendezVous;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.UUID;

@Entity
@Table(name = "appointments")
public class Appointment {

    @Id
    @GeneratedValue
    private UUID id;

    private LocalDate date;
    private LocalTime heure;

    @Enumerated(EnumType.STRING)
    private StatutRendezVous statut;

    @ManyToOne
    @JoinColumn(name = "patient_id")
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "doctor_id")
    private Doctor docteur;

    @Enumerated(EnumType.STRING)
    private TypeRendezVous type;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public LocalTime getHeure() {
        return heure;
    }

    public void setHeure(LocalTime heure) {
        this.heure = heure;
    }

    public StatutRendezVous getStatut() {
        return statut;
    }

    public void setStatut(StatutRendezVous statut) {
        this.statut = statut;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Doctor getDocteur() {
        return docteur;
    }

    public void setDocteur(Doctor docteur) {
        this.docteur = docteur;
    }

    public TypeRendezVous getType() {
        return type;
    }

    public void setType(TypeRendezVous type) {
        this.type = type;
    }

}