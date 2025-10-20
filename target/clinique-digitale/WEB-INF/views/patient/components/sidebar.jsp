<!-- Mobile Overlay -->
<div class="mobile-overlay" id="mobileOverlay"></div>

<!-- Sidebar -->
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <i class="fas fa-heartbeat"></i>
        <span>e-Clinique</span>
    </div>
    <div class="sidebar-user">
        <div class="sidebar-user-avatar">
            <c:set var="initials" value="${fn:substring(user.nom, 0, 1)}" />
            ${initials}
        </div>
        <div class="sidebar-user-info">
            <div class="sidebar-user-name">${user.nom}</div>
            <div class="sidebar-user-role">Patient</div>
        </div>
    </div>
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/patient/dashboard" class="sidebar-nav-item ${pageContext.request.servletPath == '/patient/dashboard' ? 'active' : ''}">
            <i class="fas fa-home"></i>
            <span>Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/patient/profile" class="sidebar-nav-item ${pageContext.request.servletPath == '/patient/profile' ? 'active' : ''}">
            <i class="fas fa-user"></i>
            <span>My Profil</span>
        </a>
        <a href="${pageContext.request.contextPath}/patient/simple-booking" class="sidebar-nav-item ${pageContext.request.servletPath == '/patient/simple-booking' ? 'active' : ''}">
            <i class="fas fa-user-md"></i>
            <span>Prendre RDV</span>
        </a>
        <a href="${pageContext.request.contextPath}/patient/doctors" class="sidebar-nav-item ${pageContext.request.servletPath == '/patient/doctors' ? 'active' : ''}">
            <i class="fas fa-user-md"></i>
            <span>Rechercher un doctor</span>
        </a>
        <a href="${pageContext.request.contextPath}/patient/appointments" class="sidebar-nav-item ${pageContext.request.servletPath == '/patient/appointments' ? 'active' : ''}">
            <i class="fas fa-calendar-check"></i>
            <span>Mes rendez-vous</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-nav-item">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
        </a>
    </nav>
</aside>