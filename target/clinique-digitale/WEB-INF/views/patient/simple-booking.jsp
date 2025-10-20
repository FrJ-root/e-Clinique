<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" data-theme="${sessionScope.theme || 'light'}">
<head>
    <title>Prendre un Rendez-vous - e-Clinique</title>
    <%@ include file="components/head.jsp" %>

    <style>
        /* Enhanced Progress bar styles */
        .booking-progress {
            display: flex;
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(0, 180, 216, 0.05) 0%, rgba(0, 150, 180, 0.05) 100%);
            padding: 20px;
            border-radius: 15px;
        }

        .progress-step {
            flex: 1;
            text-align: center;
            padding: 15px 10px;
            position: relative;
            z-index: 1;
            opacity: 0.5;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .progress-step.active {
            opacity: 1;
            font-weight: 600;
            color: var(--primary);
            transform: scale(1.05);
        }

        .progress-step.completed {
            opacity: 0.9;
        }

        .progress-step .step-number {
            background: linear-gradient(135deg, #f5f5f5 0%, #e0e0e0 100%);
            color: #999;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 12px;
            border: 3px solid #ddd;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            font-weight: bold;
            font-size: 1.2rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .progress-step.active .step-number {
            background: linear-gradient(135deg, var(--primary) 0%, #0098b8 100%);
            color: white;
            border-color: var(--primary);
            box-shadow: 0 4px 15px rgba(0, 180, 216, 0.4);
            animation: pulse 2s infinite;
        }

        .progress-step.completed .step-number {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary) 100%);
            color: white;
            border-color: var(--primary-dark);
            box-shadow: 0 3px 10px rgba(0, 150, 180, 0.3);
        }

        .progress-step.completed .step-number::after {
            content: "✓";
            position: absolute;
            font-size: 1.5rem;
        }

        .progress-step .step-label {
            font-size: 0.95rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .progress-step.active .step-label {
            color: var(--primary);
            font-weight: 600;
        }

        .progress-bar-line {
            position: absolute;
            top: 45px;
            height: 4px;
            background: linear-gradient(90deg, #e0e0e0 0%, #d0d0d0 100%);
            left: 10%;
            right: 10%;
            z-index: 0;
            border-radius: 2px;
        }

        .progress-bar-fill {
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            background: linear-gradient(90deg, var(--primary) 0%, #0098b8 100%);
            width: 0%;
            transition: width 0.8s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 2px;
            box-shadow: 0 2px 8px rgba(0, 180, 216, 0.4);
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }

        /* Enhanced Booking section styles */
        .booking-section {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.9) 0%, rgba(250, 250, 250, 0.9) 100%);
            border: 2px solid transparent;
            background-clip: padding-box;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        .booking-section:hover {
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
            transform: translateY(-2px);
        }

        .booking-section h4 {
            font-weight: 700;
            margin-bottom: 25px;
            color: var(--primary-dark);
            border-bottom: 3px solid var(--primary);
            padding-bottom: 15px;
            display: inline-block;
            position: relative;
        }

        .booking-section h4::after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 0;
            width: 50%;
            height: 3px;
            background: linear-gradient(90deg, var(--primary) 0%, transparent 100%);
        }

        /* Enhanced Doctor cards */
        .doctor-card {
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 15px;
            overflow: hidden;
            background: white;
            box-shadow: 0 3px 15px rgba(0, 0, 0, 0.08);
        }

        .doctor-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 35px rgba(0, 180, 216, 0.2);
        }

        .doctor-card.border-primary {
            border: 3px solid var(--primary) !important;
            box-shadow: 0 8px 30px rgba(0, 180, 216, 0.25);
        }

        .doctor-card .card-body {
            padding: 25px;
        }

        .doctor-card .card-title {
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 15px;
            font-size: 1.25rem;
        }

        .doctor-card .card-text {
            line-height: 1.8;
        }

        /* Enhanced Date buttons */
        .date-btn {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            padding: 15px;
            font-weight: 600;
            border-radius: 12px;
            border: 2px solid var(--border-color);
            position: relative;
            overflow: hidden;
        }

        .date-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s ease;
        }

        .date-btn:hover::before {
            left: 100%;
        }

        .date-btn:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0, 180, 216, 0.3);
            border-color: var(--primary);
        }

        .date-btn.btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, #0098b8 100%);
            border-color: var(--primary);
            box-shadow: 0 5px 15px rgba(0, 180, 216, 0.4);
        }

        /* Enhanced Time slots */
        .time-slot-container {
            position: relative;
        }

        .form-check {
            margin: 0;
        }

        .form-check-input {
            display: none;
        }

        .form-check-label {
            display: block;
            padding: 12px 20px;
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .form-check-label:hover {
            background: linear-gradient(135deg, rgba(0, 180, 216, 0.1) 0%, rgba(0, 150, 180, 0.1) 100%);
            border-color: var(--primary);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 180, 216, 0.2);
        }

        .form-check-input:checked + .form-check-label {
            background: linear-gradient(135deg, var(--primary) 0%, #0098b8 100%);
            color: white;
            border-color: var(--primary);
            box-shadow: 0 5px 15px rgba(0, 180, 216, 0.4);
            transform: scale(1.05);
        }

        /* Enhanced Form elements */
        .form-select, .form-control {
            border: 2px solid var(--border-color);
            border-radius: 10px;
            padding: 12px 18px;
            transition: all 0.3s ease;
            font-size: 1rem;
        }

        .form-select:focus, .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 0.25rem rgba(0, 180, 216, 0.15);
        }

        /* Enhanced Buttons */
        .btn {
            border-radius: 10px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, #0098b8 100%);
            border: none;
            box-shadow: 0 4px 15px rgba(0, 180, 216, 0.3);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #0098b8 0%, var(--primary) 100%);
            box-shadow: 0 6px 20px rgba(0, 180, 216, 0.4);
            transform: translateY(-2px);
        }

        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #20c997 0%, #28a745 100%);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
            transform: translateY(-2px);
        }

        .btn-outline-primary {
            border: 2px solid var(--primary);
            color: var(--primary);
            background: transparent;
        }

        .btn-outline-primary:hover {
            background: linear-gradient(135deg, var(--primary) 0%, #0098b8 100%);
            border-color: var(--primary);
            color: white;
            transform: translateY(-2px);
        }

        /* Enhanced Summary card */
        .summary-card {
            background: linear-gradient(135deg, rgba(0, 180, 216, 0.05) 0%, rgba(0, 150, 180, 0.05) 100%);
            border: 2px solid var(--primary);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0, 180, 216, 0.15);
        }

        .summary-card .card-title {
            color: var(--primary-dark);
            font-weight: 700;
            margin-bottom: 20px;
        }

        .summary-card strong {
            color: var(--primary-dark);
        }

        /* Enhanced Alerts */
        .alert {
            border-radius: 12px;
            border: none;
            padding: 18px 24px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
        }

        .alert-info {
            background: linear-gradient(135deg, rgba(13, 202, 240, 0.1) 0%, rgba(13, 180, 240, 0.1) 100%);
            border-left: 4px solid #0dcaf0;
        }

        .alert-warning {
            background: linear-gradient(135deg, rgba(255, 193, 7, 0.1) 0%, rgba(255, 173, 7, 0.1) 100%);
            border-left: 4px solid #ffc107;
        }

        .alert-danger {
            background: linear-gradient(135deg, rgba(220, 53, 69, 0.1) 0%, rgba(200, 53, 69, 0.1) 100%);
            border-left: 4px solid #dc3545;
        }

        /* Animations */
        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .booking-section {
            animation: slideInUp 0.6s ease-out;
        }

        /* Icon enhancements */
        .booking-section h4 i,
        .doctor-card i,
        .btn i {
            transition: transform 0.3s ease;
        }

        .booking-section:hover h4 i,
        .doctor-card:hover i,
        .btn:hover i {
            transform: scale(1.1);
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .progress-step .step-label {
                font-size: 0.75rem;
            }

            .progress-step .step-number {
                width: 40px;
                height: 40px;
                font-size: 1rem;
            }

            .booking-section {
                padding: 20px;
            }

            .booking-section h4 {
                font-size: 1.25rem;
            }
        }

        @media (max-width: 576px) {
            .progress-step .step-label {
                display: none;
            }

            .progress-step .step-number {
                width: 35px;
                height: 35px;
                font-size: 0.9rem;
            }

            .booking-section {
                padding: 15px;
            }
        }

        /* Smooth scrolling */
        html {
            scroll-behavior: smooth;
        }

        /* Loading animation for forms */
        .form-select:disabled,
        .form-control:disabled {
            background: linear-gradient(90deg, #f0f0f0 0%, #e0e0e0 50%, #f0f0f0 100%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
        }

        @keyframes loading {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }

    </style>
</head>
<body>
    <c:set var="pageTitle" value="Prendre un Rendez-vous" scope="request" />
    <%@ include file="components/sidebar.jsp" %>

    <main class="main-content" id="mainContent">
        <%@ include file="components/header.jsp" %>

        <div class="content-area">
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="content-card">
                <h2 class="mb-4">
                    <i class="fas fa-calendar-plus me-3"></i>Prendre un rendez-vous
                </h2>

                <!-- Progress Bar -->
                <div class="booking-progress">
                    <div class="progress-bar-line">
                        <div class="progress-bar-fill" style="width:
                            <c:choose>
                                <c:when test="${not empty timeSlots}">80%</c:when>
                                <c:when test="${not empty selectedDate}">60%</c:when>
                                <c:when test="${not empty selectedDoctor}">40%</c:when>
                                <c:when test="${not empty selectedSpecialtyId}">20%</c:when>
                                <c:otherwise>0%</c:otherwise>
                            </c:choose>
                        "></div>
                    </div>

                    <div class="progress-step ${empty selectedDepartmentId ? 'active' : 'completed'}">
                        <div class="step-number">1</div>
                        <div class="step-label">Département</div>
                    </div>

                    <div class="progress-step
                        <c:choose>
                            <c:when test="${not empty selectedDepartmentId and empty selectedSpecialtyId}">active</c:when>
                            <c:when test="${not empty selectedSpecialtyId}">completed</c:when>
                        </c:choose>">
                        <div class="step-number">2</div>
                        <div class="step-label">Spécialité</div>
                    </div>

                    <div class="progress-step
                        <c:choose>
                            <c:when test="${not empty selectedSpecialtyId and empty selectedDoctorId}">active</c:when>
                            <c:when test="${not empty selectedDoctorId}">completed</c:when>
                        </c:choose>">
                        <div class="step-number">3</div>
                        <div class="step-label">Médecin</div>
                    </div>

                    <div class="progress-step
                        <c:choose>
                            <c:when test="${not empty selectedDoctorId and empty selectedDate}">active</c:when>
                            <c:when test="${not empty selectedDate}">completed</c:when>
                        </c:choose>">
                        <div class="step-number">4</div>
                        <div class="step-label">Date</div>
                    </div>

                    <div class="progress-step ${not empty selectedDate ? 'active' : ''}">
                        <div class="step-number">5</div>
                        <div class="step-label">Confirmation</div>
                    </div>
                </div>

                <!-- Step 1: Select Department -->
                <div class="booking-section">
                    <h4><i class="fas fa-hospital me-2"></i>1. Choisir un département</h4>
                    <form action="${pageContext.request.contextPath}/patient/simple-booking" method="get">
                        <div class="row">
                            <div class="col-lg-8 col-md-10">
                                <select name="departmentId" class="form-select" onchange="this.form.submit()" required>
                                    <option value="">-- Sélectionnez un département --</option>
                                    <c:forEach items="${departments}" var="dept">
                                        <option value="${dept.id}" ${selectedDepartmentId eq dept.id ? 'selected' : ''}>
                                            ${dept.nom}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Step 2: Select Specialty -->
                <c:if test="${not empty specialties}">
                    <div class="booking-section">
                        <h4><i class="fas fa-stethoscope me-2"></i>2. Choisir une spécialité</h4>
                        <form action="${pageContext.request.contextPath}/patient/simple-booking" method="get">
                            <input type="hidden" name="departmentId" value="${selectedDepartmentId}">
                            <div class="row">
                                <div class="col-lg-8 col-md-10">
                                    <select name="specialtyId" class="form-select" onchange="this.form.submit()" required>
                                        <option value="">-- Sélectionnez une spécialité --</option>
                                        <c:forEach items="${specialties}" var="spec">
                                            <option value="${spec.id}" ${selectedSpecialtyId eq spec.id ? 'selected' : ''}>
                                                ${spec.nom}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </form>
                    </div>
                </c:if>

                <!-- Step 3: Select Doctor -->
                <c:if test="${not empty doctors}">
                    <div class="booking-section">
                        <h4><i class="fas fa-user-md me-2"></i>3. Choisir un médecin</h4>
                        <div class="row">
                            <c:forEach items="${doctors}" var="doctor">
                                <div class="col-lg-6 col-md-12 mb-4">
                                    <div class="card doctor-card ${selectedDoctorId eq doctor.id ? 'border-primary border-3' : ''}">
                                        <div class="card-body">
                                            <h5 class="card-title">
                                                <i class="fas fa-user-md me-2"></i>${doctor.titre} ${doctor.nom}
                                            </h5>
                                            <p class="card-text mb-3">
                                                <i class="fas fa-stethoscope me-2 text-primary"></i>${doctor.specialty.nom}<br>
                                                <i class="fas fa-building me-2 text-muted"></i>${doctor.specialty.department.nom}
                                            </p>

                                            <c:url var="doctorSelectUrl" value="/patient/simple-booking">
                                                <c:param name="departmentId" value="${selectedDepartmentId}"/>
                                                <c:param name="specialtyId" value="${selectedSpecialtyId}"/>
                                                <c:param name="doctorId" value="${doctor.id}"/>
                                            </c:url>

                                            <a href="${doctorSelectUrl}"
                                               class="btn ${selectedDoctorId eq doctor.id ? 'btn-success' : 'btn-primary'} btn-lg w-100">
                                                <i class="fas ${selectedDoctorId eq doctor.id ? 'fa-check-circle' : 'fa-hand-pointer'} me-2"></i>
                                                ${selectedDoctorId eq doctor.id ? 'Médecin sélectionné' : 'Sélectionner ce médecin'}
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <!-- Step 4: Select Date -->
                <c:if test="${not empty selectedDoctor}">
                    <div class="booking-section">
                        <h4><i class="fas fa-calendar-day me-2"></i>4. Choisir une date</h4>

                        <c:choose>
                            <c:when test="${not empty availableDates}">
                                <div class="row">
                                    <c:forEach items="${availableDates}" var="date" varStatus="status">
                                        <c:if test="${status.index < 14}">
                                            <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-3">
                                                <c:url var="dateSelectUrl" value="/patient/simple-booking">
                                                    <c:param name="departmentId" value="${selectedDepartmentId}"/>
                                                    <c:param name="specialtyId" value="${selectedSpecialtyId}"/>
                                                    <c:param name="doctorId" value="${selectedDoctorId}"/>
                                                    <c:param name="date" value="${date}"/>
                                                </c:url>

                                                <a href="${dateSelectUrl}"
                                                   class="btn ${selectedDate eq date.toString() ? 'btn-primary' : 'btn-outline-primary'} w-100 date-btn">
                                                    <i class="fas fa-calendar me-2"></i>
                                                    ${date}
                                                </a>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>

                                <c:if test="${fn:length(availableDates) > 14}">
                                    <div class="text-center mt-4">
                                        <small class="text-muted">
                                            <i class="fas fa-info-circle me-1"></i>
                                            ${fn:length(availableDates) - 14} dates supplémentaires disponibles
                                        </small>
                                    </div>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-warning">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    Ce médecin n'a pas de disponibilités pour le moment. Veuillez choisir un autre médecin ou contacter l'accueil.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <!-- Step 5: Select Time & Confirm -->
                <c:if test="${not empty timeSlots}">
                    <div class="booking-section">
                        <h4><i class="fas fa-clock me-2"></i>5. Choisir un horaire et confirmer</h4>

                        <div class="alert alert-info mb-4">
                            <i class="fas fa-info-circle me-2"></i>
                            Les rendez-vous doivent être pris au moins 2 heures à l'avance.
                        </div>

                        <form action="${pageContext.request.contextPath}/patient/simple-booking" method="post">
                            <input type="hidden" name="doctorId" value="${selectedDoctorId}">
                            <input type="hidden" name="date" value="${selectedDate}">

                            <!-- Time Slots Section -->
                            <div class="mb-5">
                                <h5 class="mb-4"><i class="fas fa-clock me-2"></i>Créneaux disponibles</h5>
                                <div class="row">
                                    <c:forEach items="${timeSlots}" var="slot">
                                        <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-3">
                                            <div class="form-check time-slot-container">
                                                <input class="form-check-input" type="radio" name="timeSlot"
                                                       id="slot_${fn:replace(slot.startTime, ':', '_')}"
                                                       value="${slot.startTime}_${slot.endTime}" required>
                                                <label class="form-check-label" for="slot_${fn:replace(slot.startTime, ':', '_')}">
                                                    <i class="fas fa-clock me-2"></i>${slot.displayTime}
                                                </label>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Motif Section -->
                            <div class="mb-5">
                                <h5 class="mb-3"><i class="fas fa-clipboard-list me-2"></i>Motif de consultation</h5>
                                <textarea class="form-control" id="motif" name="motif" rows="5"
                                          placeholder="Décrivez brièvement la raison de votre consultation..." required></textarea>
                                <small class="form-text text-muted mt-2 d-block">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Cette information aidera le médecin à mieux préparer votre rendez-vous.
                                </small>
                            </div>

                            <!-- Summary Section -->
                            <div class="card summary-card mb-5">
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <i class="fas fa-clipboard-check me-2"></i>Récapitulatif du rendez-vous
                                    </h5>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <strong><i class="fas fa-user-md me-2 text-primary"></i>Médecin:</strong><br>
                                            <span class="ms-4">${selectedDoctor.titre} ${selectedDoctor.nom}</span>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <strong><i class="fas fa-stethoscope me-2 text-primary"></i>Spécialité:</strong><br>
                                            <span class="ms-4">${selectedDoctor.specialty.nom}</span>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <strong><i class="fas fa-calendar me-2 text-primary"></i>Date:</strong><br>
                                            <span class="ms-4">${selectedDate}</span>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <strong><i class="fas fa-building me-2 text-primary"></i>Département:</strong><br>
                                            <span class="ms-4">${selectedDoctor.specialty.department.nom}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Submit Button -->
                            <div class="d-grid gap-3 d-md-flex justify-content-md-end">
                                <button type="submit" class="btn btn-success btn-lg px-5">
                                    <i class="fas fa-check-circle me-2"></i>Confirmer le rendez-vous
                                </button>
                            </div>
                        </form>
                    </div>
                </c:if>

                <!-- No Time Slots Available -->
                <c:if test="${not empty selectedDate and empty timeSlots}">
                    <div class="booking-section">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Aucun créneau disponible pour cette date. Veuillez choisir une autre date.
                        </div>
                    </div>
                </c:if>
            </div>

            <%@ include file="components/footer.jsp" %>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/patient-script.js"></script>

    <script>
        // Handle time slot selection and form submission
        document.addEventListener('DOMContentLoaded', function() {
            const timeSlotRadios = document.querySelectorAll('input[name="timeSlot"]');
            const form = document.querySelector('form[method="post"]');

            if (form && timeSlotRadios.length > 0) {
                timeSlotRadios.forEach(radio => {
                    radio.addEventListener('change', function() {
                        const [startTime, endTime] = this.value.split('_');

                        // Remove old hidden inputs if they exist
                        let oldStart = form.querySelector('input[name="startTime"]');
                        let oldEnd = form.querySelector('input[name="endTime"]');
                        if (oldStart) oldStart.remove();
                        if (oldEnd) oldEnd.remove();

                        // Add new hidden inputs
                        const startInput = document.createElement('input');
                        startInput.type = 'hidden';
                        startInput.name = 'startTime';
                        startInput.value = startTime;
                        form.appendChild(startInput);

                        const endInput = document.createElement('input');
                        endInput.type = 'hidden';
                        endInput.name = 'endTime';
                        endInput.value = endTime;
                        form.appendChild(endInput);
                    });
                });
            }

            // Smooth scroll to active section
            const activeStep = document.querySelector('.progress-step.active');
            if (activeStep) {
                setTimeout(() => {
                    const sections = document.querySelectorAll('.booking-section');
                    if (sections.length > 0) {
                        const lastSection = sections[sections.length - 1];
                        lastSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                }, 300);
            }
        });
    </script>
</body>
</html>