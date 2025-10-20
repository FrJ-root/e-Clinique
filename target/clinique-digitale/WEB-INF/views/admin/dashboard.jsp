<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Tableau de bord - Administration e-Clinique</title>
    <%@ include file="components/common-head.jsp" %>
</head>
<body>
    <c:set var="pageTitle" value="Tableau de bord administrateur" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <div class="welcome-card">
                <h2>Bienvenue, ${user.nom}</h2>
                <p>
                    <fmt:formatDate value="${now}" pattern="EEEE dd MMMM yyyy" />
                    - Panel d'administration e-Clinique
                </p>
            </div>

            <div class="info-cards">
                <div class="info-card">
                    <div class="info-card-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="info-card-content">
                        <h5 class="info-card-title">Doctors</h5>
                        <h3 class="info-card-value">${totalDoctors}</h3>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-card-icon">
                        <i class="fas fa-user-injured"></i>
                    </div>
                    <div class="info-card-content">
                        <h5 class="info-card-title">Patients</h5>
                        <h3 class="info-card-value">${totalPatients}</h3>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-card-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="info-card-content">
                        <h5 class="info-card-title">RDV aujourd'hui</h5>
                        <h3 class="info-card-value">${appointmentsToday}</h3>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-card-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <div class="info-card-content">
                        <h5 class="info-card-title">Taux d'occupation</h5>
                        <h3 class="info-card-value">${occupancyRate}%</h3>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-8">
                    <div class="content-card">
                        <h3 class="section-title">
                            Rendez-vous d'aujourd'hui
                            <div class="section-title-actions">
                                <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-sm btn-outline-primary">Voir tous</a>
                            </div>
                        </h3>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Patient</th>
                                        <th>Doctor</th>
                                        <th>Heure</th>
                                        <th>Statut</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${todaysAppointments}" var="appointment">
                                        <tr>
                                            <td>${appointment.patientName}</td>
                                            <td>Dr. ${appointment.doctorName}</td>
                                            <td>
                                                <fmt:formatDate value="${appointment.startTime}" pattern="HH:mm" /> -
                                                <fmt:formatDate value="${appointment.endTime}" pattern="HH:mm" />
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${appointment.status == 'COMPLETED'}">
                                                        <span class="badge bg-success">Terminé</span>
                                                    </c:when>
                                                    <c:when test="${appointment.status == 'CANCELLED'}">
                                                        <span class="badge bg-danger">Annulé</span>
                                                    </c:when>
                                                    <c:when test="${appointment.status == 'CONFIRMED'}">
                                                        <span class="badge bg-primary">Confirmé</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning">Planifié</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty todaysAppointments}">
                                        <tr>
                                            <td colspan="4" class="text-center">Aucun rendez-vous aujourd'hui</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="content-card">
                        <h3 class="section-title">
                            Utilisateurs récents
                            <div class="section-title-actions">
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-outline-primary">Gérer</a>
                            </div>
                        </h3>
                        <ul class="list-group list-group-flush user-list">
                            <c:forEach items="${recentUsers}" var="recentUser">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <div>
                                        <span class="user-name">${recentUser.nom}</span>
                                        <small class="text-muted d-block">${recentUser.email}</small>
                                    </div>
                                    <span class="badge bg-primary rounded-pill">${recentUser.role}</span>
                                </li>
                            </c:forEach>
                            <c:if test="${empty recentUsers}">
                                <li class="list-group-item text-center">Aucun utilisateur récent</li>
                            </c:if>
                        </ul>
                    </div>
                    <div class="content-card">
                        <h3 class="section-title">
                            Statistiques
                        </h3>
                        <div class="stat-item d-flex justify-content-between mb-3">
                            <span>Total RDV</span>
                            <span class="fw-bold">${totalAppointments}</span>
                        </div>
                        <div class="stat-item d-flex justify-content-between mb-3">
                            <span>Annulations (7j)</span>
                            <span class="fw-bold text-danger">${cancellationsThisWeek}</span>
                        </div>
                        <div class="stat-item d-flex justify-content-between">
                            <span>Taux de complétion</span>
                            <span class="fw-bold text-success">87%</span>
                        </div>
                    </div>
                </div>
            </div>

            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <%@ include file="components/common-scripts.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</body>
</html>