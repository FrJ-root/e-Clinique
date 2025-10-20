package com.clinique.service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.Optional;
import java.util.stream.Collectors;

import com.clinique.config.DBConnection;
import com.clinique.dto.DepartmentDTO;
import com.clinique.entity.Department;
import com.clinique.mapper.DepartmentMapper;
import com.clinique.repository.DepartmentRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class DepartmentService {

    private final DepartmentRepository departmentRepository = new DepartmentRepository();

    public DepartmentDTO create(DepartmentDTO departmentDTO) {
        if (departmentDTO == null) {
            throw new IllegalArgumentException("Department data cannot be null");
        }

        if (departmentDTO.getNom() == null || departmentDTO.getNom().trim().isEmpty()) {
            throw new IllegalArgumentException("Department name is required");
        }

        Optional<Department> existingDepartment = departmentRepository.findByName(departmentDTO.getNom());
        if (existingDepartment.isPresent()) {
            throw new IllegalArgumentException("A department with this name already exists");
        }

        Department department = new Department();
        department.setNom(departmentDTO.getNom());
        department.setDescription(departmentDTO.getDescription());

        String code = generateDepartmentCode(departmentDTO.getNom());
        department.setCode(code);

        Department savedDepartment = departmentRepository.save(department);
        return DepartmentMapper.toDTO(savedDepartment);
    }

    private String generateDepartmentCode(String name) {
        String prefix = name.substring(0, Math.min(3, name.length())).toUpperCase();
        int randomSuffix = (int) (Math.random() * 900) + 100; // Random number between 100-999
        return prefix + randomSuffix;
    }

    public DepartmentDTO update(DepartmentDTO departmentDTO) {
        if (departmentDTO == null || departmentDTO.getId() == null) {
            throw new IllegalArgumentException("Department ID is required for update");
        }

        if (departmentDTO.getNom() == null || departmentDTO.getNom().trim().isEmpty()) {
            throw new IllegalArgumentException("Department name is required");
        }

        Optional<Department> departmentOpt = departmentRepository.findById(departmentDTO.getId());
        if (departmentOpt.isEmpty()) {
            throw new IllegalArgumentException("Department not found");
        }

        Department department = departmentOpt.get();

        if (!department.getNom().equals(departmentDTO.getNom())) {
            Optional<Department> existingWithSameName = departmentRepository.findByName(departmentDTO.getNom());
            if (existingWithSameName.isPresent() && !existingWithSameName.get().getId().equals(departmentDTO.getId())) {
                throw new IllegalArgumentException("A department with this name already exists");
            }
        }

        department.setNom(departmentDTO.getNom());
        department.setDescription(departmentDTO.getDescription());

        if (department.getCode() == null || department.getCode().trim().isEmpty()) {
            String generatedCode = generateDepartmentCode(departmentDTO.getNom());
            department.setCode(generatedCode);
        } else if (departmentDTO.getCode() != null && !departmentDTO.getCode().trim().isEmpty()) {
            department.setCode(departmentDTO.getCode());
        }

        Department updatedDepartment = departmentRepository.save(department);
        return DepartmentMapper.toDTO(updatedDepartment);
    }

    public DepartmentDTO findById(UUID id) {
        Optional<Department> departmentOpt = departmentRepository.findById(id);
        return departmentOpt.map(DepartmentMapper::toDTO).orElse(null);
    }

    public List<DepartmentDTO> findAll() {
        return departmentRepository.findAll()
                .stream()
                .map(DepartmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public boolean delete(UUID id) {
        if (id == null) {
            throw new IllegalArgumentException("Department ID is required for deletion");
        }

        Optional<Department> departmentOpt = departmentRepository.findById(id);
        if (departmentOpt.isEmpty()) {
            return false;
        }

        try {
            departmentRepository.delete(departmentOpt.get());
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting department: " + e.getMessage());
            return false;
        }
    }

    public List<DepartmentDTO> getAllDepartments() {
        List<Department> departments = departmentRepository.findAll();
        return departments.stream()
                .map(DepartmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<DepartmentDTO> findAllActive() {
        List<Department> departments = departmentRepository.findByActive(true);
        return departments.stream()
                .map(DepartmentMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<DepartmentDTO> getDepartmentsWithDoctors() {
        List<Department> allDepartments = departmentRepository.findAll();
        List<DepartmentDTO> departmentsWithDoctors = new ArrayList<>();

        for (Department department : allDepartments) {
            if (departmentHasDoctors(department.getId())) {
                departmentsWithDoctors.add(DepartmentMapper.toDTO(department));
            }
        }

        return departmentsWithDoctors;
    }

    private boolean departmentHasDoctors(UUID departmentId) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(d) FROM Doctor d " +
                            "JOIN d.specialty s " +
                            "WHERE s.department.id = :departmentId " +
                            "AND d.actif = true",
                    Long.class
            );
            query.setParameter("departmentId", departmentId);
            return query.getSingleResult() > 0;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

}