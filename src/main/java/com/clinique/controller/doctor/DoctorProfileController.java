package com.clinique.controller.doctor;

import java.util.*;
import com.clinique.dto.UserDTO;
import com.clinique.dto.DoctorDTO;
import com.clinique.dto.SpecialtyDTO;
import jakarta.servlet.http.HttpSession;
import com.clinique.service.DoctorService;
import com.clinique.service.SpecialtyService;
import jakarta.servlet.http.HttpServletRequest;

public class DoctorProfileController {

    private final DoctorService doctorService;
    private final SpecialtyService specialtyService;

    public DoctorProfileController() {
        this.doctorService = new DoctorService();
        this.specialtyService = new SpecialtyService();
    }

    public Map<String, Object> getProfileData(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Session invalide");
                return result;
            }

            Object userObj = session.getAttribute("user");
            UserDTO userDTO = null;
            DoctorDTO doctor = null;

            if (userObj instanceof DoctorDTO) {
                doctor = (DoctorDTO) userObj;
                userDTO = doctor;
            } else if (userObj instanceof UserDTO) {
                userDTO = (UserDTO) userObj;

                if ("DOCTOR".equals(userDTO.getRole())) {
                    doctor = doctorService.findOrCreateByUserId(userDTO.getId());

                    if (doctor != null) {
                        session.setAttribute("user", doctor);
                    }
                }
            }

            if (userDTO == null) {
                result.put("success", false);
                result.put("error", "Utilisateur non trouvé");
                return result;
            }

            if (doctor == null) {
                doctor = new DoctorDTO();
                doctor.setId(userDTO.getId());
                doctor.setNom(userDTO.getNom());
                doctor.setEmail(userDTO.getEmail());
                doctor.setRole(userDTO.getRole());
                doctor.setTitre("Dr");
            }

            List<SpecialtyDTO> allSpecialties = specialtyService.findAll();

            result.put("success", true);
            result.put("doctor", doctor);
            result.put("specialties", allSpecialties);

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des données du profil: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> updateProfile(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Session invalide");
                return result;
            }

            Object userObj = session.getAttribute("user");
            DoctorDTO doctor = null;

            if (userObj instanceof DoctorDTO) {
                doctor = (DoctorDTO) userObj;
            } else if (userObj instanceof UserDTO) {
                UserDTO userDTO = (UserDTO) userObj;
                if ("DOCTOR".equals(userDTO.getRole())) {
                    doctor = doctorService.findOrCreateByUserId(userDTO.getId());
                }
            }

            if (doctor == null) {
                result.put("success", false);
                result.put("error", "Médecin non trouvé");
                return result;
            }

            String originalName = doctor.getNom();
            UUID originalSpecialtyId = doctor.getSpecialty() != null ? doctor.getSpecialty().getId() : null;

            String nom = request.getParameter("nom");
            String email = request.getParameter("email");
            String titre = request.getParameter("titre");
            String telephone = request.getParameter("telephone");
            String specialtyIdStr = request.getParameter("specialtyId");
            String presentation = request.getParameter("presentation");
            String experience = request.getParameter("experience");
            String formation = request.getParameter("formation");
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");

            if (nom != null && !nom.trim().isEmpty()) {
                doctor.setNom(nom);
            }

            if (email != null && !email.trim().isEmpty()) {
                doctor.setEmail(email);
            }

            if (titre != null) {
                doctor.setTitre(titre);
            }

            if (telephone != null) {
                doctor.setTelephone(telephone);
            }

            boolean specialtyChanged = false;
            UUID newSpecialtyId = null;

            if (specialtyIdStr != null && !specialtyIdStr.trim().isEmpty()) {
                try {
                    newSpecialtyId = UUID.fromString(specialtyIdStr);
                    SpecialtyDTO specialty = specialtyService.findById(newSpecialtyId);

                    if (specialty != null) {
                        if (originalSpecialtyId == null || !originalSpecialtyId.equals(newSpecialtyId)) {
                            specialtyChanged = true;
                            System.out.println("Specialty changed from " + originalSpecialtyId + " to " + newSpecialtyId);
                        }
                        doctor.setSpecialty(specialty);
                    }
                } catch (IllegalArgumentException e) {}
            } else if (originalSpecialtyId != null) {
                specialtyChanged = true;
                doctor.setSpecialty(null);
                System.out.println("Specialty removed");
            }

            if (presentation != null) {
                doctor.setPresentation(presentation);
            }

            if (experience != null) {
                doctor.setExperience(experience);
            }

            if (formation != null) {
                doctor.setFormation(formation);
            }

            boolean nameChanged = nom != null && !nom.equals(originalName);

            if (nameChanged) {
                System.out.println("Name changed from " + originalName + " to " + nom);
            }

            boolean passwordChanged = false;
            if (currentPassword != null && !currentPassword.trim().isEmpty() &&
                    newPassword != null && !newPassword.trim().isEmpty()) {
                passwordChanged = doctorService.updatePassword(doctor.getId(), currentPassword, newPassword);
                if (!passwordChanged) {
                    result.put("passwordError", "Le mot de passe actuel est incorrect");
                }
            }

            DoctorDTO updatedDoctor = doctorService.update(doctor);

            result.put("success", true);
            result.put("doctor", updatedDoctor);

            String message = "Profil mis à jour avec succès";
            if (passwordChanged) {
                message += " (mot de passe changé)";
            }
            if (nameChanged || specialtyChanged) {
                message += " (matricule mis à jour: " + updatedDoctor.getMatricule() + ")";
            }

            result.put("message", message);

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la mise à jour du profil: " + ex.getMessage());
        }

        return result;
    }

}