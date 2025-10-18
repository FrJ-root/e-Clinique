// DOM Elements
document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('mainContent');
    const topbar = document.getElementById('topbar');
    const toggleSidebarBtn = document.getElementById('toggleSidebar');
    const mobileOverlay = document.getElementById('mobileOverlay');
    const themeToggle = document.getElementById('themeToggle');
    const themeIcon = document.getElementById('themeIcon');
    const htmlElement = document.documentElement;

    // Check for saved theme preference
    const currentTheme = localStorage.getItem('theme') || 'light';
    htmlElement.setAttribute('data-theme', currentTheme);
    updateThemeIcon(currentTheme);

    // Theme Toggle Function
    themeToggle.addEventListener('click', function() {
        let theme = htmlElement.getAttribute('data-theme');
        let newTheme = theme === 'light' ? 'dark' : 'light';

        htmlElement.setAttribute('data-theme', newTheme);
        localStorage.setItem('theme', newTheme);
        updateThemeIcon(newTheme);
    });

    function updateThemeIcon(theme) {
        if (theme === 'dark') {
            themeIcon.classList.remove('fa-moon');
            themeIcon.classList.add('fa-sun');
        } else {
            themeIcon.classList.remove('fa-sun');
            themeIcon.classList.add('fa-moon');
        }
    }

    // Check screen width
    function checkScreenWidth() {
        const isDesktop = window.innerWidth >= 992;
        return isDesktop;
    }

    // Toggle sidebar based on device
    function toggleSidebar() {
        const isDesktop = checkScreenWidth();
        if (isDesktop) {
            sidebar.classList.toggle('collapsed');
            mainContent.classList.toggle('expanded');
            topbar.classList.toggle('expanded');
        } else {
            sidebar.classList.toggle('mobile-visible');
            mobileOverlay.classList.toggle('active');
        }
    }

    // Event Listeners
    if (toggleSidebarBtn) {
        toggleSidebarBtn.addEventListener('click', toggleSidebar);
    }

    if (mobileOverlay) {
        mobileOverlay.addEventListener('click', function() {
            sidebar.classList.remove('mobile-visible');
            mobileOverlay.classList.remove('active');
        });
    }

    // On resize
    window.addEventListener('resize', function() {
        const isDesktop = checkScreenWidth();
        if (isDesktop) {
            sidebar.classList.remove('mobile-visible');
            mobileOverlay.classList.remove('active');
        }
    });

    // Success message display and auto-hide
    const alerts = document.querySelectorAll('.alert');
    if (alerts.length > 0) {
        setTimeout(function() {
            alerts.forEach(function(alert) {
                alert.style.transition = 'opacity 0.5s ease';
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.remove();
                }, 500);
            });
        }, 5000);
    }
});



