package com.clinique.mapper;

import com.clinique.dto.SystemSettingDTO;
import com.clinique.entity.SystemSetting;

public class SystemSettingMapper {

    public static SystemSetting toEntity(SystemSettingDTO dto) {
        if (dto == null) return null;

        SystemSetting entity = new SystemSetting();
        entity.setId(dto.getId());
        entity.setSettingKey(dto.getSettingKey());
        entity.setSettingValue(dto.getSettingValue());
        entity.setDescription(dto.getDescription());

        return entity;
    }

    public static SystemSettingDTO toDTO(SystemSetting entity) {
        if (entity == null) return null;

        SystemSettingDTO dto = new SystemSettingDTO();
        dto.setId(entity.getId());
        dto.setSettingKey(entity.getSettingKey());
        dto.setSettingValue(entity.getSettingValue());
        dto.setDescription(entity.getDescription());

        return dto;
    }
}