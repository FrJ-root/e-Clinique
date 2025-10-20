<div class="mobile-overlay" id="mobileOverlay"></div>

<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <i class="fas fa-heartbeat"></i>
        <span>e-Clinique</span>
    </div>
    <div class="sidebar-user">
        <div class="sidebar-user-avatar">
            <c:set var="initials" value="${fn:substring(doctor.nom, 0, 1)}" />
            ${initials}
        </div>
        <div class="sidebar-user-info">
            <div class="sidebar-user-name">${doctor.titre} ${doctor.nom}</div>
            <div class="sidebar-user-role">Doctor -
                <c:if test="${not empty doctor.specialty}">
                    ${doctor.specialty.nom}
                </c:if>
                <c:if test="${empty doctor.specialty}">
                    <span class="text-muted small">Non definie</span>
                </c:if>
            </div>
        </div>
    </div>
<nav class="sidebar-nav">
    <a href="${pageContext.request.contextPath}/doctor/dashboard" class="sidebar-nav-item ${pageContext.request.servletPath == '/doctor/dashboard' ? 'active' : ''}">
        <i class="fas fa-home"></i>
        <span>Dashboard</span>
    </a>
    <a href="${pageContext.request.contextPath}/doctor/profile" class="sidebar-nav-item ${pageContext.request.servletPath == '/doctor/profile' ? 'active' : ''}">
        <i class="fas fa-user-md"></i>
        <span>Mon profil</span>
    </a>
    <a href="${pageContext.request.contextPath}/doctor/schedule" class="sidebar-nav-item ${pageContext.request.servletPath == '/doctor/schedule' ? 'active' : ''}">
        <i class="fas fa-calendar-alt"></i>
        <span>Agenda</span>
    </a>
    <a href="${pageContext.request.contextPath}/doctor/availability" class="sidebar-nav-item ${pageContext.request.servletPath == '/doctor/availability' ? 'active' : ''}">
        <i class="fas fa-clock"></i>
        <span>Availability</span>
    </a>
    <a href="${pageContext.request.contextPath}/doctor/appointments" class="sidebar-nav-item ${pageContext.request.servletPath == '/doctor/appointments' ? 'active' : ''}">
        <i class="fas fa-calendar-check"></i>
        <span>Rendez-vous</span>
    </a>
    <a href="${pageContext.request.contextPath}/doctor/medical-notes" class="sidebar-nav-item ${pageContext.request.servletPath == '/doctor/medical-notes' ? 'active' : ''}">
        <i class="fas fa-notes-medical"></i>
        <span>Notes medical</span>
    </a>
    <a href="${pageContext.request.contextPath}/doctor/patients" class="sidebar-nav-item ${pageContext.request.servletPath == '/doctor/patients' ? 'active' : ''}">
        <i class="fas fa-user-injured"></i>
        <span>Mes patients</span>
    </a>
    <a href="${pageContext.request.contextPath}/doctor/patient-history" class="sidebar-nav-item ${pageContext.request.servletPath == '/doctor/patient-history' ? 'active' : ''}">
        <i class="fas fa-history"></i>
        <span>Historique des patients</span>
    </a>
    <a href="${pageContext.request.contextPath}/logout" class="sidebar-nav-item">
        <i class="fas fa-sign-out-alt"></i>
        <span>Logout</span>
    </a>
</nav>
</aside>