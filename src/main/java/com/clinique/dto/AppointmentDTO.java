package com.clinique.dto;

import com.clinique.enums.AppointmentStatus;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.UUID;

public class AppointmentDTO {
    private UUID id;
    private LocalDate date;
    private LocalTime heureDebut;
    private LocalTime heureFin;
    private String type;
    private String motif;
    private AppointmentStatus statut;

    private UUID patientId;
    private String patientNom;

    private UUID doctorId;
    private String doctorNom;
    private String doctorSpecialty;

    private boolean hasMedicalNote;

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

    public UUID getPatientId() { return patientId; }
    public void setPatientId(UUID patientId) { this.patientId = patientId; }

    public String getPatientNom() { return patientNom; }
    public void setPatientNom(String patientNom) { this.patientNom = patientNom; }

    public UUID getDoctorId() { return doctorId; }
    public void setDoctorId(UUID doctorId) { this.doctorId = doctorId; }

    public String getDoctorNom() { return doctorNom; }
    public void setDoctorNom(String doctorNom) { this.doctorNom = doctorNom; }

    public String getDoctorSpecialty() { return doctorSpecialty; }
    public void setDoctorSpecialty(String doctorSpecialty) { this.doctorSpecialty = doctorSpecialty; }

    public boolean isHasMedicalNote() { return hasMedicalNote; }
    public void setHasMedicalNote(boolean hasMedicalNote) { this.hasMedicalNote = hasMedicalNote; }
}