<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Détails Utilisateur - Administration e-Clinique</title>
    <%@ include file="components/common-head.jsp" %>
</head>
<body>
    <c:set var="pageTitle" value="Détails de l'utilisateur" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <div class="content-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="d-flex align-items-center">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-primary me-3">
                            <i class="fas fa-arrow-left"></i>
                        </a>
                        <h3 class="m-0">Détails de l'utilisateur</h3>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/users/edit?id=${viewUser.id}" class="btn btn-primary me-2">
                            <i class="fas fa-edit me-2"></i>Modifier
                        </a>
                        <c:choose>
                            <c:when test="${viewUser.actif}">
                                <form method="post" action="${pageContext.request.contextPath}/admin/users/deactivate" style="display: inline;">
                                    <input type="hidden" name="id" value="${viewUser.id}">
                                    <button type="submit" class="btn btn-outline-danger">
                                        <i class="fas fa-ban me-2"></i>Désactiver
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <form method="post" action="${pageContext.request.contextPath}/admin/users/activate" style="display: inline;">
                                    <input type="hidden" name="id" value="${viewUser.id}">
                                    <button type="submit" class="btn btn-outline-success">
                                        <i class="fas fa-check me-2"></i>Activer
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="user-profile-header mb-4">
                    <div class="user-avatar-large">
                        <c:set var="initials" value="${fn:substring(viewUser.nom, 0, 1)}" />
                        ${initials}
                    </div>
                    <h2>${viewUser.nom}</h2>
                    <div class="user-meta">
                        <div class="user-meta-item">
                            <c:choose>
                                <c:when test="${viewUser.role == 'ADMIN'}">
                                    <span class="badge bg-danger">Administrateur</span>
                                </c:when>
                                <c:when test="${viewUser.role == 'DOCTOR'}">
                                    <span class="badge bg-primary">Médecin</span>
                                </c:when>
                                <c:when test="${viewUser.role == 'PATIENT'}">
                                    <span class="badge bg-success">Patient</span>
                                </c:when>
                                <c:when test="${viewUser.role == 'STAFF'}">
                                    <span class="badge bg-info">Personnel</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">${viewUser.role}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="user-meta-item">
                            <c:choose>
                                <c:when test="${viewUser.actif}">
                                    <span class="badge bg-success">Actif</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">Inactif</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-6">
                        <div class="mb-4">
                            <h4 class="detail-section-title">Informations générales</h4>

                            <div class="detail-item">
                                <div class="detail-label">Nom complet</div>
                                <div class="detail-value">${viewUser.nom}</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Email</div>
                                <div class="detail-value">${viewUser.email}</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Rôle</div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${viewUser.role == 'ADMIN'}">Administrateur</c:when>
                                        <c:when test="${viewUser.role == 'DOCTOR'}">Médecin</c:when>
                                        <c:when test="${viewUser.role == 'PATIENT'}">Patient</c:when>
                                        <c:when test="${viewUser.role == 'STAFF'}">Personnel</c:when>
                                        <c:otherwise>${viewUser.role}</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Statut</div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${viewUser.actif}">
                                            <span class="text-success">Actif</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-danger">Inactif</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <!-- Role-specific information -->
                        <c:choose>
                            <c:when test="${viewUser.role == 'DOCTOR' && doctor != null}">
                                <div class="mb-4">
                                    <h4 class="detail-section-title">Informations médecin</h4>

                                    <div class="detail-item">
                                        <div class="detail-label">Matricule</div>
                                        <div class="detail-value">${doctor.matricule}</div>
                                    </div>
                                    <div class="detail-item">
                                        <div class="detail-label">Titre</div>
                                        <div class="detail-value">${doctor.titre}</div>
                                    </div>
                                    <div class="detail-item">
                                        <div class="detail-label">Spécialité</div>
                                        <div class="detail-value">
                                            <c:choose>
                                                <c:when test="${doctor.specialty != null}">
                                                    ${doctor.specialty.nom}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Non spécifiée</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="detail-item">
                                        <div class="detail-label">Téléphone</div>
                                        <div class="detail-value">
                                            <c:choose>
                                                <c:when test="${not empty doctor.telephone}">
                                                    ${doctor.telephone}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Non spécifié</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:when test="${viewUser.role == 'PATIENT' && patient != null}">
                                <div class="mb-4">
                                    <h4 class="detail-section-title">Informations patient</h4>

                                    <div class="detail-item">
                                        <div class="detail-label">CIN</div>
                                        <div class="detail-value">${patient.cin}</div>
                                    </div>
                                    <div class="detail-item">
                                        <div class="detail-label">Date de naissance</div>
                                        <div class="detail-value">
                                            <c:choose>
                                                <c:when test="${patient.naissance != null}">
                                                    <fmt:formatDate value="${patient.naissance}" pattern="dd/MM/yyyy" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Non spécifiée</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="detail-item">
                                        <div class="detail-label">Téléphone</div>
                                        <div class="detail-value">
                                            <c:choose>
                                                <c:when test="${not empty patient.telephone}">
                                                    ${patient.telephone}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Non spécifié</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                        </c:choose>
                    </div>
                </div>

                <div class="mt-4">
                    <h4 class="detail-section-title">Actions</h4>
                    <div class="d-flex gap-2">
                        <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#resetPasswordModal">
                            <i class="fas fa-key me-2"></i>Réinitialiser le mot de passe
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/users/edit?id=${viewUser.id}" class="btn btn-primary">
                            <i class="fas fa-edit me-2"></i>Modifier l'utilisateur
                        </a>
                    </div>
                </div>
            </div>

            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <!-- Reset Password Modal -->
    <div class="modal fade" id="resetPasswordModal" tabindex="-1" aria-labelledby="resetPasswordModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="resetPasswordModalLabel">Réinitialiser le mot de passe</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/admin/users/reset-password">
                    <div class="modal-body">
                        <input type="hidden" name="id" value="${viewUser.id}">
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">Nouveau mot de passe</label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Confirmer le mot de passe</label>
                            <input type="password" class="form-control" id="confirmPassword" required>
                            <div class="invalid-feedback">Les mots de passe ne correspondent pas</div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary" id="resetPasswordBtn">Réinitialiser</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@ include file="components/common-scripts.jsp" %>

</body>
</html>