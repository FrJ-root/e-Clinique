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
                                            <!-- Appointments will be dynamically added here by JavaScript -->
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
                                                    <c:forEach var="appointment" items="${appointments}" varStatus="status">
                                                    {
                                                        id: "${appointment.id}",
                                                        patientName: "${appointment.patientNom}",
                                                        type: "${appointment.type}",
                                                        status: "${appointment.statut}",
                                                        start: {
                                                            hour: ${appointment.heureDebut.hour},
                                                            minute: ${appointment.heureDebut.minute}
                                                        },
                                                        end: {
                                                            hour: ${appointment.heureFin.hour},
                                                            minute: ${appointment.heureFin.minute}
                                                        }
                                                    }<c:if test="${!status.last}">,</c:if>
                                                    </c:forEach>
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
                    <div class="content-card">
                        <h4 class="card-title">
                            <i class="fas fa-calendar-check me-2"></i>Prochains rendez-vous
                        </h4>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Date & Heure</th>
                                        <th>Patient</th>
                                        <th>Type</th>
                                        <th>Statut</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="appointment" items="${upcomingAppointments}" begin="0" end="4">
                                        <tr>
                                            <td>
                                                <div class="fw-bold">${appointment.formattedDate}</div>
                                                <div class="text-muted small">${appointment.startTime} - ${appointment.endTime}</div>
                                            </td>
                                            <td>${appointment.patientName}</td>
                                            <td>${appointment.appointmentType}</td>
                                            <td>
                                                <span class="badge bg-${appointment.status eq 'SCHEDULED' ? 'primary' :
                                                                        appointment.status eq 'COMPLETED' ? 'success' :
                                                                        appointment.status eq 'CANCELED' ? 'danger' : 'warning'}">
                                                    ${appointment.status eq 'SCHEDULED' ? 'Confirmé' :
                                                     appointment.status eq 'COMPLETED' ? 'Terminé' :
                                                     appointment.status eq 'CANCELED' ? 'Annulé' : 'En attente'}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty upcomingAppointments}">
                                        <tr>
                                            <td colspan="4" class="text-center py-3">
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
                                            ${slot.startTime.toLocalTime()} - ${slot.endTime.toLocalTime()}
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