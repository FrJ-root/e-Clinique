package com.clinique.entity;

import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "medical_notes")
public class MedicalNote {

    @Id
    @GeneratedValue
    private UUID id;

    private String contenu;

    @OneToOne
    @JoinColumn(name = "appointment_id")
    private Appointment appointement;

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getContenu() { return contenu; }
    public void setContenu(String contenu) { this.contenu = contenu; }

    public Appointment getAppointement() { return appointement; }
    public void setAppointement(Appointment appointement) { this.appointement = appointement; }

}