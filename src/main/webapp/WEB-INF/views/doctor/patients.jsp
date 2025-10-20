<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Mes Patients - e-Clinique</title>
    <%@ include file="components/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-style.css">
    <style>
        .patient-card { transition: all 0.2s ease-in-out; cursor: pointer; }
        .patient-card:hover { transform: translateY(-5px); box-shadow: 0 5px 15px rgba(0,180,216,0.10);}
        .status-badge { display: inline-block; padding: 4px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600;}
        .status-badge.active { background-color: rgba(40, 167, 69, 0.12); color: #28a745;}
        .status-badge.inactive { background-color: rgba(108,117,125,0.12); color: #6c757d;}
        .avatar-placeholder { width: 40px; height: 40px; border-radius: 50%; background-color: #0dcaf0; color: #fff;
            display: flex; align-items: center; justify-content: center; font-weight: 700; box-shadow: 0 1px 6px rgba(0,0,0,0.07);}
        .btn-group .btn { margin-right: 5px;}
        .badge.bg-primary {background: #0dcaf0;}
        .badge.bg-success {background: #28a745;}
        .badge.bg-info {background: #17a2b8;}
        .badge.bg-secondary {background: #6c757d;}
        .table th, .table td {vertical-align: middle;}
        @media (max-width: 600px) { .avatar-placeholder { width: 28px; height: 28px; font-size: 0.92em;} }
    </style>
</head>
<body>
    <c:set var="pageTitle" value="Mes Patients" scope="request" />
    <%@ include file="components/sidebar.jsp" %>
    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>
        <div class="content-area">
            <div class="content-card">
                <!-- Search and filters -->
                <div class="row mb-4">
                    <div class="col-md-8">
                        <h3 class="mb-3">${filterTitle}</h3>
                        <div class="d-flex flex-wrap gap-2 mb-3">
                            <a href="${pageContext.request.contextPath}/doctor/patients"
                               class="btn ${filter eq 'all' || empty filter ? 'btn-primary' : 'btn-outline-primary'}">
                                <i class="fas fa-users me-1"></i>Tous les patients
                            </a>
                            <a href="${pageContext.request.contextPath}/doctor/patients?filter=recent"
                               class="btn ${filter eq 'recent' ? 'btn-primary' : 'btn-outline-primary'}">
                                <i class="fas fa-calendar-alt me-1"></i>Patients récents
                            </a>
                            <a href="${pageContext.request.contextPath}/doctor/patients?filter=frequent"
                               class="btn ${filter eq 'frequent' ? 'btn-primary' : 'btn-outline-primary'}">
                                <i class="fas fa-star me-1"></i>Patients réguliers
                            </a>
                        </div>
                        <form action="${pageContext.request.contextPath}/doctor/patients" method="get" class="mt-3">
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Rechercher un patient..."
                                       name="search" value="${searchTerm}">
                                <button class="btn btn-primary" type="submit">
                                    <i class="fas fa-search me-1"></i>Rechercher
                                </button>
                            </div>
                            <c:if test="${not empty searchTerm}">
                                <div class="mt-2">
                                    <small class="text-muted">
                                        ${searchResults} résultat(s) pour "<b>${searchTerm}</b>"
                                        <a href="${pageContext.request.contextPath}/doctor/patients"
                                           class="ms-2 text-decoration-none">
                                           <i class="fas fa-times"></i> Effacer la recherche
                                        </a>
                                    </small>
                                </div>
                            </c:if>
                        </form>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title mb-3">Statistiques</h5>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Total patients:</span>
                                    <span class="badge bg-primary">${totalPatients}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Nouveaux ce mois:</span>
                                    <span class="badge bg-success">${newPatientsThisMonth}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Patients actifs:</span>
                                    <span class="badge bg-info">${activePatients}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Patients list -->
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th></th>
                                <th>Nom</th>
                                <th>Contact</th>
                                <th>Date de naissance</th>
                                <th>Statut</th>
                                <th>Rendez-vous</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="patient" items="${patients}">
                                <tr class="patient-row" data-id="${patient.id}">
                                    <td>
                                        <div class="avatar-placeholder">
                                            ${fn:substring(patient.nom, 0, 1)}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="fw-bold">${patient.nom} ${patient.prenom}</div>
                                        <div class="small text-muted">
                                            <c:choose>
                                                <c:when test="${patient.sexe == 'M'}">Homme</c:when>
                                                <c:when test="${patient.sexe == 'F'}">Femme</c:when>
                                                <c:otherwise>Non spécifié</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td>
                                        <c:if test="${not empty patient.email}">
                                            <div><i class="fas fa-envelope me-1"></i>${patient.email}</div>
                                        </c:if>
                                        <c:if test="${not empty patient.telephone}">
                                            <div><i class="fas fa-phone me-1"></i>${patient.telephone}</div>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${not empty patient.dateNaissance}">
                                            <fmt:parseDate value="${patient.dateNaissance}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                                            <div class="small text-muted">${patient.age} ans</div>
                                        </c:if>
                                    </td>
                                    <td>
                                        <span class="status-badge ${patient.actif ? 'active' : 'inactive'}">
                                            ${patient.actif ? 'Actif' : 'Inactif'}
                                        </span>
                                    </td>
                                    <td>
                                        <c:set var="appointmentCount" value="${appointmentCounts[patient.id]}" />
                                        <span class="badge ${appointmentCount > 0 ? 'bg-primary' : 'bg-secondary'}">
                                            ${appointmentCount}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="btn-group">
                                            <a href="${pageContext.request.contextPath}/doctor/patients/view?id=${patient.id}"
                                               class="btn btn-sm btn-outline-primary" title="Voir fiche patient">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/doctor/patients/view?id=${patient.id}#medical-history"
                                               class="btn btn-sm btn-outline-success" title="Voir historique médical">
                                                <i class="fas fa-notes-medical"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty patients}">
                                <tr>
                                    <td colspan="7" class="text-center py-4">
                                        <i class="fas fa-user-slash fa-3x text-muted mb-3"></i>
                                        <h5>Aucun patient trouvé</h5>
                                        <p class="text-muted">
                                            <c:choose>
                                                <c:when test="${not empty searchTerm}">
                                                    Aucun patient ne correspond à votre recherche
                                                </c:when>
                                                <c:otherwise>
                                                    Vous n'avez encore aucun patient
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/doctor-script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Make patient rows clickable (except button/links)
            document.querySelectorAll('.patient-row').forEach(row => {
                row.addEventListener('click', function(e) {
                    if (!e.target.closest('button') && !e.target.closest('a')) {
                        const id = this.getAttribute('data-id');
                        window.location.href = `${'${pageContext.request.contextPath}'}/doctor/patients/view?id=${id}`;
                    }
                });
            });
        });
    </script>
</body>
</html>