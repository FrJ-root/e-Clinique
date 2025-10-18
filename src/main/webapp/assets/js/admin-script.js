document.addEventListener('DOMContentLoaded', function() {
            // Password confirmation validation
            const newPasswordInput = document.getElementById('newPassword');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const submitButton = document.querySelector('button[type="submit"]');

            function validatePasswordMatch() {
                if (newPasswordInput.value && newPasswordInput.value !== confirmPasswordInput.value) {
                    confirmPasswordInput.classList.add('is-invalid');
                    submitButton.disabled = true;
                } else {
                    confirmPasswordInput.classList.remove('is-invalid');
                    submitButton.disabled = false;
                }
            }

            newPasswordInput.addEventListener('input', validatePasswordMatch);
            confirmPasswordInput.addEventListener('input', validatePasswordMatch);

            // Form validation before submit
            const form = document.querySelector('form');
            form.addEventListener('submit', function(event) {
                if (newPasswordInput.value && newPasswordInput.value !== confirmPasswordInput.value) {
                    event.preventDefault();
                    confirmPasswordInput.classList.add('is-invalid');
                }
            });
        });

document.addEventListener('DOMContentLoaded', function() {
            // Password confirmation validation
            const newPasswordInput = document.getElementById('newPassword');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const resetPasswordBtn = document.getElementById('resetPasswordBtn');

            function validatePasswordMatch() {
                if (newPasswordInput.value !== confirmPasswordInput.value) {
                    confirmPasswordInput.classList.add('is-invalid');
                    resetPasswordBtn.disabled = true;
                } else {
                    confirmPasswordInput.classList.remove('is-invalid');
                    resetPasswordBtn.disabled = false;
                }
            }

            newPasswordInput.addEventListener('input', validatePasswordMatch);
            confirmPasswordInput.addEventListener('input', validatePasswordMatch);
        });

document.addEventListener('DOMContentLoaded', function() {
    // Edit user functionality
    const editUserButtons = document.querySelectorAll('.edit-user');
    editUserButtons.forEach(button => {
        button.addEventListener('click', function() {
            const userId = this.getAttribute('data-id');
            fetchUserData(userId);
        });
    });

    function fetchUserData(userId) {
        fetch(`${pageContext.request.contextPath}/admin/users/get?id=${userId}`)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    populateEditForm(data);
                    const editUserModal = new bootstrap.Modal(document.getElementById('editUserModal'));
                    editUserModal.show();
                } else {
                    alert(data.error || 'Une erreur est survenue lors de la récupération des données utilisateur');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Une erreur est survenue lors de la récupération des données utilisateur');
            });
    }

    function populateEditForm(data) {
        document.getElementById('editId').value = data.user.id;
        document.getElementById('editRole').value = data.user.role;
        document.getElementById('editNom').value = data.user.nom;
        document.getElementById('editEmail').value = data.user.email;
        document.getElementById('editActive').checked = data.user.actif;

        // Hide all role-specific fields
        const editDoctorFields = document.getElementById('editDoctorFields');
        const editStaffFields = document.getElementById('editStaffFields');

        editDoctorFields.style.display = 'none';
        if (editStaffFields) {
            editStaffFields.style.display = 'none';
        }

        // Show fields based on role
        if (data.user.role === 'DOCTOR' && data.doctor) {
            editDoctorFields.style.display = 'block';
            document.getElementById('editMatricule').value = data.doctor.matricule || '';
            document.getElementById('editTitre').value = data.doctor.titre || 'Dr';

            const specialtySelect = document.getElementById('editSpecialtyId');
            if (data.doctor.specialty) {
                specialtySelect.value = data.doctor.specialty.id;
            } else {
                specialtySelect.selectedIndex = 0;
            }
        } else if (data.user.role === 'STAFF' && data.staff && editStaffFields) {
            editStaffFields.style.display = 'block';
            document.getElementById('editPosition').value = data.staff.position || '';

            const departmentSelect = document.getElementById('editDepartmentId');
            if (data.staff.department) {
                departmentSelect.value = data.staff.department.id;
            } else {
                departmentSelect.selectedIndex = 0;
            }
        }
    }
});


