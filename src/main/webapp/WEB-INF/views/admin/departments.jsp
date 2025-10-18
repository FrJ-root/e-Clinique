<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Départements - Administration e-Clinique</title>
    <%@ include file="components/common-head.jsp" %>
</head>
<body>
    <c:set var="pageTitle" value="Gestion des départements" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <div class="content-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="m-0">Liste des départements</h3>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createDepartmentModal">
                        <i class="fas fa-plus me-2"></i>Nouveau département
                    </button>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Nom</th>
                                <th>Description</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${departments}" var="dept">
                                <tr>
                                    <td>${dept.nom}</td>
                                    <td>${dept.description}</td>
                                    <td>
                                        <div class="btn-group">
                                            <button class="btn btn-sm btn-outline-secondary edit-department"
                                                    data-id="${dept.id}"
                                                    data-nom="${dept.nom}"
                                                    data-description="${dept.description}"
                                                    data-code="${dept.code}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger delete-department"
                                                    data-id="${dept.id}"
                                                    data-nom="${dept.nom}">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty departments}">
                                <tr>
                                    <td colspan="3" class="text-center">Aucun département trouvé</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <!-- Create Department Modal -->
    <div class="modal fade" id="createDepartmentModal" tabindex="-1" aria-labelledby="createDepartmentModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="createDepartmentModalLabel">Nouveau département</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="createDepartmentForm" action="${pageContext.request.contextPath}/admin/departments" method="post">
                        <div class="mb-3">
                            <label for="nom" class="form-label">Nom *</label>
                            <input type="text" class="form-control" id="nom" name="nom" required>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" form="createDepartmentForm" class="btn btn-primary">Créer</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Department Modal -->
    <div class="modal fade" id="editDepartmentModal" tabindex="-1" aria-labelledby="editDepartmentModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editDepartmentModalLabel">Modifier le département</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editDepartmentForm" action="${pageContext.request.contextPath}/admin/departments/update" method="post">
                        <input type="hidden" id="editDepartmentId" name="id">
                        <input type="hidden" id="editDepartmentCode" name="code">
                        <div class="mb-3">
                            <label for="editNom" class="form-label">Nom *</label>
                            <input type="text" class="form-control" id="editNom" name="nom" required>
                        </div>
                        <div class="mb-3">
                            <label for="editDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="editDescription" name="description" rows="3"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" form="editDepartmentForm" class="btn btn-primary">Enregistrer</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Department Modal -->
    <div class="modal fade" id="deleteDepartmentModal" tabindex="-1" aria-labelledby="deleteDepartmentModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteDepartmentModalLabel">Confirmer la suppression</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Êtes-vous sûr de vouloir supprimer le département <strong id="deleteDepartmentName"></strong> ?</p>
                    <p class="text-danger">Cette action est irréversible.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <form id="deleteDepartmentForm" action="${pageContext.request.contextPath}/admin/departments/delete" method="post">
                        <input type="hidden" id="deleteDepartmentId" name="id">
                        <button type="submit" class="btn btn-danger">Supprimer</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="components/common-scripts.jsp" %>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Edit department
            const editButtons = document.querySelectorAll('.edit-department');
            editButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    const nom = this.getAttribute('data-nom');
                    const description = this.getAttribute('data-description');
                    const code = this.getAttribute('data-code') || ''; // Add data-code attribute to your button

                    document.getElementById('editDepartmentId').value = id;
                    document.getElementById('editDepartmentCode').value = code;
                    document.getElementById('editNom').value = nom;
                    document.getElementById('editDescription').value = description || '';

                    const editModal = new bootstrap.Modal(document.getElementById('editDepartmentModal'));
                    editModal.show();
                });
            });

            // Delete department
            const deleteButtons = document.querySelectorAll('.delete-department');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    const nom = this.getAttribute('data-nom');

                    document.getElementById('deleteDepartmentId').value = id;
                    document.getElementById('deleteDepartmentName').textContent = nom;

                    const deleteModal = new bootstrap.Modal(document.getElementById('deleteDepartmentModal'));
                    deleteModal.show();
                });
            });
        });
    </script>
</body>
</html>