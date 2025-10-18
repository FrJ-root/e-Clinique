<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Paramètres - Administration e-Clinique</title>
    <%@ include file="components/common-head.jsp" %>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
</head>
<body>
    <c:set var="pageTitle" value="Paramètres système" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <div class="row">
                <!-- Appointment Settings -->
                <div class="col-lg-6 mb-4">
                    <div class="content-card">
                        <h3 class="card-title mb-4">Paramètres des rendez-vous</h3>
                        <form id="appointmentSettingsForm" action="${pageContext.request.contextPath}/admin/settings/save" method="post">
                            <div class="mb-3">
                                <label for="slotDuration" class="form-label">Durée des créneaux (minutes) *</label>
                                <input type="number" class="form-control" id="slotDuration" name="slotDuration"
                                       value="${slotDuration}" min="5" max="120" required>
                                <small class="form-text text-muted">Durée de chaque créneau de rendez-vous (entre 5 et 120 minutes)</small>
                            </div>
                            <div class="mb-3">
                                <label for="leadTime" class="form-label">Délai minimum (heures) *</label>
                                <input type="number" class="form-control" id="leadTime" name="leadTime"
                                       value="${leadTimeHours}" min="0" max="168" required>
                                <small class="form-text text-muted">Délai minimum avant prise de rendez-vous (en heures)</small>
                            </div>
                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" id="allowWeekends" name="allowWeekends"
                                       ${allowWeekends ? 'checked' : ''}>
                                <label class="form-check-label" for="allowWeekends">Autoriser les rendez-vous le weekend</label>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Enregistrer les paramètres
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Holidays -->
                <div class="col-lg-6 mb-4">
                    <div class="content-card">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="card-title mb-0">Jours fériés</h3>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addHolidayModal">
                                <i class="fas fa-plus me-2"></i>Ajouter
                            </button>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Description</th>
                                        <th>Récurrent</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${holidays}" var="holiday">
                                        <tr>
                                            <td>
                                                <fmt:formatDate value="${holiday.date}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td>${holiday.description}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${holiday.recurring}">
                                                        <span class="badge bg-success">Oui</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Non</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group">
                                                    <button class="btn btn-sm btn-outline-secondary edit-holiday"
                                                            data-id="${holiday.id}"
                                                            data-date="${holiday.date}"
                                                            data-description="${holiday.description}"
                                                            data-recurring="${holiday.recurring}">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-danger delete-holiday"
                                                            data-id="${holiday.id}"
                                                            data-description="${holiday.description}">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty holidays}">
                                        <tr>
                                            <td colspan="4" class="text-center">Aucun jour férié configuré</td>
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

    <!-- Add Holiday Modal -->
    <div class="modal fade" id="addHolidayModal" tabindex="-1" aria-labelledby="addHolidayModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addHolidayModalLabel">Ajouter un jour férié</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="addHolidayForm" action="${pageContext.request.contextPath}/admin/settings/holiday/create" method="post">
                        <div class="mb-3">
                            <label for="date" class="form-label">Date *</label>
                            <input type="text" class="form-control datepicker" id="date" name="date" required>
                        </div>
                        <div class="mb-3">
                            <label for="holidayDescription" class="form-label">Description *</label>
                            <input type="text" class="form-control" id="holidayDescription" name="description" required>
                        </div>
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="recurring" name="recurring">
                            <label class="form-check-label" for="recurring">Récurrent (chaque année)</label>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" form="addHolidayForm" class="btn btn-primary">Ajouter</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Holiday Modal -->
    <div class="modal fade" id="editHolidayModal" tabindex="-1" aria-labelledby="editHolidayModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editHolidayModalLabel">Modifier le jour férié</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editHolidayForm" action="${pageContext.request.contextPath}/admin/settings/holiday/update" method="post">
                        <input type="hidden" id="editHolidayId" name="id">
                        <div class="mb-3">
                            <label for="editDate" class="form-label">Date *</label>
                            <input type="text" class="form-control datepicker" id="editDate" name="date" required>
                        </div>
                        <div class="mb-3">
                            <label for="editHolidayDescription" class="form-label">Description *</label>
                            <input type="text" class="form-control" id="editHolidayDescription" name="description" required>
                        </div>
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="editRecurring" name="recurring">
                            <label class="form-check-label" for="editRecurring">Récurrent (chaque année)</label>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" form="editHolidayForm" class="btn btn-primary">Enregistrer</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Holiday Modal -->
    <div class="modal fade" id="deleteHolidayModal" tabindex="-1" aria-labelledby="deleteHolidayModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteHolidayModalLabel">Confirmer la suppression</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Êtes-vous sûr de vouloir supprimer le jour férié <strong id="deleteHolidayDescription"></strong> ?</p>
                    <p class="text-danger">Cette action est irréversible.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <form id="deleteHolidayForm" action="${pageContext.request.contextPath}/admin/settings/holiday/delete" method="post">
                        <input type="hidden" id="deleteHolidayId" name="id">
                        <button type="submit" class="btn btn-danger">Supprimer</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="components/common-scripts.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/fr.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize date pickers
            flatpickr(".datepicker", {
                dateFormat: "Y-m-d",
                locale: "fr",
                allowInput: true
            });

            // Edit holiday
            const editButtons = document.querySelectorAll('.edit-holiday');
            editButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    const date = this.getAttribute('data-date');
                    const description = this.getAttribute('data-description');
                    const recurring = this.getAttribute('data-recurring') === 'true';

                    document.getElementById('editHolidayId').value = id;
                    document.getElementById('editDate').value = formatDate(new Date(date));
                    document.getElementById('editHolidayDescription').value = description;
                    document.getElementById('editRecurring').checked = recurring;

                    const editModal = new bootstrap.Modal(document.getElementById('editHolidayModal'));
                    editModal.show();

                    // Refresh the flatpickr instance after showing the modal
                    flatpickr("#editDate", {
                        dateFormat: "Y-m-d",
                        locale: "fr",
                        allowInput: true,
                        defaultDate: formatDate(new Date(date))
                    });
                });
            });

            // Delete holiday
            const deleteButtons = document.querySelectorAll('.delete-holiday');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    const description = this.getAttribute('data-description');

                    document.getElementById('deleteHolidayId').value = id;
                    document.getElementById('deleteHolidayDescription').textContent = description;

                    const deleteModal = new bootstrap.Modal(document.getElementById('deleteHolidayModal'));
                    deleteModal.show();
                });
            });

            // Helper function to format date as YYYY-MM-DD
            function formatDate(date) {
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                return `${year}-${month}-${day}`;
            }
        });
    </script>
</body>
</html>