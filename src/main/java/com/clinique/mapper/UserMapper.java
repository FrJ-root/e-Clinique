package com.clinique.mapper;

import com.clinique.dto.UserDTO;
import com.clinique.entity.User;
import com.clinique.enums.Role;

public class UserMapper {

    public static User toEntity(UserDTO dto) {
        if (dto == null) return null;
        User u = new User();
        u.setNom(dto.getNom());
        if (dto.getRole() != null) {
            u.setRole(Role.valueOf(dto.getRole().toUpperCase()));
        }
        u.setActif(dto.isActif());
        u.setEmail(dto.getEmail());
        u.setPassword(dto.getPassword());
        return u;
    }

    public static UserDTO toDTO(User entity) {
        if (entity == null) return null;
        UserDTO dto = new UserDTO();
        dto.setId(entity.getId());
        dto.setNom(entity.getNom());
        if (entity.getRole() != null) {
            dto.setRole(entity.getRole().name());
        }
        dto.setActif(entity.isActif());
        dto.setEmail(entity.getEmail());
        return dto;
    }
}