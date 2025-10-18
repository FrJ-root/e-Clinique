package com.clinique.entity;

import com.clinique.enums.AvailabilityStatus;
import com.clinique.enums.AvailabilityType;
import jakarta.persistence.*;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.UUID;

@Entity
@Table(name = "availabilities")
public class Availability {

    @Id
    @GeneratedValue
    private UUID id;

    @Column(nullable = true)
    private LocalDate jour;

    @Column(name = "jour_semaine", nullable = true)
    @Enumerated(EnumType.STRING)
    private DayOfWeek jourSemaine;

    @Column(name = "heure_debut", nullable = false)
    private LocalTime heureDebut;

    @Column(name = "heure_fin", nullable = false)
    private LocalTime heureFin;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AvailabilityStatus statut = AvailabilityStatus.AVAILABLE;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AvailabilityType type = AvailabilityType.REGULAR;

    @Column(nullable = true)
    private String raison;

    @ManyToOne
    @JoinColumn(name = "doctor_id", nullable = false)
    private Doctor doctor;

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public LocalDate getJour() { return jour; }
    public void setJour(LocalDate jour) { this.jour = jour; }

    public DayOfWeek getJourSemaine() { return jourSemaine; }
    public void setJourSemaine(DayOfWeek jourSemaine) { this.jourSemaine = jourSemaine; }

    public LocalTime getHeureDebut() { return heureDebut; }
    public void setHeureDebut(LocalTime heureDebut) { this.heureDebut = heureDebut; }

    public LocalTime getHeureFin() { return heureFin; }
    public void setHeureFin(LocalTime heureFin) { this.heureFin = heureFin; }

    public AvailabilityStatus getStatut() { return statut; }
    public void setStatut(AvailabilityStatus statut) { this.statut = statut; }

    public AvailabilityType getType() { return type; }
    public void setType(AvailabilityType type) { this.type = type; }

    public String getRaison() { return raison; }
    public void setRaison(String raison) { this.raison = raison; }

    public Doctor getDoctor() { return doctor; }
    public void setDoctor(Doctor doctor) { this.doctor = doctor; }
}