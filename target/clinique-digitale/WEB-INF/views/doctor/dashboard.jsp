<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de bord - e-Clinique</title>
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

        .welcome-card {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0, 180, 216, 0.2);
            position: relative;
            overflow: hidden;
        }

        .welcome-card::before {
            content: "";
            position: absolute;
            top: -50px;
            right: -50px;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            z-index: 1;
        }

        .welcome-card h2 {
            margin: 0;
            font-weight: 700;
            font-size: 1.8rem;
            margin-bottom: 10px;
            position: relative;
            z-index: 2;
        }

        .welcome-card p {
            opacity: 0.9;
            margin: 0;
            font-size: 1rem;
            position: relative;
            z-index: 2;
        }

        .info-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 25px;
        }

        .info-card {
            background-color: var(--card-light);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
        }

        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .info-card-icon {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-right: 20px;
        }

        .info-card-content {
            flex: 1;
        }

        .info-card-title {
            font-size: 0.85rem;
            color: #6c757d;
            margin: 0;
        }

        .info-card-value {
            font-size: 1.4rem;
            font-weight: 700;
            margin: 0;
            line-height: 1.2;
        }

        .content-card {
            background-color: var(--card-light);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .section-title {
            font-weight: 700;
            font-size: 1.3rem;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .section-title-actions {
            display: flex;
            gap: 10px;
        }

        .section-title-actions .btn {
            padding: 0.25rem 0.7rem;
            font-size: 0.875rem;
        }

        .appointment-card {
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
        }

        .appointment-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
        }

        .appointment-time {
            background-color: var(--primary);
            color: white;
            width: 70px;
            height: 70px;
            border-radius: 10px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
        }

        .appointment-time .hour {
            font-size: 1.2rem;
            font-weight: 700;
        }

        .appointment-time .duration {
            font-size: 0.7rem;
            opacity: 0.9;
        }

        .appointment-info {
            flex: 1;
        }

        .appointment-patient {
            font-weight: 600;
            font-size: 1rem;
            margin-bottom: 5px;
        }

        .appointment-details {
            color: #6c757d;
            font-size: 0.85rem;
            margin-bottom: 10px;
        }

        .appointment-actions {
            display: flex;
            gap: 10px;
            margin-left: auto;
        }

        .appointment-actions .btn {
            padding: 0.25rem 0.7rem;
            font-size: 0.875rem;
        }

        .status-tag {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 15px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-right: 5px;
        }

        .status-planned {
            background-color: #e7f5ff;
            color: #1971c2;
        }

        .status-done {
            background-color: #e6fcf5;
            color: #099268;
        }

        .status-canceled {
            background-color: #fff5f5;
            color: #e03131;
        }

        .calendar-view {
            display: flex;
            flex-direction: column;
        }

        .calendar-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .date-navigator {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .date-navigator button {
            background: none;
            border: none;
            color: var(--primary);
            font-size: 1.2rem;
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .date-navigator button:hover {
            transform: scale(1.2);
        }

        .date-navigator .current-date {
            font-weight: 600;
            font-size: 1.1rem;
        }

        .view-toggle {
            display: flex;
            align-items: center;
            background-color: var(--bg-light);
            border-radius: 20px;
            padding: 5px;
        }

        .view-toggle-btn {
            padding: 5px 15px;
            border: none;
            background: none;
            border-radius: 15px;
            cursor: pointer;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .view-toggle-btn.active {
            background-color: var(--primary);
            color: white;
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }

        .calendar-day {
            height: 80px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 10px;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .calendar-day:hover {
            background-color: var(--bg-light);
        }

        .calendar-day.today {
            border-color: var(--primary);
            background-color: rgba(0, 180, 216, 0.05);
        }

        .calendar-day.other-month {
            opacity: 0.5;
        }

        .calendar-day-header {
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }

        .calendar-day-content {
            font-size: 0.8rem;
        }

        .calendar-day-event {
            background-color: var(--primary);
            color: white;
            border-radius: 5px;
            padding: 2px 5px;
            margin-bottom: 2px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            font-size: 0.75rem;
        }

        .day-view {
            display: grid;
            grid-template-columns: repeat(1, 1fr);
            gap: 10px;
        }

        .day-hour {
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 10px;
            display: flex;
        }

        .day-hour-time {
            width: 80px;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .day-hour-content {
            flex: 1;
            position: relative;
        }

        .day-hour-event {
            background-color: var(--primary);
            color: white;
            border-radius: 5px;
            padding: 5px 10px;
            margin-bottom: 5px;
        }

        .patient-card {
            display: flex;
            align-items: center;
            padding: 15px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }

        .patient-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
        }

        .patient-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 1.2rem;
            margin-right: 15px;
        }

        .patient-info {
            flex: 1;
        }

        .patient-name {
            font-weight: 600;
            margin-bottom: 5px;
        }

        .patient-details {
            color: #6c757d;
            font-size: 0.85rem;
        }

        .patient-actions {
            margin-left: auto;
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

            .info-cards {
                grid-template-columns: repeat(2, 1fr);
            }

            .calendar-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 768px) {
            .content-area {
                padding: 15px;
            }

            .info-cards {
                grid-template-columns: 1fr;
            }

            .content-card {
                padding: 15px;
            }

            .appointment-card {
                flex-direction: column;
                align-items: flex-start;
            }

            .appointment-time {
                width: 60px;
                height: 60px;
                margin-bottom: 10px;
            }

            .appointment-actions {
                margin-left: 0;
                margin-top: 10px;
                width: 100%;
                justify-content: flex-end;
            }

            .calendar-grid {
                grid-template-columns: repeat(1, 1fr);
            }

            .calendar-header {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
<body>

    <c:set var="pageTitle" value="Dashboard" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <div class="topbar" id="topbar">
            <button class="toggle-sidebar" id="toggleSidebar">
                <i class="fas fa-bars"></i>
            </button>
            <h1 class="topbar-title">Tableau de bord</h1>
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
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/doctor/settings"><i class="fas fa-cog me-2"></i>Paramètres</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Déconnexion</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="content-area">
            <div class="welcome-card">
                <h2>Bonjour, ${doctor.titre} ${doctor.nom}</h2>
                <p>
                    <fmt:formatDate value="${today}" pattern="EEEE dd MMMM yyyy" />
                    - Bienvenue sur votre espace médecin e-Clinique
                </p>
            </div>

            <div class="info-cards">
                <div class="info-card">
                    <div class="info-card-icon">
                        <i class="fas fa-calendar-day"></i>
                    </div>
                    <div class="info-card-content">
                        <p class="info-card-title">Rendez-vous aujourd'hui</p>
                        <h3 class="info-card-value">${fn:length(todaysAppointments)}</h3>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-card-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="info-card-content">
                        <p class="info-card-title">Consultations terminées</p>
                        <h3 class="info-card-value">${completedToday}</h3>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-card-icon">
                        <i class="fas fa-hourglass-half"></i>
                    </div>
                    <div class="info-card-content">
                        <p class="info-card-title">Consultations à venir</p>
                        <h3 class="info-card-value">${pendingToday}</h3>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-card-icon">
                        <i class="fas fa-calendar-plus"></i>
                    </div>
                    <div class="info-card-content">
                        <p class="info-card-title">Prochains jours</p>
                        <button class="btn btn-sm btn-primary mt-2" onclick="window.location.href='${pageContext.request.contextPath}/doctor/schedule'">
                            <i class="fas fa-calendar-alt me-1"></i>Voir agenda
                        </button>
                    </div>
                </div>
            </div>

            <div class="content-card">
                <h2 class="section-title">
                    Rendez-vous d'aujourd'hui
                    <div class="section-title-actions">
                        <a href="${pageContext.request.contextPath}/doctor/schedule" class="btn btn-outline-primary">
                            <i class="fas fa-calendar me-1"></i>Agenda complet
                        </a>
                    </div>
                </h2>

                <div class="appointments-list">
                    <c:choose>
                        <c:when test="${not empty todaysAppointments}">
                            <c:forEach var="appointment" items="${todaysAppointments}">
                                <div class="appointment-card">
                                    <div class="appointment-time">
                                        <div class="hour">
                                            <fmt:formatDate value="${appointment.heureDebut}" pattern="HH:mm" />
                                        </div>
                                        <div class="duration">
                                            <fmt:formatDate value="${appointment.heureDebut}" pattern="HH:mm" /> -
                                            <fmt:formatDate value="${appointment.heureFin}" pattern="HH:mm" />
                                        </div>
                                    </div>
                                    <div class="appointment-info">
                                        <div class="appointment-patient">${appointment.patientNom}</div>
                                        <div class="appointment-details">
                                            <span class="status-tag
                                                <c:choose>
                                                    <c:when test="${appointment.statut == 'PLANNED'}">status-planned</c:when>
                                                    <c:when test="${appointment.statut == 'DONE'}">status-done</c:when>
                                                    <c:when test="${appointment.statut == 'CANCELED'}">status-canceled</c:when>
                                                </c:choose>
                                            ">
                                                <c:choose>
                                                    <c:when test="${appointment.statut == 'PLANNED'}">À venir</c:when>
                                                    <c:when test="${appointment.statut == 'DONE'}">Terminé</c:when>
                                                    <c:when test="${appointment.statut == 'CANCELED'}">Annulé</c:when>
                                                </c:choose>
                                            </span>
                                            Motif: ${appointment.motif}
                                        </div>
                                    </div>
                                    <div class="appointment-actions">
                                        <c:if test="${appointment.statut == 'PLANNED'}">
                                            <button class="btn btn-sm btn-outline-success" onclick="validateAppointment('${appointment.id}')">
                                                <i class="fas fa-check me-1"></i>Valider
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger" onclick="cancelAppointment('${appointment.id}')">
                                                <i class="fas fa-times me-1"></i>Annuler
                                            </button>
                                        </c:if>
                                        <c:if test="${appointment.statut == 'DONE'}">
                                            <a href="${pageContext.request.contextPath}/doctor/medical-note?appointmentId=${appointment.id}" class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-file-medical me-1"></i>Notes
                                            </a>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/doctor/appointment-details?id=${appointment.id}" class="btn btn-sm btn-outline-secondary">
                                            <i class="fas fa-info-circle me-1"></i>Détails
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <i class="fas fa-calendar-day text-muted fa-3x mb-3"></i>
                                <h5>Vous n'avez aucun rendez-vous aujourd'hui</h5>
                                <p class="text-muted">Profitez de votre journée!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-6">
                    <div class="content-card">
                        <h2 class="section-title">
                            Disponibilités d'aujourd'hui
                            <div class="section-title-actions">
                                <a href="${pageContext.request.contextPath}/doctor/availability" class="btn btn-outline-primary">
                                    <i class="fas fa-clock me-1"></i>Gérer
                                </a>
                            </div>
                        </h2>

                        <c:choose>
                            <c:when test="${not empty availableSlots}">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6 class="text-muted mb-3">Matin</h6>
                                        <c:forEach var="slot" items="${availableSlots}">
                                            <c:if test="${slot.startTime.hour < 12}">
                                                <div class="badge bg-primary mb-2 p-2">
                                                    ${slot.displayTime}
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                    <div class="col-md-6">
                                        <h6 class="text-muted mb-3">Après-midi</h6>
                                        <c:forEach var="slot" items="${availableSlots}">
                                            <c:if test="${slot.startTime.hour >= 12}">
                                                <div class="badge bg-primary mb-2 p-2">
                                                    ${slot.displayTime}
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-3">
                                    <i class="fas fa-clock text-muted fa-2x mb-2"></i>
                                    <p>Aucune disponibilité définie pour aujourd'hui</p>
                                    <a href="${pageContext.request.contextPath}/doctor/availability" class="btn btn-sm btn-primary mt-2">
                                        <i class="fas fa-plus me-1"></i>Ajouter des disponibilités
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="content-card">
                        <h2 class="section-title">
                            Patients récents
                            <div class="section-title-actions">
                                <a href="${pageContext.request.contextPath}/doctor/patients" class="btn btn-outline-primary">
                                    <i class="fas fa-users me-1"></i>Tous
                                </a>
                            </div>
                        </h2>

                        <c:choose>
                            <c:when test="${not empty recentPatients}">
                                <c:forEach var="patient" items="${recentPatients}">
                                    <div class="patient-card">
                                        <div class="patient-avatar">
                                            ${fn:substring(patient.nom, 0, 1)}
                                        </div>
                                        <div class="patient-info">
                                            <div class="patient-name">${patient.nom}</div>
                                            <div class="patient-details">
                                                <c:if test="${not empty patient.naissance}">
                                                    <i class="fas fa-birthday-cake me-1"></i>
                                                    <fmt:formatDate value="${patient.naissance}" pattern="dd/MM/yyyy" />
                                                    <span class="mx-1">|</span>
                                                </c:if>
                                                <c:if test="${not empty patient.telephone}">
                                                    <i class="fas fa-phone me-1"></i>${patient.telephone}
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="patient-actions">
                                            <a href="${pageContext.request.contextPath}/doctor/patient-details?id=${patient.id}" class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-folder-open me-1"></i>Dossier
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4">
                                    <i class="fas fa-user-injured text-muted fa-2x mb-2"></i>
                                    <p>Aucun patient récent</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
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

        function validateAppointment(id) {
            if (confirm("Confirmer ce rendez-vous ?")) {
                fetch('${pageContext.request.contextPath}/doctor/validate-appointment', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'appointmentId=' + id
                })
                .then(response => {
                    if (response.ok) {
                        window.location.reload();
                    } else {
                        alert("Une erreur est survenue lors de la validation du rendez-vous.");
                    }
                });
            }
        }

        function cancelAppointment(id) {
            if (confirm("Êtes-vous sûr de vouloir annuler ce rendez-vous ?")) {
                fetch('${pageContext.request.contextPath}/doctor/cancel-appointment', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'appointmentId=' + id
                })
                .then(response => {
                    if (response.ok) {
                        window.location.reload();
                    } else {
                        alert("Une erreur est survenue lors de l'annulation du rendez-vous.");
                    }
                });
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
    </script>
</body>
</html>