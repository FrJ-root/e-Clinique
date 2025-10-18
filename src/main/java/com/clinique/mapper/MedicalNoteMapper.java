package com.clinique.mapper;

import com.clinique.dto.MedicalNoteDTO;
import com.clinique.entity.MedicalNote;

public class MedicalNoteMapper {

    public static MedicalNoteDTO toDTO(MedicalNote entity) {
        if (entity == null) {
            return null;
        }

        MedicalNoteDTO dto = new MedicalNoteDTO();
        dto.setId(entity.getId());
        if (entity.getAppointment() != null) {
            dto.setAppointmentId(entity.getAppointment().getId());
        }
        dto.setNote(entity.getNote());
        dto.setCreatedAt(entity.getCreatedAt());
        dto.setUpdatedAt(entity.getUpdatedAt());

        return dto;
    }

    public static MedicalNote toEntity(MedicalNoteDTO dto) {
        if (dto == null) {
            return null;
        }

        MedicalNote entity = new MedicalNote();
        entity.setId(dto.getId());
        entity.setNote(dto.getNote());
        entity.setCreatedAt(dto.getCreatedAt());
        entity.setUpdatedAt(dto.getUpdatedAt());

        return entity;
    }
}