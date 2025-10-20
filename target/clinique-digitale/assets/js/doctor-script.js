/**
 * e-Clinique Doctor Dashboard JavaScript
 */

 document.addEventListener('DOMContentLoaded', function() {
             // Only run this code if we're on the daily view and have appointments
             const dailyScheduleContent = document.getElementById('dailyScheduleContent');

             if (dailyScheduleContent) {
                 // Render appointments on the daily schedule
                 const appointments = [
                     <c:forEach var="appointment" items="${appointments}" varStatus="status">
                     {
                         id: "${appointment.id}",
                         patientName: "${appointment.patientName}",
                         type: "${appointment.appointmentType}",
                         status: "${appointment.status}",
                         start: {
                             hour: ${appointment.startDateTime.hour},
                             minute: ${appointment.startDateTime.minute}
                         },
                         end: {
                             hour: ${appointment.startDateTime.plusMinutes(30).hour},
                             minute: ${appointment.startDateTime.plusMinutes(30).minute}
                         }
                     }<c:if test="${!status.last}">,</c:if>
                     </c:forEach>
                 ];

                 // Calculate the height of the schedule content
                 const contentHeight = dailyScheduleContent.offsetHeight;
                 // There are 10 hours displayed (8:00 - 18:00)
                 const hourHeight = contentHeight / 10;

                 appointments.forEach(appointment => {
                     // Calculate position and height
                     const startHour = appointment.start.hour - 8; // 8:00 is the start time
                     const startMinute = appointment.start.minute;
                     const endHour = appointment.end.hour - 8;
                     const endMinute = appointment.end.minute;

                     const startPosition = (startHour + startMinute/60) * hourHeight;
                     const endPosition = (endHour + endMinute/60) * hourHeight;
                     const appointmentHeight = endPosition - startPosition;

                     // Create appointment element
                     const appointmentEl = document.createElement('div');
                     appointmentEl.classList.add('appointment');

                     // Set class based on status
                     const statusClass = appointment.status.toLowerCase();
                     appointmentEl.classList.add(statusClass === 'scheduled' ? 'confirmed' : statusClass);

                     // Set position and height
                     appointmentEl.style.top = `${startPosition}px`;
                     appointmentEl.style.height = `${appointmentHeight}px`;

                     // Add content
                     appointmentEl.innerHTML = `
                         <div class="appointment-time">${appointment.start.hour}:${appointment.start.minute.toString().padStart(2, '0')} -
                                                ${appointment.end.hour}:${appointment.end.minute.toString().padStart(2, '0')}</div>
                         <div class="appointment-patient">${appointment.patientName}</div>
                         <div class="appointment-type">${appointment.type}</div>
                     `;

                     // Add to schedule
                     dailyScheduleContent.appendChild(appointmentEl);
                 });
             }
         });

 // Fix absence form handling
document.addEventListener('DOMContentLoaded', function() {
    // Initialize all Bootstrap modals
    var modals = [].slice.call(document.querySelectorAll('.modal'));
    modals.forEach(function(modalElement) {
        var modal = new bootstrap.Modal(modalElement);

        // Debug code to verify modal is initialized
        console.log("Modal initialized: " + modalElement.id);

        // Add click listener for the corresponding trigger button
        const triggerId = modalElement.id;
        const triggerButton = document.querySelector(`[data-bs-target="#${triggerId}"]`);

        if (triggerButton) {
            console.log(`Found trigger button for ${triggerId}`);

            // For debugging, add an explicit click handler
            triggerButton.addEventListener('click', function(e) {
                console.log(`Clicked button for ${triggerId}`);
                modal.show();
            });
        }
    });

    // Rest of your existing DOMContentLoaded code...

    // Handle full day absence checkbox
    const fullDayCheckbox = document.getElementById('fullDayAbsence');
    const absenceTimeSection = document.getElementById('absenceTimeSection');

    if (fullDayCheckbox && absenceTimeSection) {
        // Log for debugging
        console.log("Found full day checkbox and time section");

        // Initialize the display state
        absenceTimeSection.style.display = fullDayCheckbox.checked ? 'none' : 'flex';

        fullDayCheckbox.addEventListener('change', function() {
            console.log("Full day checkbox changed: " + this.checked);
            absenceTimeSection.style.display = this.checked ? 'none' : 'flex';

            // Toggle required attributes on time inputs
            const startTimeInput = document.getElementById('absenceStartTime');
            const endTimeInput = document.getElementById('absenceEndTime');

            if (this.checked) {
                startTimeInput.removeAttribute('required');
                endTimeInput.removeAttribute('required');
            } else {
                startTimeInput.setAttribute('required', 'required');
                endTimeInput.setAttribute('required', 'required');
            }
        });
    } else {
        console.warn("Could not find full day checkbox or time section elements");
    }
});

