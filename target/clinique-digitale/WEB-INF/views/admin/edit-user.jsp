<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Modifier Utilisateur - Administration e-Clinique</title>
    <%@ include file="components/common-head.jsp" %>
</head>
<body>
    <c:set var="pageTitle" value="Modifier l'utilisateur" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <div class="content-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="d-flex align-items-center">
                        <a href="${pageContext.request.contextPath}/admin/users/view?id=${editUser.id}" class="btn btn-outline-primary me-3">
                            <i class="fas fa-arrow-left"></i>
                        </a>
                        <h3 class="m-0">Modifier l'utilisateur</h3>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/admin/users/update" method="post">
                    <input type="hidden" name="id" value="${editUser.id}">

                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="role" class="form-label">Rôle</label>
                                <input type="text" class="form-control" id="role" value="${editUser.role}" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3 form-check form-switch mt-4">
                                <input type="checkbox" class="form-check-input" id="active" name="active" ${editUser.actif ? 'checked' : ''}>
                                <label class="form-check-label" for="active">Compte actif</label>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="nom" class="form-label">Nom complet *</label>
                                <input type="text" class="form-control" id="nom" name="nom" value="${editUser.nom}" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="email" class="form-label">Adresse e-mail *</label>
                                <input type="email" class="form-control" id="email" name="email" value="${editUser.email}" required>
                            </div>
                        </div>
                    </div>

                    <!-- Role specific fields -->
                    <c:choose>
                        <c:when test="${editUser.role == 'DOCTOR' && doctor != null}">
                            <div id="doctorFields">
                                <h4 class="form-section-title mt-4">Informations médecin</h4>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="matricule" class="form-label">Matricule</label>
                                            <input type="text" class="form-control" id="matricule" name="matricule" value="${doctor.matricule}" readonly>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="titre" class="form-label">Titre</label>
                                            <select class="form-select" id="titre" name="titre">
                                                <option value="Dr" ${doctor.titre == 'Dr' ? 'selected' : ''}>Dr</option>
                                                <option value="Pr" ${doctor.titre == 'Pr' ? 'selected' : ''}>Pr</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="specialtyId" class="form-label">Spécialité</label>
                                            <select class="form-select" id="specialtyId" name="specialtyId">
                                                <option value="">-- Sélectionner une spécialité --</option>
                                                <c:forEach items="${specialties}" var="specialty">
                                                    <option value="${specialty.id}" ${doctor.specialty != null && doctor.specialty.id == specialty.id ? 'selected' : ''}>
                                                        ${specialty.nom}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="telephone" class="form-label">Téléphone</label>
                                            <input type="tel" class="form-control" id="telephone" name="telephone" value="${doctor.telephone}">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${editUser.role == 'PATIENT' && patient != null}">
                            <div id="patientFields">
                                <h4 class="form-section-title mt-4">Informations patient</h4>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="cin" class="form-label">CIN</label>
                                            <input type="text" class="form-control" id="cin" name="cin" value="${patient.cin}" readonly>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="telephone" class="form-label">Téléphone</label>
                                            <input type="tel" class="form-control" id="telephone" name="telephone" value="${patient.telephone}">
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="naissance" class="form-label">Date de naissance</label>
                                            <input type="date" class="form-control" id="naissance" name="naissance"
                                                value="<fmt:formatDate value="${patient.naissance}" pattern="yyyy-MM-dd" />">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                    </c:choose>

                    <h4 class="form-section-title mt-4">Changer le mot de passe</h4>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="newPassword" class="form-label">Nouveau mot de passe</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword">
                                <small class="text-muted">Laissez vide pour conserver le mot de passe actuel</small>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirmer le mot de passe</label>
                                <input type="password" class="form-control" id="confirmPassword">
                                <div class="invalid-feedback">Les mots de passe ne correspondent pas</div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex gap-2 mt-4">
                        <a href="${pageContext.request.contextPath}/admin/users/view?id=${editUser.id}" class="btn btn-secondary">Annuler</a>
                        <button type="submit" class="btn btn-primary">Enregistrer les modifications</button>
                    </div>
                </form>
            </div>

            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <%@ include file="components/common-scripts.jsp" %>

</body>
</html>