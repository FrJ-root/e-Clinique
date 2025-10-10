<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - e-Clinique</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #00b4d8;
            --primary-dark: #0096c7;
            --secondary: #48cae4;
            --accent: #90e0ef;
            --dark: #03045e;
            --bg-light: #ffffff;
            --bg-dark: #0a0e27;
            --text-light: #212529;
            --text-dark: #e9ecef;
            --card-light: #ffffff;
            --card-dark: #1a1d3a;
        }

        [data-theme="dark"] {
            --bg-light: #0a0e27;
            --text-light: #e9ecef;
            --card-light: #1a1d3a;
            --primary: #48cae4;
            --dark: #90e0ef;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #00b4d8 0%, #0077b6 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.3s ease;
            position: relative;
            overflow: hidden;
            padding: 40px 0;
        }

        /* Background Pattern */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="1" fill="rgba(255,255,255,0.1)"/></svg>');
            opacity: 0.4;
            z-index: 0;
        }

        /* Animated Background Shapes */
        .bg-shape {
            position: absolute;
            border-radius: 50%;
            opacity: 0.1;
            animation: float 20s infinite ease-in-out;
        }

        .bg-shape-1 {
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.2);
            top: -150px;
            left: -150px;
            animation-delay: 0s;
        }

        .bg-shape-2 {
            width: 500px;
            height: 500px;
            background: rgba(255, 255, 255, 0.15);
            bottom: -200px;
            right: -200px;
            animation-delay: 5s;
        }

        .bg-shape-3 {
            width: 250px;
            height: 250px;
            background: rgba(255, 255, 255, 0.2);
            top: 40%;
            right: 5%;
            animation-delay: 10s;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) scale(1); }
            50% { transform: translateY(-30px) scale(1.1); }
        }

        .register-container {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 900px;
            padding: 20px;
        }

        .register-card {
            background-color: var(--card-light);
            border-radius: 25px;
            box-shadow: 0 25px 70px rgba(0,0,0,0.3);
            overflow: hidden;
            transition: all 0.3s ease;
            animation: slideUp 0.6s ease;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .register-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 40px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .register-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 300px;
            height: 300px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }

        .register-header .brand {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            position: relative;
            z-index: 2;
        }

        .register-header .brand i {
            font-size: 3rem;
            margin-right: 12px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }

        .register-header .brand span {
            font-size: 2.2rem;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .register-header h2 {
            margin: 0;
            font-weight: 700;
            font-size: 1.8rem;
            position: relative;
            z-index: 2;
        }

        .register-header p {
            margin: 12px 0 0 0;
            opacity: 0.95;
            font-size: 1rem;
            font-weight: 400;
            position: relative;
            z-index: 2;
        }

        .register-body {
            padding: 45px 40px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            font-weight: 600;
            color: var(--text-light);
            margin-bottom: 10px;
            display: block;
            font-size: 0.95rem;
        }

        .form-label .required {
            color: #dc3545;
            margin-left: 3px;
        }

        .form-control, .form-select {
            border: 2px solid #e3e8ef;
            border-radius: 12px;
            padding: 14px 18px 14px 50px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background-color: var(--card-light);
            color: var(--text-light);
            width: 100%;
        }

        .form-select {
            padding-left: 50px;
            cursor: pointer;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 0.25rem rgba(0, 180, 216, 0.15);
            outline: none;
            transform: translateY(-2px);
        }

        .input-group {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--primary);
            z-index: 10;
            font-size: 1.1rem;
        }

        .password-toggle {
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6c757d;
            z-index: 10;
            transition: all 0.3s ease;
            font-size: 1.1rem;
        }

        .password-toggle:hover {
            color: var(--primary);
            transform: translateY(-50%) scale(1.1);
        }

        /* Password Strength Indicator */
        .password-strength {
            margin-top: 10px;
            height: 5px;
            border-radius: 3px;
            background-color: #e0e0e0;
            overflow: hidden;
            display: none;
        }

        .password-strength.active {
            display: block;
        }

        .password-strength-bar {
            height: 100%;
            transition: all 0.3s ease;
            width: 0%;
        }

        .password-strength-bar.weak {
            width: 33%;
            background-color: #dc3545;
        }

        .password-strength-bar.medium {
            width: 66%;
            background-color: #ffc107;
        }

        .password-strength-bar.strong {
            width: 100%;
            background-color: #198754;
        }

        .password-strength-text {
            font-size: 0.85rem;
            margin-top: 5px;
            font-weight: 500;
        }

        /* Role Cards */
        .role-selection {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-top: 10px;
        }

        .role-card {
            border: 2px solid #e3e8ef;
            border-radius: 12px;
            padding: 20px 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .role-card:hover {
            border-color: var(--primary);
            transform: translateY(-3px);
            box-shadow: 0 5px 20px rgba(0, 180, 216, 0.2);
        }

        .role-card.active {
            border-color: var(--primary);
            background: linear-gradient(135deg, rgba(0, 180, 216, 0.1), rgba(72, 202, 228, 0.1));
        }

        .role-card input[type="radio"] {
            display: none;
        }

        .role-card i {
            font-size: 2.5rem;
            margin-bottom: 10px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .role-card h5 {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-light);
            margin-bottom: 5px;
        }

        .role-card p {
            font-size: 0.8rem;
            color: #6c757d;
            margin: 0;
        }

        .btn-register {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            border-radius: 12px;
            color: white;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            margin-top: 20px;
            position: relative;
            overflow: hidden;
        }

        .btn-register::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s;
        }

        .btn-register:hover::before {
            left: 100%;
        }

        .btn-register:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(0, 180, 216, 0.4);
        }

        .btn-register:active {
            transform: translateY(-1px);
        }

        .divider {
            text-align: center;
            margin: 30px 0 25px;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, #e0e0e0, transparent);
        }

        .divider span {
            background-color: var(--card-light);
            padding: 0 20px;
            position: relative;
            color: #6c757d;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            color: var(--text-light);
            font-size: 0.95rem;
        }

        .login-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .login-link a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
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

        .alert-danger {
            background-color: #f8d7da;
            color: #842029;
            border-left: 4px solid #dc3545;
        }

        .alert-success {
            background-color: #d1e7dd;
            color: #0f5132;
            border-left: 4px solid #198754;
        }

        .alert i {
            margin-right: 10px;
        }

        .theme-toggle {
            position: absolute;
            top: 25px;
            right: 25px;
            background: rgba(255, 255, 255, 0.25);
            border: 2px solid rgba(255, 255, 255, 0.4);
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.4s ease;
            z-index: 100;
            backdrop-filter: blur(10px);
        }

        .theme-toggle:hover {
            background: rgba(255, 255, 255, 0.35);
            transform: rotate(180deg) scale(1.1);
        }

        /* Back to Home Link */
        .back-home {
            position: absolute;
            top: 25px;
            left: 25px;
            z-index: 100;
        }

        .back-home a {
            color: white;
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 25px;
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }

        .back-home a:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateX(-5px);
        }

        /* Terms Checkbox */
        .terms-checkbox {
            display: flex;
            align-items: flex-start;
            margin-top: 20px;
            margin-bottom: 10px;
        }

        .terms-checkbox input[type="checkbox"] {
            width: 20px;
            height: 20px;
            margin-right: 12px;
            margin-top: 2px;
            cursor: pointer;
            accent-color: var(--primary);
        }

        .terms-checkbox label {
            margin: 0;
            cursor: pointer;
            font-size: 0.9rem;
            color: var(--text-light);
            line-height: 1.5;
        }

        .terms-checkbox label a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
        }

        .terms-checkbox label a:hover {
            text-decoration: underline;
        }

        /* Loading Animation */
        .btn-register .spinner-border {
            display: none;
            width: 22px;
            height: 22px;
            margin-right: 10px;
        }

        .btn-register.loading .spinner-border {
            display: inline-block;
        }

        .btn-register.loading .btn-text {
            opacity: 0.7;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .register-container {
                padding: 15px;
            }

            .register-header {
                padding: 35px 25px;
            }

            .register-body {
                padding: 35px 25px;
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }

            .role-selection {
                grid-template-columns: 1fr;
            }

            .register-header .brand span {
                font-size: 1.8rem;
            }

            .register-header h2 {
                font-size: 1.5rem;
            }

            .back-home, .theme-toggle {
                top: 15px;
            }

            .back-home {
                left: 15px;
            }

            .theme-toggle {
                right: 15px;
            }
        }

        /* Dark Theme Adjustments */
        [data-theme="dark"] body {
            background: linear-gradient(135deg, #1a1d3a 0%, #0a0e27 100%);
        }

        [data-theme="dark"] .form-control,
        [data-theme="dark"] .form-select {
            background-color: #0a0e27;
            border-color: #3d4147;
            color: #e9ecef;
        }

        [data-theme="dark"] .form-control:focus,
        [data-theme="dark"] .form-select:focus {
            border-color: var(--primary);
            background-color: #0a0e27;
        }

        [data-theme="dark"] .divider::before {
            background: linear-gradient(90deg, transparent, #3d4147, transparent);
        }

        [data-theme="dark"] .divider span {
            background-color: var(--card-light);
        }

        [data-theme="dark"] .input-icon {
            color: var(--secondary);
        }

        [data-theme="dark"] .role-card {
            border-color: #3d4147;
        }

        [data-theme="dark"] .role-card:hover {
            border-color: var(--primary);
        }
    </style>
</head>
<body>
    <!-- Animated Background Shapes -->
    <div class="bg-shape bg-shape-1"></div>
    <div class="bg-shape bg-shape-2"></div>
    <div class="bg-shape bg-shape-3"></div>

    <!-- Back to Home -->
    <div class="back-home">
        <a href="${pageContext.request.contextPath}/">
            <i class="fas fa-arrow-left"></i>
            <span>Retour à l'accueil</span>
        </a>
    </div>

    <!-- Theme Toggle -->
    <button class="theme-toggle" id="themeToggle" aria-label="Toggle theme">
        <i class="fas fa-moon" id="themeIcon"></i>
    </button>

    <div class="register-container">
        <div class="register-card">
            <!-- Header -->
            <div class="register-header">
                <div class="brand">
                    <i class="fas fa-heartbeat"></i>
                    <span>e-Clinique</span>
                </div>
                <h2>Créer un Compte</h2>
                <p>Rejoignez-nous pour une meilleure gestion de votre santé</p>
            </div>

            <!-- Body -->
            <div class="register-body">
                <!-- Error Message -->
                <%
                String error = (String) request.getAttribute("error");
                if (error != null && !error.isEmpty()) {
                %>
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= error %>
                    </div>
                <% } %>

                <!-- Success Message -->
                <%
                String success = (String) request.getAttribute("success");
                if (success != null && !success.isEmpty()) {
                %>
                    <div class="alert alert-success" role="alert">
                        <i class="fas fa-check-circle"></i>
                        <%= success %>
                    </div>
                <% } %>

                <!-- Registration Form -->
                <form method="post" action="${pageContext.request.contextPath}/register" id="registerForm">
                    <!-- Name and Email Row -->
                    <div class="form-row">
                        <div class="form-group">
                            <label for="nom" class="form-label">
                                Nom complet<span class="required">*</span>
                            </label>
                            <div class="input-group">
                                <i class="fas fa-user input-icon"></i>
                                <input type="text"
                                       class="form-control"
                                       id="nom"
                                       name="nom"
                                       placeholder="Jean Dupont"
                                       required
                                       value="<%= request.getParameter("nom") != null ? request.getParameter("nom") : "" %>">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email" class="form-label">
                                Adresse e-mail<span class="required">*</span>
                            </label>
                            <div class="input-group">
                                <i class="fas fa-envelope input-icon"></i>
                                <input type="email"
                                       class="form-control"
                                       id="email"
                                       name="email"
                                       placeholder="exemple@email.com"
                                       required
                                       autocomplete="email"
                                       value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                            </div>
                        </div>
                    </div>

                    <!-- Password Field -->
                    <div class="form-group">
                        <label for="password" class="form-label">
                            Mot de passe<span class="required">*</span>
                        </label>
                        <div class="input-group">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password"
                                   class="form-control"
                                   id="password"
                                   name="password"
                                   placeholder="Minimum 8 caractères"
                                   required
                                   autocomplete="new-password">
                            <i class="fas fa-eye password-toggle" id="togglePassword"></i>
                        </div>
                        <div class="password-strength" id="passwordStrength">
                            <div class="password-strength-bar" id="passwordStrengthBar"></div>
                        </div>
                        <div class="password-strength-text" id="passwordStrengthText"></div>
                    </div>

                    <!-- Role Selection -->
                    <div class="form-group">
                        <label class="form-label">
                            Sélectionnez votre profil<span class="required">*</span>
                        </label>
                        <div class="role-selection">
                            <label class="role-card active" for="rolePatient">
                                <input type="radio" name="role" id="rolePatient" value="PATIENT" checked>
                                <i class="fas fa-user-injured"></i>
                                <h5>Patient</h5>
                                <p>Gérer mes rendez-vous</p>
                            </label>

                            <label class="role-card" for="roleDoctor">
                                <input type="radio" name="role" id="roleDoctor" value="DOCTOR">
                                <i class="fas fa-user-md"></i>
                                <h5>Médecin</h5>
                                <p>Consulter mes patients</p>
                            </label>

                            <label class="role-card" for="roleAdmin">
                                <input type="radio" name="role" id="roleAdmin" value="ADMIN">
                                <i class="fas fa-user-shield"></i>
                                <h5>Administrateur</h5>
                                <p>Gérer la plateforme</p>
                            </label>
                        </div>
                    </div>

                    <!-- Terms and Conditions -->
                    <div class="terms-checkbox">
                        <input type="checkbox" id="terms" name="terms" required>
                        <label for="terms">
                            J'accepte les <a href="#">conditions d'utilisation</a> et la <a href="#">politique de confidentialité</a> d'e-Clinique
                        </label>
                    </div>

                    <!-- Register Button -->
                    <button type="submit" class="btn btn-register" id="registerBtn">
                        <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                        <span class="btn-text">
                            <i class="fas fa-user-plus me-2"></i>Créer mon compte
                        </span>
                    </button>
                </form>

                <!-- Divider -->
                <div class="divider">
                    <span>Vous avez déjà un compte ?</span>
                </div>

                <!-- Login Link -->
                <div class="login-link">
                    <a href="${pageContext.request.contextPath}/login">
                        <i class="fas fa-sign-in-alt me-1"></i>Se connecter
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom JavaScript -->
    <script>
        // Theme Toggle
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

        // Password Toggle
        const togglePassword = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('password');

        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);

            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });

        // Password Strength Checker
        const passwordStrength = document.getElementById('passwordStrength');
        const passwordStrengthBar = document.getElementById('passwordStrengthBar');
        const passwordStrengthText = document.getElementById('passwordStrengthText');

        passwordInput.addEventListener('input', function() {
            const password = this.value;

            if (password.length === 0) {
                passwordStrength.classList.remove('active');
                passwordStrengthText.textContent = '';
                return;
            }

            passwordStrength.classList.add('active');

            let strength = 0;
            if (password.length >= 8) strength++;
            if (password.match(/[a-z]/) && password.match(/[A-Z]/)) strength++;
            if (password.match(/[0-9]/)) strength++;
            if (password.match(/[^a-zA-Z0-9]/)) strength++;

            passwordStrengthBar.className = 'password-strength-bar';

            if (strength <= 1) {
                passwordStrengthBar.classList.add('weak');
                passwordStrengthText.textContent = 'Faible';
                passwordStrengthText.style.color = '#dc3545';
            } else if (strength <= 3) {
                passwordStrengthBar.classList.add('medium');
                passwordStrengthText.textContent = 'Moyen';
                passwordStrengthText.style.color = '#ffc107';
            } else {
                passwordStrengthBar.classList.add('strong');
                passwordStrengthText.textContent = 'Fort';
                passwordStrengthText.style.color = '#198754';
            }
        });

        // Role Card Selection
        const roleCards = document.querySelectorAll('.role-card');
        roleCards.forEach(card => {
            card.addEventListener('click', function() {
                roleCards.forEach(c => c.classList.remove('active'));
                this.classList.add('active');
            });
        });

        // Form Submission with Loading State
        const registerForm = document.getElementById('registerForm');
        const registerBtn = document.getElementById('registerBtn');

        registerForm.addEventListener('submit', function(e) {
            registerBtn.classList.add('loading');
            registerBtn.disabled = true;
        });

        // Auto-focus on name field
        window.addEventListener('load', function() {
            document.getElementById('nom').focus();
        });

        // Remove error/success messages after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.transition = 'opacity 0.5s ease';
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.remove();
                }, 500);
            });
        }, 5000);
    </script>
</body>
</html>