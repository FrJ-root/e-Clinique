<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Tableau de Bord - e-Clinique</title>
    <%@ include file="components/head.jsp" %>

    <style>
        .stat-card {
            background: var(--card-light);
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 20px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 10px;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            color: var(--primary);
        }

        .stat-label {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .quick-action-btn {
            width: 100%;
            padding: 15px;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .quick-action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>
    <c:set var="pageTitle" value="Tableau de Bord" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <!-- Welcome Section -->
            <div class="mb-4">
                <h2 class="mb-2">Bienvenue, ${sessionScope.user.nom} !</h2>
                <p class="text-muted">Voici un aperçu de vos rendez-vous</p>
            </div>

            <!-- Statistics Cards -->
            <div class="row mb-4">
                <div class="col-md-4 mb-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background-color: rgba(0, 180, 216, 0.1); color: var(--primary);">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-value">${upcomingCount}</div>
                        <div class="stat-label">Rendez-vous à venir</div>
                    </div>
                </div>

                <div class="col-md-4 mb-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background-color: rgba(40, 167, 69, 0.1); color: #28a745;">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="stat-value">${completedCount}</div>
                        <div class="stat-label">Rendez-vous terminés</div>
                    </div>
                </div>

                <div class="col-md-4 mb-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background-color: rgba(255, 193, 7, 0.1); color: #ffc107;">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div class="stat-value">${totalAppointments}</div>
                        <div class="stat-label">Total rendez-vous</div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="row mb-4">
                <div class="col-md-4 mb-3">
                    <a href="${pageContext.request.contextPath}/patient/simple-booking" class="btn btn-primary quick-action-btn">
                        <i class="fas fa-calendar-plus me-2"></i>Prendre un rendez-vous
                    </a>
                </div>
                <div class="col-md-4 mb-3">
                    <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-outline-primary quick-action-btn">
                        <i class="fas fa-list me-2"></i>Voir mes rendez-vous
                    </a>
                </div>
                <div class="col-md-4 mb-3">
                    <a href="${pageContext.request.contextPath}/patient/search-doctors" class="btn btn-outline-secondary quick-action-btn">
                        <i class="fas fa-search me-2"></i>Rechercher un médecin
                    </a>
                </div>
            </div>

            <!-- Upcoming Appointments -->
            <div class="content-card">
                <h4 class="mb-3"><i class="fas fa-calendar-day me-2"></i>Prochains rendez-vous</h4>

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
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="appointment" items="${upcomingAppointments}" varStatus="loop">
                                        <c:if test="${loop.index < 5}">
                                            <tr>
                                                <td><strong>${appointment.date}</strong></td>
                                                <td>${appointment.heureDebut}</td>
                                                <td>${appointment.doctorNom}</td>
                                                <td>${appointment.doctorSpecialty}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/patient/appointments"
                                                       class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-eye me-1"></i>Détails
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <c:if test="${fn:length(upcomingAppointments) > 5}">
                            <div class="text-center mt-3">
                                <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-primary">
                                    Voir tous les rendez-vous
                                </a>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            Vous n'avez aucun rendez-vous prévu.
                            <a href="${pageContext.request.contextPath}/patient/simple-booking" class="alert-link">
                                Prendre un rendez-vous maintenant
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/patient-script.js"></script>
</body>
</html>