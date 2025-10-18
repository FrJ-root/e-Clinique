package com.clinique.mapper;

import com.clinique.dto.AvailabilityDTO;
import com.clinique.entity.Availability;
import com.clinique.enums.AvailabilityType;

public class AvailabilityMapper {

    public static AvailabilityDTO toDTO(Availability entity) {
        if (entity == null) {
            return null;
        }

        AvailabilityDTO dto = new AvailabilityDTO();
        dto.setId(entity.getId());
        dto.setDate(entity.getJour());
        dto.setDayOfWeek(entity.getJourSemaine());
        dto.setStartTime(entity.getHeureDebut());
        dto.setEndTime(entity.getHeureFin());
        dto.setStatus(entity.getStatut());
        dto.setReason(entity.getRaison());

        dto.setType(entity.getType());

        if (entity.getDoctor() != null) {
            dto.setDoctorId(entity.getDoctor().getId());
        }

        return dto;
    }

    public static Availability toEntity(AvailabilityDTO dto) {
        if (dto == null) {
            return null;
        }

        Availability entity = new Availability();
        entity.setId(dto.getId());
        entity.setJour(dto.getDate());
        entity.setJourSemaine(dto.getDayOfWeek());
        entity.setHeureDebut(dto.getStartTime());
        entity.setHeureFin(dto.getEndTime());
        entity.setStatut(dto.getStatus());
        entity.setRaison(dto.getReason());

        if (dto.getType() != null) {
            entity.setType(dto.getType());
        } else if (dto instanceof AvailabilityDTO) {
            String typeString = ((AvailabilityDTO)dto).getType().toString();
            try {
                entity.setType(AvailabilityType.valueOf(typeString));
            } catch (IllegalArgumentException e) {
                entity.setType(AvailabilityType.REGULAR);
            }
        }

        return entity;
    }

}