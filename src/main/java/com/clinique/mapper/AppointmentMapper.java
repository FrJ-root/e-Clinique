package com.clinique.mapper;

import com.clinique.dto.AppointmentDTO;
import com.clinique.entity.Appointment;

public class AppointmentMapper {

    public static Appointment toEntity(AppointmentDTO dto) {
        if (dto == null) return null;

        Appointment entity = new Appointment();
        entity.setId(dto.getId());
        entity.setDate(dto.getDate());
        entity.setHeureDebut(dto.getHeureDebut());
        entity.setHeureFin(dto.getHeureFin());
        entity.setType(dto.getType());
        entity.setMotif(dto.getMotif());
        entity.setStatut(dto.getStatut());

        return entity;
    }

    public static AppointmentDTO toDTO(Appointment entity) {
        if (entity == null) return null;

        AppointmentDTO dto = new AppointmentDTO();
        dto.setId(entity.getId());
        dto.setDate(entity.getDate());
        dto.setHeureDebut(entity.getHeureDebut());
        dto.setHeureFin(entity.getHeureFin());
        dto.setType(entity.getType());
        dto.setMotif(entity.getMotif());
        dto.setStatut(entity.getStatut());

        if (entity.getPatient() != null) {
            dto.setPatientId(entity.getPatient().getId());
            dto.setPatientNom(entity.getPatient().getNom());
        }

        if (entity.getDoctor() != null) {
            dto.setDoctorId(entity.getDoctor().getId());
            dto.setDoctorNom(entity.getDoctor().getNom());
            if (entity.getDoctor().getSpecialty() != null) {
                dto.setDoctorSpecialty(entity.getDoctor().getSpecialty().getNom());
            }
        }

        dto.setHasMedicalNote(entity.getMedicalNote() != null);

        return dto;
    }
}