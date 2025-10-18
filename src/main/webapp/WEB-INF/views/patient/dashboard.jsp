<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Tableau de bord - e-Clinique</title>
    <%@ include file="components/head.jsp" %>
</head>
<body>
    <c:set var="pageTitle" value="Tableau de bord" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <!-- Welcome Card -->
            <div class="welcome-card">
                <h2>Bonjour, ${user.nom}</h2>
                <p>Bienvenue sur votre espace patient e-Clinique</p>
            </div>

            <!-- Info Cards -->
            <div class="info-cards">
                <div class="info-card">
                    <div class="info-card-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="info-card-content">
                        <p class="info-card-title">Rendez-vous à venir</p>
                        <h3 class="info-card-value">${upcomingAppointments.size()}</h3>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-card-icon">
                        <i class="fas fa-history"></i>
                    </div>
                    <div class="info-card-content">
                        <p class="info-card-title">Total de consultations</p>
                        <h3 class="info-card-value">${allAppointments.size()}</h3>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-card-icon">
                        <i class="fas fa-calendar-plus"></i>
                    </div>
                    <div class="info-card-content">
                        <p class="info-card-title">Prendre rendez-vous</p>
                        <button class="btn btn-sm btn-primary mt-2" onclick="window.location.href='${pageContext.request.contextPath}/patient/doctors'">
                            <i class="fas fa-plus me-1"></i>Nouveau
                        </button>
                    </div>
                </div>
            </div>

            <!-- Upcoming Appointments -->
            <div class="content-card">
                <h2 class="section-title">
                    Prochains rendez-vous
                    <div class="section-title-actions">
                        <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-outline-primary">
                            <i class="fas fa-calendar me-1"></i>Tout voir
                        </a>
                    </div>
                </h2>

                <div class="table-responsive">
                    <c:choose>
                        <c:when test="${not empty upcomingAppointments}">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Heure</th>
                                        <th>Docteur</th>
                                        <th>Spécialité</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="appointment" items="${upcomingAppointments}" varStatus="loop">
                                        <c:if test="${loop.index < 3}">
                                            <tr>
                                                <td><fmt:formatDate value="${appointment.date}" pattern="dd/MM/yyyy" /></td>
                                                <td><fmt:formatDate value="${appointment.heureDebut}" pattern="HH:mm" /></td>
                                                <td>${appointment.doctorNom}</td>
                                                <td>${appointment.doctorSpecialty}</td>
                                                <td>
                                                    <span class="status-tag status-planned">Planifié</span>
                                                </td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/patient/cancel-appointment" method="post" style="display: inline;" onsubmit="return confirm('Êtes-vous sûr de vouloir annuler ce rendez-vous ?');">
                                                        <input type="hidden" name="appointmentId" value="${appointment.id}">
                                                        <button type="submit" class="action-btn cancel">
                                                            <i class="fas fa-times me-1"></i>Annuler
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <i class="fas fa-calendar-day text-muted fa-3x mb-3"></i>
                                <p>Vous n'avez aucun rendez-vous à venir.</p>
                                <a href="${pageContext.request.contextPath}/patient/doctors" class="btn btn-primary mt-2">
                                    <i class="fas fa-plus me-1"></i>Prendre un rendez-vous
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Recent Appointments History -->
            <div class="content-card">
                <h2 class="section-title">
                    Historique récent
                    <div class="section-title-actions">
                        <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-outline-primary">
                            <i class="fas fa-history me-1"></i>Historique complet
                        </a>
                    </div>
                </h2>

                <div class="table-responsive">
                    <c:choose>
                        <c:when test="${not empty allAppointments}">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Heure</th>
                                        <th>Docteur</th>
                                        <th>Spécialité</th>
                                        <th>Statut</th>
                                        <th>Note</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:set var="count" value="0" />
                                    <c:forEach var="appointment" items="${allAppointments}" varStatus="loop">
                                        <c:if test="${appointment.statut != 'PLANNED' && count < 3}">
                                            <c:set var="count" value="${count + 1}" />
                                            <tr>
                                                <td><fmt:formatDate value="${appointment.date}" pattern="dd/MM/yyyy" /></td>
                                                <td><fmt:formatDate value="${appointment.heureDebut}" pattern="HH:mm" /></td>
                                                <td>${appointment.doctorNom}</td>
                                                <td>${appointment.doctorSpecialty}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${appointment.statut == 'DONE'}">
                                                            <span class="status-tag status-done">Terminé</span>
                                                        </c:when>
                                                        <c:when test="${appointment.statut == 'CANCELED'}">
                                                            <span class="status-tag status-canceled">Annulé</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${appointment.hasMedicalNote}">
                                                        <button type="button" class="action-btn">
                                                            <i class="fas fa-file-medical me-1"></i>Voir
                                                        </button>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${count == 0}">
                                        <tr>
                                            <td colspan="6" class="text-center py-3">Aucun historique disponible</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <i class="fas fa-history text-muted fa-3x mb-3"></i>
                                <p>Vous n'avez aucun historique de rendez-vous.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="content-card">
                <h2 class="section-title">Actions rapides</h2>

                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="card h-100">
                            <div class="card-body text-center py-4">
                                <i class="fas fa-user-md fa-3x text-primary mb-3"></i>
                                <h5 class="card-title">Trouver un médecin</h5>
                                <p class="card-text">Recherchez un médecin par spécialité</p>
                                <a href="${pageContext.request.contextPath}/patient/doctors" class="btn btn-primary">Rechercher</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card h-100">
                            <div class="card-body text-center py-4">
                                <i class="fas fa-calendar-plus fa-3x text-primary mb-3"></i>
                                <h5 class="card-title">Rendez-vous</h5>
                                <p class="card-text">Planifiez votre prochain rendez-vous</p>
                                <a href="${pageContext.request.contextPath}/patient/book-appointment" class="btn btn-primary">Réserver</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card h-100">
                            <div class="card-body text-center py-4">
                                <i class="fas fa-user-edit fa-3x text-primary mb-3"></i>
                                <h5 class="card-title">Mon profil</h5>
                                <p class="card-text">Modifier vos informations personnelles</p>
                                <a href="${pageContext.request.contextPath}/patient/profile" class="btn btn-primary">Éditer</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <!-- Bootstrap JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/js/patient-script.js"></script>
</body>
</html>