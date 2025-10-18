package com.clinique.mapper;

import com.clinique.dto.PatientDTO;
import com.clinique.entity.Patient;
import com.clinique.enums.Role;

public class PatientMapper {

    public static Patient toEntity(PatientDTO dto) {
        if (dto == null) return null;

        Patient patient = new Patient();
        patient.setId(dto.getId());
        patient.setNom(dto.getNom());
        if (dto.getRole() != null) {
            patient.setRole(Role.valueOf(dto.getRole().toUpperCase()));
        }
        patient.setActif(dto.isActif());
        patient.setEmail(dto.getEmail());
        patient.setPassword(dto.getPassword());

        patient.setCin(dto.getCin());
        patient.setSang(dto.getSang());
        patient.setSexe(dto.getSexe());
        patient.setAdresse(dto.getAdresse());
        patient.setTelephone(dto.getTelephone());
        patient.setNaissance(dto.getNaissance());

        return patient;
    }

    public static PatientDTO toDTO(Patient entity) {
        if (entity == null) return null;

        PatientDTO dto = new PatientDTO();
        dto.setId(entity.getId());
        dto.setNom(entity.getNom());
        if (entity.getRole() != null) {
            dto.setRole(entity.getRole().name());
        }
        dto.setActif(entity.isActif());
        dto.setEmail(entity.getEmail());

        dto.setCin(entity.getCin());
        dto.setSang(entity.getSang());
        dto.setSexe(entity.getSexe());
        dto.setAdresse(entity.getAdresse());
        dto.setTelephone(entity.getTelephone());
        dto.setNaissance(entity.getNaissance());

        return dto;
    }

}