// Add a direct handler for the absence button
document.addEventListener('DOMContentLoaded', function() {
    const absenceButton = document.querySelector('button[data-bs-target="#addAbsenceModal"]');
    if (absenceButton) {
        absenceButton.onclick = function() {
            const absenceModal = new bootstrap.Modal(document.getElementById('addAbsenceModal'));
            absenceModal.show();
            console.log("Absence button clicked, showing modal");
        };
    } else {
        console.error("Absence button not found!");
    }
});



document.addEventListener('DOMContentLoaded', function() {

    document.getElementById('exceptionalAvailabilityForm').addEventListener('submit', function(e) {
        const startTime = document.getElementById('exceptionalStartTime').value;
        const endTime = document.getElementById('exceptionalEndTime').value;

        if (!startTime || !endTime) {
            e.preventDefault();
            alert('Les heures de début et de fin sont obligatoires.');
            return;
        }

        if (endTime <= startTime) {
            e.preventDefault();
            alert("L'heure de fin doit être après l'heure de début.");
            return;
        }
    });
    initializeSidebar();
    initializeThemeToggle();
    initializeAlerts();
    initializeFormValidation();
    initializeDateTimePickers();

    // Initialize any page-specific handlers
    if (document.getElementById('availabilityForm')) initializeAvailabilityPage();
    if (document.getElementById('appointmentsList')) initializeAppointmentsPage();
});

/**
 * Initialize sidebar functionality
 */
function initializeSidebar() {
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('mainContent');
    const topbar = document.getElementById('topbar');
    const toggleSidebarBtn = document.getElementById('toggleSidebar');
    const mobileOverlay = document.getElementById('mobileOverlay');

    if (!sidebar || !mainContent || !topbar || !toggleSidebarBtn || !mobileOverlay) return;

    // Function to toggle sidebar state
    function toggleSidebar() {
        const isDesktop = window.innerWidth >= 992;
        if (isDesktop) {
            sidebar.classList.toggle('collapsed');
            mainContent.classList.toggle('expanded');
            topbar.classList.toggle('expanded');

            // Save sidebar state in localStorage
            localStorage.setItem('sidebarCollapsed', sidebar.classList.contains('collapsed'));
        } else {
            sidebar.classList.toggle('mobile-visible');
            mobileOverlay.classList.toggle('active');
        }
    }

    // Initialize sidebar state from localStorage
    const savedState = localStorage.getItem('sidebarCollapsed');
    if (savedState === 'true') {
        sidebar.classList.add('collapsed');
        mainContent.classList.add('expanded');
        topbar.classList.add('expanded');
    }

    // Add event listeners
    toggleSidebarBtn.addEventListener('click', toggleSidebar);

    mobileOverlay.addEventListener('click', function() {
        sidebar.classList.remove('mobile-visible');
        mobileOverlay.classList.remove('active');
    });

    // Adjust on window resize
    window.addEventListener('resize', function() {
        const isDesktop = window.innerWidth >= 992;
        if (isDesktop) {
            sidebar.classList.remove('mobile-visible');
            mobileOverlay.classList.remove('active');
        }
    });
}

/**
 * Initialize theme toggle functionality
 */
