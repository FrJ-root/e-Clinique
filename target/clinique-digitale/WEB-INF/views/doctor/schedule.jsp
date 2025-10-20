<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Mon Agenda - e-Clinique</title>
    <%@ include file="components/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-style.css">
    <style>
        .content-card {
            background: linear-gradient(135deg, #fff 0%, #f8fafd 100%);
            border-radius: 16px;
            box-shadow: 0 6px 32px rgba(0,180,216,0.08);
            padding: 28px 32px;
            margin-bottom: 32px;
        }
        .schedule-nav h3 .today-indicator {
            background: #0dcaf0;
            color: #fff;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.95em;
            margin-left: 8px;
            font-weight: 500;
        }
        .schedule-tabs {
            margin-top: 20px;
            margin-bottom: 0;
        }
        .nav-tabs .nav-link.active {
            background: linear-gradient(135deg, #0dcaf0 0%, #0098b8 100%);
            color: #fff;
            border-radius: 8px 8px 0 0;
        }
        .nav-tabs .nav-link {
            color: #0098b8;
            font-weight: 500;
            border-radius: 8px 8px 0 0;
        }
        .daily-schedule {
            display: flex;
            gap: 32px;
            margin-top: 32px;
        }
        .time-column {
            flex: 0 0 75px;
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            font-size: 0.97em;
            color: #999;
        }
        .time-slot {
            margin-bottom: 20px;
            padding-right: 10px;
        }
        .schedule-content {
            flex: 1;
            min-height: 350px;
            border-left: 2px solid #0dcaf0;
            padding-left: 32px;
        }
        .appointment-block {
            background: linear-gradient(135deg, #0dcaf0 0%, #0098b8 100%);
            color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,180,216,0.18);
            padding: 14px 22px;
            margin-bottom: 18px;
            font-size: 1em;
            position: relative;
        }
        .appointment-block .patient {
            font-weight: 600;
            font-size: 1.08em;
        }
        .appointment-block .label {
            font-size: 0.91em;
            opacity: 0.87;
        }
        .weekly-calendar {
            display: flex;
            gap: 18px;
            margin-top: 24px;
        }
        .day-column {
            flex: 1;
            background: #f7fbfc;
            border-radius: 12px;
            padding: 16px;
            box-shadow: 0 2px 10px rgba(0,180,216,0.06);
            min-width: 120px;
        }
        .day-header {
            font-weight: 700;
            font-size: 1.1em;
            margin-bottom: 7px;
            color: #0098b8;
        }
        .current-day {
            border: 2px solid #0dcaf0;
        }
        .appointment-list {
            margin: 0;
            padding: 0;
            list-style: none;
        }
        .empty-day {
            text-align: center;
            color: #999;
            font-size: 0.98em;
            padding: 8px 0;
        }
        .badge {
            font-size: 0.99em;
            padding: 6px 13px;
            border-radius: 12px;
            font-weight: 600;
        }
        .bg-primary {background: #0dcaf0 !important; color: #fff;}
        .bg-success {background: #28a745 !important; color: #fff;}
        .bg-danger {background: #dc3545 !important; color: #fff;}
        .bg-warning {background: #ffc107 !important; color: #000;}
        .table th, .table td {
            vertical-align: middle;
        }
        .table-responsive {
            border-radius: 12px;
            overflow-x: auto;
        }
        .time-slot.unavailable {
            background: #eee;
            color: #aaa;
            border-radius: 8px;
            padding: 5px 12px;
        }
        .time-slot {
            background: #cdeffc;
            color: #0098b8;
            border-radius: 8px;
            padding: 5px 12px;
            margin-right: 8px;
        }
        .card-title {
            font-weight: 700;
            color: #0098b8;
        }
        @media (max-width: 900px) {
            .weekly-calendar { flex-direction: column; }
            .day-column { margin-bottom: 16px; min-width: 0;}
        }
        @media (max-width: 600px) {
            .content-card { padding: 14px; }
            .daily-schedule { flex-direction: column; gap: 16px; }
            .schedule-content { padding-left: 8px; }
            .time-column { align-items: flex-start;}
        }
    </style>
</head>
<body>
    <c:set var="pageTitle" value="Mon Agenda" scope="request" />
    <%@ include file="components/sidebar.jsp" %>
    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>
        <div class="content-area">

            <!-- Schedule Navigation -->
            <div class="content-card mb-4">
                <div class="d-flex justify-content-between align-items-center schedule-nav">
                    <div>
                        <c:choose>
                            <c:when test="${viewType eq 'daily'}">
                                <h3 class="mb-0">
                                    <i class="fas fa-calendar-day me-2"></i>Agenda du ${formattedDate}
                                    <c:if test="${currentDate.equals(java.time.LocalDate.now())}">
                                        <span class="today-indicator">Aujourd'hui</span>
                                    </c:if>
                                </h3>
                            </c:when>
                            <c:otherwise>
                                <h3 class="mb-0">
                                    <i class="fas fa-calendar-week me-2"></i>Agenda Hebdomadaire
                                    <small class="text-muted ms-2">${weekRange}</small>
                                </h3>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="d-flex">
                        <c:choose>
                            <c:when test="${viewType eq 'daily'}">
                                <a href="${pageContext.request.contextPath}/doctor/schedule?view=daily&date=${previousDate}" class="btn btn-outline-primary me-2">
                                    <i class="fas fa-chevron-left"></i> Jour précédent
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/schedule?view=daily&date=${nextDate}" class="btn btn-outline-primary me-3">
                                    Jour suivant <i class="fas fa-chevron-right"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/doctor/schedule?view=weekly&date=${previousDate}" class="btn btn-outline-primary me-2">
                                    <i class="fas fa-chevron-left"></i> Semaine précédente
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/schedule?view=weekly&date=${nextDate}" class="btn btn-outline-primary me-3">
                                    Semaine suivante <i class="fas fa-chevron-right"></i>
                                </a>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/doctor/schedule?view=daily&date=${java.time.LocalDate.now()}" class="btn btn-primary me-2">
                            <i class="fas fa-calendar-day"></i> Aujourd'hui
                        </a>
                    </div>
                </div>

                <!-- View type tabs -->
                <ul class="nav nav-tabs schedule-tabs">
                    <li class="nav-item">
                        <a class="nav-link ${viewType eq 'daily' ? 'active' : ''}" href="${pageContext.request.contextPath}/doctor/schedule?view=daily&date=${currentDate}">
                            <i class="fas fa-calendar-day me-2"></i>Vue journalière
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${viewType eq 'weekly' ? 'active' : ''}" href="${pageContext.request.contextPath}/doctor/schedule?view=weekly&date=${currentDate}">
                            <i class="fas fa-calendar-week me-2"></i>Vue hebdomadaire
                        </a>
                    </li>
                </ul>

                <!-- Schedule content -->
                <c:choose>
                    <c:when test="${viewType eq 'daily'}">
                        <!-- Daily schedule view -->
                        <div class="daily-view mt-4">
                            <c:choose>
                                <c:when test="${empty appointments}">
                                    <div class="text-center p-5">
                                        <i class="fas fa-calendar-check fa-3x text-muted mb-3"></i>
                                        <h4>Aucun rendez-vous prévu pour cette journée</h4>
                                        <p class="text-muted">Vous n'avez pas de rendez-vous programmés pour le ${formattedDate}</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="daily-schedule">
                                        <!-- Time column -->
                                        <div class="time-column">
                                            <div class="time-slot">08:00</div>
                                            <div class="time-slot">09:00</div>
                                            <div class="time-slot">10:00</div>
                                            <div class="time-slot">11:00</div>
                                            <div class="time-slot">12:00</div>
                                            <div class="time-slot">13:00</div>
                                            <div class="time-slot">14:00</div>
                                            <div class="time-slot">15:00</div>
                                            <div class="time-slot">16:00</div>
                                            <div class="time-slot">17:00</div>
                                            <div class="time-slot">18:00</div>
                                        </div>
                                        <!-- Schedule content -->
                                        <div class="schedule-content" id="dailyScheduleContent">
                                            <c:forEach var="appointment" items="${appointments}">
                                                <div class="appointment-block">
                                                    <div>
                                                        <span class="label">Heure:</span>
                                                        <span>${appointment.heureDebut} - ${appointment.heureFin}</span>
                                                    </div>
                                                    <div>
                                                        <span class="label">Patient:</span>
                                                        <span class="patient">${appointment.patientNom}</span>
                                                    </div>
                                                    <div>
                                                        <span class="label">Type:</span>
                                                        <span>${appointment.type}</span>
                                                    </div>
                                                    <div>
                                                        <span class="label">Motif:</span>
                                                        <span>${appointment.motif}</span>
                                                    </div>
                                                    <div>
                                                        <span class="label">Statut:</span>
                                                        <span>
                                                            <span class="badge bg-${appointment.statut == 'PLANNED' ? 'primary' :
                                                                                 appointment.statut == 'DONE' ? 'success' :
                                                                                 appointment.statut == 'CANCELED' ? 'danger' : 'warning'}">
                                                                <c:choose>
                                                                    <c:when test="${appointment.statut == 'PLANNED'}">Confirmé</c:when>
                                                                    <c:when test="${appointment.statut == 'DONE'}">Terminé</c:when>
                                                                    <c:when test="${appointment.statut == 'CANCELED'}">Annulé</c:when>
                                                                    <c:otherwise>${appointment.statut}</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </span>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Weekly schedule view -->
                        <div class="weekly-view mt-4">
                            <div class="weekly-calendar">
                                <c:forEach var="day" items="${weeklySchedule}">
                                    <c:set var="isCurrentDay" value="${day.key.equals(java.time.LocalDate.now())}" />
                                    <div class="day-column ${isCurrentDay ? 'current-day' : ''}">
                                        <div class="day-header">
                                            ${formattedDays[day.key]}
                                            <c:if test="${isCurrentDay}">
                                                <span class="today-indicator">Aujourd'hui</span>
                                            </c:if>
                                        </div>
                                        <div class="day-content">
                                            <c:choose>
                                                <c:when test="${empty day.value}">
                                                    <div class="empty-day">
                                                        <i class="fas fa-calendar-check mb-2"></i><br>
                                                        Aucun rendez-vous
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <ul class="appointment-list">
                                                        <c:forEach var="appointment" items="${day.value}">
                                                            <li>
                                                                <div class="appointment-block">
                                                                    <div>
                                                                        <span class="label">Heure:</span>
                                                                        <span>${appointment.heureDebut} - ${appointment.heureFin}</span>
                                                                    </div>
                                                                    <div>
                                                                        <span class="label">Patient:</span>
                                                                        <span class="patient">${appointment.patientNom}</span>
                                                                    </div>
                                                                    <div>
                                                                        <span class="label">Type:</span>
                                                                        <span>${appointment.type}</span>
                                                                    </div>
                                                                    <div>
                                                                        <span class="label">Motif:</span>
                                                                        <span>${appointment.motif}</span>
                                                                    </div>
                                                                    <div>
                                                                        <span class="label">Statut:</span>
                                                                        <span>
                                                                            <span class="badge bg-${appointment.statut == 'PLANNED' ? 'primary' :
                                                                                                         appointment.statut == 'DONE' ? 'success' :
                                                                                                         appointment.statut == 'CANCELED' ? 'danger' : 'warning'}">
                                                                                <c:choose>
                                                                                    <c:when test="${appointment.statut == 'PLANNED'}">Confirmé</c:when>
                                                                                    <c:when test="${appointment.statut == 'DONE'}">Terminé</c:when>
                                                                                    <c:when test="${appointment.statut == 'CANCELED'}">Annulé</c:when>
                                                                                    <c:otherwise>${appointment.statut}</c:otherwise>
                                                                                </c:choose>
                                                                            </span>
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                            </li>
                                                        </c:forEach>
                                                    </ul>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Upcoming appointments quick view -->
            <div class="row">
                <div class="col-md-6 mb-4">
                    <!-- Prochains rendez-vous -->
                    <div class="content-card">
                        <h4 class="card-title">
                            <i class="fas fa-calendar-check me-2"></i>Prochains rendez-vous
                        </h4>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Heure</th>
                                        <th>Patient</th>
                                        <th>Type</th>
                                        <th>Motif</th>
                                        <th>Statut</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="appointment" items="${upcomingAppointments}" begin="0" end="4">
                                        <tr>
                                            <td>${appointment.date}</td>
                                            <td>${appointment.heureDebut} - ${appointment.heureFin}</td>
                                            <td>${appointment.patientNom}</td>
                                            <td>
                                                <c:out value="${appointment.type}" default="-" />
                                            </td>
                                            <td>
                                                <c:out value="${appointment.motif}" default="-" />
                                            </td>
                                            <td>
                                                <span class="badge bg-${appointment.statut == 'PLANNED' ? 'primary' :
                                                                       appointment.statut == 'DONE' ? 'success' :
                                                                       appointment.statut == 'CANCELED' ? 'danger' : 'warning'}">
                                                    <c:choose>
                                                        <c:when test="${appointment.statut == 'PLANNED'}">Confirmé</c:when>
                                                        <c:when test="${appointment.statut == 'DONE'}">Terminé</c:when>
                                                        <c:when test="${appointment.statut == 'CANCELED'}">Annulé</c:when>
                                                        <c:otherwise>${appointment.statut}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty upcomingAppointments}">
                                        <tr>
                                            <td colspan="6" class="text-center py-3">
                                                <i class="fas fa-calendar-check text-muted mb-2"></i><br>
                                                Aucun rendez-vous à venir
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                        <c:if test="${not empty upcomingAppointments}">
                            <div class="text-center mt-3">
                                <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-outline-primary btn-sm">
                                    <i class="fas fa-eye me-1"></i>Voir tous les rendez-vous
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="content-card">
                        <h4 class="card-title">
                            <i class="fas fa-clock me-2"></i>Disponibilités du jour
                        </h4>
                        <c:choose>
                            <c:when test="${empty availableTimeSlots}">
                                <div class="text-center p-4">
                                    <i class="fas fa-calendar-times text-muted mb-2"></i><br>
                                    <p>Aucune disponibilité définie pour cette journée</p>
                                    <a href="${pageContext.request.contextPath}/doctor/availability" class="btn btn-primary btn-sm mt-2">
                                        <i class="fas fa-plus me-1"></i>Gérer mes disponibilités
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="d-flex flex-wrap gap-2 mt-3">
                                    <c:forEach items="${availableTimeSlots}" var="slot">
                                        <div class="time-slot ${slot.available ? '' : 'unavailable'}">
                                            ${slot.startTime} - ${slot.endTime}
                                        </div>
                                    </c:forEach>
                                </div>
                                <div class="text-center mt-3">
                                    <a href="${pageContext.request.contextPath}/doctor/availability" class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-cog me-1"></i>Gérer mes disponibilités
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            <%@ include file="components/footer.jsp" %>
        </div>
    </main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/doctor-script.js"></script>
</body>
</html>