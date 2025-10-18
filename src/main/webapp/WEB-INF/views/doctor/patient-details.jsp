<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Dossier Patient - ${patient.nom} ${patient.prenom} - e-Clinique</title>
    <%@ include file="components/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-style.css">
    <style>
        .patient-info-card {
            border-left: 5px solid var(--primary);
        }
        .medical-note-card {
            margin-bottom: 15px;
            border-radius: 8px;
        }
        .medical-note-date {
            color: var(--primary);
            font-weight: 600;
            font-size: 0.85rem;
        }
        .appointment-item {
            padding: 10px;
            border-left: 3px solid transparent;
            margin-bottom: 10px;
            border-radius: 8px;
            transition: all 0.2s;
        }
        .appointment-item:hover {
            background-color: rgba(0, 123, 255, 0.05);
            transform: translateX(5px);
        }
        .appointment-item.past {
            border-left-color: #6c757d;
        }
        .appointment-item.upcoming {
            border-left-color: #28a745;
        }
        .appointment-item.canceled {
            border-left-color: #dc3545;
            opacity: 0.7;
        }
        .appointment-date {
            font-weight: 600;
        }
        .tab-pane {
            padding: 20px 0;
        }
        .patient-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            font-weight: 600;
            margin: 0 auto 15px;
        }
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .status-badge.active {
            background-color: rgba(40, 167, 69, 0.1);
            color: #28a745;
        }
        .status-badge.inactive {
            background-color: rgba(108, 117, 125, 0.1);
            color: #6c757d;
        }
    </style>
