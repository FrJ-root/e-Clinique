<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Mon Profil - e-Clinique</title>
    <%@ include file="components/head.jsp" %>
</head>
<body>
    <c:set var="pageTitle" value="Mon Profil" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${successMessage}
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                </div>
            </c:if>

            <div class="content-card">
                <div class="profile-header">
                    <div class="profile-avatar">
                        ${fn:substring(user.nom, 0, 1)}
                    </div>
                    <h2 class="profile-name">${user.nom}</h2>
                    <p class="profile-email">${user.email}</p>
                </div>

                <form action="${pageContext.request.contextPath}/patient/update-profile" method="post">
                    <div class="profile-section">
                        <h3 class="profile-section-title">
                            <i class="fas fa-user-circle me-2"></i>Informations personnelles
                        </h3>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="nom" class="form-label">Nom complet</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <input type="text" class="form-control" id="nom" name="nom" value="${user.nom}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label">Adresse e-mail</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                    <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="cin" class="form-label">CIN</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                    <input type="text" class="form-control" id="cin" name="cin" value="${user.cin}" required readonly>
                                </div>
                                <small class="form-text text-muted">Le CIN ne peut pas être modifié.</small>
                            </div>
                            <div class="col-md-6">
                                <label for="telephone" class="form-label">Téléphone</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                    <input type="tel" class="form-control" id="telephone" name="telephone" value="${user.telephone}">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="naissance" class="form-label">Date de naissance</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-calendar-alt"></i></span>
                                    <input type="date" class="form-control" id="naissance" name="naissance" value="${user.naissance}">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="sexe" class="form-label">Sexe</label>
                                <select class="form-select" id="sexe" name="sexe">
                                    <option value="" ${empty user.sexe ? 'selected' : ''}>Non spécifié</option>
                                    <option value="M" ${user.sexe == 'M' ? 'selected' : ''}>Masculin</option>
                                    <option value="F" ${user.sexe == 'F' ? 'selected' : ''}>Féminin</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="profile-section">
                        <h3 class="profile-section-title">
                            <i class="fas fa-heartbeat me-2"></i>Informations médicales
                        </h3>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="sang" class="form-label">Groupe sanguin</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-tint"></i></span>
                                    <select class="form-select" id="sang" name="sang">
                                        <option value="" ${empty user.sang ? 'selected' : ''}>Non spécifié</option>
                                        <option value="A+" ${user.sang == 'A+' ? 'selected' : ''}>A+</option>
                                        <option value="A-" ${user.sang == 'A-' ? 'selected' : ''}>A-</option>
                                        <option value="B+" ${user.sang == 'B+' ? 'selected' : ''}>B+</option>
                                        <option value="B-" ${user.sang == 'B-' ? 'selected' : ''}>B-</option>
                                        <option value="AB+" ${user.sang == 'AB+' ? 'selected' : ''}>AB+</option>
                                        <option value="AB-" ${user.sang == 'AB-' ? 'selected' : ''}>AB-</option>
                                        <option value="O+" ${user.sang == 'O+' ? 'selected' : ''}>O+</option>
                                        <option value="O-" ${user.sang == 'O-' ? 'selected' : ''}>O-</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="adresse" class="form-label">Adresse</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-map-marker-alt"></i></span>
                                    <textarea class="form-control" id="adresse" name="adresse" rows="3">${user.adresse}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="profile-section">
                        <h3 class="profile-section-title">
                            <i class="fas fa-lock me-2"></i>Changer le mot de passe
                        </h3>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="currentPassword" class="form-label">Mot de passe actuel</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-key"></i></span>
                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="newPassword" class="form-label">Nouveau mot de passe</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword">
                                </div>
                            </div>
                        </div>
                        <div class="form-text mt-2">
                            <i class="fas fa-info-circle me-1"></i>Laissez ces champs vides si vous ne souhaitez pas changer de mot de passe.
                        </div>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Enregistrer les modifications
                        </button>
                    </div>
                </form>
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