package com.clinique.mapper;

import com.clinique.dto.SpecialtyDTO;
import com.clinique.entity.Specialty;

public class SpecialtyMapper {

    public static Specialty toEntity(SpecialtyDTO dto) {
        if (dto == null) return null;

        Specialty entity = new Specialty();
        entity.setId(dto.getId());
        entity.setCode(dto.getCode());
        entity.setNom(dto.getNom());
        entity.setDescription(dto.getDescription());

        return entity;
    }

    public static SpecialtyDTO toDTO(Specialty entity) {
        if (entity == null) return null;

        SpecialtyDTO dto = new SpecialtyDTO();
        dto.setId(entity.getId());
        dto.setCode(entity.getCode());
        dto.setNom(entity.getNom());
        dto.setDescription(entity.getDescription());

        if (entity.getDepartment() != null) {
            dto.setDepartment(DepartmentMapper.toDTO(entity.getDepartment()));
        }

        return dto;
    }
}