function initializeThemeToggle() {
    const themeToggle = document.getElementById('themeToggle');
    const themeIcon = document.getElementById('themeIcon');
    const htmlElement = document.documentElement;

    if (!themeToggle || !themeIcon) return;

    // Get saved theme from localStorage or default to light
    const currentTheme = localStorage.getItem('theme') || 'light';
    htmlElement.setAttribute('data-theme', currentTheme);
    updateThemeIcon(currentTheme);

    // Toggle theme on click
    themeToggle.addEventListener('click', function() {
        let theme = htmlElement.getAttribute('data-theme');
        let newTheme = theme === 'light' ? 'dark' : 'light';

        htmlElement.setAttribute('data-theme', newTheme);
        localStorage.setItem('theme', newTheme);
        updateThemeIcon(newTheme);
    });

    // Update icon based on current theme
    function updateThemeIcon(theme) {
        if (theme === 'dark') {
            themeIcon.classList.remove('fa-moon');
            themeIcon.classList.add('fa-sun');
        } else {
            themeIcon.classList.remove('fa-sun');
            themeIcon.classList.add('fa-moon');
        }
    }
}

/**
 * Initialize automatic alert dismissal
 */
function initializeAlerts() {
    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
        alerts.forEach(alert => {
            alert.style.transition = 'opacity 0.5s ease';
            alert.style.opacity = '0';
            setTimeout(() => {
                if (alert.parentNode) {
                    alert.parentNode.removeChild(alert);
                }
            }, 500);
        });
    }, 5000);
}

/**
 * Initialize form validation for all forms
 */
function initializeFormValidation() {
    // Handle time range validations
    document.querySelectorAll('form').forEach(form => {
        const startTimeInput = form.querySelector('input[name="startTime"]');
        const endTimeInput = form.querySelector('input[name="endTime"]');

        if (startTimeInput && endTimeInput) {
            form.addEventListener('submit', function(e) {
                if (startTimeInput.value && endTimeInput.value) {
                    if (endTimeInput.value <= startTimeInput.value) {
                        e.preventDefault();
                        alert("L'heure de fin doit être après l'heure de début.");
                    }
                }
            });
        }
    });

    // Handle required fields with custom validation messages
    document.querySelectorAll('[data-required-message]').forEach(input => {
        input.addEventListener('invalid', function(e) {
            e.preventDefault();
            const message = this.dataset.requiredMessage || 'Ce champ est requis';
            this.setCustomValidity(message);
        });

        input.addEventListener('input', function() {
            this.setCustomValidity('');
        });
    });
}

/**
 * Initialize date and time pickers
 */
function initializeDateTimePickers() {
    // If flatpickr is loaded, initialize date pickers
    if (typeof flatpickr === 'function') {
        flatpickr("input[type=date]", {
            locale: "fr",
            dateFormat: "Y-m-d",
            minDate: "today"
        });

        flatpickr("input[type=time]", {
            enableTime: true,
            noCalendar: true,
            dateFormat: "H:i",
            time_24hr: true
        });
    }
}

/**
 * Initialize availability page specific functionality
 */
function initializeAvailabilityPage() {
    // Handle full day absence toggle
    const fullDayCheckbox = document.getElementById('fullDayAbsence');
    const absenceTimeSection = document.getElementById('absenceTimeSection');

    if (fullDayCheckbox && absenceTimeSection) {
        fullDayCheckbox.addEventListener('change', function() {
            if (this.checked) {
                absenceTimeSection.style.display = 'none';
                document.getElementById('absenceStartTime').removeAttribute('required');
                document.getElementById('absenceEndTime').removeAttribute('required');
            } else {
                absenceTimeSection.style.display = 'flex';
                document.getElementById('absenceStartTime').setAttribute('required', 'required');
                document.getElementById('absenceEndTime').setAttribute('required', 'required');
            }
        });
    }

    // Handle delete buttons
    const deleteButtons = document.querySelectorAll('.delete-availability');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function() {
            const availabilityId = this.getAttribute('data-id');
            document.getElementById('deleteAvailabilityId').value = availabilityId;

            const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmationModal'));
            deleteModal.show();
        });
    });
}

/**
 * Initialize appointments page specific functionality
 */
