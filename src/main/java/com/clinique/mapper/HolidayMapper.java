package com.clinique.mapper;

import com.clinique.dto.HolidayDTO;
import com.clinique.entity.Holiday;

public class HolidayMapper {

    public static Holiday toEntity(HolidayDTO dto) {
        if (dto == null) return null;

        Holiday entity = new Holiday();
        entity.setId(dto.getId());
        entity.setDate(dto.getDate());
        entity.setDescription(dto.getDescription());
        entity.setRecurring(dto.isRecurring());

        return entity;
    }

    public static HolidayDTO toDTO(Holiday entity) {
        if (entity == null) return null;

        HolidayDTO dto = new HolidayDTO();
        dto.setId(entity.getId());
        dto.setDate(entity.getDate());
        dto.setDescription(entity.getDescription());
        dto.setRecurring(entity.isRecurring());

        return dto;
    }
}