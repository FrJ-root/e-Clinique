<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - e-Clinique</title>
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
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.2);
            top: -100px;
            left: -100px;
            animation-delay: 0s;
        }

        .bg-shape-2 {
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.15);
            bottom: -150px;
            right: -150px;
            animation-delay: 5s;
        }

        .bg-shape-3 {
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.2);
            top: 50%;
            right: 10%;
            animation-delay: 10s;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) scale(1); }
            50% { transform: translateY(-30px) scale(1.1); }
        }

        .login-container {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 480px;
            padding: 20px;
        }

        .login-card {
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

        .login-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 45px 35px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .login-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }

        .login-header .brand {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            position: relative;
            z-index: 2;
        }

        .login-header .brand i {
            font-size: 3rem;
            margin-right: 12px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }

        .login-header .brand span {
            font-size: 2.2rem;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .login-header h2 {
            margin: 0;
            font-weight: 700;
            font-size: 1.8rem;
            position: relative;
            z-index: 2;
        }

        .login-header p {
            margin: 12px 0 0 0;
            opacity: 0.95;
            font-size: 1rem;
            font-weight: 400;
            position: relative;
            z-index: 2;
        }

        .login-body {
            padding: 45px 35px;
        }

        .form-group {
            margin-bottom: 28px;
        }

        .form-label {
            font-weight: 600;
            color: var(--text-light);
            margin-bottom: 10px;
            display: block;
            font-size: 0.95rem;
        }

        .form-control {
            border: 2px solid #e3e8ef;
            border-radius: 12px;
            padding: 14px 18px 14px 50px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background-color: var(--card-light);
            color: var(--text-light);
        }

        .form-control:focus {
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

        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            border-radius: 12px;
            color: white;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            margin-top: 15px;
            position: relative;
            overflow: hidden;
        }

        .btn-login::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s;
        }

        .btn-login:hover::before {
            left: 100%;
        }

        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(0, 180, 216, 0.4);
        }

        .btn-login:active {
            transform: translateY(-1px);
        }

        .divider {
            text-align: center;
            margin: 30px 0;
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

        .register-link {
            text-align: center;
            margin-top: 25px;
            color: var(--text-light);
            font-size: 0.95rem;
        }

        .register-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .register-link a:hover {
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

        .forgot-password {
            text-align: right;
        }

        .forgot-password a {
            color: #6c757d;
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.3s ease;
            font-weight: 500;
        }

        .forgot-password a:hover {
            color: var(--primary);
        }

        .remember-me {
            display: flex;
            align-items: center;
        }

        .remember-me input[type="checkbox"] {
            width: 20px;
            height: 20px;
            margin-right: 10px;
            cursor: pointer;
            accent-color: var(--primary);
        }

        .remember-me label {
            margin: 0;
            cursor: pointer;
            font-size: 0.95rem;
            color: var(--text-light);
            font-weight: 500;
        }

        /* Loading Animation */
        .btn-login .spinner-border {
            display: none;
            width: 22px;
            height: 22px;
            margin-right: 10px;
        }

        .btn-login.loading .spinner-border {
            display: inline-block;
        }

        .btn-login.loading .btn-text {
            opacity: 0.7;
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

        /* Responsive */
        @media (max-width: 576px) {
            .login-container {
                padding: 15px;
            }

            .login-header {
                padding: 35px 25px;
            }

            .login-body {
                padding: 35px 25px;
            }

            .login-header .brand span {
                font-size: 1.8rem;
            }

            .login-header h2 {
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

        [data-theme="dark"] .form-control {
            background-color: #0a0e27;
            border-color: #3d4147;
            color: #e9ecef;
        }

        [data-theme="dark"] .form-control:focus {
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

    <div class="login-container">
        <div class="login-card">
            <!-- Header -->
            <div class="login-header">
                <div class="brand">
                    <i class="fas fa-heartbeat"></i>
                    <span>e-Clinique</span>
                </div>
                <h2>Bienvenue</h2>
                <p>Connectez-vous à votre espace santé</p>
            </div>

            <!-- Body -->
            <div class="login-body">
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

                <!-- Login Form -->
                <form method="post" action="${pageContext.request.contextPath}/login" id="loginForm">
                    <!-- Email Field -->
                    <div class="form-group">
                        <label for="email" class="form-label">
                            Adresse e-mail
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

                    <!-- Password Field -->
                    <div class="form-group">
                        <label for="password" class="form-label">
                            Mot de passe
                        </label>
                        <div class="input-group">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password"
                                   class="form-control"
                                   id="password"
                                   name="password"
                                   placeholder="••••••••"
                                   required
                                   autocomplete="current-password">
                            <i class="fas fa-eye password-toggle" id="togglePassword"></i>
                        </div>
                    </div>

                    <!-- Remember Me & Forgot Password -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="remember-me">
                            <input type="checkbox" id="rememberMe" name="rememberMe">
                            <label for="rememberMe">Se souvenir de moi</label>
                        </div>
                        <div class="forgot-password">
                            <a href="${pageContext.request.contextPath}/forgot-password">
                                Mot de passe oublié ?
                            </a>
                        </div>
                    </div>

                    <!-- Login Button -->
                    <button type="submit" class="btn btn-login" id="loginBtn">
                        <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                        <span class="btn-text">
                            <i class="fas fa-sign-in-alt me-2"></i>Se connecter
                        </span>
                    </button>
                </form>

                <!-- Divider -->
                <div class="divider">
                    <span>Nouveau sur e-Clinique ?</span>
                </div>

                <!-- Register Link -->
                <div class="register-link">
                    <a href="${pageContext.request.contextPath}/register">
                        <i class="fas fa-user-plus me-1"></i>Créer un compte gratuitement
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

        // Check for saved theme preference
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

        // Form Submission with Loading State
        const loginForm = document.getElementById('loginForm');
        const loginBtn = document.getElementById('loginBtn');

        loginForm.addEventListener('submit', function(e) {
            loginBtn.classList.add('loading');
            loginBtn.disabled = true;
        });

        // Auto-focus on email field
        window.addEventListener('load', function() {
            document.getElementById('email').focus();
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