function initializeAppointmentsPage() {
    // Handle appointment status changes
    document.querySelectorAll('.change-status').forEach(button => {
        button.addEventListener('click', function() {
            const appointmentId = this.getAttribute('data-id');
            const status = this.getAttribute('data-status');

            document.getElementById('statusAppointmentId').value = appointmentId;
            document.getElementById('appointmentStatus').value = status;

            if (status === 'CANCELED') {
                const confirmModal = new bootstrap.Modal(document.getElementById('cancelConfirmationModal'));
                confirmModal.show();
            } else {
                document.getElementById('changeStatusForm').submit();
            }
        });
    });

    // Handle appointment notes
    document.querySelectorAll('.add-notes').forEach(button => {
        button.addEventListener('click', function() {
            const appointmentId = this.getAttribute('data-id');
            const patientName = this.getAttribute('data-patient');

            document.getElementById('notesAppointmentId').value = appointmentId;
            document.getElementById('notesModalTitle').textContent = 'Notes - ' + patientName;

            const notesModal = new bootstrap.Modal(document.getElementById('appointmentNotesModal'));
            notesModal.show();
        });
    });
}

/**
 * Format date to locale string
 * @param {string} dateStr - Date string in ISO format
 * @returns {string} Formatted date string
 */
function formatDate(dateStr) {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    return date.toLocaleDateString('fr-FR', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
    });
}

/**
 * Format time to locale string
 * @param {string} timeStr - Time string in HH:MM format
 * @returns {string} Formatted time string
 */
function formatTime(timeStr) {
    if (!timeStr) return '';
    return timeStr;
}

/**
 * Show a toast notification
 * @param {string} message - Message to display
 * @param {string} type - Type of toast (success, error, warning, info)
 */
function showToast(message, type = 'info') {
    // Check if a toast container exists, create one if not
    let toastContainer = document.querySelector('.toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
        document.body.appendChild(toastContainer);
    }

    // Create toast element
    const toastId = 'toast-' + Date.now();
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.id = toastId;
    toast.setAttribute('role', 'alert');
    toast.setAttribute('aria-live', 'assertive');
    toast.setAttribute('aria-atomic', 'true');

    // Toast content
    toast.innerHTML = `
        <div class="toast-header">
            <strong class="me-auto">${type.charAt(0).toUpperCase() + type.slice(1)}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body">
            ${message}
        </div>
    `;

    // Add toast to container
    toastContainer.appendChild(toast);

    // Initialize and show toast
    const toastInstance = new bootstrap.Toast(toast, {
        autohide: true,
        delay: 5000
    });
    toastInstance.show();

    // Remove toast after it's hidden
    toast.addEventListener('hidden.bs.toast', function() {
        if (toast.parentNode) {
            toast.parentNode.removeChild(toast);
        }
    });
}


//APPOINTMENT

