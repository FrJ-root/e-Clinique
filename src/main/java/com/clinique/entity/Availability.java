package com.clinique.entity;

import com.clinique.enums.Jour;
import com.clinique.enums.StatutDisponibilite;
import jakarta.persistence.*;
import java.time.LocalTime;
import java.util.UUID;

@Entity
@Table(name = "availabilities")
public class Availability {

    @Id
    @GeneratedValue
    private UUID id;

    @Enumerated(EnumType.STRING)
    private Jour jour;

    private LocalTime heureDebutFin;

    @Enumerated(EnumType.STRING)
    private StatutDisponibilite statut;

    private boolean validite;

    @ManyToOne
    @JoinColumn(name = "doctor_id")
    private Doctor doctor;

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Jour getJour() { return jour; }
    public void setJour(Jour jour) { this.jour = jour; }

    public LocalTime getHeureDebutFin() { return heureDebutFin; }
    public void setHeureDebutFin(LocalTime heureDebutFin) { this.heureDebutFin = heureDebutFin; }

    public StatutDisponibilite getStatut() { return statut; }
    public void setStatut(StatutDisponibilite statut) { this.statut = statut; }

    public boolean isValidite() { return validite; }
    public void setValidite(boolean validite) { this.validite = validite; }

    public Doctor getDoctor() { return doctor; }
    public void setDoctor(Doctor doctor) { this.doctor = doctor; }
}