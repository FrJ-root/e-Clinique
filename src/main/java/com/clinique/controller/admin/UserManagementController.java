package com.clinique.controller.admin;

import java.util.Map;
import java.util.UUID;
import java.util.List;
import java.util.HashMap;
import com.clinique.enums.Role;
import com.clinique.dto.UserDTO;
import com.clinique.dto.DoctorDTO;
import com.clinique.dto.PatientDTO;
import com.clinique.dto.SpecialtyDTO;
import jakarta.servlet.http.HttpSession;
import com.clinique.service.UserService;
import com.clinique.service.DoctorService;
import com.clinique.service.PatientService;
import com.clinique.service.SpecialtyService;
import jakarta.servlet.http.HttpServletRequest;

public class UserManagementController {

    private final UserService userService;
    private final DoctorService doctorService;
    private final PatientService patientService;
    private final SpecialtyService specialtyService;

    public UserManagementController() {
        this.userService = new UserService();
        this.doctorService = new DoctorService();
        this.patientService = new PatientService();
        this.specialtyService = new SpecialtyService();
    }

    public Map<String, Object> getAllUsers(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Session invalide");
                return result;
            }

            String roleFilter = request.getParameter("role");
            String searchQuery = request.getParameter("q");

            List<UserDTO> users;
            if (roleFilter != null && !roleFilter.isEmpty()) {
                users = userService.findByRole(Role.valueOf(roleFilter), searchQuery);
            } else if (searchQuery != null && !searchQuery.isEmpty()) {
                users = userService.searchUsers(searchQuery);
            } else {
                users = userService.findAll();
            }

            result.put("success", true);
            result.put("users", users);
            result.put("roleFilter", roleFilter);
            result.put("searchQuery", searchQuery);

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des utilisateurs: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> getUserDetails(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Session invalide");
                return result;
            }

            String userIdStr = request.getParameter("id");
            if (userIdStr == null || userIdStr.isEmpty()) {
                result.put("success", false);
                result.put("error", "ID utilisateur requis");
                return result;
            }

            UUID userId = UUID.fromString(userIdStr);
            UserDTO user = userService.findById(userId);

            if (user == null) {
                result.put("success", false);
                result.put("error", "Utilisateur non trouvé");
                return result;
            }

            if ("DOCTOR".equals(user.getRole())) {
                DoctorDTO doctor = doctorService.findByUserId(userId);
                result.put("doctor", doctor);

                List<SpecialtyDTO> specialties = specialtyService.findAll();
                result.put("specialties", specialties);
            } else if ("PATIENT".equals(user.getRole())) {
                PatientDTO patient = patientService.findByUserId(userId);
                result.put("patient", patient);
            }