document.addEventListener('DOMContentLoaded', function() {
            // Initialize date range picker
            flatpickr("#dateRange", {
                locale: "fr",
                mode: "range",
                dateFormat: "d/m/Y",
                maxDate: "today",
                defaultDate: [
                    "${startDate}",
                    "${endDate}"
                ]
            });

            // Handle date range filter button
            document.getElementById('dateRangeFilterBtn').addEventListener('click', function() {
                const form = document.getElementById('dateRangeFilterForm');
                form.style.display = form.style.display === 'none' ? 'block' : 'none';
            });

            // Handle complete appointment buttons
            document.querySelectorAll('.complete-appointment').forEach(button => {
                button.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    const patient = this.getAttribute('data-patient');

                    document.getElementById('completeAppointmentId').value = id;
                    document.querySelectorAll('#completeAppointmentModal .patient-name').forEach(el => {
                        el.textContent = patient;
                    });

                    const modal = new bootstrap.Modal(document.getElementById('completeAppointmentModal'));
                    modal.show();
                });
            });

            // Handle confirm complete button
            document.getElementById('confirmCompleteBtn').addEventListener('click', function() {
                const note = document.getElementById('appointmentNote').value;
                document.getElementById('completeAppointmentNote').value = note;
                document.getElementById('completeAppointmentForm').submit();
            });

            // Handle cancel appointment buttons
            document.querySelectorAll('.cancel-appointment').forEach(button => {
                button.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    const patient = this.getAttribute('data-patient');

                    document.getElementById('cancelAppointmentId').value = id;
                    document.querySelectorAll('#cancelAppointmentModal .patient-name').forEach(el => {
                        el.textContent = patient;
                    });

                    const modal = new bootstrap.Modal(document.getElementById('cancelAppointmentModal'));
                    modal.show();
                });
            });

            // Handle confirm cancel button
            document.getElementById('confirmCancelBtn').addEventListener('click', function() {
                document.getElementById('cancelAppointmentForm').submit();
            });

            // Handle view appointment details
            document.querySelectorAll('.view-appointment').forEach(button => {
                button.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    showAppointmentDetails(id);
                });
            });

            // Also allow clicking on the entire row to view details
            document.querySelectorAll('.appointment-row').forEach(row => {
                row.addEventListener('click', function(e) {
                    // Only trigger if not clicking on a button
                    if (!e.target.closest('button')) {
                        const id = this.getAttribute('data-id');
                        showAppointmentDetails(id);
                    }
                });
            });

            // Function to show appointment details
            function showAppointmentDetails(id) {
                // Reset and show modal
                document.getElementById('appointmentLoading').style.display = 'block';
                document.getElementById('appointmentDetails').style.display = 'none';
                document.getElementById('appointmentError').style.display = 'none';
                document.getElementById('medicalNoteSection').style.display = 'none';

                const modal = new bootstrap.Modal(document.getElementById('viewAppointmentModal'));
                modal.show();

                // Fetch appointment details
                fetch(`${pageContext.request.contextPath}/doctor/appointments/details?appointmentId=${id}`)
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('appointmentLoading').style.display = 'none';

                        if (data.success) {
                            const appointment = data.appointment;

                            // Format date
                            const date = new Date(appointment.date);
                            const formattedDate = date.toLocaleDateString('fr-FR', {
                                day: '2-digit',
                                month: '2-digit',
                                year: 'numeric'
                            });

                            // Populate details
                            document.getElementById('appointmentDate').textContent = formattedDate;
                            document.getElementById('appointmentTime').textContent =
                                `${appointment.heureDebut} - ${appointment.heureFin}`;
                            document.getElementById('appointmentType').textContent =
                                appointment.type || 'Non spécifié';
                            document.getElementById('appointmentReason').textContent =
                                appointment.motif || 'Non spécifié';

                            // Set status with appropriate styling
                            const statusEl = document.getElementById('appointmentStatus');
                            let statusText, statusClass;

                            switch(appointment.statut) {
                                case 'PLANNED':
                                    statusText = 'Prévu';
                                    statusClass = 'planned';
                                    break;
                                case 'DONE':
                                    statusText = 'Terminé';
                                    statusClass = 'done';
                                    break;
                                case 'CANCELED':
                                    statusText = 'Annulé';
                                    statusClass = 'canceled';
                                    break;
                                default:
                                    statusText = appointment.statut;
                                    statusClass = '';
                            }

                            statusEl.textContent = statusText;
                            statusEl.className = '';
                            statusEl.classList.add('appointment-status', statusClass);

                            // Set patient info
                            document.getElementById('patientName').textContent = appointment.patientNom;
                            document.getElementById('viewPatientBtn').setAttribute(
                                'onclick',
                                `window.location.href='${pageContext.request.contextPath}/doctor/patients/view?id=${appointment.patientId}'`
                            );

                            // Set action buttons based on status
                            const actionsDiv = document.getElementById('appointmentActions');
                            actionsDiv.innerHTML = '';

                            if (appointment.statut === 'PLANNED') {
                                const completeBtn = document.createElement('button');
                                completeBtn.className = 'btn btn-success me-2';
                                completeBtn.innerHTML = '<i class="fas fa-check me-1"></i> Valider';
                                completeBtn.onclick = function() {
                                    // Close details modal
                                    bootstrap.Modal.getInstance(document.getElementById('viewAppointmentModal')).hide();
                                    // Show complete modal
                                    document.getElementById('completeAppointmentId').value = appointment.id;
                                    document.querySelectorAll('#completeAppointmentModal .patient-name').forEach(el => {
                                        el.textContent = appointment.patientNom;
                                    });
                                    new bootstrap.Modal(document.getElementById('completeAppointmentModal')).show();
                                };
                                actionsDiv.appendChild(completeBtn);

                                const cancelBtn = document.createElement('button');
                                cancelBtn.className = 'btn btn-danger';
                                cancelBtn.innerHTML = '<i class="fas fa-times me-1"></i> Annuler';
                                cancelBtn.onclick = function() {
                                    // Close details modal
                                    bootstrap.Modal.getInstance(document.getElementById('viewAppointmentModal')).hide();
                                    // Show cancel modal
                                    document.getElementById('cancelAppointmentId').value = appointment.id;
                                    document.querySelectorAll('#cancelAppointmentModal .patient-name').forEach(el => {
                                        el.textContent = appointment.patientNom;
                                    });
                                    new bootstrap.Modal(document.getElementById('cancelAppointmentModal')).show();
                                };
                                actionsDiv.appendChild(cancelBtn);
                            }

                            // Show medical notes if available
                            if (data.medicalNote) {
                                document.getElementById('medicalNoteContent').textContent = data.medicalNote.note;

                                const updatedAt = new Date(data.medicalNote.updatedAt || data.medicalNote.createdAt);
                                document.getElementById('medicalNoteDate').textContent = updatedAt.toLocaleString('fr-FR');

                                document.getElementById('medicalNoteSection').style.display = 'block';
                            }

                            // Show the details
                            document.getElementById('appointmentDetails').style.display = 'block';
                        } else {
                            document.getElementById('appointmentError').style.display = 'block';
                            document.getElementById('errorMessage').textContent = data.error || 'Une erreur est survenue';
                        }
                    })
                    .catch(error => {
                        document.getElementById('appointmentLoading').style.display = 'none';
                        document.getElementById('appointmentError').style.display = 'block';
                        document.getElementById('errorMessage').textContent = 'Erreur lors du chargement des détails';
                        console.error('Error fetching appointment details:', error);
                    });
            }

            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert:not(#appointmentError)');
                alerts.forEach(alert => {
                    alert.style.opacity = '0';
                    alert.style.transition = 'opacity 0.5s';
                    setTimeout(() => {
                        if (alert.parentNode) {
                            alert.parentNode.removeChild(alert);
                        }
                    }, 500);
                });
            }, 5000);
        });


