package com.clinique.controller.patient;

import jakarta.servlet.http.HttpServletRequest;
import java.time.format.DateTimeParseException;
import com.clinique.service.PatientService;
import jakarta.servlet.http.HttpSession;
import com.clinique.dto.PatientDTO;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

public class PatientController {

    private final PatientService patientService = new PatientService();

    public Map<String, Object> registerPatient(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            String nom = request.getParameter("nom");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String cin = request.getParameter("cin");
            String sang = request.getParameter("sang");
            String sexe = request.getParameter("sexe");
            String adresse = request.getParameter("adresse");
            String telephone = request.getParameter("telephone");
            String naissanceStr = request.getParameter("naissance");

            PatientDTO dto = new PatientDTO();
            dto.setNom(nom);
            dto.setEmail(email);
            dto.setPassword(password);
            dto.setCin(cin);
            dto.setSang(sang);
            dto.setSexe(sexe);
            dto.setAdresse(adresse);
            dto.setTelephone(telephone);

            if (naissanceStr != null && !naissanceStr.isEmpty()) {
                try {
                    LocalDate naissance = LocalDate.parse(naissanceStr);
                    dto.setNaissance(naissance);
                } catch (DateTimeParseException e) {
                    result.put("success", false);
                    result.put("error", "Format de date de naissance invalide");
                    return result;
                }
            }

            PatientDTO registered = patientService.register(dto);

            result.put("success", true);
            result.put("patient", registered);

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur serveur, réessayez plus tard");
        }

        return result;
    }

    public Map<String, Object> findPatientByCin(String cin) {
        Map<String, Object> result = new HashMap<>();

        try {
            PatientDTO patient = patientService.findByCin(cin);

            if (patient != null) {
                result.put("success", true);
                result.put("patient", patient);
            } else {
                result.put("success", false);
                result.put("error", "Patient non trouvé");
            }

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la recherche du patient");
        }

        return result;
    }

    public Map<String, Object> updatePatient(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            String cinParam = request.getParameter("cin");

            if (cinParam == null || cinParam.isEmpty()) {
                result.put("success", false);
                result.put("error", "CIN est requis pour mettre à jour les informations");
                return result;
            }

            PatientDTO existingPatient = patientService.findByCin(cinParam);

            if (existingPatient == null) {
                result.put("success", false);
                result.put("error", "Patient non trouvé");
                return result;
            }

            String nom = request.getParameter("nom");
            if (nom != null && !nom.isEmpty()) {
                existingPatient.setNom(nom);
            }

            String email = request.getParameter("email");
            if (email != null && !email.isEmpty()) {
                existingPatient.setEmail(email);
            }

            String sang = request.getParameter("sang");
            if (sang != null) {
                existingPatient.setSang(sang);
            }

            String sexe = request.getParameter("sexe");
            if (sexe != null) {
                existingPatient.setSexe(sexe);
            }

            String adresse = request.getParameter("adresse");
            if (adresse != null) {
                existingPatient.setAdresse(adresse);
            }

            String telephone = request.getParameter("telephone");
            if (telephone != null) {
                existingPatient.setTelephone(telephone);
            }

            String naissanceStr = request.getParameter("naissance");
            if (naissanceStr != null && !naissanceStr.isEmpty()) {
                try {
                    LocalDate naissance = LocalDate.parse(naissanceStr);
                    existingPatient.setNaissance(naissance);
                } catch (DateTimeParseException e) {
                    result.put("success", false);
                    result.put("error", "Format de date de naissance invalide");
                    return result;
                }
            }

            PatientDTO updated = patientService.updatePatient(existingPatient);

            HttpSession session = request.getSession(false);
            if (session != null) {
                Object user = session.getAttribute("user");
                if (user instanceof PatientDTO &&
                        ((PatientDTO)user).getCin().equals(updated.getCin())) {
                    session.setAttribute("user", updated);
                }
            }

            result.put("success", true);
            result.put("patient", updated);
            result.put("message", "Informations mises à jour avec succès");

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur serveur, réessayez plus tard");
        }

        return result;
    }
}