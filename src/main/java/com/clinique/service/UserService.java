package com.clinique.service;

import java.util.Optional;
import com.clinique.dto.UserDTO;
import com.clinique.entity.User;
import org.mindrot.jbcrypt.BCrypt;
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

}