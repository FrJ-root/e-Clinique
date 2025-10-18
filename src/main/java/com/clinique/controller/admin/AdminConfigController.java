package com.clinique.controller.admin;

import com.clinique.dto.DepartmentDTO;
import com.clinique.dto.HolidayDTO;
import com.clinique.dto.SpecialtyDTO;
import com.clinique.dto.SystemSettingDTO;
import com.clinique.service.DepartmentService;
import com.clinique.service.HolidayService;
import com.clinique.service.SpecialtyService;
import com.clinique.service.SystemSettingService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import com.clinique.dto.UserDTO;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class AdminConfigController {

    private final DepartmentService departmentService;
    private final SpecialtyService specialtyService;
    private final SystemSettingService settingService;
    private final HolidayService holidayService;

    public AdminConfigController() {
        this.departmentService = new DepartmentService();
        this.specialtyService = new SpecialtyService();
        this.settingService = new SystemSettingService();
        this.holidayService = new HolidayService();
    }

    // ===================== Department Methods =====================

    public Map<String, Object> getAllDepartments(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (!isAdmin(session)) {
                result.put("success", false);
                result.put("error", "Session invalide ou accès refusé");
                return result;
            }

            List<DepartmentDTO> departments = departmentService.findAll();
            result.put("success", true);
            result.put("departments", departments);

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des départements: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> createDepartment(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (!isAdmin(session)) {
                result.put("success", false);
                result.put("error", "Session invalide ou accès refusé");
                return result;
            }

            String nom = request.getParameter("nom");
            String description = request.getParameter("description");

            if (nom == null || nom.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "Le nom du département est obligatoire");
                return result;
            }

            DepartmentDTO departmentDTO = new DepartmentDTO();
            departmentDTO.setNom(nom);
            departmentDTO.setDescription(description);

            DepartmentDTO created = departmentService.create(departmentDTO);
            result.put("success", true);
            result.put("department", created);
            result.put("message", "Département créé avec succès");

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la création du département: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> updateDepartment(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (!isAdmin(session)) {
                result.put("success", false);
                result.put("error", "Session invalide ou accès refusé");
                return result;
            }

            String id = request.getParameter("id");
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");
            String code = request.getParameter("code"); // Get the code parameter if provided in the form

            if (id == null || id.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "ID du département requis");
                return result;
            }

            if (nom == null || nom.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "Le nom du département est obligatoire");
                return result;
            }

            DepartmentDTO existingDept = departmentService.findById(UUID.fromString(id));
            if (existingDept == null) {
                result.put("success", false);
                result.put("error", "Département non trouvé");
                return result;
            }

            DepartmentDTO departmentDTO = new DepartmentDTO();
            departmentDTO.setId(UUID.fromString(id));
            departmentDTO.setNom(nom);
            departmentDTO.setDescription(description);

            departmentDTO.setCode(existingDept.getCode());

            if (code != null && !code.trim().isEmpty()) {
                departmentDTO.setCode(code);
            }

            DepartmentDTO updated = departmentService.update(departmentDTO);
            result.put("success", true);
            result.put("department", updated);
            result.put("message", "Département mis à jour avec succès");

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la mise à jour du département: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> deleteDepartment(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (!isAdmin(session)) {
                result.put("success", false);
                result.put("error", "Session invalide ou accès refusé");
                return result;
            }

            String id = request.getParameter("id");

            if (id == null || id.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "ID du département requis");
                return result;
            }

            UUID departmentId = UUID.fromString(id);

            if (specialtyService.existsByDepartment(departmentId)) {
                result.put("success", false);
                result.put("error", "Impossible de supprimer ce département car il est utilisé par des spécialités");
                return result;
            }

            boolean deleted = departmentService.delete(departmentId);
            if (deleted) {
                result.put("success", true);
                result.put("message", "Département supprimé avec succès");
            } else {
                result.put("success", false);
                result.put("error", "Le département n'a pas pu être supprimé");
            }

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la suppression du département: " + ex.getMessage());
        }

        return result;
    }

    // ===================== Specialty Methods =====================

    public Map<String, Object> getAllSpecialties(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (!isAdmin(session)) {
                result.put("success", false);
                result.put("error", "Session invalide ou accès refusé");
                return result;
            }

            List<SpecialtyDTO> specialties = specialtyService.findAll();
            List<DepartmentDTO> departments = departmentService.findAll();

            result.put("success", true);
            result.put("specialties", specialties);
            result.put("departments", departments);

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des spécialités: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> createSpecialty(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (!isAdmin(session)) {
                result.put("success", false);
                result.put("error", "Session invalide ou accès refusé");
                return result;
            }

            String nom = request.getParameter("nom");
            String description = request.getParameter("description");
            String departmentId = request.getParameter("departmentId");
            String code = request.getParameter("code");

            if (nom == null || nom.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "Le nom de la spécialité est obligatoire");
                return result;
            }

            SpecialtyDTO specialtyDTO = new SpecialtyDTO();
            specialtyDTO.setNom(nom);
            specialtyDTO.setDescription(description);

            if (code != null && !code.trim().isEmpty()) {
                specialtyDTO.setCode(code);
            }

            if (departmentId != null && !departmentId.trim().isEmpty()) {
                DepartmentDTO department = departmentService.findById(UUID.fromString(departmentId));
                if (department != null) {
                    specialtyDTO.setDepartment(department);
                }
            }

            SpecialtyDTO created = specialtyService.create(specialtyDTO);
            result.put("success", true);
            result.put("specialty", created);
            result.put("message", "Spécialité créée avec succès");

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la création de la spécialité: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> updateSpecialty(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (!isAdmin(session)) {
                result.put("success", false);
                result.put("error", "Session invalide ou accès refusé");
                return result;
            }

            String id = request.getParameter("id");
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");
            String departmentId = request.getParameter("departmentId");
            String code = request.getParameter("code"); // Get code if it exists in form

            if (id == null || id.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "ID de la spécialité requis");
                return result;
            }

            if (nom == null || nom.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "Le nom de la spécialité est obligatoire");
                return result;
            }

            SpecialtyDTO existingSpecialty = specialtyService.findById(UUID.fromString(id));
            if (existingSpecialty == null) {
                result.put("success", false);
                result.put("error", "Spécialité non trouvée");
                return result;
            }

            SpecialtyDTO specialtyDTO = new SpecialtyDTO();
            specialtyDTO.setId(UUID.fromString(id));
            specialtyDTO.setNom(nom);
            specialtyDTO.setDescription(description);

            if (code != null && !code.trim().isEmpty()) {
                specialtyDTO.setCode(code);
            } else {
                specialtyDTO.setCode(existingSpecialty.getCode());
            }

            if (departmentId != null && !departmentId.trim().isEmpty()) {
                DepartmentDTO department = departmentService.findById(UUID.fromString(departmentId));
                if (department != null) {
                    specialtyDTO.setDepartment(department);
                }
            }

            SpecialtyDTO updated = specialtyService.update(specialtyDTO);
            result.put("success", true);
            result.put("specialty", updated);
            result.put("message", "Spécialité mise à jour avec succès");

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la mise à jour de la spécialité: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> deleteSpecialty(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (!isAdmin(session)) {
                result.put("success", false);
                result.put("error", "Session invalide ou accès refusé");
                return result;
            }

            String id = request.getParameter("id");

            if (id == null || id.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "ID de la spécialité requis");
                return result;
            }

            boolean deleted = specialtyService.delete(UUID.fromString(id));
            if (deleted) {
                result.put("success", true);
                result.put("message", "Spécialité supprimée avec succès");
            } else {
                result.put("success", false);
                result.put("error", "La spécialité n'a pas pu être supprimée");
            }

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la suppression de la spécialité: " + ex.getMessage());
        }

        return result;
    }

    // ===================== Settings Methods =====================

    public Map<String, Object> getSettings(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (!isAdmin(session)) {
                result.put("success", false);
                result.put("error", "Session invalide ou accès refusé");
                return result;
            }

            List<SystemSettingDTO> settings = settingService.findAll();

            int slotDuration = settingService.getIntValue("SLOT_DURATION_MINUTES", 30);
            int leadTimeHours = settingService.getIntValue("APPOINTMENT_LEAD_TIME_HOURS", 24);
            boolean allowWeekends = settingService.getBoolValue("ALLOW_WEEKEND_APPOINTMENTS", false);

            List<HolidayDTO> holidays = holidayService.findAll();

            result.put("success", true);
            result.put("settings", settings);
            result.put("slotDuration", slotDuration);
            result.put("leadTimeHours", leadTimeHours);
            result.put("allowWeekends", allowWeekends);
            result.put("holidays", holidays);

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des paramètres: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> saveSettings(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (!isAdmin(session)) {
                result.put("success", false);
                result.put("error", "Session invalide ou accès refusé");
                return result;
            }

            String slotDurationStr = request.getParameter("slotDuration");
            if (slotDurationStr != null && !slotDurationStr.trim().isEmpty()) {
                int slotDuration = Integer.parseInt(slotDurationStr);
                if (slotDuration < 5 || slotDuration > 120) {
                    result.put("success", false);
                    result.put("error", "La durée des créneaux doit être entre 5 et 120 minutes");
                    return result;
                }

                SystemSettingDTO slotSetting = new SystemSettingDTO();
                slotSetting.setSettingKey("SLOT_DURATION_MINUTES");
                slotSetting.setSettingValue(slotDurationStr);
                slotSetting.setDescription("Durée des créneaux de rendez-vous en minutes");
                settingService.createOrUpdate(slotSetting);
            }

            String leadTimeStr = request.getParameter("leadTime");
            if (leadTimeStr != null && !leadTimeStr.trim().isEmpty()) {
                int leadTime = Integer.parseInt(leadTimeStr);
                if (leadTime < 0 || leadTime > 168) { // Max 1 week (168 hours)
                    result.put("success", false);
                    result.put("error", "Le délai minimum de prise de rendez-vous doit être entre 0 et 168 heures");
                    return result;
                }

                SystemSettingDTO leadTimeSetting = new SystemSettingDTO();
                leadTimeSetting.setSettingKey("APPOINTMENT_LEAD_TIME_HOURS");
                leadTimeSetting.setSettingValue(leadTimeStr);
                leadTimeSetting.setDescription("Délai minimum avant prise de rendez-vous (en heures)");
                settingService.createOrUpdate(leadTimeSetting);
            }

            String allowWeekendsStr = request.getParameter("allowWeekends");
            boolean allowWeekends = "on".equals(allowWeekendsStr) || "true".equals(allowWeekendsStr);

            SystemSettingDTO weekendSetting = new SystemSettingDTO();
            weekendSetting.setSettingKey("ALLOW_WEEKEND_APPOINTMENTS");
            weekendSetting.setSettingValue(String.valueOf(allowWeekends));
            weekendSetting.setDescription("Autoriser les rendez-vous le weekend");
            settingService.createOrUpdate(weekendSetting);

            result.put("success", true);
            result.put("message", "Paramètres enregistrés avec succès");

        } catch (NumberFormatException ex) {
            result.put("success", false);
            result.put("error", "Format de nombre invalide: " + ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de l'enregistrement des paramètres: " + ex.getMessage());
        }

        return result;
    }

    // ===================== Holiday Methods =====================

    public Map<String, Object> createHoliday(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (!isAdmin(session)) {
                result.put("success", false);
                result.put("error", "Session invalide ou accès refusé");
                return result;
            }

            String dateStr = request.getParameter("date");
            String description = request.getParameter("description");
            String recurringStr = request.getParameter("recurring");

            if (dateStr == null || dateStr.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "La date du jour férié est obligatoire");
                return result;
            }

            if (description == null || description.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "La description du jour férié est obligatoire");
                return result;
            }

            LocalDate date = LocalDate.parse(dateStr);
            boolean recurring = "on".equals(recurringStr) || "true".equals(recurringStr);

            HolidayDTO holidayDTO = new HolidayDTO();
            holidayDTO.setDate(date);
            holidayDTO.setDescription(description);
            holidayDTO.setRecurring(recurring);

            HolidayDTO created = holidayService.create(holidayDTO);
            result.put("success", true);
            result.put("holiday", created);
            result.put("message", "Jour férié ajouté avec succès");

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de l'ajout du jour férié: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> updateHoliday(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (!isAdmin(session)) {
                result.put("success", false);
                result.put("error", "Session invalide ou accès refusé");
                return result;
            }

            String id = request.getParameter("id");
            String dateStr = request.getParameter("date");
            String description = request.getParameter("description");
            String recurringStr = request.getParameter("recurring");

            if (id == null || id.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "ID du jour férié requis");
                return result;
            }

            if (dateStr == null || dateStr.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "La date du jour férié est obligatoire");
                return result;
            }

            if (description == null || description.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "La description du jour férié est obligatoire");
                return result;
            }

            LocalDate date = LocalDate.parse(dateStr);
            boolean recurring = "on".equals(recurringStr) || "true".equals(recurringStr);

            HolidayDTO holidayDTO = new HolidayDTO();
            holidayDTO.setId(UUID.fromString(id));
            holidayDTO.setDate(date);
            holidayDTO.setDescription(description);
            holidayDTO.setRecurring(recurring);

            HolidayDTO updated = holidayService.update(holidayDTO);
            result.put("success", true);
            result.put("holiday", updated);
            result.put("message", "Jour férié mis à jour avec succès");

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la mise à jour du jour férié: " + ex.getMessage());
        }

        return result;
    }

    public Map<String, Object> deleteHoliday(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (!isAdmin(session)) {
                result.put("success", false);
                result.put("error", "Session invalide ou accès refusé");
                return result;
            }

            String id = request.getParameter("id");

            if (id == null || id.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "ID du jour férié requis");
                return result;
            }

            boolean deleted = holidayService.delete(UUID.fromString(id));
            if (deleted) {
                result.put("success", true);
                result.put("message", "Jour férié supprimé avec succès");
            } else {
                result.put("success", false);
                result.put("error", "Le jour férié n'a pas pu être supprimé");
            }

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la suppression du jour férié: " + ex.getMessage());
        }

        return result;
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null || session.getAttribute("user") == null) {
            return false;
        }

        Object userObj = session.getAttribute("user");
        if (userObj instanceof UserDTO) {
            UserDTO user = (UserDTO) userObj;
            return "ADMIN".equals(user.getRole());
        }

        return false;
    }

}