</head>
<body>
    <c:set var="pageTitle" value="Dossier Patient" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                </div>
            </c:if>

            <c:if test="${not empty patient}">
                <!-- Patient info -->
                <div class="content-card mb-4">
                    <div class="row">
                        <div class="col-md-3 text-center">
                            <div class="patient-avatar">
                                ${fn:substring(patient.nom, 0, 1)}
                            </div>
                            <h4>${patient.nom} ${patient.prenom}</h4>
                            <p>
                                <span class="status-badge ${patient.actif ? 'active' : 'inactive'}">
                                    ${patient.actif ? 'Actif' : 'Inactif'}
                                </span>
                            </p>
                            <div class="mt-3">
                                <button class="btn btn-primary btn-sm" onclick="window.location.href='${pageContext.request.contextPath}/appointment/new?patientId=${patient.id}'">
                                    <i class="fas fa-calendar-plus me-1"></i>Nouveau RDV
                                </button>
                            </div>
                        </div>

                        <div class="col-md-9">
                            <div class="row">
                                <div class="col-md-6">
                                    <h5>Informations personnelles</h5>
                                    <table class="table table-sm">
                                        <tr>
                                            <td><strong>Date de naissance:</strong></td>
                                            <td>
                                                <c:if test="${not empty patient.dateNaissance}">
                                                    <fmt:parseDate value="${patient.dateNaissance}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                                                    (${patient.age} ans)
                                                </c:if>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Sexe:</strong></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${patient.sexe == 'M'}">Homme</c:when>
                                                    <c:when test="${patient.sexe == 'F'}">Femme</c:when>
                                                    <c:otherwise>Non spécifié</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>NSS:</strong></td>
                                            <td>${patient.numeroSecuriteSociale}</td>
                                        </tr>
                                    </table>
                                </div>

                                <div class="col-md-6">
                                    <h5>Contact</h5>
                                    <table class="table table-sm">
                                        <tr>
                                            <td><i class="fas fa-envelope me-2"></i></td>
                                            <td>${patient.email}</td>
                                        </tr>
                                        <tr>
                                            <td><i class="fas fa-phone me-2"></i></td>
                                            <td>${patient.telephone}</td>
                                        </tr>
                                        <tr>
                                            <td><i class="fas fa-map-marker-alt me-2"></i></td>
                                            <td>${patient.adresse}</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>

                            <div class="row mt-3">
                                <div class="col-md-12">
                                    <h5>Statistiques</h5>
                                    <div class="row">
                                        <div class="col-4">
                                            <div class="card text-center">
                                                <div class="card-body">
                                                    <h3 class="card-title">${totalAppointments}</h3>
                                                    <p class="card-text">Total RDV</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-4">
                                            <div class="card text-center">
                                                <div class="card-body">
                                                    <h3 class="card-title">${upcomingAppointments}</h3>
                                                    <p class="card-text">RDV à venir</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-4">
                                            <div class="card text-center">
                                                <div class="card-body">
                                                    <h3 class="card-title">${pastAppointments}</h3>
                                                    <p class="card-text">RDV passés</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Patient medical data tabs -->
                <div class="content-card">
                    <ul class="nav nav-tabs" id="patientTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="history-tab" data-bs-toggle="tab" data-bs-target="#history"
                                    type="button" role="tab" aria-controls="history" aria-selected="true">
                                <i class="fas fa-history me-1"></i>Historique des visites
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="notes-tab" data-bs-toggle="tab" data-bs-target="#notes"
                                    type="button" role="tab" aria-controls="notes" aria-selected="false">
                                <i class="fas fa-notes-medical me-1"></i>Notes médicales
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="patientTabsContent">
                        <!-- Appointment History Tab -->
                        <div class="tab-pane fade show active" id="history" role="tabpanel" aria-labelledby="history-tab">
                            <h5 class="mb-3">Historique des rendez-vous</h5>

                            <c:choose>
                                <c:when test="${empty appointments}">
                                    <div class="text-center p-4">
                                        <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                        <h5>Aucun rendez-vous</h5>
                                        <p class="text-muted">Ce patient n'a pas encore eu de rendez-vous avec vous</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="list-group">
                                        <c:forEach var="appointment" items="${appointments}">
                                            <c:set var="isUpcoming" value="false" />
                                            <c:set var="isPast" value="false" />
                                            <c:set var="isCanceled" value="false" />

                                            <c:choose>
                                                <c:when test="${appointment.statut == 'CANCELED'}">
                                                    <c:set var="isCanceled" value="true" />
                                                </c:when>
                                                <c:when test="${appointment.date gt localDate.now()}">
                                                    <c:set var="isUpcoming" value="true" />
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="isPast" value="true" />
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="appointment-item ${isUpcoming ? 'upcoming' : isPast ? 'past' : 'canceled'}">
                                                <div class="row">
                                                    <div class="col-md-3">
                                                        <div class="appointment-date">
                                                            <fmt:parseDate value="${appointment.date}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                                                        </div>
                                                        <div class="appointment-time">${appointment.heureDebut} - ${appointment.heureFin}</div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div>
                                                            <strong>Type:</strong> ${appointment.type || 'Consultation standard'}
                                                        </div>
                                                        <div>
                                                            <strong>Motif:</strong> ${appointment.motif || 'Non spécifié'}
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <span class="badge ${appointment.statut eq 'PLANNED' ? 'bg-primary' :
                                                                            appointment.statut eq 'DONE' ? 'bg-success' :
                                                                            'bg-danger'}">
                                                            ${appointment.statut eq 'PLANNED' ? 'Prévu' :
                                                             appointment.statut eq 'DONE' ? 'Terminé' : 'Annulé'}
                                                        </span>
                                                        <c:if test="${appointment.hasMedicalNote}">
                                                            <span class="badge bg-info ms-1">
                                                                <i class="fas fa-notes-medical me-1"></i>Avec notes
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                    <div class="col-md-3 text-end">
                                                        <c:if test="${appointment.hasMedicalNote}">
                                                            <button class="btn btn-sm btn-outline-primary view-note" data-id="${appointment.id}">
                                                                <i class="fas fa-eye me-1"></i>Voir notes
                                                            </button>
                                                        </c:if>
                                                        <c:if test="${appointment.statut eq 'DONE' && !appointment.hasMedicalNote}">
                                                            <a href="${pageContext.request.contextPath}/doctor/medical-notes?filter=patient&patientId=${patient.id}"
                                                               class="btn btn-sm btn-outline-success">
                                                                <i class="fas fa-plus me-1"></i>Ajouter notes
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Medical Notes Tab -->
                        <div class="tab-pane fade" id="notes" role="tabpanel" aria-labelledby="notes-tab">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5>Notes médicales</h5>
                                <a href="${pageContext.request.contextPath}/doctor/medical-notes?filter=patient&patientId=${patient.id}"
                                   class="btn btn-sm btn-primary">
                                    <i class="fas fa-external-link-alt me-1"></i>Toutes les notes
                                </a>
                            </div>

                            <c:choose>
                                <c:when test="${empty medicalNotes}">
                                    <div class="text-center p-4">
                                        <i class="fas fa-clipboard-list fa-3x text-muted mb-3"></i>
                                        <h5>Aucune note médicale</h5>
                                        <p class="text-muted">Vous n'avez pas encore ajouté de notes pour ce patient</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="accordion" id="medicalNotesAccordion">
                                        <c:forEach var="note" items="${medicalNotes}" varStatus="status">
                                            <div class="accordion-item medical-note-card">
                                                <h2 class="accordion-header" id="heading${status.index}">
                                                    <button class="accordion-button ${status.index > 0 ? 'collapsed' : ''}" type="button"
                                                            data-bs-toggle="collapse" data-bs-target="#collapse${status.index}"
                                                            aria-expanded="${status.index == 0}" aria-controls="collapse${status.index}">
                                                        <div class="d-flex w-100 justify-content-between align-items-center">
                                                            <span class="medical-note-date">
                                                                <fmt:parseDate value="${note.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDateTime" type="both" />
                                                                <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy" />
                                                            </span>
                                                            <span class="badge bg-secondary">Consultation</span>
                                                        </div>
                                                    </button>
                                                </h2>
                                                <div id="collapse${status.index}" class="accordion-collapse collapse ${status.index == 0 ? 'show' : ''}"
                                                     aria-labelledby="heading${status.index}" data-bs-parent="#medicalNotesAccordion">
                                                    <div class="accordion-body">
                                                        <p class="medical-note-content">${note.note}</p>
                                                        <div class="text-end">
                                                            <small class="text-muted">
                                                                Dernière mise à jour:
                                                                <fmt:parseDate value="${note.updatedAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDateTime" type="both" />
                                                                <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy HH:mm" />
                                                            </small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:if>

            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <!-- View Medical Note Modal -->
    <div class="modal fade" id="medicalNoteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Note Médicale</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center p-4" id="noteLoading">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Chargement...</span>
                        </div>
                        <p class="mt-2">Chargement de la note médicale...</p>
                    </div>

                    <div id="noteDetails" style="display: none;">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h6 class="text-muted mb-3">Rendez-vous</h6>
                                <div class="mb-2">
                                    <strong>Date:</strong> <span id="appointmentDate"></span>
                                </div>
                                <div class="mb-2">
                                    <strong>Heure:</strong> <span id="appointmentTime"></span>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <h6 class="text-muted mb-3">Note médicale</h6>
                            <div class="card">
                                <div class="card-body">
                                    <p id="noteContent"></p>
                                    <div class="text-muted small text-end">
                                        Dernière mise à jour: <span id="noteUpdateDate"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-danger" id="noteError" style="display: none;">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <span id="errorMessage"></span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                    <a href="#" class="btn btn-primary" id="editNoteBtn">
                        <i class="fas fa-edit me-1"></i>Modifier
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/doctor-script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // View medical note details
            document.querySelectorAll('.view-note').forEach(button => {
                button.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    viewMedicalNote(id);
                });
            });

            // Function to view medical note
            function viewMedicalNote(appointmentId) {
                // Reset and show modal
                document.getElementById('noteLoading').style.display = 'block';
                document.getElementById('noteDetails').style.display = 'none';
                document.getElementById('noteError').style.display = 'none';

                const modal = new bootstrap.Modal(document.getElementById('medicalNoteModal'));
                modal.show();

                // Fetch note details
                fetch(`${pageContext.request.contextPath}/doctor/medical-notes/details?appointmentId=${appointmentId}`)
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('noteLoading').style.display = 'none';

                        if (data.success) {
                            const appointment = data.appointment;
                            const medicalNote = data.medicalNote;

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

                            // Set note content
                            document.getElementById('noteContent').textContent = medicalNote.note;

                            // Format update date
                            const updatedAt = new Date(medicalNote.updatedAt || medicalNote.createdAt);
                            document.getElementById('noteUpdateDate').textContent = updatedAt.toLocaleString('fr-FR');

                            // Set edit button link
                            document.getElementById('editNoteBtn').href =
                                `${pageContext.request.contextPath}/doctor/medical-notes?appointmentId=${appointmentId}`;

                            // Show the details
                            document.getElementById('noteDetails').style.display = 'block';
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

            // Store the active tab in local storage
            const tabEls = document.querySelectorAll('button[data-bs-toggle="tab"]');
            tabEls.forEach(tabEl => {
                tabEl.addEventListener('shown.bs.tab', function (e) {
                    localStorage.setItem('doctorPatientActiveTab', e.target.id);
                });
            });

            // Restore the active tab
            const activeTab = localStorage.getItem('doctorPatientActiveTab');
            if (activeTab) {
                const tab = document.querySelector(`#${activeTab}`);
                if (tab) {
                    const bsTab = new bootstrap.Tab(tab);
                    bsTab.show();
                }
            }
        });
    </script>
</body>
</html>