//medical notes


document.addEventListener('DOMContentLoaded', function() {
            // Handle view/edit medical note
            document.querySelectorAll('.view-note').forEach(button => {
                button.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    const hasNote = this.getAttribute('data-has-note') === 'true';
                    viewOrEditNote(id, !hasNote); // Go directly to edit mode if no note exists
                });
            });

            // Also allow clicking on the entire row
            document.querySelectorAll('.appointment-row').forEach(row => {
                row.addEventListener('click', function(e) {
                    // Only trigger if not clicking on a button
                    if (!e.target.closest('button')) {
                        const id = this.getAttribute('data-id');
                        const hasNote = this.querySelector('.view-note').getAttribute('data-has-note') === 'true';
                        viewOrEditNote(id, !hasNote);
                    }
                });
            });

            // Handle edit button
            document.getElementById('editNoteBtn').addEventListener('click', function() {
                toggleEditMode(true);
            });

            // Handle cancel edit button
            document.getElementById('cancelEditBtn').addEventListener('click', function() {
                toggleEditMode(false);
            });

            // Handle save note button
            document.getElementById('saveNoteBtn').addEventListener('click', function() {
                const noteContent = document.getElementById('noteEditor').value.trim();
                if (!noteContent) {
                    alert('Veuillez saisir une note médicale.');
                    return;
                }

                document.getElementById('noteFormContent').value = noteContent;
                document.getElementById('saveNoteForm').submit();
            });

            // Function to toggle between view and edit modes
            function toggleEditMode(edit) {
                if (edit) {
                    // Switch to edit mode
                    document.getElementById('viewModeControls').style.display = 'none';
                    document.getElementById('editModeControls').style.display = 'block';

                    // Copy content from view to editor
                    const currentContent = document.getElementById('noteContent').textContent || '';
                    document.getElementById('noteEditor').value = currentContent;

                    // Focus on the editor
                    document.getElementById('noteEditor').focus();
                } else {
                    // Switch back to view mode
                    document.getElementById('editModeControls').style.display = 'none';
                    document.getElementById('viewModeControls').style.display = 'block';
                }
            }

            // Function to view or edit a medical note
            function viewOrEditNote(id, goToEditMode = false) {
                // Reset and show modal
                document.getElementById('noteLoading').style.display = 'block';
                document.getElementById('noteDetails').style.display = 'none';
                document.getElementById('noteError').style.display = 'none';
                document.getElementById('noteAppointmentId').value = id;

                const modal = new bootstrap.Modal(document.getElementById('medicalNoteModal'));
                modal.show();

                // Fetch note details
                fetch(`${pageContext.request.contextPath}/doctor/medical-notes/details?appointmentId=${id}`)
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('noteLoading').style.display = 'none';

                        if (data.success) {
                            const appointment = data.appointment;

                            // Format date
                            const date = new Date(appointment.date);
                            const formattedDate = date.toLocaleDateString('fr-FR', {
                                day: '2-digit',
                                month: '2-digit',
                                year: 'numeric'
                            });

                            // Populate details
                            document.getElementById('appointmentDate').textContent = formattedDate;
                            document.getElementById('appointmentTime').textContent =
                                `${appointment.heureDebut} - ${appointment.heureFin}`;
                            document.getElementById('appointmentType').textContent =
                                appointment.type || 'Non spécifié';
                            document.getElementById('appointmentReason').textContent =
                                appointment.motif || 'Non spécifié';

                            // Set patient info
                            document.getElementById('patientName').textContent = appointment.patientNom;
                            document.getElementById('viewPatientBtn').setAttribute(
                                'onclick',
                                `window.location.href='${pageContext.request.contextPath}/doctor/patients/view?id=${appointment.patientId}'`
                            );

                            // Set note content
                            if (data.medicalNote) {
                                document.getElementById('noteContent').textContent = data.medicalNote.note;

                                // Format update date
                                const updatedAt = new Date(data.medicalNote.updatedAt || data.medicalNote.createdAt);
                                document.getElementById('noteUpdateDate').textContent = updatedAt.toLocaleString('fr-FR');
                                document.getElementById('hasLastUpdate').style.display = 'block';
                            } else {
                                document.getElementById('noteContent').textContent =
                                    'Aucune note médicale n\'a encore été rédigée pour ce rendez-vous.';
                                document.getElementById('hasLastUpdate').style.display = 'none';
                            }

                            // Show the details and switch to appropriate mode
                            document.getElementById('noteDetails').style.display = 'block';

                            if (goToEditMode) {
                                toggleEditMode(true);
                            } else {
                                toggleEditMode(false);
                            }
                        } else {
                            document.getElementById('noteError').style.display = 'block';
                            document.getElementById('errorMessage').textContent = data.error || 'Une erreur est survenue';
                        }
                    })
                    .catch(error => {
                        document.getElementById('noteLoading').style.display = 'none';
                        document.getElementById('noteError').style.display = 'block';
                        document.getElementById('errorMessage').textContent = 'Erreur lors du chargement des détails';
                        console.error('Error fetching note details:', error);
                    });
            }

            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert:not(#noteError)');
                alerts.forEach(alert => {
                    alert.style.opacity = '0';
                    alert.style.transition = 'opacity 0.5s';
                    setTimeout(() => {
                        if (alert.parentNode) {
                            alert.parentNode.removeChild(alert);
                        }
                    }, 500);
                });
            }, 5000);
        });