// Add time slot validation logic
document.addEventListener('DOMContentLoaded', function() {
    // Existing code...

    // Add time validation for slots
    const timeSlots = document.querySelectorAll('.time-slot');
    if (timeSlots.length > 0) {
        const minBookingHours = 2; // Should match the server-side constraint
        const now = new Date();
        const selectedDate = document.querySelector('input[name="date"]').value;

        timeSlots.forEach(slot => {
            const startTime = slot.dataset.startTime;
            const appointmentDateTime = new Date(selectedDate + 'T' + startTime);

            // Calculate hours difference
            const hoursDiff = (appointmentDateTime - now) / (1000 * 60 * 60);

            // If appointment is less than minBookingHours away, disable the slot
            if (hoursDiff < minBookingHours) {
                slot.classList.add('disabled');
                slot.setAttribute('title', `Les rendez-vous doivent être pris au moins ${minBookingHours} heures à l'avance`);

                // Prevent selection of disabled slots
                slot.addEventListener('click', function(e) {
                    e.stopPropagation();
                    e.preventDefault();
                });
            }
        });
    }

    // Form submission validation
    const appointmentForm = document.getElementById('appointmentForm');
    if (appointmentForm) {
        appointmentForm.addEventListener('submit', function(e) {
            const selectedSlot = document.querySelector('.time-slot.selected');

            if (!selectedSlot) {
                e.preventDefault();
                alert('Veuillez sélectionner un créneau horaire');
                return;
            }

            if (selectedSlot.classList.contains('disabled')) {
                e.preventDefault();
                alert(`Les rendez-vous doivent être pris au moins 2 heures à l'avance`);
                return;
            }
        });
    }
});
// Appointment-specific JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Time slot selection
    const timeSlots = document.querySelectorAll('.time-slot');
    const startTimeInput = document.getElementById('startTimeInput');
    const endTimeInput = document.getElementById('endTimeInput');
    const bookButton = document.getElementById('bookButton');

    if (timeSlots.length > 0) {
        timeSlots.forEach(slot => {
            slot.addEventListener('click', function() {
                timeSlots.forEach(s => s.classList.remove('selected'));
                this.classList.add('selected');

                startTimeInput.value = this.dataset.startTime;
                endTimeInput.value = this.dataset.endTime;

                if (bookButton) {
                    bookButton.disabled = false;
                }
            });
        });
    }

    // Appointment form validation
    const appointmentForm = document.getElementById('appointmentForm');
    if (appointmentForm) {
        appointmentForm.addEventListener('submit', function(e) {
            if (!startTimeInput.value || !endTimeInput.value) {
                e.preventDefault();
                alert("Veuillez sélectionner un créneau horaire");
            }
        });
    }

    // Date navigation
    const nextWeekBtn = document.getElementById('nextWeek');
    const prevWeekBtn = document.getElementById('prevWeek');

    if (nextWeekBtn && prevWeekBtn) {
        nextWeekBtn.addEventListener('click', function(e) {
            e.preventDefault();
            showNextDates();
        });

        prevWeekBtn.addEventListener('click', function(e) {
            e.preventDefault();
            showPrevDates();
        });
    }

    function showNextDates() {
        const dateGrid = document.getElementById('dateGrid');
        if (!dateGrid) return;

        // This would be implemented with actual date navigation functionality
        // For now, it's just a placeholder
        console.log('Navigate to next week');
    }

    function showPrevDates() {
        const dateGrid = document.getElementById('dateGrid');
        if (!dateGrid) return;

        // This would be implemented with actual date navigation functionality
        // For now, it's just a placeholder
        console.log('Navigate to previous week');
    }
});



// Doctor search specific JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Any doctor search-specific functionality can be added here

    // Example: Filter animation
    const filterItems = document.querySelectorAll('.list-group-item');
    if (filterItems) {
        filterItems.forEach(item => {
            item.addEventListener('click', function() {
                // Add a brief highlight animation when clicking filter
                this.style.transition = 'background-color 0.3s';
                const originalBg = this.style.backgroundColor;
                this.style.backgroundColor = 'rgba(0, 180, 216, 0.1)';

                setTimeout(() => {
                    this.style.backgroundColor = originalBg;
                }, 300);
            });
        });
    }

    // Example: Doctor card hover effect enhancement
    const doctorCards = document.querySelectorAll('.doctor-card');
    if (doctorCards) {
        doctorCards.forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-5px)';
            });

            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });
    }
});



// Patient profile specific JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Password field validation
    const currentPasswordField = document.getElementById('currentPassword');
    const newPasswordField = document.getElementById('newPassword');

    if (currentPasswordField && newPasswordField) {
        // Validate that both password fields are filled if one is filled
        document.querySelector('form').addEventListener('submit', function(e) {
            if ((currentPasswordField.value && !newPasswordField.value) ||
                (!currentPasswordField.value && newPasswordField.value)) {
                e.preventDefault();
                alert('Veuillez remplir les deux champs de mot de passe pour effectuer un changement.');
            }
        });
    }

    // Auto-hide alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    if (alerts.length > 0) {
        setTimeout(function() {
            alerts.forEach(function(alert) {
                alert.style.transition = 'opacity 0.5s ease';
                alert.style.opacity = '0';
                setTimeout(function() {
                    if (alert.parentNode) {
                        alert.parentNode.removeChild(alert);
                    }
                }, 500);
            });
        }, 5000);
    }

    // Input field animation
    const formControls = document.querySelectorAll('.form-control, .form-select');
    formControls.forEach(control => {
        control.addEventListener('focus', function() {
            this.parentElement.style.transform = 'translateY(-2px)';
            this.parentElement.style.transition = 'transform 0.3s ease';
        });

        control.addEventListener('blur', function() {
            this.parentElement.style.transform = 'translateY(0)';
        });
    });
});


