package com.clinique.service;

import java.util.UUID;
import java.util.List;
import java.util.Optional;
import com.clinique.enums.Role;
import com.clinique.dto.UserDTO;
import com.clinique.entity.User;
import org.mindrot.jbcrypt.BCrypt;
import java.util.stream.Collectors;
import com.clinique.mapper.UserMapper;
import com.clinique.repository.UserRepository;

public class UserService {

    private final UserRepository userRepository = new UserRepository();

    public UserDTO register(UserDTO dto) {
        if (dto.getEmail() == null || dto.getPassword() == null || dto.getNom() == null) {
            throw new IllegalArgumentException("Nom, email et mot de passe sont requis");
        }

        Optional<User> existing = userRepository.findByEmail(dto.getEmail());
        if (existing.isPresent()) {
            throw new IllegalArgumentException("Un utilisateur avec cet e-mail existe déjà");
        }

        String hashed = BCrypt.hashpw(dto.getPassword(), BCrypt.gensalt());
        dto.setPassword(hashed);
        dto.setActif(true);

        User user = UserMapper.toEntity(dto);
        User saved = userRepository.save(user);
        return UserMapper.toDTO(saved);
    }

    public UserDTO authenticate(String email, String rawPassword) {
        Optional<User> maybe = userRepository.findByEmail(email);
        if (maybe.isEmpty()) {
            throw new IllegalArgumentException("Identifiants invalides");
        }

        User user = maybe.get();

        if (!user.isActif()) {
            throw new IllegalArgumentException("Compte inactif");
        }

        String storedPassword = user.getPassword();
        boolean ok;

        if (storedPassword != null && storedPassword.startsWith("$2a$")) {
            ok = BCrypt.checkpw(rawPassword, storedPassword);
        } else {
            ok = rawPassword.equals(storedPassword);
        }

        if (!ok) {
            throw new IllegalArgumentException("Identifiants invalides");
        }

        if (!storedPassword.startsWith("$2a$")) {
            String hashed = BCrypt.hashpw(rawPassword, BCrypt.gensalt());
            user.setPassword(hashed);
            userRepository.save(user); // update DB
            System.out.println("Password for " + email + " was upgraded to hashed version ✅");
        }

        return UserMapper.toDTO(user);
    }

    public boolean verifyPassword(String email, String rawPassword) {
        Optional<User> maybe = userRepository.findByEmail(email);
        if (maybe.isEmpty()) {
            throw new IllegalArgumentException("Utilisateur non trouvé");
        }

        User user = maybe.get();
        String storedPassword = user.getPassword();

        if (storedPassword != null && storedPassword.startsWith("$2a$")) {
            if (BCrypt.checkpw(rawPassword, storedPassword)) {
                return true;
            }
        } else if (rawPassword.equals(storedPassword)) {
            return true;
        }

        throw new IllegalArgumentException("Mot de passe incorrect");
    }

    public UserDTO updateUser(UserDTO dto) {
        if (dto.getId() == null) {
            throw new IllegalArgumentException("ID utilisateur requis pour la mise à jour");
        }

        Optional<User> existingOpt = userRepository.findById(dto.getId());
        if (existingOpt.isEmpty()) {
            throw new IllegalArgumentException("Utilisateur non trouvé");
        }

        User existing = existingOpt.get();

        if (!existing.getEmail().equals(dto.getEmail())) {
            Optional<User> userWithSameEmail = userRepository.findByEmail(dto.getEmail());
            if (userWithSameEmail.isPresent() && !userWithSameEmail.get().getId().equals(dto.getId())) {
                throw new IllegalArgumentException("Un utilisateur avec cet e-mail existe déjà");
            }
        }

        if (dto.getNom() != null) {
            existing.setNom(dto.getNom());
        }

        if (dto.getEmail() != null) {
            existing.setEmail(dto.getEmail());
        }

        if (dto.getPassword() != null && !dto.getPassword().trim().isEmpty()) {
            String hashed = BCrypt.hashpw(dto.getPassword(), BCrypt.gensalt());
            existing.setPassword(hashed);
        }

        User updated = userRepository.save(existing);
        return UserMapper.toDTO(updated);
    }

    public UserDTO updateUserStatus(UUID userId, boolean active) {
        if (userId == null) {
            throw new IllegalArgumentException("ID utilisateur requis");
        }

        Optional<User> existingOpt = userRepository.findById(userId);
        if (existingOpt.isEmpty()) {
            throw new IllegalArgumentException("Utilisateur non trouvé");
        }

        User existing = existingOpt.get();
        existing.setActif(active);

        User updated = userRepository.save(existing);
        return UserMapper.toDTO(updated);
    }

