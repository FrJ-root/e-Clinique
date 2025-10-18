package com.clinique.service;

import com.clinique.repository.DepartmentRepository;
import com.clinique.repository.SpecialtyRepository;
import com.clinique.mapper.SpecialtyMapper;
import com.clinique.entity.Department;
import com.clinique.dto.SpecialtyDTO;
import com.clinique.entity.Specialty;
import java.util.stream.Collectors;
import java.util.Optional;
import java.util.List;
import java.util.UUID;

public class SpecialtyService {

    private final SpecialtyRepository specialtyRepository = new SpecialtyRepository();
    private final DepartmentRepository departmentRepository = new DepartmentRepository();

    public SpecialtyDTO findById(UUID id) {
        Optional<Specialty> specialtyOpt = specialtyRepository.findById(id);
        return specialtyOpt.map(SpecialtyMapper::toDTO).orElse(null);
    }

    public List<SpecialtyDTO> findByDepartment(UUID departmentId) {
        Optional<Department> departmentOpt = departmentRepository.findById(departmentId);
        if (departmentOpt.isEmpty()) {
            throw new IllegalArgumentException("Département non trouvé");
        }

        return specialtyRepository.findByDepartment(departmentOpt.get())
                .stream()
                .map(SpecialtyMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<SpecialtyDTO> findAll() {
        return specialtyRepository.findAll()
                .stream()
                .map(SpecialtyMapper::toDTO)
                .collect(Collectors.toList());
    }

    public SpecialtyDTO create(SpecialtyDTO specialtyDTO) {
        if (specialtyDTO.getNom() == null || specialtyDTO.getNom().trim().isEmpty()) {
            throw new IllegalArgumentException("Specialty name is required");
        }

        Specialty specialty = new Specialty();
        specialty.setNom(specialtyDTO.getNom());
        specialty.setDescription(specialtyDTO.getDescription());

        String code = generateSpecialtyCode(specialtyDTO.getNom());
        specialty.setCode(code);

        if (specialtyDTO.getDepartment() != null) {
            Department department = departmentRepository.findById(specialtyDTO.getDepartment().getId())
                    .orElseThrow(() -> new IllegalArgumentException("Department not found"));
            specialty.setDepartment(department);
        }

        Specialty savedSpecialty = specialtyRepository.save(specialty);
        return SpecialtyMapper.toDTO(savedSpecialty);
    }

    private String generateSpecialtyCode(String name) {
        String prefix = name.substring(0, Math.min(2, name.length())).toUpperCase();
        int randomSuffix = (int) (Math.random() * 900) + 100; // Random number between 100-999
        return prefix + randomSuffix;
    }

    public SpecialtyDTO update(SpecialtyDTO specialtyDTO) {
        if (specialtyDTO == null || specialtyDTO.getId() == null) {
            throw new IllegalArgumentException("Specialty ID is required for update");
        }

        Optional<Specialty> specialtyOpt = specialtyRepository.findById(specialtyDTO.getId());
        if (specialtyOpt.isEmpty()) {
            throw new IllegalArgumentException("Specialty not found");
        }

        Specialty specialty = specialtyOpt.get();
        specialty.setNom(specialtyDTO.getNom());
        specialty.setDescription(specialtyDTO.getDescription());

        if (specialty.getCode() == null || specialty.getCode().trim().isEmpty()) {
            String code = generateSpecialtyCode(specialtyDTO.getNom());
            specialty.setCode(code);
        } else if (specialtyDTO.getCode() != null && !specialtyDTO.getCode().isEmpty()) {
            specialty.setCode(specialtyDTO.getCode());
        }

        if (specialtyDTO.getDepartment() != null) {
            Department department = departmentRepository.findById(specialtyDTO.getDepartment().getId())
                    .orElseThrow(() -> new IllegalArgumentException("Department not found"));
            specialty.setDepartment(department);
        } else {
            specialty.setDepartment(null);
        }

        Specialty updatedSpecialty = specialtyRepository.save(specialty);
        return SpecialtyMapper.toDTO(updatedSpecialty);
    }

    public boolean delete(UUID id) {
        Optional<Specialty> specialtyOpt = specialtyRepository.findById(id);
        if (specialtyOpt.isPresent()) {
            specialtyRepository.delete(specialtyOpt.get());
            return true;
        }
        return false;
    }

    public boolean existsByDepartment(UUID departmentId) {
        return specialtyRepository.existsByDepartment(departmentId);
    }

}