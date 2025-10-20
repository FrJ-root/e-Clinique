<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Historique des Patients - e-Clinique</title>
    <%@ include file="components/head.jsp" %>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-style.css">
    <style>
        .patient-history-header {
            background-color: rgba(var(--bs-primary-rgb), 0.1);
            border-left: 5px solid var(--primary);
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 5px;
        }
        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .status-badge.done {
            background-color: rgba(40, 167, 69, 0.1);
            color: #28a745;
        }
        .status-badge.planned {
            background-color: rgba(0, 123, 255, 0.1);
            color: #007bff;
        }
        .status-badge.canceled {
            background-color: rgba(220, 53, 69, 0.1);
            color: #dc3545;
        }
        .timeline {
            position: relative;
            padding-left: 30px;
        }
        .timeline::before {
            content: "";
            position: absolute;
            top: 0;
            bottom: 0;
            left: 12px;
            width: 2px;
            background-color: var(--border-color);
        }
        .timeline-item {
            position: relative;
            margin-bottom: 25px;
        }
        .timeline-item::before {
            content: "";
            position: absolute;
            left: -30px;
            top: 5px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: var(--primary);
        }
        .timeline-item.done::before {
            background-color: #28a745;
        }
        .timeline-item.canceled::before {
            background-color: #dc3545;
        }
        .timeline-item.planned::before {
            background-color: #007bff;
        }
        .timeline-date {
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 5px;
        }
        .timeline-content {
            padding: 15px;
            border-radius: 5px;
            background-color: var(--card-bg);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        .filter-section {
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            background-color: var(--card-bg);
        }
        .date-range-picker {
            max-width: 100%;
        }
        .consultation-card {
            transition: all 0.2s ease;
        }
        .consultation-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        .patient-summary {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .patient-name {
            color: var(--primary);
            font-weight: 600;
            font-size: 1.1rem;
        }
    </style>
</head>
<body>
    <c:set var="pageTitle" value="Historique des Patients" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                </div>
            </c:if>

            <div class="content-card mb-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="mb-0">
                        <i class="fas fa-history me-2"></i>${filterTitle}
                    </h3>
                </div>

                <!-- Filter Section -->
                <div class="filter-section">
                    <div class="row">
                        <div class="col-md-7">
                            <h5 class="mb-3">Période</h5>
                            <div class="d-flex flex-wrap gap-2 mb-3">
                                <a href="${pageContext.request.contextPath}/doctor/patient-history?timeFilter=last7days"
                                   class="btn ${timeFilter eq 'last7days' ? 'btn-primary' : 'btn-outline-primary'}">
                                    7 derniers jours
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/patient-history?timeFilter=last30days"
                                   class="btn ${timeFilter eq 'last30days' ? 'btn-primary' : 'btn-outline-primary'}">
                                    30 derniers jours
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/patient-history?timeFilter=last3months"
                                   class="btn ${timeFilter eq 'last3months' ? 'btn-primary' : 'btn-outline-primary'}">
                                    3 derniers mois
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/patient-history?timeFilter=last6months"
                                   class="btn ${timeFilter eq 'last6months' ? 'btn-primary' : 'btn-outline-primary'}">
                                    6 derniers mois
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/patient-history?timeFilter=lastyear"
                                   class="btn ${timeFilter eq 'lastyear' ? 'btn-primary' : 'btn-outline-primary'}">
                                    Année passée
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/patient-history"
                                   class="btn ${empty timeFilter || timeFilter eq 'all' ? 'btn-primary' : 'btn-outline-primary'}">
                                    Tout
                                </a>
                            </div>

                            <div class="mt-3 mb-3">
                                <form action="${pageContext.request.contextPath}/doctor/patient-history" method="get" class="d-flex gap-2 align-items-end">
                                    <input type="hidden" name="timeFilter" value="custom">
                                    <div class="flex-grow-1">
                                        <label for="dateRange" class="form-label">Période personnalisée</label>
                                        <input type="text" name="dateRange" id="dateRange" class="form-control date-range-picker"
                                               placeholder="Sélectionner une période" value="${dateRangeStr}">
                                    </div>
                                    <button type="submit" class="btn btn-primary">Appliquer</button>
                                </form>
                            </div>
                        </div>

                        <div class="col-md-5">
                            <h5 class="mb-3">Filtrer par statut</h5>
                            <div class="d-flex flex-wrap gap-2">
                                <a href="${pageContext.request.contextPath}/doctor/patient-history?timeFilter=${timeFilter}&statusFilter=all"
                                   class="btn ${statusFilter eq 'all' || empty statusFilter ? 'btn-primary' : 'btn-outline-primary'}">
                                    Tous
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/patient-history?timeFilter=${timeFilter}&statusFilter=planned"
                                   class="btn ${statusFilter eq 'planned' ? 'btn-primary' : 'btn-outline-primary'}">
                                    <span class="status-badge planned me-1">•</span>Prévus
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/patient-history?timeFilter=${timeFilter}&statusFilter=done"
                                   class="btn ${statusFilter eq 'done' ? 'btn-primary' : 'btn-outline-primary'}">
                                    <span class="status-badge done me-1">•</span>Terminés
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/patient-history?timeFilter=${timeFilter}&statusFilter=canceled"
                                   class="btn ${statusFilter eq 'canceled' ? 'btn-primary' : 'btn-outline-primary'}">
                                    <span class="status-badge canceled me-1">•</span>Annulés
                                </a>
                            </div>

                            <div class="mt-4">
                                <div class="card">
                                    <div class="card-body">
                                        <h6 class="card-title">Statistiques</h6>
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Total patients:</span>
                                            <span class="badge bg-primary">${totalPatients}</span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Total consultations:</span>
                                            <span class="badge bg-info">${totalAppointments}</span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Moyenne par patient:</span>
                                            <span class="badge bg-secondary"><fmt:formatNumber value="${avgAppointmentsPerPatient}" maxFractionDigits="1"/></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Appointment History -->
                <div class="mt-4">
                    <c:choose>
                        <c:when test="${empty appointmentsByPatient}">
                            <div class="text-center p-5">
                                <i class="fas fa-history fa-3x text-muted mb-3"></i>
                                <h4>Aucun historique trouvé</h4>
                                <p class="text-muted">Aucune consultation ne correspond aux critères sélectionnés</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Group by patient -->
                            <c:forEach var="patientEntry" items="${appointmentsByPatient}">
                                <c:set var="patientId" value="${patientEntry.key}" />
                                <c:set var="patientAppointments" value="${patientEntry.value}" />
                                <c:set var="patient" value="${patients[patientId]}" />

                                <div class="patient-history-header">
                                    <div class="row align-items-center">
                                        <div class="col-md-5">
                                            <h5 class="patient-name mb-0">${patient.nom} ${patient.prenom}</h5>
                                            <div class="small text-muted">
                                                <c:if test="${not empty patient.dateNaissance}">
                                                    <fmt:parseDate value="${patient.dateNaissance}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" /> (${patient.age} ans)
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="small">
                                                <i class="fas fa-calendar-check me-1"></i>
                                                <b>${fn:length(patientAppointments)}</b> consultations
                                            </div>
                                            <div class="small">
                                                <i class="fas fa-user-md me-1"></i>
                                                Patient depuis:
                                                <c:set var="firstVisit" value="${patientAppointments[fn:length(patientAppointments)-1]}" />
                                                <fmt:parseDate value="${firstVisit.date}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                                <fmt:formatDate value="${parsedDate}" pattern="MM/yyyy" />
                                            </div>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <a href="${pageContext.request.contextPath}/doctor/patients/view?id=${patientId}" class="btn btn-sm btn-primary">
                                                <i class="fas fa-folder-open me-1"></i>Dossier complet
                                            </a>
                                        </div>
                                    </div>
                                </div>

                                <div class="timeline mb-5">
                                    <c:forEach var="appointment" items="${patientAppointments}">
                                        <div class="timeline-item ${fn:toLowerCase(appointment.statut)}">
                                            <div class="timeline-date">
                                                <fmt:parseDate value="${appointment.date}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                                <fmt:formatDate value="${parsedDate}" pattern="dd MMMM yyyy" />
                                            </div>
                                            <div class="timeline-content consultation-card">
                                                <div class="row">
                                                    <div class="col-md-3">
                                                        <div class="mb-2">
                                                            <i class="fas fa-clock me-1"></i>
                                                            ${appointment.heureDebut} - ${appointment.heureFin}
                                                        </div>
                                                        <span class="status-badge ${fn:toLowerCase(appointment.statut)}">
                                                            ${appointment.statut eq 'PLANNED' ? 'Prévu' :
                                                              appointment.statut eq 'DONE' ? 'Terminé' : 'Annulé'}
                                                        </span>
                                                    </div>
                                                    <div class="col-md-5">
                                                        <div class="mb-1">
                                                            <strong>Type:</strong> ${not empty appointment.type ? appointment.type : 'Consultation standard'}
                                                        </div>
                                                        <div>
                                                            <strong>Motif:</strong> ${not empty appointment.motif ? appointment.motif : 'Non spécifié'}
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4 text-end">
                                                        <c:if test="${appointment.hasMedicalNote}">
                                                            <button class="btn btn-sm btn-outline-primary view-note" data-id="${appointment.id}">
                                                                <i class="fas fa-clipboard-list me-1"></i>Voir notes
                                                            </button>
                                                        </c:if>
                                                        <c:if test="${appointment.statut eq 'DONE' && !appointment.hasMedicalNote}">
                                                            <a href="${pageContext.request.contextPath}/doctor/medical-notes?appointmentId=${appointment.id}" class="btn btn-sm btn-outline-success">
                                                                <i class="fas fa-plus me-1"></i>Ajouter notes
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

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
                                <h6 class="text-muted mb-3">Consultation</h6>
                                <div class="mb-2">
                                    <strong>Patient:</strong> <span id="patientName"></span>
                                </div>
                                <div class="mb-2">
                                    <strong>Date:</strong> <span id="appointmentDate"></span>
                                </div>
                                <div class="mb-2">
                                    <strong>Heure:</strong> <span id="appointmentTime"></span>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <h6 class="text-muted mb-3">Notes médicales</h6>
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
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/fr.js"></script>
    <script>
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
                            const patient = data.patient || { nom: appointment.patientNom };

                            // Format date
                            const date = new Date(appointment.date);
                            const formattedDate = date.toLocaleDateString('fr-FR', {
                                day: '2-digit',
                                month: '2-digit',
                                year: 'numeric'
                            });

                            // Populate details
                            document.getElementById('patientName').textContent = patient.nom;
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
        });
    </script>
</body>
</html>