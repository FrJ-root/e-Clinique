package com.clinique.dto;

import java.util.UUID;

public class DoctorDTO extends UserDTO {

    private boolean active = true;
    private SpecialtyDTO specialty;
    private String presentation;
    private String experience;
    private String formation;
    private String telephone;
    private String matricule;
    private String titre;

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public SpecialtyDTO getSpecialty() {
        return specialty;
    }

    public void setSpecialty(SpecialtyDTO specialty) {
        this.specialty = specialty;
    }

    public String getPresentation() {
        return presentation;
    }

    public void setPresentation(String presentation) {
        this.presentation = presentation;
    }

    public String getExperience() {
        return experience;
    }

    public void setExperience(String experience) {
        this.experience = experience;
    }

    public String getFormation() {
        return formation;
    }

    public void setFormation(String formation) {
        this.formation = formation;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

}