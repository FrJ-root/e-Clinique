<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Mes Rendez-vous - e-Clinique</title>
    <%@ include file="components/head.jsp" %>

    <style>
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .status-PLANNED {
            background-color: #cfe2ff;
            color: #084298;
        }

        .status-DONE {
            background-color: #d1e7dd;
            color: #0f5132;
        }

        .status-CANCELED {
            background-color: #f8d7da;
            color: #842029;
        }

        .appointment-card {
            transition: transform 0.2s;
        }

        .appointment-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <c:set var="pageTitle" value="Mes Rendez-vous" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="content-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-calendar-check me-2"></i>Mes Rendez-vous</h2>
                    <a href="${pageContext.request.contextPath}/patient/simple-booking" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Nouveau rendez-vous
                    </a>
                </div>

                <!-- Upcoming Appointments -->
                <div class="mb-5">
                    <h4 class="mb-3"><i class="fas fa-calendar-day me-2"></i>Rendez-vous à venir</h4>

                    <c:choose>
                        <c:when test="${not empty upcomingAppointments}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th><i class="fas fa-calendar me-2"></i>Date</th>
                                            <th><i class="fas fa-clock me-2"></i>Heure</th>
                                            <th><i class="fas fa-user-md me-2"></i>Médecin</th>
                                            <th><i class="fas fa-stethoscope me-2"></i>Spécialité</th>
                                            <th><i class="fas fa-info-circle me-2"></i>Statut</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="appointment" items="${upcomingAppointments}">
                                            <tr>
                                                <td>${appointment.date}</td>
                                                <td>${appointment.heureDebut} - ${appointment.heureFin}</td>
                                                <td>${appointment.doctorNom}</td>
                                                <td>${appointment.doctorSpecialty}</td>
                                                <td>
                                                    <span class="status-badge status-${appointment.statut}">
                                                        <c:choose>
                                                            <c:when test="${appointment.statut == 'PLANNED'}">Prévu</c:when>
                                                            <c:when test="${appointment.statut == 'DONE'}">Terminé</c:when>
                                                            <c:when test="${appointment.statut == 'CANCELED'}">Annulé</c:when>
                                                            <c:otherwise>${appointment.statut}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:if test="${appointment.statut == 'PLANNED'}">
                                                        <button type="button" class="btn btn-sm btn-danger"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#cancelModal${appointment.id}">
                                                            <i class="fas fa-times me-1"></i>Annuler
                                                        </button>

                                                        <!-- Cancel Confirmation Modal -->
                                                        <div class="modal fade" id="cancelModal${appointment.id}" tabindex="-1">
                                                            <div class="modal-dialog">
                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title">Confirmer l'annulation</h5>
                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <p>Êtes-vous sûr de vouloir annuler ce rendez-vous ?</p>
                                                                        <div class="alert alert-warning">
                                                                            <strong>Date:</strong> ${appointment.date}<br>
                                                                            <strong>Heure:</strong> ${appointment.heureDebut}<br>
                                                                            <strong>Médecin:</strong> ${appointment.doctorNom}
                                                                        </div>
                                                                        <p class="text-muted small">
                                                                            <i class="fas fa-info-circle me-1"></i>
                                                                            Les annulations doivent être faites au moins 12 heures à l'avance.
                                                                        </p>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                                                            Non, garder
                                                                        </button>
                                                                        <form action="${pageContext.request.contextPath}/patient/cancel-appointment" method="post" style="display: inline;">
                                                                            <input type="hidden" name="appointmentId" value="${appointment.id}">
                                                                            <button type="submit" class="btn btn-danger">
                                                                                <i class="fas fa-times me-1"></i>Oui, annuler
                                                                            </button>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                Vous n'avez aucun rendez-vous à venir.
                                <a href="${pageContext.request.contextPath}/patient/simple-booking" class="alert-link">
                                    Prendre un rendez-vous
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Past Appointments -->
                <div>
                    <h4 class="mb-3"><i class="fas fa-history me-2"></i>Historique des rendez-vous</h4>

                    <c:choose>
                        <c:when test="${not empty pastAppointments}">
                            <div class="table-responsive">
                                <table class="table table-sm">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Heure</th>
                                            <th>Médecin</th>
                                            <th>Spécialité</th>
                                            <th>Statut</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="appointment" items="${pastAppointments}">
                                            <tr>
                                                <td>${appointment.date}</td>
                                                <td>${appointment.heureDebut}</td>
                                                <td>${appointment.doctorNom}</td>
                                                <td>${appointment.doctorSpecialty}</td>
                                                <td>
                                                    <span class="status-badge status-${appointment.statut}">
                                                        <c:choose>
                                                            <c:when test="${appointment.statut == 'PLANNED'}">Prévu</c:when>
                                                            <c:when test="${appointment.statut == 'DONE'}">Terminé</c:when>
                                                            <c:when test="${appointment.statut == 'CANCELED'}">Annulé</c:when>
                                                            <c:otherwise>${appointment.statut}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-secondary">
                                <i class="fas fa-info-circle me-2"></i>
                                Aucun historique de rendez-vous.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/patient-script.js"></script>
</body>
</html>