// Time slot selection with validation for minimum booking time
document.addEventListener('DOMContentLoaded', function() {
    const timeSlots = document.querySelectorAll('.time-slot:not(.disabled)');
    const startTimeInput = document.getElementById('startTimeInput');
    const endTimeInput = document.getElementById('endTimeInput');
    const bookButton = document.getElementById('bookButton');

    if (timeSlots.length > 0) {
        timeSlots.forEach(slot => {
            slot.addEventListener('click', function() {
                if (this.classList.contains('disabled')) {
                    return; // Skip if the slot is disabled
                }

                timeSlots.forEach(s => s.classList.remove('selected'));
                this.classList.add('selected');

                startTimeInput.value = this.dataset.startTime;
                endTimeInput.value = this.dataset.endTime;

                if (bookButton) {
                    bookButton.disabled = false;
                }
            });
        });
    }

    // Disable clicking on slots that are less than 2 hours away
    const disabledSlots = document.querySelectorAll('.time-slot.disabled');
    disabledSlots.forEach(slot => {
        slot.addEventListener('click', function(e) {
            e.preventDefault();
            alert('Les rendez-vous doivent être pris au moins 2 heures à l'avance.');
        });
    });
});



// Patient appointment booking specific JavaScript :



document.addEventListener('DOMContentLoaded', function() {
    const timeSlots = document.querySelectorAll('.time-slot');
    const startTimeInput = document.getElementById('startTimeInput');
    const endTimeInput = document.getElementById('endTimeInput');
    const bookButton = document.getElementById('bookButton');

    if (timeSlots.length > 0) {
        timeSlots.forEach(slot => {
            if (slot.classList.contains('disabled')) {
                return;
            }

            slot.addEventListener('click', function() {
                timeSlots.forEach(s => s.classList.remove('selected'));

                // Add selection to this slot
                this.classList.add('selected');

                // Set form values
                startTimeInput.value = this.dataset.startTime;
                endTimeInput.value = this.dataset.endTime;

                // Enable book button
                if (bookButton) {
                    bookButton.disabled = false;
                }
            });
        });
    }

    // Date navigation
    const nextWeekBtn = document.getElementById('nextWeek');
    const prevWeekBtn = document.getElementById('prevWeek');
    const dateGrid = document.getElementById('dateGrid');

    if (nextWeekBtn && dateGrid) {
        nextWeekBtn.addEventListener('click', function(e) {
            e.preventDefault();
            navigateDates('next');
        });
    }

    if (prevWeekBtn && dateGrid) {
        prevWeekBtn.addEventListener('click', function(e) {
            e.preventDefault();
            navigateDates('prev');
        });
    }

    function navigateDates(direction) {
        // Get the current date from the URL or first date button
        let currentDateStr = new URLSearchParams(window.location.search).get('date');
        if (!currentDateStr) {
            const firstDateBtn = document.querySelector('.date-btn');
            if (firstDateBtn) {
                const href = firstDateBtn.getAttribute('href');
                const urlParams = new URLSearchParams(new URL(href).search);
                currentDateStr = urlParams.get('date');
            }
        }

        if (!currentDateStr) return;

        // Parse the date
        const currentDate = new Date(currentDateStr);

        // Calculate new date (7 days forward or backward)
        const newDate = new Date(currentDate);
        if (direction === 'next') {
            newDate.setDate(newDate.getDate() + 7);
        } else {
            newDate.setDate(newDate.getDate() - 7);
        }

        // Format the new date as YYYY-MM-DD
        const newDateStr = newDate.toISOString().split('T')[0];

        // Get current URL params
        const urlParams = new URLSearchParams(window.location.search);

        // Update the date parameter
        urlParams.set('date', newDateStr);

        // Redirect to the new URL
        window.location.href = window.location.pathname + '?' + urlParams.toString();
    }

    // Form validation
    const appointmentForm = document.getElementById('appointmentForm');
    if (appointmentForm) {
        appointmentForm.addEventListener('submit', function(e) {
            if (!startTimeInput.value || !endTimeInput.value) {
                e.preventDefault();
                alert('Veuillez sélectionner un créneau horaire');
                return false;
            }

            const motifField = document.getElementById('motif');
            if (motifField && !motifField.value.trim()) {
                e.preventDefault();
                alert('Veuillez indiquer le motif de votre consultation');
                return false;
            }

            return true;
        });
    }
});