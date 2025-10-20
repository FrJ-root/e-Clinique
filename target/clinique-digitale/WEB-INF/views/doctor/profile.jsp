<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil - e-Clinique</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #00b4d8;
            --primary-dark: #0096c7;
            --secondary: #48cae4;
            --accent: #90e0ef;
            --dark: #03045e;
            --bg-light: #f5f7fa;
            --text-light: #212529;
            --card-light: #ffffff;
            --border-color: #e3e8ef;
            --sidebar-width: 280px;
            --topbar-height: 70px;
            --sidebar-collapsed: 70px;
        }

        [data-theme="dark"] {
            --bg-light: #0a0e27;
            --text-light: #e9ecef;
            --card-light: #1a1d3a;
            --border-color: #2c3148;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-light);
            color: var(--text-light);
            min-height: 100vh;
            transition: background-color 0.3s ease;
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: var(--sidebar-width);
            height: 100vh;
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--dark) 100%);
            color: white;
            overflow-y: auto;
            overflow-x: hidden;
            z-index: 1000;
            transition: all 0.3s ease;
            box-shadow: 4px 0 15px rgba(0, 0, 0, 0.1);
        }

        .sidebar.collapsed {
            width: var(--sidebar-collapsed);
        }

        .sidebar-brand {
            padding: 25px;
            display: flex;
            align-items: center;
            height: var(--topbar-height);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-brand i {
            font-size: 1.8rem;
            margin-right: 15px;
            color: white;
        }

        .sidebar-brand span {
            font-size: 1.4rem;
            font-weight: 700;
            color: white;
            white-space: nowrap;
            opacity: 1;
            transition: opacity 0.3s;
        }

        .sidebar.collapsed .sidebar-brand span {
            opacity: 0;
            width: 0;
            display: none;
        }

        .sidebar-user {
            padding: 20px 25px;
            display: flex;
            align-items: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-user-avatar {
            width: 40px;
            height: 40px;
            background-color: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-weight: 600;
            font-size: 1rem;
        }

        .sidebar-user-info {
            flex: 1;
            min-width: 0;
            opacity: 1;
            transition: opacity 0.3s;
        }

        .sidebar.collapsed .sidebar-user-info {
            opacity: 0;
            width: 0;
            display: none;
        }

        .sidebar-user-name {
            font-weight: 600;
            font-size: 0.95rem;
            margin-bottom: 2px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .sidebar-user-role {
            font-size: 0.8rem;
            opacity: 0.8;
        }

        .sidebar-nav {
            padding: 15px 0;
        }

        .sidebar-nav-item {
            padding: 12px 25px;
            display: flex;
            align-items: center;
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            white-space: nowrap;
            margin-bottom: 5px;
        }

        .sidebar-nav-item:hover {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .sidebar-nav-item.active {
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            font-weight: 600;
            padding-left: 22px;
            border-left: 3px solid white;
        }

        .sidebar-nav-item i {
            font-size: 1.1rem;
            margin-right: 15px;
            width: 20px;
            text-align: center;
        }

        .sidebar-nav-item span {
            transition: opacity 0.3s;
            opacity: 1;
        }

        .sidebar.collapsed .sidebar-nav-item span {
            opacity: 0;
            width: 0;
            display: none;
        }

        .main-content {
            margin-left: var(--sidebar-width);
            padding-top: var(--topbar-height);
            transition: margin-left 0.3s ease;
            min-height: 100vh;
        }

        .main-content.expanded {
            margin-left: var(--sidebar-collapsed);
        }

        .topbar {
            position: fixed;
            top: 0;
            left: var(--sidebar-width);
            right: 0;
            height: var(--topbar-height);
            background-color: var(--card-light);
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            padding: 0 25px;
            z-index: 999;
            transition: left 0.3s ease;
        }

        .topbar.expanded {
            left: var(--sidebar-collapsed);
        }

        .toggle-sidebar {
            background: none;
            border: none;
            color: var(--text-light);
            font-size: 1.2rem;
            cursor: pointer;
            margin-right: 20px;
        }

        .topbar-title {
            font-weight: 600;
            font-size: 1.1rem;
        }

        .topbar-actions {
            margin-left: auto;
            display: flex;
            align-items: center;
        }

        .theme-toggle {
            background: none;
            border: none;
            color: var(--text-light);
            font-size: 1.1rem;
            cursor: pointer;
            margin-right: 20px;
        }

        .dropdown-toggle {
            background: none;
            border: none;
            color: var(--text-light);
            cursor: pointer;
        }

        .dropdown-toggle::after {
            display: none;
        }

        .topbar-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background-color: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .content-area {
            padding: 25px;
        }

        .alert {
            border-radius: 12px;
            padding: 14px 18px;
            margin-bottom: 25px;
            border: none;
            animation: slideDown 0.4s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-success {
            background-color: #d1e7dd;
            color: #0f5132;
            border-left: 4px solid #198754;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #842029;
            border-left: 4px solid #dc3545;
        }

        .content-card {
            background-color: var(--card-light);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .profile-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 2.5rem;
            margin: 0 auto 20px auto;
            box-shadow: 0 10px 25px rgba(0, 180, 216, 0.2);
        }

        .profile-name {
            font-size: 1.5rem;
            font-weight: 700;
            margin: 0;
            color: var(--text-light);
        }

        .profile-specialty {
            color: var(--primary);
            font-weight: 600;
            margin: 5px 0;
        }

        .profile-email {
            color: #6c757d;
            margin: 5px 0 0 0;
        }

        .profile-section {
            margin-bottom: 35px;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .profile-section-title {
            font-weight: 600;
            font-size: 1.1rem;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--border-color);
            color: var(--text-light);
        }

        .form-label {
            font-weight: 500;
            color: var(--text-light);
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 12px 15px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background-color: var(--card-light);
            color: var(--text-light);
        }

        .form-control:focus, .form-select:focus {
            box-shadow: 0 0 0 0.25rem rgba(0, 180, 216, 0.15);
            border-color: var(--primary);
        }

        .form-control:disabled, .form-select:disabled {
            background-color: rgba(0, 0, 0, 0.03);
            color: #6c757d;
        }

        .form-text {
            font-size: 0.85rem;
            color: #6c757d;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            border: none;
            border-radius: 12px;
            padding: 12px 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 180, 216, 0.3);
        }

        .footer {
            padding: 20px 25px;
            text-align: center;
            color: #6c757d;
            font-size: 0.875rem;
            border-top: 1px solid var(--border-color);
        }

        .mobile-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
            display: none;
        }

        .mobile-overlay.active {
            display: block;
        }

        @media (max-width: 992px) {
            .sidebar {
                transform: translateX(-100%);
                box-shadow: none;
            }

            .sidebar.mobile-visible {
                transform: translateX(0);
                box-shadow: 4px 0 15px rgba(0, 0, 0, 0.1);
            }

            .main-content {
                margin-left: 0;
            }

            .topbar {
                left: 0;
            }

            .toggle-sidebar {
                display: block;
            }
        }

        @media (max-width: 768px) {
            .content-area {
                padding: 15px;
            }

            .content-card {
                padding: 20px;
            }

            .row > * {
                margin-bottom: 15px;
            }

            .btn-primary {
                width: 100%;
            }
        }

        @media (max-width: 576px) {
            .profile-avatar {
                width: 100px;
                height: 100px;
                font-size: 2rem;
            }

            .profile-section {
                margin-bottom: 25px;
            }

            .profile-section-title {
                font-size: 1rem;
            }

            .form-label {
                font-size: 0.9rem;
            }

            .topbar-title {
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <c:set var="pageTitle" value="Profile" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
            <div class="topbar" id="topbar">
                <button class="toggle-sidebar" id="toggleSidebar">
                    <i class="fas fa-bars"></i>
                </button>
                <h1 class="topbar-title">Mon Profil</h1>
                <div class="topbar-actions">
                    <button class="theme-toggle" id="themeToggle" aria-label="Toggle theme">
                        <i class="fas fa-moon" id="themeIcon"></i>
                    </button>
                    <div class="dropdown">
                        <button class="dropdown-toggle" type="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <div class="topbar-avatar">
                                ${fn:substring(doctor.nom, 0, 1)}
                            </div>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/doctor/profile"><i class="fas fa-user-circle me-2"></i>Mon profil</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Déconnexion</a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="content-area">
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                    </div>
                </c:if>

                <div class="content-card">
                    <div class="profile-header">
                        <div class="profile-avatar">
                            ${fn:substring(doctor.nom, 0, 1)}
                        </div>
                        <h2 class="profile-name">${doctor.titre} ${doctor.nom}</h2>
                        <c:choose>
                            <c:when test="${doctor.specialty != null}">
                                <p class="profile-specialty">${doctor.specialty.nom}</p>
                            </c:when>
                            <c:otherwise>
                                <p class="profile-specialty text-muted">Spécialité non définie</p>
                            </c:otherwise>
                        </c:choose>
                        <p class="profile-email">${doctor.email}</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/doctor/update-profile" method="post">
                        <div class="profile-section">
                            <h3 class="profile-section-title">
                                <i class="fas fa-user-circle me-2"></i>Informations personnelles
                            </h3>

                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label for="titre" class="form-label">Titre</label>
                                    <select class="form-select" id="titre" name="titre">
                                        <option value="Dr" ${doctor.titre == 'Dr' || doctor.titre == 'Dr.' ? 'selected' : ''}>Dr.</option>
                                        <option value="Pr" ${doctor.titre == 'Pr' || doctor.titre == 'Pr.' ? 'selected' : ''}>Pr.</option>
                                    </select>
                                </div>
                                <div class="col-md-8">
                                    <label for="nom" class="form-label">Nom complet</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                                        <input type="text" class="form-control" id="nom" name="nom" value="${doctor.nom}" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="email" class="form-label">Adresse e-mail</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                        <input type="email" class="form-control" id="email" name="email" value="${doctor.email}" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="telephone" class="form-label">Téléphone</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                        <input type="tel" class="form-control" id="telephone" name="telephone" value="${doctor.telephone}">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="matricule" class="form-label">Matricule</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                        <input type="text" class="form-control" id="matricule" name="matricule" value="${doctor.matricule}" readonly>
                                    </div>
                                    <small class="form-text text-muted">
                                        Format automatique: Initiales-Department-Year. Ne peut pas etre modifie manuellement.
                                    </small>
                                </div>
                                <div class="col-md-6">
                                    <label for="specialtyId" class="form-label">Spécialité</label>
                                    <select class="form-select" id="specialtyId" name="specialtyId">
                                        <option value="">-- Sélectionner une spécialité --</option>
                                        <c:forEach items="${specialties}" var="specialty">
                                            <option value="${specialty.id}"
                                                ${doctor.specialty != null && doctor.specialty.id == specialty.id ? 'selected' : ''}>
                                                ${specialty.nom}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="profile-section">
                            <h3 class="profile-section-title">
                                <i class="fas fa-file-medical me-2"></i>Informations professionnelles
                            </h3>

                            <div class="row g-3">
                                <div class="col-12">
                                    <label for="presentation" class="form-label">Présentation</label>
                                    <textarea class="form-control" id="presentation" name="presentation" rows="3">${doctor.presentation}</textarea>
                                    <small class="form-text text-muted">Une brève description de vous-même et de votre approche de soins.</small>
                                </div>
                                <div class="col-md-6">
                                    <label for="experience" class="form-label">Expérience professionnelle</label>
                                    <textarea class="form-control" id="experience" name="experience" rows="4">${doctor.experience}</textarea>
                                    <small class="form-text text-muted">Décrivez votre parcours professionnel.</small>
                                </div>
                                <div class="col-md-6">
                                    <label for="formation" class="form-label">Formation et diplômes</label>
                                    <textarea class="form-control" id="formation" name="formation" rows="4">${doctor.formation}</textarea>
                                    <small class="form-text text-muted">Listez vos diplômes et certifications.</small>
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
                                    <c:if test="${not empty passwordError}">
                                        <small class="text-danger">${passwordError}</small>
                                    </c:if>
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
                                <i class="fas fa-save me-2"></i>Save Updates
                            </button>
                        </div>
                    </form>
                </div>

                <div class="footer">
                    &copy; 2025 e-Clinique. Tous droits réservés.
                </div>
            </div>
        </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('mainContent');
        const topbar = document.getElementById('topbar');
        const toggleSidebarBtn = document.getElementById('toggleSidebar');
        const mobileOverlay = document.getElementById('mobileOverlay');
        const themeToggle = document.getElementById('themeToggle');
        const themeIcon = document.getElementById('themeIcon');
        const htmlElement = document.documentElement;

        const currentTheme = localStorage.getItem('theme') || 'light';
        htmlElement.setAttribute('data-theme', currentTheme);
        updateThemeIcon(currentTheme);

        themeToggle.addEventListener('click', function() {
            let theme = htmlElement.getAttribute('data-theme');
            let newTheme = theme === 'light' ? 'dark' : 'light';

            htmlElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            updateThemeIcon(newTheme);
        });

        function updateThemeIcon(theme) {
            if (theme === 'dark') {
                themeIcon.classList.remove('fa-moon');
                themeIcon.classList.add('fa-sun');
            } else {
                themeIcon.classList.remove('fa-sun');
                themeIcon.classList.add('fa-moon');
            }
        }

        function checkScreenWidth() {
            const isDesktop = window.innerWidth >= 992;
            return isDesktop;
        }

        function toggleSidebar() {
            const isDesktop = checkScreenWidth();
            if (isDesktop) {
                sidebar.classList.toggle('collapsed');
                mainContent.classList.toggle('expanded');
                topbar.classList.toggle('expanded');
            } else {
                sidebar.classList.toggle('mobile-visible');
                mobileOverlay.classList.toggle('active');
            }
        }

        toggleSidebarBtn.addEventListener('click', toggleSidebar);
        mobileOverlay.addEventListener('click', function() {
            sidebar.classList.remove('mobile-visible');
            mobileOverlay.classList.remove('active');
        });

        window.addEventListener('resize', function() {
            const isDesktop = checkScreenWidth();
            if (isDesktop) {
                sidebar.classList.remove('mobile-visible');
                mobileOverlay.classList.remove('active');
            }
        });

        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            if (alerts.length > 0) {
                setTimeout(function() {
                    alerts.forEach(function(alert) {
                        alert.style.transition = 'opacity 0.5s ease';
                        alert.style.opacity = '0';
                        setTimeout(function() {
                            alert.remove();
                        }, 500);
                    });
                }, 5000);
            }
        });
    </script>
</body>
</html>