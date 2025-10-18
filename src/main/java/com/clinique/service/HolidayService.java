package com.clinique.service;

import com.clinique.dto.HolidayDTO;
import com.clinique.entity.Holiday;
import com.clinique.mapper.HolidayMapper;
import com.clinique.repository.HolidayRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

public class HolidayService {

    private final HolidayRepository repository = new HolidayRepository();

    public HolidayDTO findById(UUID id) {
        Optional<Holiday> holidayOpt = repository.findById(id);
        return holidayOpt.map(HolidayMapper::toDTO).orElse(null);
    }

    public List<HolidayDTO> findAll() {
        return repository.findAll()
                .stream()
                .map(HolidayMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<HolidayDTO> findFutureHolidays() {
        return repository.findFutureHolidays()
                .stream()
                .map(HolidayMapper::toDTO)
                .collect(Collectors.toList());
    }

    public HolidayDTO create(HolidayDTO dto) {
        validateHoliday(dto);

        Holiday entity = HolidayMapper.toEntity(dto);
        Holiday saved = repository.save(entity);
        return HolidayMapper.toDTO(saved);
    }

    public HolidayDTO update(HolidayDTO dto) {
        if (dto.getId() == null) {
            throw new IllegalArgumentException("Holiday ID is required for update");
        }

        validateHoliday(dto);

        Optional<Holiday> holidayOpt = repository.findById(dto.getId());
        if (holidayOpt.isEmpty()) {
            throw new IllegalArgumentException("Holiday not found");
        }

        Holiday entity = holidayOpt.get();
        entity.setDate(dto.getDate());
        entity.setDescription(dto.getDescription());
        entity.setRecurring(dto.isRecurring());

        Holiday updated = repository.save(entity);
        return HolidayMapper.toDTO(updated);
    }

    public boolean delete(UUID id) {
        Optional<Holiday> holidayOpt = repository.findById(id);
        if (holidayOpt.isPresent()) {
            repository.delete(holidayOpt.get());
            return true;
        }
        return false;
    }

    public boolean isHoliday(LocalDate date) {
        List<Holiday> holidays = repository.findAll();

        for (Holiday holiday : holidays) {
            if (holiday.getDate().equals(date)) {
                return true;
            }

            if (holiday.isRecurring() &&
                    holiday.getDate().getMonth() == date.getMonth() &&
                    holiday.getDate().getDayOfMonth() == date.getDayOfMonth()) {
                return true;
            }
        }

        return false;
    }

    private void validateHoliday(HolidayDTO dto) {
        if (dto.getDate() == null) {
            throw new IllegalArgumentException("Holiday date is required");
        }

        if (dto.getDescription() == null || dto.getDescription().trim().isEmpty()) {
            throw new IllegalArgumentException("Holiday description is required");
        }
    }

}