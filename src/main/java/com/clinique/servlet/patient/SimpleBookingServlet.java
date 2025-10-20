package com.clinique.servlet.patient;

import com.clinique.dto.DepartmentDTO;
import com.clinique.dto.DoctorDTO;
import com.clinique.dto.PatientDTO;
import com.clinique.dto.SpecialtyDTO;
import com.clinique.dto.TimeSlotDTO;
import com.clinique.service.AppointmentService;
import com.clinique.service.AvailabilityService;
import com.clinique.service.DepartmentService;
import com.clinique.service.DoctorService;
import com.clinique.service.SpecialtyService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "SimpleBookingServlet", urlPatterns = {"/patient/simple-booking"})
public class SimpleBookingServlet extends HttpServlet {

    private DepartmentService departmentService;
    private SpecialtyService specialtyService;
    private DoctorService doctorService;
    private AvailabilityService availabilityService;
    private AppointmentService appointmentService;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.departmentService = new DepartmentService();
            this.specialtyService = new SpecialtyService();
            this.doctorService = new DoctorService();
            this.availabilityService = new AvailabilityService();
            this.appointmentService = new AppointmentService();
            System.out.println("✓ SimpleBookingServlet services initialized");
        } catch (Exception e) {
            System.err.println("✗ FATAL: Failed to initialize services");
            e.printStackTrace();
            throw new ServletException("Service initialization failed", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("\n==========================================");
        System.out.println("SimpleBookingServlet.doGet() - START");
        System.out.println("==========================================");

        // Check session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("No session, redirecting to login");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Object userObj = session.getAttribute("user");
        if (!(userObj instanceof PatientDTO)) {
            System.out.println("Not a patient user");
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès réservé aux patients");
            return;
        }

        PatientDTO patient = (PatientDTO) userObj;
        System.out.println("Patient: " + patient.getNom());

        // Get parameters
        String departmentIdStr = req.getParameter("departmentId");
        String specialtyIdStr = req.getParameter("specialtyId");
        String doctorIdStr = req.getParameter("doctorId");
        String dateStr = req.getParameter("date");

        System.out.println("Parameters:");
        System.out.println("  departmentId: " + departmentIdStr);
        System.out.println("  specialtyId: " + specialtyIdStr);
        System.out.println("  doctorId: " + doctorIdStr);
        System.out.println("  date: " + dateStr);

        try {
            // STEP 1: Load departments
            List<DepartmentDTO> departments = new ArrayList<>();
            try {
                departments = departmentService.getDepartmentsWithDoctors();
                System.out.println("✓ Loaded " + departments.size() + " departments");
            } catch (Exception e) {
                System.err.println("✗ Error loading departments:");
                e.printStackTrace();
            }
            req.setAttribute("departments", departments);

            // STEP 2: Load specialties
            if (departmentIdStr != null && !departmentIdStr.isEmpty()) {
                try {
                    UUID departmentId = UUID.fromString(departmentIdStr);
                    List<SpecialtyDTO> specialties = specialtyService.getSpecialtiesByDepartment(departmentId);
                    req.setAttribute("specialties", specialties);
                    req.setAttribute("selectedDepartmentId", departmentIdStr);
                    System.out.println("✓ Loaded " + specialties.size() + " specialties");
                } catch (Exception e) {
                    System.err.println("✗ Error loading specialties:");
                    e.printStackTrace();
                }
            }

            // STEP 3: Load doctors
            if (specialtyIdStr != null && !specialtyIdStr.isEmpty()) {
                try {
                    UUID specialtyId = UUID.fromString(specialtyIdStr);
                    List<DoctorDTO> doctors = doctorService.findBySpecialty(specialtyId);
                    req.setAttribute("doctors", doctors);
                    req.setAttribute("selectedSpecialtyId", specialtyIdStr);
                    System.out.println("✓ Loaded " + doctors.size() + " doctors");
                } catch (Exception e) {
                    System.err.println("✗ Error loading doctors:");
                    e.printStackTrace();
                }
            }

            // STEP 4: Load doctor and dates
            if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
                System.out.println("\n>>> LOADING DOCTOR AND DATES <<<");

                DoctorDTO doctor = null;
                List<LocalDate> availableDates = new ArrayList<>();

                try {
                    UUID doctorId = UUID.fromString(doctorIdStr);
                    System.out.println("Doctor UUID: " + doctorId);

                    // Load doctor
                    try {
                        doctor = doctorService.findById(doctorId);
                        if (doctor != null) {
                            System.out.println("✓ Doctor found: " + doctor.getNom());
                            req.setAttribute("selectedDoctor", doctor);
                            req.setAttribute("selectedDoctorId", doctorIdStr);
                        } else {
                            System.err.println("✗ Doctor is NULL");
                            req.setAttribute("error", "Médecin non trouvé");
                        }
                    } catch (Exception e) {
                        System.err.println("✗ Exception finding doctor:");
                        e.printStackTrace();
                        req.setAttribute("error", "Erreur: " + e.getMessage());
                    }

                    // Load dates
                    if (doctor != null) {
                        try {
                            System.out.println("Generating available dates...");
                            availableDates = availabilityService.generateAvailableDates(doctorId, 30);
                            System.out.println("✓ Generated " + availableDates.size() + " dates");

                            if (availableDates.isEmpty()) {
                                // Generate some default dates if none exist
                                System.out.println("⚠ No dates from service, generating defaults");
                                LocalDate today = LocalDate.now();
                                for (int i = 1; i <= 14; i++) {
                                    LocalDate date = today.plusDays(i);
                                    // Skip weekends
                                    if (date.getDayOfWeek().getValue() < 6) {
                                        availableDates.add(date);
                                    }
                                }
                                System.out.println("✓ Generated " + availableDates.size() + " default dates");
                            }

                            req.setAttribute("availableDates", availableDates);
                            System.out.println("✓ Set availableDates attribute");

                        } catch (Exception e) {
                            System.err.println("✗ Exception generating dates:");
                            e.printStackTrace();
                            req.setAttribute("error", "Erreur dates: " + e.getMessage());
                        }
                    }

                } catch (Exception e) {
                    System.err.println("✗ Exception in doctor section:");
                    e.printStackTrace();
                    req.setAttribute("error", "Erreur: " + e.getMessage());
                }

                System.out.println(">>> END LOADING DOCTOR AND DATES <<<\n");
            }

            // STEP 5: Load time slots
            if (dateStr != null && !dateStr.isEmpty() && doctorIdStr != null) {
                System.out.println("\n>>> LOADING TIME SLOTS <<<");

                try {
                    UUID doctorId = UUID.fromString(doctorIdStr);
                    LocalDate date = LocalDate.parse(dateStr);

                    List<TimeSlotDTO> timeSlots = availabilityService.getAvailableTimeSlotsForBooking(doctorId, date);
                    req.setAttribute("timeSlots", timeSlots);
                    req.setAttribute("selectedDate", dateStr);

                    System.out.println("✓ Loaded " + timeSlots.size() + " time slots");

                } catch (Exception e) {
                    System.err.println("✗ Error loading time slots:");
                    e.printStackTrace();
                    req.setAttribute("error", "Erreur créneaux: " + e.getMessage());
                }

                System.out.println(">>> END LOADING TIME SLOTS <<<\n");
            }

            System.out.println("==========================================");
            System.out.println("SimpleBookingServlet.doGet() - END");
            System.out.println("Forwarding to JSP...");
            System.out.println("==========================================\n");

            req.getRequestDispatcher("/WEB-INF/views/patient/simple-booking.jsp").forward(req, resp);

        } catch (Exception e) {
            System.err.println("✗ FATAL ERROR in doGet:");
            e.printStackTrace();

            // Send error page
            resp.setContentType("text/html;charset=UTF-8");
            PrintWriter out = resp.getWriter();
            out.println("<html><body>");
            out.println("<h1>Erreur</h1>");
            out.println("<p>Une erreur est survenue: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
            out.println("<a href='" + req.getContextPath() + "/patient/dashboard'>Retour au tableau de bord</a>");
            out.println("</body></html>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("\n=== SimpleBookingServlet.doPost() ===");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Object userObj = session.getAttribute("user");
        if (!(userObj instanceof PatientDTO)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        PatientDTO patient = (PatientDTO) userObj;

        try {
            String doctorIdStr = req.getParameter("doctorId");
            String dateStr = req.getParameter("date");
            String startTimeStr = req.getParameter("startTime");
            String endTimeStr = req.getParameter("endTime");
            String motif = req.getParameter("motif");

            if (doctorIdStr == null || dateStr == null || startTimeStr == null ||
                    endTimeStr == null || motif == null || motif.trim().isEmpty()) {
                req.setAttribute("error", "Tous les champs sont requis");
                doGet(req, resp);
                return;
            }

            UUID doctorId = UUID.fromString(doctorIdStr);
            LocalDate date = LocalDate.parse(dateStr);
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalTime endTime = LocalTime.parse(endTimeStr);

            appointmentService.bookAppointment(patient.getId(), doctorId, date, startTime, endTime, motif);

            System.out.println("✓ Appointment booked!");
            session.setAttribute("successMessage", "Rendez-vous réservé avec succès!");
            resp.sendRedirect(req.getContextPath() + "/patient/appointments");

        } catch (IllegalArgumentException e) {
            // Handle validation errors (including duplicate appointment check)
            System.err.println("✗ Validation error: " + e.getMessage());
            req.setAttribute("error", e.getMessage());

            // Preserve the form data so user can try a different doctor/date
            req.setAttribute("selectedDoctorId", req.getParameter("doctorId"));
            req.setAttribute("selectedDate", req.getParameter("date"));

            doGet(req, resp);

        } catch (Exception e) {
            System.err.println("✗ Error booking:");
            e.printStackTrace();
            req.setAttribute("error", "Une erreur est survenue lors de la réservation. Veuillez réessayer.");
            doGet(req, resp);
        }
    }
}