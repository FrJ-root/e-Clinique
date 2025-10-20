<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Mes Disponibilités - e-Clinique</title>
    <%@ include file="components/head.jsp" %>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-style.css">
</head>
<body>
    <c:set var="pageTitle" value="Gestion des disponibilités" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                </div>
            </c:if>

            <!-- Main container -->
            <div class="row">
                <!-- Regular weekly availabilities -->
                <div class="col-lg-6 mb-4">
                    <div class="content-card">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="card-title mb-0">
                                <i class="fas fa-calendar-week me-2"></i>Horaires hebdomadaires
                            </h3>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addRegularAvailabilityModal">
                                <i class="fas fa-plus me-2"></i>Ajouter
                            </button>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Jour</th>
                                        <th>Horaires</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${regularAvailabilities}" var="avail">
                                        <tr>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${avail.dayOfWeek == 'MONDAY'}">Lundi</c:when>
                                                    <c:when test="${avail.dayOfWeek == 'TUESDAY'}">Mardi</c:when>
                                                    <c:when test="${avail.dayOfWeek == 'WEDNESDAY'}">Mercredi</c:when>
                                                    <c:when test="${avail.dayOfWeek == 'THURSDAY'}">Jeudi</c:when>
                                                    <c:when test="${avail.dayOfWeek == 'FRIDAY'}">Vendredi</c:when>
                                                    <c:when test="${avail.dayOfWeek == 'SATURDAY'}">Samedi</c:when>
                                                    <c:when test="${avail.dayOfWeek == 'SUNDAY'}">Dimanche</c:when>
                                                </c:choose>
                                            </td>
                                            <td>${avail.displayTime}</td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary me-1 edit-availability"
                                                        data-id="${avail.id}" data-type="regular"
                                                        data-day="${avail.dayOfWeek}"
                                                        data-start="${avail.startTime}" data-end="${avail.endTime}">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger delete-availability"
                                                        data-id="${avail.id}" data-type="regular">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty regularAvailabilities}">
                                        <tr>
                                            <td colspan="3" class="text-center">
                                                <div class="p-3 text-muted">
                                                    <i class="fas fa-info-circle me-2"></i>
                                                    Aucun horaire hebdomadaire défini
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Exceptional availabilities -->
                <div class="col-lg-6 mb-4">
                    <div class="content-card">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="card-title mb-0">
                                <i class="fas fa-calendar-plus me-2"></i>Disponibilités exceptionnelles
                            </h3>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addExceptionalAvailabilityModal">
                                <i class="fas fa-plus me-2"></i>Ajouter
                            </button>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Horaires</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${exceptionalAvailabilities}" var="avail">
                                        <tr>
                                            <td>${avail.formattedDate}</td>
                                            <td>${avail.displayTime}</td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary me-1 edit-availability"
                                                        data-id="${avail.id}" data-type="exceptional"
                                                        data-date="${avail.date}"
                                                        data-start="${avail.startTime}" data-end="${avail.endTime}">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger delete-availability"
                                                        data-id="${avail.id}" data-type="exceptional">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty exceptionalAvailabilities}">
                                        <tr>
                                            <td colspan="3" class="text-center">
                                                <div class="p-3 text-muted">
                                                    <i class="fas fa-info-circle me-2"></i>
                                                    Aucune disponibilité exceptionnelle définie
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Absences -->
                <div class="col-12 mb-4">
                    <div class="content-card">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="card-title mb-0">
                                <i class="fas fa-calendar-minus me-2"></i>Absences prévues
                            </h3>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addAbsenceModal">
                                <i class="fas fa-plus me-2"></i>Ajouter
                            </button>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Horaires</th>
                                        <th>Raison</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${absences}" var="absence">
                                        <tr>
                                            <td>${absence.formattedDate}</td>
                                            <td>${absence.displayTime}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty absence.reason}">${absence.reason}</c:when>
                                                    <c:otherwise><span class="text-muted">Non spécifiée</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary me-1 edit-availability"
                                                        data-id="${absence.id}" data-type="absence"
                                                        data-date="${absence.date}"
                                                        data-start="${absence.startTime}" data-end="${absence.endTime}"
                                                        data-reason="${absence.reason}">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger delete-availability"
                                                        data-id="${absence.id}" data-type="absence">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty absences}">
                                        <tr>
                                            <td colspan="4" class="text-center">
                                                <div class="p-3 text-muted">
                                                    <i class="fas fa-info-circle me-2"></i>
                                                    Aucune absence prévue
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <!-- Modal: Add Regular Availability -->
    <div class="modal fade" id="addRegularAvailabilityModal" tabindex="-1" aria-labelledby="addRegularAvailabilityModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addRegularAvailabilityModalLabel">Ajouter un horaire hebdomadaire</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="regularAvailabilityForm" action="${pageContext.request.contextPath}/doctor/save-availability" method="post">
                        <input type="hidden" name="availabilityType" value="regular">
                        <input type="hidden" name="availabilityId" id="regularAvailabilityId" value="">

                        <div class="mb-3">
                            <label for="dayOfWeek" class="form-label">Jour de la semaine</label>
                            <select class="form-select" id="dayOfWeek" name="dayOfWeek" required>
                                <option value="">-- Sélectionner un jour --</option>
                                <option value="MONDAY">Lundi</option>
                                <option value="TUESDAY">Mardi</option>
                                <option value="WEDNESDAY">Mercredi</option>
                                <option value="THURSDAY">Jeudi</option>
                                <option value="FRIDAY">Vendredi</option>
                                <option value="SATURDAY">Samedi</option>
                                <option value="SUNDAY">Dimanche</option>
                            </select>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="regularStartTime" class="form-label">Heure de début</label>
                                <input type="time" class="form-control" id="regularStartTime" name="startTime" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="regularEndTime" class="form-label">Heure de fin</label>
                                <input type="time" class="form-control" id="regularEndTime" name="endTime" required>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" form="regularAvailabilityForm" class="btn btn-primary">Enregistrer</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal: Add Exceptional Availability -->
    <div class="modal fade" id="addExceptionalAvailabilityModal" tabindex="-1" aria-labelledby="addExceptionalAvailabilityModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addExceptionalAvailabilityModalLabel">Ajouter une disponibilité exceptionnelle</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="exceptionalAvailabilityForm" action="${pageContext.request.contextPath}/doctor/save-availability" method="post">
                        <input type="hidden" name="availabilityType" value="exceptional">
                        <input type="hidden" name="availabilityId" id="exceptionalAvailabilityId" value="">

                        <div class="mb-3">
                            <label for="exceptionalDate" class="form-label">Date</label>
                            <input type="date" class="form-control" id="exceptionalDate" name="date" required>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="exceptionalStartTime" class="form-label">Heure de début</label>
                                <input type="time" class="form-control" id="exceptionalStartTime" name="startTime" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="exceptionalEndTime" class="form-label">Heure de fin</label>
                                <input type="time" class="form-control" id="exceptionalEndTime" name="endTime" required>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" form="exceptionalAvailabilityForm" class="btn btn-primary">Enregistrer</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal: Add Absence -->
    <div class="modal fade" id="addAbsenceModal" tabindex="-1" aria-labelledby="addAbsenceModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addAbsenceModalLabel">Ajouter une absence</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="absenceForm" action="${pageContext.request.contextPath}/doctor/save-availability" method="post">
                        <input type="hidden" name="availabilityType" value="absence">
                        <input type="hidden" name="availabilityId" id="absenceAvailabilityId" value="">

                        <div class="mb-3">
                            <label for="absenceDate" class="form-label">Date</label>
                            <input type="date" class="form-control" id="absenceDate" name="date" required>
                        </div>

                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="fullDayAbsence" name="fullDayAbsence" checked>
                                <label class="form-check-label" for="fullDayAbsence">
                                    Absence toute la journée
                                </label>
                            </div>
                        </div>

                        <div id="absenceTimeSection" class="row" style="display: none;">
                            <div class="col-md-6 mb-3">
                                <label for="absenceStartTime" class="form-label">Heure de début</label>
                                <input type="time" class="form-control" id="absenceStartTime" name="startTime">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="absenceEndTime" class="form-label">Heure de fin</label>
                                <input type="time" class="form-control" id="absenceEndTime" name="endTime">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="absenceReason" class="form-label">Raison (optionnelle)</label>
                            <textarea class="form-control" id="absenceReason" name="reason" rows="2"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" form="absenceForm" class="btn btn-primary">Enregistrer</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteConfirmationModal" tabindex="-1" aria-labelledby="deleteConfirmationModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteConfirmationModalLabel">Confirmer la suppression</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Êtes-vous sûr de vouloir supprimer cette disponibilité ?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <form id="deleteAvailabilityForm" action="${pageContext.request.contextPath}/doctor/delete-availability" method="post">
                        <input type="hidden" id="deleteAvailabilityId" name="availabilityId">
                        <button type="submit" class="btn btn-danger">Supprimer</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/doctor-script.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/fr.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            flatpickr("input[type=date]", {
                locale: "fr",
                minDate: "today",
                dateFormat: "Y-m-d"
            });

            const fullDayCheckbox = document.getElementById('fullDayAbsence');
            const absenceTimeSection = document.getElementById('absenceTimeSection');

            if (fullDayCheckbox && absenceTimeSection) {
                fullDayCheckbox.addEventListener('change', function() {
                    absenceTimeSection.style.display = this.checked ? 'none' : 'flex';

                    if (this.checked) {
                        document.getElementById('absenceStartTime').removeAttribute('required');
                        document.getElementById('absenceEndTime').removeAttribute('required');
                    } else {
                        document.getElementById('absenceStartTime').setAttribute('required', 'required');
                        document.getElementById('absenceEndTime').setAttribute('required', 'required');
                    }
                });
            }

            // Handle edit availability buttons
            const editButtons = document.querySelectorAll('.edit-availability');
            editButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const availabilityId = this.getAttribute('data-id');
                    const type = this.getAttribute('data-type');

                    // Common fields
                    const startTime = this.getAttribute('data-start');
                    const endTime = this.getAttribute('data-end');

                    if (type === 'regular') {
                        const dayOfWeek = this.getAttribute('data-day');

                        // Update modal title
                        document.getElementById('addRegularAvailabilityModalLabel').textContent = 'Modifier un horaire hebdomadaire';

                        // Set form values
                        document.getElementById('regularAvailabilityId').value = availabilityId;
                        document.getElementById('dayOfWeek').value = dayOfWeek;
                        document.getElementById('regularStartTime').value = formatTime(startTime);
                        document.getElementById('regularEndTime').value = formatTime(endTime);

                        // Open modal
                        const modal = new bootstrap.Modal(document.getElementById('addRegularAvailabilityModal'));
                        modal.show();
                    }
                    else if (type === 'exceptional') {
                        const date = this.getAttribute('data-date');

                        // Update modal title
                        document.getElementById('addExceptionalAvailabilityModalLabel').textContent = 'Modifier une disponibilité exceptionnelle';

                        // Set form values
                        document.getElementById('exceptionalAvailabilityId').value = availabilityId;
                        document.getElementById('exceptionalDate').value = date;
                        document.getElementById('exceptionalStartTime').value = formatTime(startTime);
                        document.getElementById('exceptionalEndTime').value = formatTime(endTime);

                        // Open modal
                        const modal = new bootstrap.Modal(document.getElementById('addExceptionalAvailabilityModal'));
                        modal.show();
                    }
                    else if (type === 'absence') {
                        const date = this.getAttribute('data-date');
                        const reason = this.getAttribute('data-reason');

                        // Update modal title
                        document.getElementById('addAbsenceModalLabel').textContent = 'Modifier une absence';

                        // Set form values
                        document.getElementById('absenceAvailabilityId').value = availabilityId;
                        document.getElementById('absenceDate').value = date;
                        document.getElementById('absenceReason').value = reason || '';

                        // Check if it's a full day absence or not
                        const isFullDay = startTime === '09:00' && endTime === '17:00';
                        document.getElementById('fullDayAbsence').checked = isFullDay;
                        document.getElementById('absenceTimeSection').style.display = isFullDay ? 'none' : 'flex';

                        if (!isFullDay) {
                            document.getElementById('absenceStartTime').value = formatTime(startTime);
                            document.getElementById('absenceEndTime').value = formatTime(endTime);
                        }

                        // Open modal
                        const modal = new bootstrap.Modal(document.getElementById('addAbsenceModal'));
                        modal.show();
                    }
                });
            });

            // Handle delete availability buttons
            const deleteButtons = document.querySelectorAll('.delete-availability');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const availabilityId = this.getAttribute('data-id');
                    document.getElementById('deleteAvailabilityId').value = availabilityId;

                    const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmationModal'));
                    deleteModal.show();
                });
            });

            // Helper function to format time for input fields
            function formatTime(timeStr) {
                if (!timeStr) return '';

                // If timeStr is already in HH:MM format, return as is
                if (timeStr.match(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/)) {
                    return timeStr;
                }

                // Handle Java LocalTime format (may include seconds)
                const timeParts = timeStr.split(':');
                if (timeParts.length >= 2) {
                    return `${timeParts[0].padStart(2, '0')}:${timeParts[1].padStart(2, '0')}`;
                }

                return '';
            }

            // Form validation for time inputs
            const validateTimeRange = (form) => {
                const startTime = form.querySelector('input[name="startTime"]');
                const endTime = form.querySelector('input[name="endTime"]');

                if (startTime && endTime && startTime.value && endTime.value) {
                    if (endTime.value <= startTime.value) {
                        alert("L'heure de fin doit être après l'heure de début.");
                        return false;
                    }
                }
                return true;
            };

            // Add form validations
            document.getElementById('regularAvailabilityForm').addEventListener('submit', function(e) {
                if (!validateTimeRange(this)) {
                    e.preventDefault();
                }
            });

            document.getElementById('exceptionalAvailabilityForm').addEventListener('submit', function(e) {
                if (!validateTimeRange(this)) {
                    e.preventDefault();
                }
            });

            document.getElementById('absenceForm').addEventListener('submit', function(e) {
                if (!document.getElementById('fullDayAbsence').checked) {
                    if (!validateTimeRange(this)) {
                        e.preventDefault();
                    }
                }
            });

            // Reset forms when modals are closed
            document.querySelectorAll('.modal').forEach(modal => {
                modal.addEventListener('hidden.bs.modal', function() {
                    // Get the form inside this modal
                    const form = this.querySelector('form');
                    if (form) {
                        form.reset();

                        // Clear hidden ID field
                        const idField = form.querySelector('input[name="availabilityId"]');
                        if (idField) {
                            idField.value = '';
                        }

                        // Reset modal title to "Add"
                        const titlePrefix = this.id === 'addRegularAvailabilityModal' ? 'Ajouter un horaire hebdomadaire' :
                                          this.id === 'addExceptionalAvailabilityModal' ? 'Ajouter une disponibilité exceptionnelle' :
                                          'Ajouter une absence';

                        const titleElement = this.querySelector('.modal-title');
                        if (titleElement) {
                            titleElement.textContent = titlePrefix;
                        }
                    }
                });
            });

            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    alert.classList.add('fade');
                    setTimeout(() => alert.remove(), 500);
                });
            }, 5000);
        });
    </script>
</body>
</html>