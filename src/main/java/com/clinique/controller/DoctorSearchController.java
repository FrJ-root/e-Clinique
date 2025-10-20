package com.clinique.controller;

import jakarta.servlet.http.HttpServletRequest;
import com.clinique.service.DepartmentService;
import com.clinique.service.SpecialtyService;
import com.clinique.service.DoctorService;
import com.clinique.dto.DepartmentDTO;
import com.clinique.dto.SpecialtyDTO;
import com.clinique.dto.DoctorDTO;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;
import java.util.Map;

public class DoctorSearchController {

    private final DoctorService doctorService;
    private final SpecialtyService specialtyService;
    private final DepartmentService departmentService;

    public DoctorSearchController() {
        this.doctorService = new DoctorService();
        this.specialtyService = new SpecialtyService();
        this.departmentService = new DepartmentService();
    }

    public Map<String, Object> getSearchFormData(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            List<DepartmentDTO> departments = departmentService.findAll();
            List<SpecialtyDTO> specialties = specialtyService.getAllSpecialties();

            result.put("success", true);
            result.put("departments", departments);
            result.put("specialties", specialties);

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors du chargement des données");
        }

        return result;
    }

    public Map<String, Object> searchDoctorsBySpecialty(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            String specialtyIdStr = request.getParameter("specialtyId");

            if (specialtyIdStr == null || specialtyIdStr.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "ID de spécialité requis");
                return result;
            }

            UUID specialtyId = UUID.fromString(specialtyIdStr);

            SpecialtyDTO specialty = specialtyService.findById(specialtyId);
            if (specialty == null) {
                result.put("success", false);
                result.put("error", "Spécialité non trouvée");
                return result;
            }

            List<DoctorDTO> doctors = doctorService.findBySpecialty(specialtyId);

            result.put("success", true);
            result.put("specialty", specialty);
            result.put("doctors", doctors);

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la recherche des médecins");
        }

        return result;
    }

    public Map<String, Object> searchDoctorsByDepartment(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            String departmentIdStr = request.getParameter("departmentId");

            if (departmentIdStr == null || departmentIdStr.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "ID de département requis");
                return result;
            }

            UUID departmentId = UUID.fromString(departmentIdStr);

            DepartmentDTO department = departmentService.findById(departmentId);
            if (department == null) {
                result.put("success", false);
                result.put("error", "Département non trouvé");
                return result;
            }

            List<DoctorDTO> doctors = doctorService.findByDepartment(departmentId);

            result.put("success", true);
            result.put("department", department);
            result.put("doctors", doctors);

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la recherche des médecins");
        }

        return result;
    }

    public Map<String, Object> getAllDoctors(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            List<DoctorDTO> doctors = doctorService.findAll();

            result.put("success", true);
            result.put("doctors", doctors);

        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des médecins");
        }

        return result;
    }

    public Map<String, Object> getDoctorDetails(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            String doctorIdStr = request.getParameter("id");

            if (doctorIdStr == null || doctorIdStr.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "ID du docteur requis");
                return result;
            }

            UUID doctorId = UUID.fromString(doctorIdStr);

            DoctorDTO doctor = doctorService.findById(doctorId);
            if (doctor == null) {
                result.put("success", false);
                result.put("error", "Docteur non trouvé");
                return result;
            }

            result.put("success", true);
            result.put("doctor", doctor);

        } catch (IllegalArgumentException ex) {
            result.put("success", false);
            result.put("error", ex.getMessage());
        } catch (Exception ex) {
            result.put("success", false);
            result.put("error", "Erreur lors de la récupération des détails du docteur");
        }

        return result;
    }
}