document.addEventListener('DOMContentLoaded', function() {
    const deleteButtons = document.querySelectorAll('.delete-user');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function() {
            const userId = this.getAttribute('data-id');
            const userName = this.getAttribute('data-name');
            document.getElementById('deleteUserId').value = userId;
            document.getElementById('deleteUserName').textContent = userName;
        });
    });
});

document.addEventListener('DOMContentLoaded', function() {
    const roleSelect = document.getElementById('role');
    const doctorFields = document.getElementById('doctorFields');
    const patientFields = document.getElementById('patientFields');
    const staffFields = document.getElementById('staffFields');

    if (roleSelect) {
        roleSelect.addEventListener('change', function() {
            // Hide all fields first
            doctorFields.style.display = 'none';
            patientFields.style.display = 'none';
            if (staffFields) staffFields.style.display = 'none';

            // Reset required fields
            if (document.getElementById('matricule')) document.getElementById('matricule').required = false;
            if (document.getElementById('cin')) document.getElementById('cin').required = false;
            if (document.getElementById('position')) document.getElementById('position').required = false;

            // Show appropriate fields based on role
            if (this.value === 'DOCTOR') {
                doctorFields.style.display = 'block';
                if (document.getElementById('matricule')) document.getElementById('matricule').required = true;
            } else if (this.value === 'PATIENT') {
                patientFields.style.display = 'block';
                if (document.getElementById('cin')) document.getElementById('cin').required = true;
            } else if (this.value === 'STAFF' && staffFields) {
                staffFields.style.display = 'block';
                if (document.getElementById('position')) document.getElementById('position').required = true;
            }
        });
    }
});
//-------------

document.addEventListener('DOMContentLoaded', function() {
            // Show/hide fields based on role selection
            const roleSelect = document.getElementById('role');
            const doctorFields = document.getElementById('doctorFields');
            const patientFields = document.getElementById('patientFields');
            const staffFields = document.getElementById('staffFields');

            roleSelect.addEventListener('change', function() {
                // Hide all fields first
                doctorFields.style.display = 'none';
                patientFields.style.display = 'none';
                staffFields.style.display = 'none';

                // Reset required fields
                document.getElementById('matricule').required = false;
                document.getElementById('cin').required = false;
                if (document.getElementById('position')) {
                    document.getElementById('position').required = false;
                }

                // Show appropriate fields based on role
                if (this.value === 'DOCTOR') {
                    doctorFields.style.display = 'block';
                    document.getElementById('matricule').required = true;
                } else if (this.value === 'PATIENT') {
                    patientFields.style.display = 'block';
                    document.getElementById('cin').required = true;
                } else if (this.value === 'STAFF') {
                    staffFields.style.display = 'block';
                    if (document.getElementById('position')) {
                        document.getElementById('position').required = true;
                    }
                }
            });

            // Edit user functionality
            const editUserButtons = document.querySelectorAll('.edit-user');
            editUserButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const userId = this.getAttribute('data-id');
                    fetchUserData(userId);
                });
            });

            function fetchUserData(userId) {
                fetch(`${pageContext.request.contextPath}/admin/users/get?id=${userId}`)
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            populateEditForm(data);
                            const editUserModal = new bootstrap.Modal(document.getElementById('editUserModal'));
                            editUserModal.show();
                        } else {
                            alert(data.error || 'Une erreur est survenue lors de la récupération des données utilisateur');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Une erreur est survenue lors de la récupération des données utilisateur');
                    });
            }

            function populateEditForm(data) {
                document.getElementById('editId').value = data.user.id;
                document.getElementById('editRole').value = data.user.role;
                document.getElementById('editNom').value = data.user.nom;
                document.getElementById('editEmail').value = data.user.email;
                document.getElementById('editActive').checked = data.user.actif;

                // Hide all role-specific fields
                const editDoctorFields = document.getElementById('editDoctorFields');
                const editStaffFields = document.getElementById('editStaffFields');

                editDoctorFields.style.display = 'none';
                if (editStaffFields) {
                    editStaffFields.style.display = 'none';
                }

                // Show fields based on role
                if (data.user.role === 'DOCTOR' && data.doctor) {
                    editDoctorFields.style.display = 'block';
                    document.getElementById('editMatricule').value = data.doctor.matricule || '';
                    document.getElementById('editTitre').value = data.doctor.titre || 'Dr';

                    const specialtySelect = document.getElementById('editSpecialtyId');
                    if (data.doctor.specialty) {
                        specialtySelect.value = data.doctor.specialty.id;
                    } else {
                        specialtySelect.selectedIndex = 0;
                    }
                } else if (data.user.role === 'STAFF' && data.staff && editStaffFields) {
                    editStaffFields.style.display = 'block';
                    document.getElementById('editPosition').value = data.staff.position || '';

                    const departmentSelect = document.getElementById('editDepartmentId');
                    if (data.staff.department) {
                        departmentSelect.value = data.staff.department.id;
                    } else {
                        departmentSelect.selectedIndex = 0;
                    }
                }
            }

            // Delete user functionality
            const deleteButtons = document.querySelectorAll('.delete-user');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const userId = this.getAttribute('data-id');
                    const userName = this.getAttribute('data-name');
                    document.getElementById('deleteUserId').value = userId;
                    document.getElementById('deleteUserName').textContent = userName;
                });
            });
        });