            result.put("success", true);
            result.put("user", user);

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des détails de l'utilisateur: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> createUser(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Session invalide");
                return result;
            }

            String nom = request.getParameter("nom");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String roleStr = request.getParameter("role");

            if (nom == null || email == null || password == null || roleStr == null) {
                result.put("success", false);
                result.put("error", "Tous les champs sont requis");
                return result;
            }

            Role role = Role.valueOf(roleStr);

            UserDTO newUser = new UserDTO();
            newUser.setNom(nom);
            newUser.setEmail(email);
            newUser.setRole(roleStr);

            switch (role) {
                case ADMIN:
                    UserDTO admin = userService.registerAdmin(newUser, password);
                    result.put("user", admin);
                    break;
                case DOCTOR:
                    String matricule = request.getParameter("matricule");
                    String titre = request.getParameter("titre");
                    String specialtyIdStr = request.getParameter("specialtyId");

                    DoctorDTO doctorDTO = new DoctorDTO();
                    doctorDTO.setNom(nom);
                    doctorDTO.setEmail(email);
                    doctorDTO.setRole(roleStr);
                    doctorDTO.setMatricule(matricule);
                    doctorDTO.setTitre(titre);

                    if (specialtyIdStr != null && !specialtyIdStr.isEmpty()) {
                        UUID specialtyId = UUID.fromString(specialtyIdStr);
                        SpecialtyDTO specialty = specialtyService.findById(specialtyId);
                        doctorDTO.setSpecialty(specialty);
                    }

                    DoctorDTO doctor = doctorService.register(doctorDTO, password);
                    result.put("user", doctor);
                    break;
                case PATIENT:
                    String cin = request.getParameter("cin");

                    PatientDTO patientDTO = new PatientDTO();
                    patientDTO.setNom(nom);
                    patientDTO.setEmail(email);
                    patientDTO.setRole(roleStr);
                    patientDTO.setCin(cin);

                    PatientDTO patient = patientService.register(patientDTO, password);
                    result.put("user", patient);
                    break;
                default:
                    throw new IllegalArgumentException("Rôle non valide");
            }

            result.put("success", true);
            result.put("message", "Utilisateur créé avec succès");

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la création de l'utilisateur: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> updateUser(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Session invalide");
                return result;
            }

            String userIdStr = request.getParameter("id");
            if (userIdStr == null || userIdStr.isEmpty()) {
                result.put("success", false);
                result.put("error", "ID utilisateur requis");
                return result;
            }

            UUID userId = UUID.fromString(userIdStr);
            UserDTO existingUser = userService.findById(userId);

            if (existingUser == null) {
                result.put("success", false);
                result.put("error", "Utilisateur non trouvé");
                return result;
            }

            String nom = request.getParameter("nom");
            String email = request.getParameter("email");
            String newPassword = request.getParameter("newPassword");
            String active = request.getParameter("active");

            existingUser.setNom(nom);
            existingUser.setEmail(email);

            if (active != null) {
                boolean isActive = "on".equals(active) || "true".equals(active);
                existingUser.setActive(isActive);
            }

            switch (existingUser.getRole()) {
                case "ADMIN":
                    UserDTO updatedAdmin;
                    if (newPassword != null && !newPassword.isEmpty()) {
                        updatedAdmin = userService.updateWithPassword(existingUser, newPassword);
                    } else {
                        updatedAdmin = userService.update(existingUser);
                    }
                    result.put("user", updatedAdmin);
                    break;
                case "DOCTOR":
                    String titre = request.getParameter("titre");
                    String specialtyIdStr = request.getParameter("specialtyId");

                    DoctorDTO doctorDTO = doctorService.findByUserId(userId);
                    doctorDTO.setNom(nom);
                    doctorDTO.setEmail(email);
                    doctorDTO.setTitre(titre);

                    if (active != null) {
                        boolean isActive = "on".equals(active) || "true".equals(active);
                        doctorDTO.setActive(isActive);
                    }

                    if (specialtyIdStr != null && !specialtyIdStr.isEmpty()) {
                        UUID specialtyId = UUID.fromString(specialtyIdStr);
                        SpecialtyDTO specialty = specialtyService.findById(specialtyId);
                        doctorDTO.setSpecialty(specialty);
                    }

                    DoctorDTO updatedDoctor;
                    if (newPassword != null && !newPassword.isEmpty()) {
                        updatedDoctor = doctorService.updateWithPassword(doctorDTO, newPassword);
                    } else {
                        updatedDoctor = doctorService.update(doctorDTO);
                    }
                    result.put("user", updatedDoctor);
                    break;
                case "PATIENT":
                    PatientDTO patientDTO = patientService.findByUserId(userId);
                    patientDTO.setNom(nom);
                    patientDTO.setEmail(email);

                    if (active != null) {
                        boolean isActive = "on".equals(active) || "true".equals(active);
                        patientDTO.setActive(isActive);
                    }

                    PatientDTO updatedPatient;
                    if (newPassword != null && !newPassword.isEmpty()) {
                        updatedPatient = patientService.updateWithPassword(patientDTO, newPassword);
                    } else {
                        updatedPatient = patientService.update(patientDTO);
                    }
                    result.put("user", updatedPatient);
                    break;
                default:
                    throw new IllegalArgumentException("Rôle non valide");
            }

            result.put("success", true);
            result.put("message", "Utilisateur mis à jour avec succès");

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la mise à jour de l'utilisateur: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> resetPassword(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Session invalide");
                return result;
            }

            String userIdStr = request.getParameter("id");
            if (userIdStr == null || userIdStr.isEmpty()) {
                result.put("success", false);
                result.put("error", "ID utilisateur requis");
                return result;
            }

            UUID userId = UUID.fromString(userIdStr);
            String newPassword = request.getParameter("newPassword");

            if (newPassword == null || newPassword.isEmpty()) {
                result.put("success", false);
                result.put("error", "Nouveau mot de passe requis");
                return result;
            }

            boolean success = userService.resetPassword(userId, newPassword);

            if (success) {
                result.put("success", true);
                result.put("message", "Mot de passe réinitialisé avec succès");
            } else {
                result.put("success", false);
                result.put("error", "Erreur lors de la réinitialisation du mot de passe");
            }

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la réinitialisation du mot de passe: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> deactivateUser(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Session invalide");
                return result;
            }

            String userIdStr = request.getParameter("id");
            if (userIdStr == null || userIdStr.isEmpty()) {
                result.put("success", false);
                result.put("error", "ID utilisateur requis");
                return result;
            }

            UUID userId = UUID.fromString(userIdStr);
            boolean success = userService.deactivateUser(userId);

            if (success) {
                result.put("success", true);
                result.put("message", "Utilisateur désactivé avec succès");
            } else {
                result.put("success", false);
                result.put("error", "Erreur lors de la désactivation de l'utilisateur");
            }

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la désactivation de l'utilisateur: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> activateUser(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Session invalide");
                return result;
            }

            String userIdStr = request.getParameter("id");
            if (userIdStr == null || userIdStr.isEmpty()) {
                result.put("success", false);
                result.put("error", "ID utilisateur requis");
                return result;
            }

            UUID userId = UUID.fromString(userIdStr);
            boolean success = userService.activateUser(userId);

            if (success) {
                result.put("success", true);
                result.put("message", "Utilisateur activé avec succès");
            } else {
                result.put("success", false);
                result.put("error", "Erreur lors de l'activation de l'utilisateur");
            }

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de l'activation de l'utilisateur: " + ex.getMessage());
        }

        return result;
    }

}