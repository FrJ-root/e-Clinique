package com.clinique.service;

import java.util.List;
import java.util.UUID;
import java.util.Optional;
import java.util.stream.Collectors;
import com.clinique.dto.SystemSettingDTO;
import com.clinique.entity.SystemSetting;
import com.clinique.mapper.SystemSettingMapper;
import com.clinique.repository.SystemSettingRepository;

public class SystemSettingService {

    private final SystemSettingRepository repository = new SystemSettingRepository();

    public SystemSettingDTO findById(UUID id) {
        Optional<SystemSetting> settingOpt = repository.findById(id);
        return settingOpt.map(SystemSettingMapper::toDTO).orElse(null);
    }

    public SystemSettingDTO findByKey(String key) {
        Optional<SystemSetting> settingOpt = repository.findByKey(key);
        return settingOpt.map(SystemSettingMapper::toDTO).orElse(null);
    }

    public List<SystemSettingDTO> findAll() {
        return repository.findAll()
                .stream()
                .map(SystemSettingMapper::toDTO)
                .collect(Collectors.toList());
    }

    public SystemSettingDTO createOrUpdate(SystemSettingDTO dto) {
        if (dto.getSettingKey() == null || dto.getSettingKey().trim().isEmpty()) {
            throw new IllegalArgumentException("Setting key is required");
        }
        if (dto.getSettingValue() == null) {
            throw new IllegalArgumentException("Setting value is required");
        }

        SystemSetting entity;
        Optional<SystemSetting> existingOpt =
                dto.getId() != null ? repository.findById(dto.getId()) : repository.findByKey(dto.getSettingKey());

        if (existingOpt.isPresent()) {
            entity = existingOpt.get();
            entity.setSettingValue(dto.getSettingValue());
            if (dto.getDescription() != null) {
                entity.setDescription(dto.getDescription());
            }
        } else {
            entity = new SystemSetting();
            entity.setSettingKey(dto.getSettingKey());
            entity.setSettingValue(dto.getSettingValue());
            entity.setDescription(dto.getDescription());
        }

        SystemSetting saved = repository.save(entity);
        return SystemSettingMapper.toDTO(saved);
    }

    public boolean delete(UUID id) {
        Optional<SystemSetting> settingOpt = repository.findById(id);
        if (settingOpt.isPresent()) {
            repository.delete(settingOpt.get());
            return true;
        }
        return false;
    }

    public String getValue(String key, String defaultValue) {
        SystemSettingDTO setting = findByKey(key);
        return setting != null ? setting.getSettingValue() : defaultValue;
    }

    public int getIntValue(String key, int defaultValue) {
        String value = getValue(key, String.valueOf(defaultValue));
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public boolean getBoolValue(String key, boolean defaultValue) {
        String value = getValue(key, String.valueOf(defaultValue));
        return Boolean.parseBoolean(value);
    }

}