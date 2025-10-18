package com.clinique.service;

import com.clinique.repository.DepartmentRepository;
import com.clinique.repository.SpecialtyRepository;
import com.clinique.repository.DoctorRepository;
import com.clinique.repository.UserRepository;
import jakarta.persistence.EntityManager;
import com.clinique.mapper.DoctorMapper;
import com.clinique.config.DBConnection;
import com.clinique.entity.Department;
import com.clinique.entity.Specialty;
import java.util.stream.Collectors;
import com.clinique.dto.DoctorDTO;
import com.clinique.entity.Doctor;
import jakarta.persistence.Query;
import org.mindrot.jbcrypt.BCrypt;
import com.clinique.entity.User;
import com.clinique.enums.Role;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Optional;
import java.util.List;
import java.util.UUID;

public class DoctorService {

    private  final UserRepository userRepository = new UserRepository();
    private final DoctorRepository doctorRepository = new DoctorRepository();
    private final SpecialtyRepository specialtyRepository = new SpecialtyRepository();
    private final DepartmentRepository departmentRepository = new DepartmentRepository();

    public DoctorDTO findById(UUID id) {
        Optional<Doctor> doctorOpt = doctorRepository.findById(id);
        return doctorOpt.map(DoctorMapper::toDTO).orElse(null);
    }

