package com.clinique.service;

import com.clinique.config.DBConnection;
import com.clinique.entity.Doctor;
import com.clinique.repository.DepartmentRepository;
import com.clinique.repository.SpecialtyRepository;
import com.clinique.mapper.SpecialtyMapper;
import com.clinique.entity.Department;
import com.clinique.dto.SpecialtyDTO;
import com.clinique.entity.Specialty;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;

import java.util.*;
import java.util.stream.Collectors;

public class SpecialtyService {

    private final SpecialtyRepository specialtyRepository = new SpecialtyRepository();
    private final DepartmentRepository departmentRepository = new DepartmentRepository();

    public SpecialtyDTO findById(UUID id) {
        Optional<Specialty> specialtyOpt = specialtyRepository.findById(id);
        return specialtyOpt.map(SpecialtyMapper::toDTO).orElse(null);
    }

    public List<SpecialtyDTO> getAllSpecialties() {
        List<Specialty> specialties = specialtyRepository.findAll();

        return specialties.stream()
                .map(SpecialtyMapper::toDTO)
                .sorted(Comparator.comparing(SpecialtyDTO::getNom))
                .collect(Collectors.toList());
    }

    public List<SpecialtyDTO> findByDepartment(UUID departmentId) {
        System.out.println("SpecialtyService: Finding specialties for department ID: " + departmentId);

        List<SpecialtyDTO> results = new ArrayList<>(); // Initialize the list

        try {
            // Find the department first to ensure it exists
            Optional<Department> departmentOpt = departmentRepository.findById(departmentId);

            if (departmentOpt.isEmpty()) {
                System.out.println("SpecialtyService: Department not found for ID: " + departmentId);
                return results; // Return empty list
            }

            Department department = departmentOpt.get();

            // Find all specialties for this department
            List<Specialty> specialties = specialtyRepository.findByDepartment(department);

            // Convert to DTOs
            results = specialties.stream()
                    .map(SpecialtyMapper::toDTO)
                    .collect(Collectors.toList());

            System.out.println("SpecialtyService: Found " + results.size() + " specialties for department ID: " + departmentId);
            for (SpecialtyDTO specialty : results) {
                System.out.println("  - " + specialty.getNom() + " (ID: " + specialty.getId() + ")");
            }

        } catch (Exception e) {
            System.err.println("SpecialtyService: Error finding specialties for department ID: " + departmentId);
            e.printStackTrace();
        }

        return results;
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

    public List<SpecialtyDTO> getSpecialtiesWithDoctors() {
        EntityManager em = DBConnection.getEntityManager();
        try {
            TypedQuery<Specialty> query = em.createQuery(
                    "SELECT DISTINCT s FROM Specialty s " +
                            "JOIN s.doctors doc " +
                            "WHERE doc.actif = true " +
                            "ORDER BY s.nom",
                    Specialty.class
            );

            List<Specialty> specialties = query.getResultList();

            return specialties.stream()
                    .map(SpecialtyMapper::toDTO)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<SpecialtyDTO> getSpecialtiesWithDoctorsByDepartment(UUID departmentId) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            // Query to get all specialties in the department
            TypedQuery<Specialty> query = em.createQuery(
                    "SELECT DISTINCT s FROM Specialty s " +
                            "WHERE s.department.id = :departmentId " +
                            "ORDER BY s.nom",
                    Specialty.class
            );
            query.setParameter("departmentId", departmentId);

            List<Specialty> allSpecialties = query.getResultList();

            // Filter specialties that have at least one active doctor
            List<Specialty> specialtiesWithDoctors = allSpecialties.stream()
                    .filter(specialty -> {
                        // Get doctors for this specialty
                        TypedQuery<Long> doctorCountQuery = em.createQuery(
                                "SELECT COUNT(d) FROM Doctor d " +
                                        "WHERE d.specialty.id = :specialtyId " +
                                        "AND d.actif = true",
                                Long.class
                        );
                        doctorCountQuery.setParameter("specialtyId", specialty.getId());
                        Long doctorCount = doctorCountQuery.getSingleResult();

                        return doctorCount > 0;
                    })
                    .collect(Collectors.toList());

            return specialtiesWithDoctors.stream()
                    .map(SpecialtyMapper::toDTO)
                    .collect(Collectors.toList());

        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<SpecialtyDTO> getSpecialtiesByDepartment(UUID departmentId) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            System.out.println("DEBUG: Getting specialties for department ID: " + departmentId);

            TypedQuery<Specialty> query = em.createQuery(
                    "SELECT s FROM Specialty s " +
                            "WHERE s.department.id = :departmentId " +
                            "ORDER BY s.nom",
                    Specialty.class
            );
            query.setParameter("departmentId", departmentId);

            List<Specialty> specialties = query.getResultList();

            System.out.println("DEBUG: Found " + specialties.size() + " specialties");
            for (Specialty s : specialties) {
                System.out.println("  - " + s.getNom() + " (ID: " + s.getId() + ")");
            }

            return specialties.stream()
                    .map(SpecialtyMapper::toDTO)
                    .collect(Collectors.toList());

        } catch (Exception e) {
            System.err.println("ERROR in getSpecialtiesByDepartment: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void debugSpecialtiesForDepartment(UUID departmentId) {
        EntityManager em = DBConnection.getEntityManager();
        try {
            // Get all specialties for department
            TypedQuery<Specialty> query1 = em.createQuery(
                    "SELECT s FROM Specialty s WHERE s.department.id = :departmentId",
                    Specialty.class
            );
            query1.setParameter("departmentId", departmentId);
            List<Specialty> allSpecialties = query1.getResultList();

            System.out.println("=== DEBUG: Specialties for Department " + departmentId + " ===");
            System.out.println("Total specialties in department: " + allSpecialties.size());

            for (Specialty specialty : allSpecialties) {
                System.out.println("  Specialty: " + specialty.getNom() + " (ID: " + specialty.getId() + ")");
                System.out.println("    Total doctors: " + (specialty.getDoctors() != null ? specialty.getDoctors().size() : 0));

                if (specialty.getDoctors() != null) {
                    for (Doctor doctor : specialty.getDoctors()) {
                        System.out.println("      Doctor: " + doctor.getNom() + " - Active: " + doctor.isActif());
                    }
                }
            }

            // Get count of active doctors per specialty
            String sql = "SELECT s.nom, COUNT(d.id) as doctor_count " +
                    "FROM specialties s " +
                    "LEFT JOIN doctors d ON d.specialty_id = s.id " +
                    "LEFT JOIN users u ON u.id = d.id " +
                    "WHERE s.department_id = :departmentId " +
                    "GROUP BY s.id, s.nom " +
                    "ORDER BY s.nom";

            Query nativeQuery = em.createNativeQuery(sql);
            nativeQuery.setParameter("departmentId", departmentId);

            @SuppressWarnings("unchecked")
            List<Object[]> results = nativeQuery.getResultList();

            System.out.println("\n=== Doctor counts per specialty ===");
            for (Object[] row : results) {
                System.out.println("  " + row[0] + ": " + row[1] + " doctors");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

}