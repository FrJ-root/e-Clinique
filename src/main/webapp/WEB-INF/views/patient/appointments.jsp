<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Réserver un Rendez-vous - e-Clinique</title>
    <%@ include file="components/head.jsp" %>
</head>
<body>
    <c:set var="pageTitle" value="Réserver un Rendez-vous" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                </div>
            </c:if>

            <div class="content-card">
                <c:if test="${not empty doctor}">
                    <div class="doctor-profile">
                        <div class="doctor-avatar">
                            ${fn:substring(doctor.nom, 0, 1)}
                        </div>
                        <div class="doctor-info">
                            <h3>${doctor.titre} ${doctor.nom}</h3>
                            <div class="doctor-specialty">
                                <i class="fas fa-stethoscope me-2"></i>${doctor.specialty.nom}
                            </div>
                            <div class="text-muted">
                                <i class="fas fa-building me-2"></i>${doctor.specialty.department.nom}
                            </div>
                        </div>
                    </div>

                    <div class="date-selection">
                        <h4 class="mb-3">
                            <i class="fas fa-calendar-day me-2"></i>Sélectionnez une date
                        </h4>

                        <div class="date-nav mb-3">
                            <a href="#" class="btn-nav" id="prevWeek">
                                <i class="fas fa-chevron-left me-2"></i>Semaine précédente
                            </a>
                            <a href="#" class="btn-nav" id="nextWeek">
                                Semaine suivante<i class="fas fa-chevron-right ms-2"></i>
                            </a>
                        </div>

                        <div class="date-grid" id="dateGrid">
                            <c:forEach items="${availableDates}" var="date" varStatus="status">
                                <c:if test="${status.index < 7}">
                                    <a href="${pageContext.request.contextPath}/patient/book-appointment?doctorId=${doctor.id}&date=${date}"
                                       class="date-btn ${date eq selectedDate ? 'active' : ''}">
                                        <span class="day-name"><fmt:formatDate value="${date}" pattern="EEE" /></span>
                                        <span class="day-number"><fmt:formatDate value="${date}" pattern="dd" /></span>
                                        <span class="month"><fmt:formatDate value="${date}" pattern="MMM" /></span>
                                    </a>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="alert alert-info mb-3">
                        <i class="fas fa-info-circle me-2"></i>
                        Les rendez-vous doivent être pris au moins 2 heures à l'avance.
                        <c:if test="${not empty minValidTime}">
                            <br>
                            <small>Le prochain créneau disponible commence à partir de
                            <fmt:formatDate value="${minValidTime}" pattern="HH:mm" /> aujourd'hui.</small>
                        </c:if>
                    </div>

                    <!-- Add this to the time slots section to show disabled slots -->
                    <c:when test="${not empty timeSlots}">
                        <div class="time-slots" id="timeSlots">
                            <c:forEach items="${timeSlots}" var="slot" varStatus="status">
                                <div class="time-slot ${LocalDateTime.of(selectedDate, LocalTime.parse(slot.startTime)).isBefore(minValidTime) ? 'disabled' : ''}"
                                     data-start-time="${slot.startTime}"
                                     data-end-time="${slot.endTime}"
                                     ${LocalDateTime.of(selectedDate, LocalTime.parse(slot.startTime)).isBefore(minValidTime) ? 'disabled' : ''}>
                                    ${slot.displayTime}
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>

                    <form id="appointmentForm" action="${pageContext.request.contextPath}/patient/book-appointment" method="post">
                        <input type="hidden" name="doctorId" value="${doctor.id}">
                        <input type="hidden" name="date" value="${selectedDate}">
                        <input type="hidden" name="startTime" id="startTimeInput">
                        <input type="hidden" name="endTime" id="endTimeInput">

                        <h4 class="mb-3">
                            <i class="fas fa-clock me-2"></i>Créneaux disponibles
                        </h4>

                        <c:choose>
                            <c:when test="${not empty timeSlots}">
                                <div class="time-slots" id="timeSlots">
                                    <c:forEach items="${timeSlots}" var="slot" varStatus="status">
                                        <div class="time-slot"
                                             data-start-time="${slot.startTime}"
                                             data-end-time="${slot.endTime}">
                                            ${slot.displayTime}
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="no-slots-message">
                                    <i class="fas fa-calendar-times"></i>
                                    <h4>Aucun créneau disponible</h4>
                                    <p>Veuillez sélectionner une autre date ou consulter un autre médecin.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="mt-4 mb-3">
                            <label for="motif" class="form-label">
                                <i class="fas fa-sticky-note me-2"></i>Motif de consultation
                            </label>
                            <textarea class="form-control" id="motif" name="motif" rows="3" placeholder="Décrivez brièvement la raison de votre consultation" required></textarea>
                        </div>

                        <div class="d-grid gap-2 mt-4">
                            <button type="submit" class="btn btn-primary" id="bookButton" disabled>
                                <i class="fas fa-calendar-check me-2"></i>Confirmer le rendez-vous
                            </button>
                        </div>
                    </form>
                </c:if>
            </div>

            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <!-- Bootstrap JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Common Patient Scripts -->
    <script src="${pageContext.request.contextPath}/assets/js/patient-script.js"></script>
</body>
</html>