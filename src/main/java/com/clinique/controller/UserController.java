package com.clinique.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import com.clinique.service.UserService;
import com.clinique.dto.UserDTO;
import java.util.HashMap;
import java.util.UUID;
import java.util.Map;

public class UserController {

    private final UserService userService = new UserService();

    public Map<String, Object> authenticate(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "Email et mot de passe sont requis");
                return result;
            }

            UserDTO user = userService.authenticate(email, password);

            result.put("success", true);
            result.put("user", user);
            result.put("role", user.getRole());

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur d'authentification");
        }

        return result;
    }

    public Map<String, Object> logout(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        result.put("success", true);
        result.put("message", "Déconnexion réussie");

        return result;
    }

    public Map<String, Object> register(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            String nom = request.getParameter("nom");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            if (role == null || role.trim().isEmpty()) {
                role = "USER";
            }

            UserDTO dto = new UserDTO();
            dto.setNom(nom);
            dto.setEmail(email);
            dto.setPassword(password);
            dto.setRole(role.toUpperCase());

            UserDTO registered = userService.register(dto);

            result.put("success", true);
            result.put("user", registered);
            result.put("message", "Compte créé avec succès");

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la création du compte");
        }

        return result;
    }

    public Map<String, Object> updateUser(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Utilisateur non connecté");
                return result;
            }

            UserDTO currentUser = (UserDTO) session.getAttribute("user");
            UUID userId = currentUser.getId();

            String nom = request.getParameter("nom");
            String email = request.getParameter("email");
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");

            if ((email != null && !email.equals(currentUser.getEmail())) ||
                    (newPassword != null && !newPassword.trim().isEmpty())) {

                if (currentPassword == null || currentPassword.trim().isEmpty()) {
                    result.put("success", false);
                    result.put("error", "Le mot de passe actuel est requis pour modifier l'email ou le mot de passe");
                    return result;
                }

                try {
                    userService.verifyPassword(currentUser.getEmail(), currentPassword);
                } catch (IllegalArgumentException ex) {
                    result.put("success", false);
                    result.put("error", "Mot de passe actuel incorrect");
                    return result;
                }
            }

            UserDTO userToUpdate = new UserDTO();
            userToUpdate.setId(userId);
            userToUpdate.setRole(currentUser.getRole());

            if (nom != null && !nom.trim().isEmpty()) {
                userToUpdate.setNom(nom);
            } else {
                userToUpdate.setNom(currentUser.getNom());
            }

            if (email != null && !email.trim().isEmpty()) {
                userToUpdate.setEmail(email);
            } else {
                userToUpdate.setEmail(currentUser.getEmail());
            }

            if (newPassword != null && !newPassword.trim().isEmpty()) {
                userToUpdate.setPassword(newPassword);
            }

            UserDTO updatedUser = userService.updateUser(userToUpdate);

            session.setAttribute("user", updatedUser);

            result.put("success", true);
            result.put("user", updatedUser);
            result.put("message", "Profil mis à jour avec succès");

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la mise à jour du profil");
        }

        return result;
    }

    public Map<String, Object> changeAccountStatus(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            String userIdStr = request.getParameter("userId");
            String statusStr = request.getParameter("status");

            if (userIdStr == null || statusStr == null) {
                result.put("success", false);
                result.put("error", "ID utilisateur et statut requis");
                return result;
            }

            UUID userId = UUID.fromString(userIdStr);
            boolean active = Boolean.parseBoolean(statusStr);

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Non autorisé");
                return result;
            }

            UserDTO currentUser = (UserDTO) session.getAttribute("user");
            if (!"ADMIN".equals(currentUser.getRole())) {
                result.put("success", false);
                result.put("error", "Accès refusé: droits d'administrateur requis");
                return result;
            }

            userService.updateUserStatus(userId, active);

            result.put("success", true);
            result.put("message", "Statut du compte mis à jour avec succès");

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la mise à jour du statut du compte");
        }

        return result;
    }

    public Map<String, Object> getUserProfile(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("success", false);
                result.put("error", "Utilisateur non connecté");
                return result;
            }

            UserDTO currentUser = (UserDTO) session.getAttribute("user");

            UserDTO userProfile = userService.getUserById(currentUser.getId());

            if (userProfile == null) {
                result.put("success", false);
                result.put("error", "Utilisateur non trouvé");
                return result;
            }

            result.put("success", true);
            result.put("user", userProfile);

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération du profil");
        }

        return result;
    }

}