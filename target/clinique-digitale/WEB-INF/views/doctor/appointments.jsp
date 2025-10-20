<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Mes Rendez-vous - e-Clinique</title>
    <%@ include file="components/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
</head>
<body>
    <c:set var="pageTitle" value="Mes Rendez-vous" scope="request" />
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

            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMessage}
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <!-- Main content -->
            <div class="content-card">
                <!-- Filters and statistics -->
                <div class="row mb-4">
                    <div class="col-md-8">
                        <h3 class="mb-3">${filterTitle}</h3>
                        <div class="d-flex flex-wrap gap-2 mb-3">
                            <a href="${pageContext.request.contextPath}/doctor/appointments?filter=today"
                               class="btn ${filter eq 'today' ? 'btn-primary' : 'btn-outline-primary'}">
                                <i class="fas fa-calendar-day me-1"></i>Aujourd'hui
                            </a>
                            <a href="${pageContext.request.contextPath}/doctor/appointments?filter=upcoming"
                               class="btn ${filter eq 'upcoming' ? 'btn-primary' : 'btn-outline-primary'}">
                                <i class="fas fa-calendar-alt me-1"></i>À venir
                            </a>
                            <a href="${pageContext.request.contextPath}/doctor/appointments?filter=past"
                               class="btn ${filter eq 'past' ? 'btn-primary' : 'btn-outline-primary'}">
                                <i class="fas fa-history me-1"></i>Passés
                            </a>
                            <a href="${pageContext.request.contextPath}/doctor/appointments"
                               class="btn ${filter eq 'all' ? 'btn-primary' : 'btn-outline-primary'}">
                                <i class="fas fa-list me-1"></i>Tous
                            </a>
                            <button class="btn btn-outline-primary" id="dateRangeFilterBtn">
                                <i class="fas fa-calendar-week me-1"></i>Période
                            </button>
                        </div>

                        <!-- Date range filter form -->
                        <div id="dateRangeFilterForm" class="mb-3" style="display: none;">
                            <form action="${pageContext.request.contextPath}/doctor/appointments" method="get" class="d-flex gap-2">
                                <input type="hidden" name="filter" value="dateRange">
                                <input type="text" name="dateRange" id="dateRange" class="form-control date-range-picker"
                                       placeholder="Sélectionner une période" required>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search me-1"></i>Filtrer
                                </button>
                            </form>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title mb-3">Statistiques</h5>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Rendez-vous prévus:</span>
                                    <span class="badge bg-primary">${countByStatus.PLANNED}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Rendez-vous terminés:</span>
                                    <span class="badge bg-success">${countByStatus.DONE}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Rendez-vous annulés:</span>
                                    <span class="badge bg-danger">${countByStatus.CANCELED}</span>
                                </div>
                                <div class="d-flex justify-content-between fw-bold">
                                    <span>Total:</span>
                                    <span class="badge bg-dark">${countByStatus.TOTAL}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Appointments list -->
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Date & Heure</th>
                                <th>Patient</th>
                                <th>Type / Motif</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="appointment" items="${appointments}">
                                <tr class="appointment-row" data-id="${appointment.id}">
                                    <td>
                                        <div class="fw-bold">
                                            <fmt:parseDate value="${appointment.date}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                                        </div>
                                        <div class="text-muted small">
                                            ${appointment.heureDebut} - ${appointment.heureFin}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="fw-bold">${appointment.patientNom}</div>
                                    </td>
                                    <td>
                                        <c:if test="${not empty appointment.type}">
                                            <div class="small fw-bold">${appointment.type}</div>
                                        </c:if>
                                        <c:if test="${not empty appointment.motif}">
                                            <div class="text-muted small">${appointment.motif}</div>
                                        </c:if>
                                    </td>
                                    <td>
                                        <span class="appointment-status ${fn:toLowerCase(appointment.statut)}">
                                            ${appointment.statut eq 'PLANNED' ? 'Prévu' :
                                              appointment.statut eq 'DONE' ? 'Terminé' : 'Annulé'}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="btn-group">
                                            <button type="button" class="btn btn-sm btn-outline-primary view-appointment"
                                                    data-id="${appointment.id}">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <c:if test="${appointment.statut eq 'PLANNED'}">
                                                <button type="button" class="btn btn-sm btn-outline-success complete-appointment"
                                                        data-id="${appointment.id}" data-patient="${appointment.patientNom}">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                                <button type="button" class="btn btn-sm btn-outline-danger cancel-appointment"
                                                        data-id="${appointment.id}" data-patient="${appointment.patientNom}">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty appointments}">
                                <tr>
                                    <td colspan="5" class="text-center py-4">
                                        <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                        <h5>Aucun rendez-vous trouvé</h5>
                                        <p class="text-muted">Aucun rendez-vous ne correspond aux critères sélectionnés</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <!-- Complete Appointment Modal -->
    <div class="modal fade" id="completeAppointmentModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Valider le rendez-vous</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Êtes-vous sûr de vouloir marquer ce rendez-vous comme terminé?</p>
                    <p class="fw-bold patient-name"></p>

                    <div class="mb-3">
                        <label for="appointmentNote" class="form-label">Note médicale (optionnelle)</label>
                        <textarea class="form-control" id="appointmentNote" rows="3" placeholder="Ajoutez une note concernant cette consultation..."></textarea>
                    </div>

                    <form id="completeAppointmentForm" action="${pageContext.request.contextPath}/doctor/appointments/update-status" method="post">
                        <input type="hidden" name="appointmentId" id="completeAppointmentId">
                        <input type="hidden" name="status" value="DONE">
                        <input type="hidden" name="note" id="completeAppointmentNote">
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-success" id="confirmCompleteBtn">Valider</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Cancel Appointment Modal -->
    <div class="modal fade" id="cancelAppointmentModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Annuler le rendez-vous</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Êtes-vous sûr de vouloir annuler ce rendez-vous?</p>
                    <p class="fw-bold patient-name"></p>
                    <form id="cancelAppointmentForm" action="${pageContext.request.contextPath}/doctor/appointments/update-status" method="post">
                        <input type="hidden" name="appointmentId" id="cancelAppointmentId">
                        <input type="hidden" name="status" value="CANCELED">
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-danger" id="confirmCancelBtn">Confirmer l'annulation</button>
                </div>
            </div>
        </div>
    </div>

    <!-- View Appointment Modal -->
    <div class="modal fade" id="viewAppointmentModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Détails du rendez-vous</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center p-4" id="appointmentLoading">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Chargement...</span>
                        </div>
                        <p class="mt-2">Chargement des détails...</p>
                    </div>

                    <div id="appointmentDetails" style="display: none;">
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="text-muted mb-3">Informations générales</h6>
                                <div class="mb-2">
                                    <strong>Date:</strong> <span id="appointmentDate"></span>
                                </div>
                                <div class="mb-2">
                                    <strong>Heure:</strong> <span id="appointmentTime"></span>
                                </div>
                                <div class="mb-2">
                                    <strong>Type:</strong> <span id="appointmentType"></span>
                                </div>
                                <div class="mb-2">
                                    <strong>Motif:</strong> <span id="appointmentReason"></span>
                                </div>
                                <div class="mb-2">
                                    <strong>Statut:</strong> <span id="appointmentStatus"></span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6 class="text-muted mb-3">Informations du patient</h6>
                                <div class="mb-2">
                                    <strong>Nom:</strong> <span id="patientName"></span>
                                </div>
                                <div class="mb-4">
                                    <button class="btn btn-sm btn-outline-primary" id="viewPatientBtn">
                                        <i class="fas fa-user-circle me-1"></i> Voir le profil complet
                                    </button>
                                </div>

                                <div id="appointmentActions">
                                    <!-- Action buttons will be dynamically added here -->
                                </div>
                            </div>
                        </div>

                        <div class="mt-4" id="medicalNoteSection" style="display: none;">
                            <h6 class="text-muted mb-3">Notes médicales</h6>
                            <div class="card">
                                <div class="card-body">
                                    <p id="medicalNoteContent"></p>
                                    <div class="text-muted small">
                                        Dernière mise à jour: <span id="medicalNoteDate"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-danger" id="appointmentError" style="display: none;">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <span id="errorMessage"></span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/doctor-script.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/fr.js"></script>
</body>
</html>