<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Spécialités - Administration e-Clinique</title>
    <%@ include file="components/common-head.jsp" %>
</head>
<body>
    <c:set var="pageTitle" value="Gestion des spécialités" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <div class="content-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="m-0">Liste des spécialités</h3>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createSpecialtyModal">
                        <i class="fas fa-plus me-2"></i>Nouvelle spécialité
                    </button>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Nom</th>
                                <th>Département</th>
                                <th>Description</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${specialties}" var="specialty">
                                <tr>
                                    <td>${specialty.nom}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${specialty.department != null}">
                                                ${specialty.department.nom}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Non assigné</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${specialty.description}</td>
                                    <td>
                                        <div class="btn-group">
                                            <button class="btn btn-sm btn-outline-secondary edit-specialty"
                                                    data-id="${specialty.id}"
                                                    data-nom="${specialty.nom}"
                                                    data-department-id="${specialty.department != null ? specialty.department.id : ''}"
                                                    data-description="${specialty.description}"
                                                    data-code="${specialty.code}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger delete-specialty"
                                                    data-id="${specialty.id}"
                                                    data-nom="${specialty.nom}">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty specialties}">
                                <tr>
                                    <td colspan="4" class="text-center">Aucune spécialité trouvée</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <!-- Create Specialty Modal -->
    <div class="modal fade" id="createSpecialtyModal" tabindex="-1" aria-labelledby="createSpecialtyModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="createSpecialtyModalLabel">Nouvelle spécialité</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="createSpecialtyForm" action="${pageContext.request.contextPath}/admin/specialties" method="post">
                        <div class="mb-3">
                            <label for="nom" class="form-label">Nom *</label>
                            <input type="text" class="form-control" id="nom" name="nom" required>
                        </div>
                        <div class="mb-3">
                            <label for="departmentId" class="form-label">Département</label>
                            <select class="form-select" id="departmentId" name="departmentId">
                                <option value="">-- Sélectionner un département --</option>
                                <c:forEach items="${departments}" var="dept">
                                    <option value="${dept.id}">${dept.nom}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" form="createSpecialtyForm" class="btn btn-primary">Créer</button>
                </div>
            </div>
        </div>
    </div>

<!-- Edit Specialty Modal -->
<div class="modal fade" id="editSpecialtyModal" tabindex="-1" aria-labelledby="editSpecialtyModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editSpecialtyModalLabel">Modifier la spécialité</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editSpecialtyForm" action="${pageContext.request.contextPath}/admin/specialties/update" method="post">
                    <input type="hidden" id="editSpecialtyId" name="id">
                    <input type="hidden" id="editSpecialtyCode" name="code">
                    <div class="mb-3">
                        <label for="editNom" class="form-label">Nom *</label>
                        <input type="text" class="form-control" id="editNom" name="nom" required>
                    </div>
                    <div class="mb-3">
                        <label for="editDepartmentId" class="form-label">Département</label>
                        <select class="form-select" id="editDepartmentId" name="departmentId">
                            <option value="">-- Sélectionner un département --</option>
                            <c:forEach items="${departments}" var="dept">
                                <option value="${dept.id}">${dept.nom}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="editDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="editDescription" name="description" rows="3"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <button type="submit" form="editSpecialtyForm" class="btn btn-primary">Enregistrer</button>
            </div>
        </div>
    </div>
</div>

    <!-- Delete Specialty Modal -->
    <div class="modal fade" id="deleteSpecialtyModal" tabindex="-1" aria-labelledby="deleteSpecialtyModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteSpecialtyModalLabel">Confirmer la suppression</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Êtes-vous sûr de vouloir supprimer la spécialité <strong id="deleteSpecialtyName"></strong> ?</p>
                    <p class="text-danger">Cette action est irréversible.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <form id="deleteSpecialtyForm" action="${pageContext.request.contextPath}/admin/specialties/delete" method="post">
                        <input type="hidden" id="deleteSpecialtyId" name="id">
                        <button type="submit" class="btn btn-danger">Supprimer</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="components/common-scripts.jsp" %>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
// Edit specialty
const editButtons = document.querySelectorAll('.edit-specialty');
editButtons.forEach(button => {
    button.addEventListener('click', function() {
        const id = this.getAttribute('data-id');
        const nom = this.getAttribute('data-nom');
        const departmentId = this.getAttribute('data-department-id');
        const description = this.getAttribute('data-description');
        const code = this.getAttribute('data-code') || ''; // Add data-code attribute to your button

        document.getElementById('editSpecialtyId').value = id;
        document.getElementById('editSpecialtyCode').value = code;
        document.getElementById('editNom').value = nom;
        document.getElementById('editDepartmentId').value = departmentId || '';
        document.getElementById('editDescription').value = description || '';

        const editModal = new bootstrap.Modal(document.getElementById('editSpecialtyModal'));
        editModal.show();
    });
});

            // Delete specialty
            const deleteButtons = document.querySelectorAll('.delete-specialty');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    const nom = this.getAttribute('data-nom');

                    document.getElementById('deleteSpecialtyId').value = id;
                    document.getElementById('deleteSpecialtyName').textContent = nom;

                    const deleteModal = new bootstrap.Modal(document.getElementById('deleteSpecialtyModal'));
                    deleteModal.show();
                });
            });
        });
    </script>
</body>
</html>