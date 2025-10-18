<div class="modal fade" id="createUserModal" tabindex="-1" aria-labelledby="createUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="createUserModalLabel">Nouvel utilisateur</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="createUserForm" action="${pageContext.request.contextPath}/admin/users/create" method="post">
                    <div class="mb-3">
                        <label for="role" class="form-label">Rôle *</label>
                        <select class="form-select" id="role" name="role" required>
                            <option value="">Choose a role</option>
                            <option value="DOCTOR">Doctor</option>
                            <option value="PATIENT">Patient</option>
                            <option value="STAFF">Staff</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="nom" class="form-label">Nom complet *</label>
                        <input type="text" class="form-control" id="nom" name="nom" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Adresse e-mail *</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Mot de passe *</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>

                    <div id="doctorFields" style="display: none;">
                        <div class="mb-3">
                            <label for="matricule" class="form-label">Matricule *</label>
                            <input type="text" class="form-control" id="matricule" name="matricule">
                        </div>
                        <div class="mb-3">
                            <label for="titre" class="form-label">Titre</label>
                            <select class="form-select" id="titre" name="titre">
                                <option value="Dr">Dr</option>
                                <option value="Pr">Pr</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="specialtyId" class="form-label">Speciality</label>
                            <select class="form-select" id="specialtyId" name="specialtyId">
                                <option value="">-- choose a specialty --</option>
                                <c:forEach items="${specialties}" var="specialty">
                                    <option value="${specialty.id}">${specialty.nom}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div id="patientFields" style="display: none;">
                        <div class="mb-3">
                            <label for="cin" class="form-label">CIN *</label>
                            <input type="text" class="form-control" id="cin" name="cin">
                        </div>
                    </div>

                    <div id="staffFields" style="display: none;">
                        <div class="mb-3">
                            <label for="position" class="form-label">Poste *</label>
                            <input type="text" class="form-control" id="position" name="position">
                        </div>
                        <div class="mb-3">
                            <label for="departmentId" class="form-label">Department</label>
                            <select class="form-select" id="departmentId" name="departmentId">
                                <option value="">-- choose a department --</option>
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
                <button type="submit" form="createUserForm" class="btn btn-primary">Create</button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin-script.js"></script>