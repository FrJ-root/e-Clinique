<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Utilisateurs - Administration e-Clinique</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-style.css" rel="stylesheet">
</head>
<body>
    <c:set var="pageTitle" value="Gestion des utilisateurs" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <div class="content-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="m-0">Liste des utilisateurs</h3>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createUserModal">
                        <i class="fas fa-plus me-2"></i>Nouvel utilisateur
                    </button>
                </div>

                <div class="mb-4 d-flex flex-wrap justify-content-between align-items-center">
                    <div class="btn-group mb-2" role="group">
                        <a href="${pageContext.request.contextPath}/admin/users" class="${empty param.role ? 'btn btn-primary' : 'btn btn-outline-primary'}">Tous</a>
                        <a href="${pageContext.request.contextPath}/admin/users?role=ADMIN" class="${param.role == 'ADMIN' ? 'btn btn-primary' : 'btn btn-outline-primary'}">ADMIN</a>
                        <a href="${pageContext.request.contextPath}/admin/users?role=DOCTOR" class="${param.role == 'DOCTOR' ? 'btn btn-primary' : 'btn btn-outline-primary'}">DOCTOR</a>
                        <a href="${pageContext.request.contextPath}/admin/users?role=PATIENT" class="${param.role == 'PATIENT' ? 'btn btn-primary' : 'btn btn-outline-primary'}">PATIENT</a>
                        <a href="${pageContext.request.contextPath}/admin/users?role=STAFF" class="${param.role == 'STAFF' ? 'btn btn-primary' : 'btn btn-outline-primary'}">STAFF</a>
                    </div>
                    <div class="search-form mb-2">
                        <form action="${pageContext.request.contextPath}/admin/users" method="get" class="d-flex">
                            <c:if test="${not empty param.role}">
                                <input type="hidden" name="role" value="${param.role}">
                            </c:if>
                            <div class="input-group">
                                <input type="text" class="form-control" name="q" value="${param.q}" placeholder="Rechercher...">
                                <button class="btn btn-outline-primary" type="submit">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Nom</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${users}" var="u">
                                <tr>
                                    <td>${u.nom}</td>
                                    <td>${u.email}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.role == 'ADMIN'}">
                                                <span class="badge bg-danger">ADMIN</span>
                                            </c:when>
                                            <c:when test="${u.role == 'DOCTOR'}">
                                                <span class="badge bg-primary">DOCTOR</span>
                                            </c:when>
                                            <c:when test="${u.role == 'PATIENT'}">
                                                <span class="badge bg-success">PATIENT</span>
                                            </c:when>
                                            <c:when test="${u.role == 'STAFF'}">
                                                <span class="badge bg-info">STAFF</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${u.role}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.actif}">
                                                <span class="badge bg-success">Actif</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">Inactif</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group">
                                            <a href="${pageContext.request.contextPath}/admin/users/view?id=${u.id}" class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/users/edit?id=${u.id}" class="btn btn-sm btn-outline-secondary">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <c:choose>
                                                <c:when test="${u.actif}">
                                                    <form method="post" action="${pageContext.request.contextPath}/admin/users/deactivate" style="display: inline;">
                                                        <input type="hidden" name="id" value="${u.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger">
                                                            <i class="fas fa-ban"></i>
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <form method="post" action="${pageContext.request.contextPath}/admin/users/activate" style="display: inline;">
                                                        <input type="hidden" name="id" value="${u.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-success">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                            <button class="btn btn-sm btn-outline-danger delete-user" data-id="${u.id}" data-name="${u.nom}" data-bs-toggle="modal" data-bs-target="#deleteUserModal">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty users}">
                                <tr>
                                    <td colspan="5" class="text-center">Aucun utilisateur trouvé</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <%-- Include modal components --%>
    <%@ include file="modals/create-user-modal.jsp" %>
    <%@ include file="modals/edit-user-modal.jsp" %>
    <%@ include file="modals/delete-user-modal.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin-script.js"></script>
</body>
</html>