// Replace the existing activate/deactivate handlers in admin-script.js with these improved versions
document.addEventListener('DOMContentLoaded', function() {
    // Deactivate user functionality
    const deactivateUserButtons = document.querySelectorAll('.deactivate-user');
    if (deactivateUserButtons.length > 0) {
        deactivateUserButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                const userId = this.getAttribute('data-id');
                if (confirm('Êtes-vous sûr de vouloir désactiver cet utilisateur ?')) {
                    const form = document.createElement('form');
                    form.method = 'post';
                    form.action = `${window.location.pathname.split('/admin')[0]}/admin/users/deactivate`;

                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'id';
                    idInput.value = userId;

                    form.appendChild(idInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        });
    }

    // Activate user functionality
    const activateUserButtons = document.querySelectorAll('.activate-user');
    if (activateUserButtons.length > 0) {
        activateUserButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                const userId = this.getAttribute('data-id');
                if (confirm('Êtes-vous sûr de vouloir activer cet utilisateur ?')) {
                    const form = document.createElement('form');
                    form.method = 'post';
                    form.action = `${window.location.pathname.split('/admin')[0]}/admin/users/activate`;

                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'id';
                    idInput.value = userId;

                    form.appendChild(idInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        });
    }
});
//-------------------------
document.addEventListener('DOMContentLoaded', function() {

    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('mainContent');
    const topbar = document.getElementById('topbar');
    const toggleSidebarBtn = document.getElementById('toggleSidebar');
    const mobileOverlay = document.getElementById('mobileOverlay');

    const themeToggle = document.getElementById('themeToggle');
    const themeIcon = document.getElementById('themeIcon');
    const htmlElement = document.documentElement;

    const currentTheme = localStorage.getItem('theme') || 'light';
    htmlElement.setAttribute('data-theme', currentTheme);
    updateThemeIcon(currentTheme);

    if (themeToggle) {
        themeToggle.addEventListener('click', function() {
            let theme = htmlElement.getAttribute('data-theme');
            let newTheme = theme === 'light' ? 'dark' : 'light';

            htmlElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            updateThemeIcon(newTheme);
        });
    }

    function updateThemeIcon(theme) {
        if (themeIcon) {
            if (theme === 'dark') {
                themeIcon.classList.remove('fa-moon');
                themeIcon.classList.add('fa-sun');
            } else {
                themeIcon.classList.remove('fa-sun');
                themeIcon.classList.add('fa-moon');
            }
        }
    }

    function checkScreenWidth() {
        return window.innerWidth >= 992;
    }

    if (toggleSidebarBtn) {
        toggleSidebarBtn.addEventListener('click', function() {
            const isDesktop = checkScreenWidth();
            if (isDesktop) {
                sidebar.classList.toggle('collapsed');
                mainContent.classList.toggle('expanded');
                topbar.classList.toggle('expanded');
            } else {
                sidebar.classList.toggle('mobile-visible');
                mobileOverlay.classList.toggle('active');
            }
        });
    }

    if (mobileOverlay) {
        mobileOverlay.addEventListener('click', function() {
            sidebar.classList.remove('mobile-visible');
            mobileOverlay.classList.remove('active');
        });
    }

    window.addEventListener('resize', function() {
        const isDesktop = checkScreenWidth();
        if (isDesktop) {
            sidebar.classList.remove('mobile-visible');
            mobileOverlay.classList.remove('active');
        }
    });

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