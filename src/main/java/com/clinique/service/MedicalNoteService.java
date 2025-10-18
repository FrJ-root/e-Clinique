package com.clinique.service;

import com.clinique.dto.MedicalNoteDTO;
import com.clinique.entity.Appointment;
import com.clinique.entity.MedicalNote;
import com.clinique.mapper.MedicalNoteMapper;
import com.clinique.repository.AppointmentRepository;
import com.clinique.repository.MedicalNoteRepository;

import java.time.LocalDateTime;
import java.util.UUID;

public class MedicalNoteService {

    private final MedicalNoteRepository medicalNoteRepository;
    private final AppointmentRepository appointmentRepository;

    public MedicalNoteService() {
        this.medicalNoteRepository = new MedicalNoteRepository();
        this.appointmentRepository = new AppointmentRepository();
    }

    public MedicalNoteDTO saveOrUpdateMedicalNote(UUID appointmentId, String noteContent) {
        if (noteContent == null || noteContent.trim().isEmpty()) {
            throw new IllegalArgumentException("Le contenu de la note ne peut pas être vide");
        }

        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new IllegalArgumentException("Rendez-vous non trouvé"));

        // Get existing note or create new one
        MedicalNote medicalNote = appointment.getMedicalNote();
        boolean isNew = false;

        if (medicalNote == null) {
            medicalNote = new MedicalNote();
            medicalNote.setAppointment(appointment);
            medicalNote.setCreatedAt(LocalDateTime.now());
            isNew = true;
        }

        // Update content and timestamp
        medicalNote.setNote(noteContent);
        medicalNote.setUpdatedAt(LocalDateTime.now());

        // Save the medical note
        MedicalNote savedNote = medicalNoteRepository.save(medicalNote);

        // If this is a new note, update the appointment relationship
        if (isNew) {
            appointment.setMedicalNote(savedNote);
            appointmentRepository.save(appointment);
        }

        return MedicalNoteMapper.toDTO(savedNote);
    }

    public MedicalNoteDTO getMedicalNote(UUID appointmentId) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new IllegalArgumentException("Rendez-vous non trouvé"));

        MedicalNote medicalNote = appointment.getMedicalNote();
        if (medicalNote == null) {
            return null;
        }

        return MedicalNoteMapper.toDTO(medicalNote);
    }

    public void deleteMedicalNote(UUID appointmentId) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new IllegalArgumentException("Rendez-vous non trouvé"));

        MedicalNote medicalNote = appointment.getMedicalNote();
        if (medicalNote != null) {
            appointment.setMedicalNote(null);
            appointmentRepository.save(appointment);
            medicalNoteRepository.delete(medicalNote);
        }
    }
}