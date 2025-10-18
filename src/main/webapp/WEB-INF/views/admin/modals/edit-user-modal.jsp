<div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editUserModalLabel">Modifier l'utilisateur</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editUserForm" action="${pageContext.request.contextPath}/admin/users/update" method="post">
                    <input type="hidden" id="editId" name="id">
                    <div class="mb-3">
                        <label for="editRole" class="form-label">Role</label>
                        <input type="text" class="form-control" id="editRole" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="editNom" class="form-label">Nom complet *</label>
                        <input type="text" class="form-control" id="editNom" name="nom" required>
                    </div>
                    <div class="mb-3">
                        <label for="editEmail" class="form-label">Adresse e-mail *</label>
                        <input type="email" class="form-control" id="editEmail" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label for="editNewPassword" class="form-label">Nouveau mot de passe</label>
                        <input type="password" class="form-control" id="editNewPassword" name="newPassword">
                        <small class="form-text text-muted">Laissez vide pour ne pas changer le mot de passe</small>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="editActive" name="active">
                        <label class="form-check-label" for="editActive">Compte actif</label>
                    </div>

                    <div id="editDoctorFields" style="display: none;">
                        <div class="mb-3">
                            <label for="editMatricule" class="form-label">Matricule</label>
                            <input type="text" class="form-control" id="editMatricule" name="matricule" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="editTitre" class="form-label">Titre</label>
                            <select class="form-select" id="editTitre" name="titre">
                                <option value="Dr">Dr</option>
                                <option value="Pr">Pr</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="editSpecialtyId" class="form-label">Specialty</label>
                            <select class="form-select" id="editSpecialtyId" name="specialtyId">
                                <option value="">-- Choose a specialty --</option>
                                <c:forEach items="${specialties}" var="specialty">
                                    <option value="${specialty.id}">${specialty.nom}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div id="editStaffFields" style="display: none;">
                        <div class="mb-3">
                            <label for="editPosition" class="form-label">Poste</label>
                            <input type="text" class="form-control" id="editPosition" name="position">
                        </div>
                        <div class="mb-3">
                            <label for="editDepartmentId" class="form-label">Department</label>
                            <select class="form-select" id="editDepartmentId" name="departmentId">
                                <option value="">-- Choose a department --</option>
                                <c:forEach items="${departments}" var="department">
                                    <option value="${department.id}">${department.nom}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" form="editUserForm" class="btn btn-primary">Save</button>
            </div>
        </div>
    </div>
</div>