    public List<DoctorDTO> findBySpecialty(UUID specialtyId) {
        Optional<Specialty> specialtyOpt = specialtyRepository.findById(specialtyId);
        if (specialtyOpt.isEmpty()) {
            throw new IllegalArgumentException("Spécialité non trouvée");
        }

        return doctorRepository.findBySpecialty(specialtyOpt.get())
                .stream()
                .map(DoctorMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<DoctorDTO> findByDepartment(UUID departmentId) {
        Optional<Department> departmentOpt = departmentRepository.findById(departmentId);
        if (departmentOpt.isEmpty()) {
            throw new IllegalArgumentException("Département non trouvé");
        }

        Department department = departmentOpt.get();

        List<Specialty> specialties = specialtyRepository.findByDepartment(department);

        List<Doctor> doctors = new ArrayList<>();
        for (Specialty specialty : specialties) {
            doctors.addAll(doctorRepository.findBySpecialty(specialty));
        }

        return doctors.stream()
                .distinct() // Remove duplicates if any
                .map(DoctorMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<DoctorDTO> findAll() {
        return doctorRepository.findAll()
                .stream()
                .map(DoctorMapper::toDTO)
                .collect(Collectors.toList());
    }

    public DoctorDTO findByUserId(UUID userId) {
        Optional<Doctor> doctorOpt = doctorRepository.findById(userId);
        return doctorOpt.map(DoctorMapper::toDTO).orElse(null);
    }

    public DoctorDTO update(DoctorDTO doctorDTO) {
        Optional<Doctor> doctorOpt = doctorRepository.findById(doctorDTO.getId());
        Doctor doctor;

        if (doctorOpt.isPresent()) {
            doctor = doctorOpt.get();
        } else {
            doctor = new Doctor();
            doctor.setId(doctorDTO.getId());
            doctor.setEmail(doctorDTO.getEmail());

            Optional<User> userOpt = userRepository.findById(doctorDTO.getId());
            if (userOpt.isPresent()) {
                doctor.setPassword(userOpt.get().getPassword());
                doctor.setRole(userOpt.get().getRole());
            }

            doctor.setActif(true);
        }

        // Check if name has changed (will affect matricule)
        boolean nameChanged = !doctor.getNom().equals(doctorDTO.getNom());
        doctor.setNom(doctorDTO.getNom());

        doctor.setEmail(doctorDTO.getEmail());
        doctor.setTitre(doctorDTO.getTitre());
        doctor.setTelephone(doctorDTO.getTelephone());
        doctor.setPresentation(doctorDTO.getPresentation());
        doctor.setExperience(doctorDTO.getExperience());
        doctor.setFormation(doctorDTO.getFormation());

        // Check for specialty change
        Specialty oldSpecialty = doctor.getSpecialty();
        Specialty newSpecialty = null;
        boolean specialtyChanged = false;

        if (doctorDTO.getSpecialty() != null) {
            newSpecialty = specialtyRepository.findById(doctorDTO.getSpecialty().getId()).orElse(null);

            // Check if specialty has changed
            if ((oldSpecialty == null && newSpecialty != null) ||
                    (oldSpecialty != null && newSpecialty != null &&
                            !oldSpecialty.getId().equals(newSpecialty.getId()))) {
                specialtyChanged = true;
            }

            doctor.setSpecialty(newSpecialty);
        } else if (oldSpecialty != null) {
            // Specialty was removed
            specialtyChanged = true;
            doctor.setSpecialty(null);
        }

        // Regenerate matricule if name or specialty changed
        if (nameChanged || specialtyChanged) {
            String generatedMatricule = generateDoctorMatricule(doctor.getNom(), doctor.getSpecialty());
            System.out.println("Regenerating matricule due to data change. New matricule: " + generatedMatricule);
            doctor.setMatricule(generatedMatricule);
        }

        Doctor updatedDoctor = doctorRepository.save(doctor);
        return DoctorMapper.toDTO(updatedDoctor);
    }

    public boolean updatePassword(UUID doctorId, String currentPassword, String newPassword) {
        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur non trouvé"));

        if (!BCrypt.checkpw(currentPassword, doctor.getPassword())) {
            return false;
        }

        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        doctor.setPassword(hashedPassword);

        doctorRepository.save(doctor);
        return true;
    }

    public DoctorDTO findOrCreateByUserId(UUID userId) {
        try {
            System.out.println("Finding or creating doctor for user ID: " + userId);

            // First check if we already have a doctor record
            EntityManager em = DBConnection.getEntityManager();
            Doctor doctor = null;

            try {
                // Use a direct SQL query to check if a record exists in the doctors table
                String checkSql = "SELECT id FROM doctors WHERE id = ?";
                Query query = em.createNativeQuery(checkSql);
                query.setParameter(1, userId);

                List<?> results = query.getResultList();
                boolean doctorExists = !results.isEmpty();

                if (doctorExists) {
                    System.out.println("Doctor record exists, retrieving it");
                    // If exists, get the full doctor entity with JPA
                    doctor = em.find(Doctor.class, userId);
                } else {
                    System.out.println("Doctor record doesn't exist, creating one");
                    // Need to create a new doctor record

                    // First, get the user information
                    User user = em.find(User.class, userId);
                    if (user == null) {
                        System.err.println("User not found with ID: " + userId);
                        return null;
                    }

                    // Create a new doctor record
                    em.getTransaction().begin();

                    // Use native SQL to insert the doctor record
                    String matricule = generateDoctorMatricule(user.getNom(), null);
                    String insertSql = "INSERT INTO doctors (id, matricule, titre, actif) VALUES (?, ?, ?, ?)";

                    Query insertQuery = em.createNativeQuery(insertSql);
                    insertQuery.setParameter(1, userId);
                    insertQuery.setParameter(2, matricule);
                    insertQuery.setParameter(3, "Dr");
                    insertQuery.setParameter(4, true);

                    insertQuery.executeUpdate();
                    em.getTransaction().commit();

                    // Now get the newly created doctor
                    doctor = em.find(Doctor.class, userId);
                }

                if (doctor != null) {
                    return DoctorMapper.toDTO(doctor);
                } else {
                    System.err.println("Failed to find/create doctor record");
                    return null;
                }

            } catch (Exception e) {
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                throw e;
            } finally {
                if (em.isOpen()) em.close();
            }
        } catch (Exception e) {
            System.err.println("Error in findOrCreateByUserId: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    private DoctorDTO createDoctorWithFallback(User user, String matricule) {
        System.out.println("Trying fallback doctor creation approach");
        EntityManager em = DBConnection.getEntityManager();
        try {
            em.getTransaction().begin();

            // Create doctor from scratch without using inheritance
            Doctor doctor = new Doctor();
            doctor.setId(user.getId());
            doctor.setNom(user.getNom());
            doctor.setEmail(user.getEmail());
            doctor.setPassword(user.getPassword());
            doctor.setRole(user.getRole());
            doctor.setMatricule(matricule);
            doctor.setTitre("Dr");
            doctor.setActif(true);

            // Try a simple merge
            doctor = em.merge(doctor);
            em.getTransaction().commit();

            System.out.println("Fallback approach successful");
            return DoctorMapper.toDTO(doctor);
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            System.err.println("Fallback approach failed: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public int countActiveDoctors() {
        return doctorRepository.countActiveDoctors();
    }

    public DoctorDTO register(DoctorDTO doctorDTO, String password) {
        Doctor doctor = new Doctor();
        doctor.setNom(doctorDTO.getNom());
        doctor.setEmail(doctorDTO.getEmail());
        doctor.setRole(Role.valueOf(Role.DOCTOR.toString()));
        doctor.setMatricule(doctorDTO.getMatricule());
        doctor.setTitre(doctorDTO.getTitre());
        doctor.setActif(true);

        if (doctorDTO.getSpecialty() != null) {
            Specialty specialty = specialtyRepository.findById(doctorDTO.getSpecialty().getId())
                    .orElseThrow(() -> new IllegalArgumentException("Specialty not found"));
            doctor.setSpecialty(specialty);
        }

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        doctor.setPassword(hashedPassword);

        Doctor savedDoctor = doctorRepository.save(doctor);
        return DoctorMapper.toDTO(savedDoctor);
    }

    public DoctorDTO updateWithPassword(DoctorDTO doctorDTO, String newPassword) {
        Optional<Doctor> doctorOpt = doctorRepository.findById(doctorDTO.getId());
        if (doctorOpt.isEmpty()) {
            throw new IllegalArgumentException("Doctor not found");
        }

        Doctor doctor = doctorOpt.get();
        doctor.setNom(doctorDTO.getNom());
        doctor.setEmail(doctorDTO.getEmail());
        doctor.setTitre(doctorDTO.getTitre());
        doctor.setActif(doctorDTO.isActive());

        if (doctorDTO.getSpecialty() != null) {
            Specialty specialty = specialtyRepository.findById(doctorDTO.getSpecialty().getId())
                    .orElseThrow(() -> new IllegalArgumentException("Specialty not found"));
            doctor.setSpecialty(specialty);
        }

        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        doctor.setPassword(hashedPassword);

        Doctor updatedDoctor = doctorRepository.save(doctor);
        return DoctorMapper.toDTO(updatedDoctor);
    }

    public boolean existsBySpecialty(UUID specialtyId) {
        return doctorRepository.existsBySpecialty(specialtyId);
    }

    private String generateDoctorMatricule(String fullName, Specialty specialty) {
        String[] nameParts = fullName.trim().split("\\s+");
        StringBuilder initials = new StringBuilder();

        for (int i = 0; i < Math.min(2, nameParts.length); i++) {
            if (!nameParts[i].isEmpty()) {
                initials.append(Character.toUpperCase(nameParts[i].charAt(0)));
            }
        }

        if (nameParts.length == 1 && nameParts[0].length() > 1) {
            initials.append(Character.toUpperCase(nameParts[0].charAt(1)));
        }

        String year = String.valueOf(LocalDate.now().getYear()).substring(2);

        String deptCode = "MED"; // Default
        if (specialty != null) {
            if (specialty.getCode() != null && !specialty.getCode().isEmpty()) {
                deptCode = specialty.getCode().toUpperCase();
            } else if (specialty.getNom() != null && !specialty.getNom().isEmpty()) {
                deptCode = specialty.getNom().substring(0, Math.min(5, specialty.getNom().length())).toUpperCase();
            }
        }

        return initials + "-" + deptCode + "-" + year;
    }

}