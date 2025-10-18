<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Rechercher un Docteur - e-Clinique</title>
    <%@ include file="components/head.jsp" %>
</head>
<body>
    <c:set var="pageTitle" value="Rechercher un Docteur" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <div class="search-header">
                <h2 class="search-title">
                    <i class="fas fa-search me-2"></i>Trouver un médecin spécialiste
                </h2>
                <p class="search-subtitle">
                    Recherchez un médecin par spécialité ou département pour prendre rendez-vous
                </p>
            </div>

            <div class="row">
                <!-- Filters sidebar -->
                <div class="col-lg-4 mb-4">
                    <div class="search-filters">
                        <h3 class="filter-title">Filtrer par département</h3>

                        <div class="list-group mb-4">
                            <a href="${pageContext.request.contextPath}/patient/doctors"
                               class="list-group-item list-group-item-action ${empty param.departmentId ? 'active' : ''}">
                                <i class="fas fa-globe me-2"></i>Tous les départements
                            </a>

                            <c:forEach items="${departments}" var="department">
                                <a href="${pageContext.request.contextPath}/patient/doctors?departmentId=${department.id}"
                                   class="list-group-item list-group-item-action ${param.departmentId eq department.id ? 'active' : ''}">
                                    <i class="fas fa-building me-2"></i>${department.nom}
                                </a>
                            </c:forEach>
                        </div>

                        <h3 class="filter-title">Filtrer par spécialité</h3>

                        <div class="list-group">
                            <a href="${pageContext.request.contextPath}/patient/doctors"
                               class="list-group-item list-group-item-action ${empty param.specialtyId ? 'active' : ''}">
                                <i class="fas fa-star me-2"></i>Toutes les spécialités
                            </a>

                            <c:forEach items="${specialties}" var="specialty">
                                <a href="${pageContext.request.contextPath}/patient/doctors?specialtyId=${specialty.id}"
                                   class="list-group-item list-group-item-action ${param.specialtyId eq specialty.id ? 'active' : ''}">
                                    <i class="fas fa-stethoscope me-2"></i>${specialty.nom}
                                    <small class="d-block text-muted ms-4">${specialty.department.nom}</small>
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Search results -->
                <div class="col-lg-8">
                    <div class="content-card">
                        <!-- Selected filters -->
                        <div class="search-results-info mb-4">
                            <c:choose>
                                <c:when test="${not empty specialty}">
                                    <h4>
                                        <i class="fas fa-filter me-2"></i>
                                        Résultats pour la spécialité: <span class="text-primary">${specialty.nom}</span>
                                    </h4>
                                </c:when>
                                <c:when test="${not empty department}">
                                    <h4>
                                        <i class="fas fa-filter me-2"></i>
                                        Résultats pour le département: <span class="text-primary">${department.nom}</span>
                                    </h4>
                                </c:when>
                                <c:otherwise>
                                    <h4>
                                        <i class="fas fa-user-md me-2"></i>
                                        Tous nos médecins
                                    </h4>
                                </c:otherwise>
                            </c:choose>

                            <div class="mt-2">
                                <c:if test="${not empty doctors}">
                                    <span class="text-muted">${fn:length(doctors)} résultat(s) trouvé(s)</span>
                                </c:if>
                            </div>
                        </div>

                        <!-- Doctor results -->
                        <div class="doctors-list">
                            <c:choose>
                                <c:when test="${not empty doctors}">
                                    <c:forEach items="${doctors}" var="doctor">
                                        <div class="doctor-card">
                                            <div class="doctor-avatar">
                                                ${fn:substring(doctor.nom, 0, 1)}
                                            </div>
                                            <div class="doctor-info">
                                                <h3 class="doctor-name">${doctor.titre} ${doctor.nom}</h3>
                                                <div class="doctor-specialty">
                                                    <i class="fas fa-stethoscope me-2"></i>${doctor.specialty.nom}
                                                </div>
                                                <div class="doctor-details">
                                                    <div class="mb-2">
                                                        <i class="fas fa-building me-2"></i>${doctor.specialty.department.nom}
                                                    </div>
                                                    <div class="mb-2">
                                                        <i class="fas fa-id-card me-2"></i>Matricule: ${doctor.matricule}
                                                    </div>
                                                </div>
                                                <div class="doctor-actions">
                                                    <a href="${pageContext.request.contextPath}/patient/book-appointment?doctorId=${doctor.id}" class="btn btn-primary">
                                                        <i class="fas fa-calendar-plus me-2"></i>Prendre rendez-vous
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/patient/doctor-details?id=${doctor.id}" class="btn btn-outline-primary">
                                                        <i class="fas fa-info-circle me-2"></i>Détails
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="search-empty">
                                        <i class="fas fa-user-md-slash"></i>
                                        <h3>Aucun médecin trouvé</h3>
                                        <p>Veuillez modifier vos critères de recherche et réessayer.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
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