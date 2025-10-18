<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <i class="fas fa-heartbeat"></i>
        <span>e-Clinique Admin</span>
    </div>
    <div class="sidebar-user">
        <div class="sidebar-user-avatar">
            <c:set var="initials" value="${fn:substring(user.nom, 0, 1)}" />
            ${initials}
        </div>
        <div class="sidebar-user-info">
            <div class="sidebar-user-name">${user.nom}</div>
            <div class="sidebar-user-role">Administrateur</div>
        </div>
    </div>

    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-nav-item ${pageContext.request.servletPath.contains('/dashboard') ? 'active' : ''}">
            <i class="fas fa-tachometer-alt"></i>
            <span>Tableau de bord</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-nav-item ${pageContext.request.servletPath.contains('/users') ? 'active' : ''}">
            <i class="fas fa-users"></i>
            <span>Gestion utilisateurs</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/departments" class="sidebar-nav-item ${pageContext.request.servletPath.contains('/departments') ? 'active' : ''}">
            <i class="fas fa-building"></i>
            <span>Departments</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/specialties" class="sidebar-nav-item ${pageContext.request.servletPath.contains('/specialties') ? 'active' : ''}">
            <i class="fas fa-stethoscope"></i>
            <span>Specialities</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/settings" class="sidebar-nav-item ${pageContext.request.servletPath.contains('/settings') ? 'active' : ''}">
            <i class="fas fa-cog"></i>
            <span>Managing working hours</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-nav-item ${pageContext.request.servletPath.contains('/reports') ? 'active' : ''}">
            <i class="fas fa-chart-bar"></i>
            <span>Rapports</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-nav-item">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
        </a>
    </nav>
</aside>
<div class="mobile-overlay" id="mobileOverlay"></div>