    public UserDTO getUserById(UUID id) {
        if (id == null) {
            throw new IllegalArgumentException("ID utilisateur requis");
        }

        Optional<User> userOpt = userRepository.findById(id);
        return userOpt.map(UserMapper::toDTO).orElse(null);
    }

    public List<UserDTO> findRecentUsers(int limit) {
        if (limit <= 0) {
            throw new IllegalArgumentException("Limit must be greater than zero");
        }

        List<User> users = userRepository.findRecentUsers(limit);
        return users.stream()
                .map(UserMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<UserDTO> findByRole(Role role, String searchQuery) {
        List<User> users;
        if (searchQuery != null && !searchQuery.isEmpty()) {
            users = userRepository.findByRoleAndQuery(role, searchQuery);
        } else {
            users = userRepository.findByRole(role);
        }
        return users.stream()
                .map(UserMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<UserDTO> searchUsers(String query) {
        if (query == null || query.trim().isEmpty()) {
            throw new IllegalArgumentException("Search query cannot be empty");
        }

        List<User> users = userRepository.search(query);
        return users.stream()
                .map(UserMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<UserDTO> findAll() {
        List<User> users = userRepository.findAll();
        return users.stream()
                .map(UserMapper::toDTO)
                .collect(Collectors.toList());
    }

    public UserDTO findById(UUID id) {
        return getUserById(id);
    }

    public UserDTO registerAdmin(UserDTO userDTO, String password) {
        if (userDTO == null) {
            throw new IllegalArgumentException("User data cannot be null");
        }

        if (userDTO.getEmail() == null || password == null || userDTO.getNom() == null) {
            throw new IllegalArgumentException("Name, email and password are required");
        }

        Optional<User> existing = userRepository.findByEmail(userDTO.getEmail());
        if (existing.isPresent()) {
            throw new IllegalArgumentException("A user with this email already exists");
        }

        String hashed = BCrypt.hashpw(password, BCrypt.gensalt());

        User admin = new User();
        admin.setNom(userDTO.getNom());
        admin.setEmail(userDTO.getEmail());
        admin.setRole(Role.ADMIN);
        admin.setPassword(hashed);
        admin.setActif(true);

        User saved = userRepository.save(admin);
        return UserMapper.toDTO(saved);
    }

    public UserDTO updateWithPassword(UserDTO userDTO, String newPassword) {
        if (userDTO == null || userDTO.getId() == null) {
            throw new IllegalArgumentException("User ID is required for update");
        }

        Optional<User> existingOpt = userRepository.findById(userDTO.getId());
        if (existingOpt.isEmpty()) {
            throw new IllegalArgumentException("User not found");
        }

        User existing = existingOpt.get();

        if (!existing.getEmail().equals(userDTO.getEmail())) {
            Optional<User> userWithSameEmail = userRepository.findByEmail(userDTO.getEmail());
            if (userWithSameEmail.isPresent() && !userWithSameEmail.get().getId().equals(userDTO.getId())) {
                throw new IllegalArgumentException("A user with this email already exists");
            }
        }

        existing.setNom(userDTO.getNom());
        existing.setEmail(userDTO.getEmail());

        if (userDTO.isActif() != existing.isActif()) {
            existing.setActif(userDTO.isActif());
        }

        if (newPassword != null && !newPassword.trim().isEmpty()) {
            String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            existing.setPassword(hashed);
        }

        User updated = userRepository.save(existing);
        return UserMapper.toDTO(updated);
    }

    public UserDTO update(UserDTO userDTO) {
        return updateUser(userDTO);
    }

    public boolean resetPassword(UUID userId, String newPassword) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID is required");
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("New password cannot be empty");
        }

        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            return false;
        }

        User user = userOpt.get();
        String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        user.setPassword(hashed);

        userRepository.save(user);
        return true;
    }

    public boolean deactivateUser(UUID userId) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID is required");
        }

        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            return false;
        }

        User user = userOpt.get();
        user.setActif(false);

        userRepository.save(user);
        return true;
    }

    public boolean activateUser(UUID userId) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID is required");
        }

        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            return false;
        }

        User user = userOpt.get();
        user.setActif(true);

        userRepository.save(user);
        return true;
    }

}