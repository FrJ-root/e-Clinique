package com.clinique.entity;

import com.clinique.enums.AppointmentStatus;
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

    @Column(nullable = false)
    private LocalDate date;

    @Column(nullable = false)
    private LocalTime heureDebut;

    @Column(nullable = false)
    private LocalTime heureFin;

    private String type;

    private String motif;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AppointmentStatus statut = AppointmentStatus.PLANNED;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "doctor_id", nullable = false)
    private Doctor doctor;

    @OneToOne(mappedBy = "appointment", cascade = CascadeType.ALL)
    private MedicalNote medicalNote;

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public LocalTime getHeureDebut() { return heureDebut; }
    public void setHeureDebut(LocalTime heureDebut) { this.heureDebut = heureDebut; }

    public LocalTime getHeureFin() { return heureFin; }
    public void setHeureFin(LocalTime heureFin) { this.heureFin = heureFin; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getMotif() { return motif; }
    public void setMotif(String motif) { this.motif = motif; }

    public AppointmentStatus getStatut() { return statut; }
    public void setStatut(AppointmentStatus statut) { this.statut = statut; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public Doctor getDoctor() { return doctor; }
    public void setDoctor(Doctor doctor) { this.doctor = doctor; }

    public MedicalNote getMedicalNote() { return medicalNote; }
    public void setMedicalNote(MedicalNote medicalNote) { this.medicalNote = medicalNote; }

}