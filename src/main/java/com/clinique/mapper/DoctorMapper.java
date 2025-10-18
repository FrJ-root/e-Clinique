package com.clinique.mapper;

import com.clinique.dto.DoctorDTO;
import com.clinique.entity.Doctor;
import com.clinique.enums.Role;

public class DoctorMapper {

    public static Doctor toEntity(DoctorDTO dto) {
        if (dto == null) return null;

        Doctor entity = new Doctor();

        entity.setId(dto.getId());
        entity.setNom(dto.getNom());
        entity.setEmail(dto.getEmail());
        entity.setActif(dto.isActif());
        entity.setPassword(dto.getPassword());

        if (dto.getRole() != null) {
            entity.setRole(Role.valueOf(dto.getRole().toUpperCase()));
        } else {
            entity.setRole(Role.DOCTOR);
        }

        entity.setMatricule(dto.getMatricule());
        entity.setTitre(dto.getTitre());
        entity.setTelephone(dto.getTelephone());
        entity.setPresentation(dto.getPresentation());
        entity.setExperience(dto.getExperience());
        entity.setFormation(dto.getFormation());

        return entity;
    }

    public static DoctorDTO toDTO(Doctor entity) {
        if (entity == null) {
            return null;
        }

        DoctorDTO dto = new DoctorDTO();

        dto.setId(entity.getId());
        dto.setNom(entity.getNom());
        dto.setEmail(entity.getEmail());
        dto.setActif(entity.isActif());
        dto.setActive(entity.isActif());
        dto.setRole(entity.getRole().toString());

        dto.setMatricule(entity.getMatricule());
        dto.setTitre(entity.getTitre());
        dto.setTelephone(entity.getTelephone());
        dto.setPresentation(entity.getPresentation());
        dto.setExperience(entity.getExperience());
        dto.setFormation(entity.getFormation());

        if (entity.getSpecialty() != null) {
            dto.setSpecialty(SpecialtyMapper.toDTO(entity.getSpecialty()));
        }

        return dto;
    }

}