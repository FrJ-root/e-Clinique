package com.clinique.dto;

import java.time.LocalDate;

public class PatientDTO extends UserDTO {
    private String cin;
    private String sang;
    private String sexe;
    private String adresse;
    private String telephone;
    private LocalDate naissance;
    private boolean active = true;

    public String getCin() { return cin; }
    public void setCin(String cin) { this.cin = cin; }

    public String getSang() { return sang; }
    public void setSang(String sang) { this.sang = sang; }

    public String getSexe() { return sexe; }
    public void setSexe(String sexe) { this.sexe = sexe; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public LocalDate getNaissance() { return naissance; }
    public void setNaissance(LocalDate naissance) { this.naissance = naissance; }

    public boolean isActive() {
        return active;
    }
    public void setActive(boolean active) {
        this.active = active;
    }

}