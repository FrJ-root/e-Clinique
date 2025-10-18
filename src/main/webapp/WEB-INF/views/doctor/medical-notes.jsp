<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Notes Médicales - e-Clinique</title>
    <%@ include file="components/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-style.css">
</head>
<body>
    <c:set var="pageTitle" value="Notes Médicales" scope="request" />
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
                            <a href="${pageContext.request.contextPath}/doctor/medical-notes"
                               class="btn ${filter eq 'all' || empty filter ? 'btn-primary' : 'btn-outline-primary'}">
                                <i class="fas fa-list me-1"></i>Toutes les notes
                            </a>
                            <a href="${pageContext.request.contextPath}/doctor/medical-notes?filter=pending"
                               class="btn ${filter eq 'pending' ? 'btn-primary' : 'btn-outline-primary'}">
                                <i class="fas fa-clipboard me-1"></i>Notes à remplir
                            </a>
                            <a href="${pageContext.request.contextPath}/doctor/medical-notes?filter=recent"
                               class="btn ${filter eq 'recent' ? 'btn-primary' : 'btn-outline-primary'}">
                                <i class="fas fa-calendar-alt me-1"></i>Récentes
                            </a>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title mb-3">Statistiques</h5>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Notes rédigées:</span>
                                    <span class="badge bg-success">${totalWithNotes}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>À compléter:</span>
                                    <span class="badge bg-warning">${totalWithoutNotes}</span>
                                </div>
                                <div class="d-flex justify-content-between fw-bold">
                                    <span>Total:</span>
                                    <span class="badge bg-dark">${totalWithNotes + totalWithoutNotes}</span>
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
                                <th>Notes</th>
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
                                        <c:choose>
                                            <c:when test="${appointment.hasMedicalNote}">
                                                <span class="has-notes-badge">
                                                    <i class="fas fa-check-circle me-1"></i>Complétée
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="no-notes-badge">
                                                    <i class="fas fa-exclamation-circle me-1"></i>À remplir
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group">
                                            <button type="button" class="btn btn-sm btn-outline-primary view-note"
                                                    data-id="${appointment.id}" data-has-note="${appointment.hasMedicalNote}">
                                                <i class="fas fa-${appointment.hasMedicalNote ? 'eye' : 'edit'}"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty appointments}">
                                <tr>
                                    <td colspan="5" class="text-center py-4">
                                        <i class="fas fa-clipboard-list fa-3x text-muted mb-3"></i>
                                        <h5>Aucun rendez-vous trouvé</h5>
                                        <p class="text-muted">Aucun rendez-vous terminé ne correspond aux critères sélectionnés</p>
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

    <!-- Medical Note Modal -->
    <div class="modal fade" id="medicalNoteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="medicalNoteModalTitle">Notes médicales</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center p-4" id="noteLoading">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Chargement...</span>
                        </div>
                        <p class="mt-2">Chargement des détails...</p>
                    </div>

                    <div id="noteDetails" style="display: none;">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h6 class="text-muted mb-3">Informations du rendez-vous</h6>
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
                            </div>
                            <div class="col-md-6">
                                <h6 class="text-muted mb-3">Informations du patient</h6>
                                <div class="mb-2">
                                    <strong>Nom:</strong> <span id="patientName"></span>
                                </div>
                                <div class="mb-2">
                                    <button class="btn btn-sm btn-outline-primary" id="viewPatientBtn">
                                        <i class="fas fa-user-circle me-1"></i> Voir le dossier médical
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <h6 class="text-muted mb-3">Notes médicales</h6>
                            <div id="viewModeControls" class="mb-3">
                                <div class="card">
                                    <div class="card-body">
                                        <div id="noteContent" class="mb-2"></div>
                                        <div class="text-muted small">
                                            <span id="hasLastUpdate">Dernière mise à jour: <span id="noteUpdateDate"></span></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="text-end mt-3">
                                    <button class="btn btn-primary" id="editNoteBtn">
                                        <i class="fas fa-edit me-1"></i> Modifier
                                    </button>
                                </div>
                            </div>

                            <div id="editModeControls" style="display: none;">
                                <textarea class="form-control note-editor mb-3" id="noteEditor" rows="10" placeholder="Saisissez vos notes médicales ici..."></textarea>
                                <div class="text-end">
                                    <button class="btn btn-secondary me-2" id="cancelEditBtn">Annuler</button>
                                    <button class="btn btn-success" id="saveNoteBtn">
                                        <i class="fas fa-save me-1"></i> Enregistrer
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-danger" id="noteError" style="display: none;">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <span id="errorMessage"></span>
                    </div>

                    <form id="saveNoteForm" action="${pageContext.request.contextPath}/doctor/medical-notes/save" method="post" style="display: none;">
                        <input type="hidden" name="appointmentId" id="noteAppointmentId">
                        <input type="hidden" name="noteContent" id="noteFormContent">
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/doctor-script.js"></script>
</body>
</html>