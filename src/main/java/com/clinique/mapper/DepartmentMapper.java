package com.clinique.mapper;

import com.clinique.dto.DepartmentDTO;
import com.clinique.entity.Department;

public class DepartmentMapper {

    public static Department toEntity(DepartmentDTO dto) {
        if (dto == null) return null;

        Department entity = new Department();
        entity.setId(dto.getId());
        entity.setCode(dto.getCode());
        entity.setNom(dto.getNom());
        entity.setDescription(dto.getDescription());

        return entity;
    }

    public static DepartmentDTO toDTO(Department entity) {
        if (entity == null) return null;

        DepartmentDTO dto = new DepartmentDTO();
        dto.setId(entity.getId());
        dto.setCode(entity.getCode());
        dto.setNom(entity.getNom());
        dto.setDescription(entity.getDescription());

        return dto;
    }
}