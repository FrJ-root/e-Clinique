<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>e-Clinique - Votre Santé Digitale</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
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
      --light: #caf0f8;
      --bg-light: #ffffff;
      --bg-dark: #0a0e27;
      --text-light: #212529;
      --text-dark: #e9ecef;
      --card-light: #ffffff;
      --card-dark: #1a1d3a;
      --nav-light: rgba(255, 255, 255, 0.98);
      --nav-dark: rgba(3, 4, 94, 0.98);
    }

    [data-theme="dark"] {
      --bg-light: #0a0e27;
      --text-light: #e9ecef;
      --card-light: #1a1d3a;
      --nav-light: rgba(26, 29, 58, 0.98);
      --dark: #90e0ef;
      --primary: #48cae4;
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
      transition: background-color 0.3s ease, color 0.3s ease;
      overflow-x: hidden;
    }

    /* Navbar Styling */
    .navbar {
      background-color: var(--nav-light) !important;
      backdrop-filter: blur(10px);
      box-shadow: 0 2px 20px rgba(0,0,0,0.08);
      padding: 1.2rem 0;
      transition: all 0.3s ease;
      position: sticky;
      top: 0;
      z-index: 1000;
    }

    .navbar.scrolled {
      padding: 0.8rem 0;
      box-shadow: 0 5px 30px rgba(0,0,0,0.15);
    }

    .navbar-brand {
      font-size: 1.8rem;
      font-weight: 800;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      letter-spacing: -0.5px;
    }

    .navbar-brand i {
      margin-right: 8px;
      font-size: 1.8rem;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    .nav-link {
      color: var(--text-light) !important;
      font-weight: 500;
      padding: 0.5rem 1.2rem !important;
      transition: all 0.3s ease;
      position: relative;
    }

    .nav-link::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 50%;
      width: 0;
      height: 2px;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      transition: all 0.3s ease;
      transform: translateX(-50%);
    }

    .nav-link:hover::after {
      width: 80%;
    }

    .nav-link:hover {
      color: var(--primary) !important;
    }

    /* Theme Toggle */
    .theme-toggle {
      background: none;
      border: 2px solid var(--primary);
      color: var(--primary);
      width: 42px;
      height: 42px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.3s ease;
      margin-right: 15px;
    }

    .theme-toggle:hover {
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      color: white;
      transform: rotate(180deg);
    }

    /* Buttons */
    .btn-connexion {
      margin-right: 10px;
      border-radius: 25px;
      padding: 10px 28px;
      font-weight: 600;
      border: 2px solid var(--primary);
      transition: all 0.3s ease;
      color: var(--primary);
    }

    .btn-connexion:hover {
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      color: white;
      transform: translateY(-2px);
      box-shadow: 0 5px 20px rgba(0, 180, 216, 0.3);
    }

    .btn-start {
      border-radius: 25px;
      padding: 10px 32px;
      font-weight: 600;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      border: none;
      transition: all 0.3s ease;
      color: white;
    }

    .btn-start:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(0, 180, 216, 0.4);
    }

    /* Hero Section */
    .hero-section {
      background: linear-gradient(135deg, #00b4d8 0%, #0077b6 100%);
      min-height: 90vh;
      display: flex;
      align-items: center;
      position: relative;
      overflow: hidden;
      padding: 100px 0 80px;
    }

    .hero-section::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="1" fill="rgba(255,255,255,0.1)"/></svg>');
      opacity: 0.4;
    }

    .hero-content {
      position: relative;
      z-index: 2;
    }

    .hero-section h1 {
      font-size: 3.8rem;
      font-weight: 800;
      color: white;
      margin-bottom: 25px;
      line-height: 1.2;
      animation: fadeInUp 1s ease;
    }

    .hero-section .lead {
      font-size: 1.3rem;
      color: rgba(255,255,255,0.95);
      margin-bottom: 35px;
      line-height: 1.7;
      animation: fadeInUp 1s ease 0.2s backwards;
    }

    .hero-buttons {
      animation: fadeInUp 1s ease 0.4s backwards;
    }

    .hero-section .btn-hero {
      padding: 16px 45px;
      font-size: 1.1rem;
      border-radius: 30px;
      background-color: white;
      color: var(--primary);
      border: none;
      font-weight: 700;
      transition: all 0.3s ease;
      box-shadow: 0 10px 30px rgba(0,0,0,0.2);
      margin-right: 15px;
    }

    .hero-section .btn-hero:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 40px rgba(0,0,0,0.3);
    }

    .hero-section .btn-secondary-hero {
      padding: 16px 45px;
      font-size: 1.1rem;
      border-radius: 30px;
      background-color: transparent;
      color: white;
      border: 2px solid white;
      font-weight: 700;
      transition: all 0.3s ease;
    }

    .hero-section .btn-secondary-hero:hover {
      background-color: white;
      color: var(--primary);
      transform: translateY(-5px);
    }

    .hero-image {
      position: relative;
      animation: fadeInRight 1s ease 0.3s backwards;
    }

    .hero-image img {
      width: 100%;
      max-width: 550px;
      filter: drop-shadow(0 20px 40px rgba(0,0,0,0.3));
    }

    /* Floating Animation */
    @keyframes floating {
      0%, 100% { transform: translateY(0px); }
      50% { transform: translateY(-20px); }
    }

    .hero-image::before {
      content: '';
      position: absolute;
      top: -30px;
      right: -30px;
      width: 200px;
      height: 200px;
      background: linear-gradient(135deg, rgba(255,255,255,0.2), rgba(255,255,255,0.05));
      border-radius: 50%;
      animation: floating 3s ease-in-out infinite;
    }

    /* Stats Section */
    .stats-section {
      background-color: var(--card-light);
      padding: 60px 0;
      margin-top: -50px;
      position: relative;
      z-index: 10;
      box-shadow: 0 -10px 40px rgba(0,0,0,0.05);
    }

    .stat-card {
      text-align: center;
      padding: 30px 20px;
      transition: all 0.3s ease;
      border-radius: 15px;
    }

    .stat-card:hover {
      transform: translateY(-10px);
    }

    .stat-number {
      font-size: 3rem;
      font-weight: 800;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      margin-bottom: 10px;
      display: block;
    }

    .stat-label {
      color: var(--text-light);
      font-weight: 600;
      font-size: 1.1rem;
    }

    /* Services Section */
    .services-section {
      padding: 100px 0;
    }

    .section-title {
      text-align: center;
      margin-bottom: 60px;
    }

    .section-title h2 {
      font-size: 2.8rem;
      font-weight: 800;
      color: var(--text-light);
      margin-bottom: 15px;
      position: relative;
      display: inline-block;
    }

    .section-title h2::after {
      content: '';
      position: absolute;
      bottom: -15px;
      left: 50%;
      transform: translateX(-50%);
      width: 100px;
      height: 4px;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      border-radius: 2px;
    }

    .section-title p {
      color: var(--text-light);
      opacity: 0.8;
      font-size: 1.1rem;
      margin-top: 25px;
    }

    .service-card {
      background-color: var(--card-light);
      border-radius: 20px;
      padding: 40px 30px;
      text-align: center;
      transition: all 0.4s ease;
      border: 2px solid transparent;
      height: 100%;
      box-shadow: 0 5px 20px rgba(0,0,0,0.05);
    }

    .service-card:hover {
      transform: translateY(-15px);
      border-color: var(--primary);
      box-shadow: 0 20px 50px rgba(0, 180, 216, 0.2);
    }

    .service-icon {
      width: 90px;
      height: 90px;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      border-radius: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 25px;
      transition: all 0.3s ease;
    }

    .service-card:hover .service-icon {
      transform: rotateY(360deg);
    }

    .service-icon i {
      font-size: 2.5rem;
      color: white;
    }

    .service-card h4 {
      font-weight: 700;
      margin-bottom: 15px;
      color: var(--text-light);
      font-size: 1.4rem;
    }

    .service-card p {
      color: var(--text-light);
      opacity: 0.8;
      line-height: 1.7;
    }

    /* Specialties Section */
    .specialties-section {
      background: linear-gradient(135deg, #caf0f8 0%, #ade8f4 100%);
      padding: 100px 0;
    }

    [data-theme="dark"] .specialties-section {
      background: linear-gradient(135deg, #1a1d3a 0%, #0a0e27 100%);
    }

    .specialty-card {
      background-color: var(--card-light);
      border-radius: 15px;
      padding: 25px;
      text-align: center;
      transition: all 0.3s ease;
      margin-bottom: 20px;
      cursor: pointer;
    }

    .specialty-card:hover {
      transform: scale(1.05);
      box-shadow: 0 10px 30px rgba(0,0,0,0.15);
    }

    .specialty-card i {
      font-size: 2.5rem;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      margin-bottom: 15px;
    }

    .specialty-card h5 {
      font-weight: 600;
      color: var(--text-light);
      margin-bottom: 0;
    }

    /* Process Section */
    .process-section {
      padding: 100px 0;
    }

    .process-step {
      position: relative;
      padding: 30px;
      text-align: center;
    }

    .process-number {
      width: 80px;
      height: 80px;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 25px;
      font-size: 2rem;
      font-weight: 800;
      color: white;
      position: relative;
      z-index: 2;
    }

    .process-step::before {
      content: '';
      position: absolute;
      top: 40px;
      left: 50%;
      width: 100%;
      height: 4px;
      background: linear-gradient(90deg, var(--primary), transparent);
      z-index: 1;
    }

    .process-step:last-child::before {
      display: none;
    }

    .process-step h4 {
      font-weight: 700;
      margin-bottom: 15px;
      color: var(--text-light);
    }

    .process-step p {
      color: var(--text-light);
      opacity: 0.8;
      line-height: 1.7;
    }

    /* CTA Section */
    .cta-section {
      background: linear-gradient(135deg, var(--primary), var(--primary-dark));
      padding: 80px 0;
      color: white;
      text-align: center;
      position: relative;
      overflow: hidden;
    }

    .cta-section::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -10%;
      width: 500px;
      height: 500px;
      background: rgba(255,255,255,0.1);
      border-radius: 50%;
    }

    .cta-section h2 {
      font-size: 2.8rem;
      font-weight: 800;
      margin-bottom: 20px;
      position: relative;
      z-index: 2;
    }

    .cta-section p {
      font-size: 1.2rem;
      margin-bottom: 35px;
      opacity: 0.95;
      position: relative;
      z-index: 2;
    }

    .cta-section .btn-cta {
      padding: 16px 50px;
      font-size: 1.1rem;
      border-radius: 30px;
      background-color: white;
      color: var(--primary);
      border: none;
      font-weight: 700;
      transition: all 0.3s ease;
      position: relative;
      z-index: 2;
    }

    .cta-section .btn-cta:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 40px rgba(0,0,0,0.3);
    }

    /* Footer */
    footer {
      background: linear-gradient(135deg, #03045e 0%, #023e8a 100%);
      color: white;
      padding: 60px 0 20px;
    }

    footer h5 {
      font-weight: 700;
      margin-bottom: 25px;
      font-size: 1.3rem;
    }

    footer a {
      color: rgba(255,255,255,0.8);
      text-decoration: none;
      transition: all 0.3s ease;
      display: block;
      margin-bottom: 10px;
    }

    footer a:hover {
      color: var(--accent);
      padding-left: 5px;
    }

    footer .social-links a {
      display: inline-block;
      width: 45px;
      height: 45px;
      line-height: 45px;
      text-align: center;
      border-radius: 50%;
      background-color: rgba(255,255,255,0.1);
      margin-right: 10px;
      margin-bottom: 0;
      padding-left: 0;
      transition: all 0.3s ease;
    }

    footer .social-links a:hover {
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      transform: translateY(-5px);
      padding-left: 0;
    }

    /* Animations */
    @keyframes fadeInUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    @keyframes fadeInRight {
      from {
        opacity: 0;
        transform: translateX(30px);
      }
      to {
        opacity: 1;
        transform: translateX(0);
      }
    }

    /* Responsive */
    @media (max-width: 992px) {
      .hero-section h1 {
        font-size: 2.8rem;
      }

      .hero-image {
        margin-top: 50px;
      }

      .process-step::before {
        display: none;
      }
    }

    @media (max-width: 768px) {
      .hero-section h1 {
        font-size: 2.2rem;
      }

      .section-title h2 {
        font-size: 2.2rem;
      }

      .btn-hero, .btn-secondary-hero {
        display: block;
        width: 100%;
        margin-bottom: 15px;
      }
    }
  </style>
</head>
<body>
  <!-- Navigation Bar -->
  <nav class="navbar navbar-expand-lg navbar-light" id="mainNavbar">
    <div class="container">
      <a class="navbar-brand" href="${pageContext.request.contextPath}/">
        <i class="fas fa-heartbeat"></i>e-Clinique
      </a>

      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarContent">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <li class="nav-item">
            <a class="nav-link" href="#accueil">Accueil</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#services">Services</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#specialites">Spécialités</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#contact">Contact</a>
          </li>
        </ul>

        <div class="d-flex align-items-center">
          <button class="theme-toggle" id="themeToggle" aria-label="Toggle theme">
            <i class="fas fa-moon" id="themeIcon"></i>
          </button>
          <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary btn-connexion">
            <i class="fas fa-sign-in-alt me-2"></i>Connexion
          </a>
          <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-start">
            <i class="fas fa-rocket me-2"></i>Démarrer
          </a>
        </div>
      </div>
    </div>
  </nav>

  <!-- Hero Section -->
  <section class="hero-section" id="accueil">
    <div class="container">
      <div class="row align-items-center">
        <div class="col-lg-6 hero-content">
          <h1>Votre Santé au Cœur de l'Innovation</h1>
          <p class="lead">Prenez rendez-vous en ligne avec nos médecins spécialistes et accédez à vos dossiers médicaux en toute sécurité.</p>
          <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/appointment" class="btn btn-hero">
              <i class="fas fa-calendar-check me-2"></i>Prendre rendez-vous
            </a>
            <a href="#services" class="btn btn-secondary-hero">
              <i class="fas fa-info-circle me-2"></i>En savoir plus
            </a>
          </div>
        </div>
        <div class="col-lg-6 hero-image">
          <i class="fas fa-user-md" style="font-size: 400px; color: rgba(255,255,255,0.2);"></i>
        </div>
      </div>
    </div>
  </section>

  <!-- Stats Section -->
  <section class="stats-section">
    <div class="container">
      <div class="row">
        <div class="col-md-3 col-6">
          <div class="stat-card">
            <span class="stat-number">25K+</span>
            <span class="stat-label">Patients Satisfaits</span>
          </div>
        </div>
        <div class="col-md-3 col-6">
          <div class="stat-card">
            <span class="stat-number">150+</span>
            <span class="stat-label">Médecins Experts</span>
          </div>
        </div>
        <div class="col-md-3 col-6">
          <div class="stat-card">
            <span class="stat-number">40+</span>
            <span class="stat-label">Spécialités</span>
          </div>
        </div>
        <div class="col-md-3 col-6">
          <div class="stat-card">
            <span class="stat-number">99%</span>
            <span class="stat-label">Taux de Satisfaction</span>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Services Section -->
  <section class="services-section" id="services">
    <div class="container">
      <div class="section-title">
        <h2>Nos Services d'Excellence</h2>
        <p>Des solutions médicales complètes pour votre bien-être</p>
      </div>
      <div class="row">
        <div class="col-lg-4 col-md-6 mb-4">
          <div class="service-card">
            <div class="service-icon">
              <i class="fas fa-calendar-check"></i>
            </div>
            <h4>Prise de Rendez-vous</h4>
            <p>Réservez vos consultations en ligne 24h/24 avec nos médecins spécialistes disponibles.</p>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 mb-4">
          <div class="service-card">
            <div class="service-icon">
              <i class="fas fa-video"></i>
            </div>
            <h4>Téléconsultation</h4>
            <p>Consultez nos médecins à distance via vidéo sécurisée pour un suivi médical optimal.</p>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 mb-4">
          <div class="service-card">
            <div class="service-icon">
              <i class="fas fa-file-medical-alt"></i>
            </div>
            <h4>Dossier Médical Numérique</h4>
            <p>Accédez à votre historique médical, ordonnances et résultats d'examens en ligne.</p>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 mb-4">
          <div class="service-card">
            <div class="service-icon">
              <i class="fas fa-ambulance"></i>
            </div>
            <h4>Urgences 24/7</h4>
            <p>Service d'urgence disponible jour et nuit pour vos besoins médicaux immédiats.</p>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 mb-4">
          <div class="service-card">
            <div class="service-icon">
              <i class="fas fa-pills"></i>
            </div>
            <h4>Pharmacie en Ligne</h4>
            <p>Commandez vos médicaments en ligne et recevez-les directement chez vous.</p>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 mb-4">
          <div class="service-card">
            <div class="service-icon">
              <i class="fas fa-heartbeat"></i>
            </div>
            <h4>Suivi Personnalisé</h4>
            <p>Bénéficiez d'un suivi médical personnalisé adapté à vos besoins de santé.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Specialties Section -->
  <section class="specialties-section" id="specialites">
    <div class="container">
      <div class="section-title">
        <h2>Nos Spécialités Médicales</h2>
        <p>Une équipe d'experts dans tous les domaines de la santé</p>
      </div>
      <div class="row">
        <div class="col-lg-3 col-md-4 col-sm-6">
          <div class="specialty-card">
            <i class="fas fa-heart"></i>
            <h5>Cardiologie</h5>
          </div>
        </div>
        <div class="col-lg-3 col-md-4 col-sm-6">
          <div class="specialty-card">
            <i class="fas fa-brain"></i>
            <h5>Neurologie</h5>
          </div>
        </div>
        <div class="col-lg-3 col-md-4 col-sm-6">
          <div class="specialty-card">
            <i class="fas fa-bone"></i>
            <h5>Orthopédie</h5>
          </div>
        </div>
        <div class="col-lg-3 col-md-4 col-sm-6">
          <div class="specialty-card">
            <i class="fas fa-baby"></i>
            <h5>Pédiatrie</h5>
          </div>
        </div>
        <div class="col-lg-3 col-md-4 col-sm-6">
          <div class="specialty-card">
            <i class="fas fa-eye"></i>
            <h5>Ophtalmologie</h5>
          </div>
        </div>
        <div class="col-lg-3 col-md-4 col-sm-6">
          <div class="specialty-card">
            <i class="fas fa-tooth"></i>
            <h5>Dentisterie</h5>
          </div>
        </div>
        <div class="col-lg-3 col-md-4 col-sm-6">
          <div class="specialty-card">
            <i class="fas fa-lungs"></i>
            <h5>Pneumologie</h5>
          </div>
        </div>
        <div class="col-lg-3 col-md-4 col-sm-6">
          <div class="specialty-card">
            <i class="fas fa-user-md"></i>
            <h5>Médecine Générale</h5>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Process Section -->
  <section class="process-section">
    <div class="container">
      <div class="section-title">
        <h2>Comment Ça Marche ?</h2>
        <p>3 étapes simples pour prendre soin de votre santé</p>
      </div>
      <div class="row">
        <div class="col-md-4">
          <div class="process-step">
            <div class="process-number">1</div>
            <h4>Inscrivez-vous</h4>
            <p>Créez votre compte en quelques clics et complétez votre profil médical en toute sécurité.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="process-step">
            <div class="process-number">2</div>
            <h4>Choisissez un Médecin</h4>
            <p>Sélectionnez un spécialiste selon vos besoins et consultez ses disponibilités en temps réel.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="process-step">
            <div class="process-number">3</div>
            <h4>Réservez votre RDV</h4>
            <p>Prenez rendez-vous à l'heure qui vous convient et recevez une confirmation instantanée.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- CTA Section -->
  <section class="cta-section">
    <div class="container">
      <h2>Prêt à Prendre Soin de Votre Santé ?</h2>
      <p>Rejoignez des milliers de patients qui nous font confiance</p>
      <a href="${pageContext.request.contextPath}/register" class="btn btn-cta">
        <i class="fas fa-user-plus me-2"></i>Créer Mon Compte Gratuit
      </a>
    </div>
  </section>

  <!-- Footer -->
  <footer id="contact">
    <div class="container">
      <div class="row">
        <div class="col-md-4 mb-4">
          <h5><i class="fas fa-heartbeat me-2"></i>e-Clinique</h5>
          <p>Votre partenaire santé digitale pour une vie plus saine et plus simple.</p>
          <div class="social-links mt-3">
            <a href="#"><i class="fab fa-facebook-f"></i></a>
            <a href="#"><i class="fab fa-twitter"></i></a>
            <a href="#"><i class="fab fa-linkedin-in"></i></a>
            <a href="#"><i class="fab fa-instagram"></i></a>
            <a href="#"><i class="fab fa-youtube"></i></a>
          </div>
        </div>
        <div class="col-md-2 mb-4">
          <h5>Services</h5>
          <a href="#">Consultations</a>
          <a href="#">Télémédecine</a>
          <a href="#">Urgences</a>
          <a href="#">Pharmacie</a>
        </div>
        <div class="col-md-2 mb-4">
          <h5>Informations</h5>
          <a href="#">À propos</a>
          <a href="#">Nos médecins</a>
          <a href="#">Tarifs</a>
          <a href="#">Blog</a>
        </div>
        <div class="col-md-4 mb-4">
          <h5>Contact</h5>
          <p><i class="fas fa-map-marker-alt me-2"></i> 123 Avenue de la Santé, 75000 Paris</p>
          <p><i class="fas fa-phone me-2"></i> +33 1 23 45 67 89</p>
          <p><i class="fas fa-envelope me-2"></i> contact@e-clinique.fr</p>
          <p><i class="fas fa-clock me-2"></i> Lun-Ven: 8h-20h | Sam: 9h-18h</p>
        </div>
      </div>
      <hr class="mt-4" style="border-color: rgba(255,255,255,0.2);">
      <div class="text-center pt-3">
        <p class="mb-0">© 2025 e-Clinique. Tous droits réservés. | <a href="#" style="display: inline;">Politique de confidentialité</a> | <a href="#" style="display: inline;">CGU</a></p>
      </div>
    </div>
  </footer>

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

    // Navbar Scroll Effect
    window.addEventListener('scroll', function() {
      const navbar = document.getElementById('mainNavbar');
      if (window.scrollY > 50) {
        navbar.classList.add('scrolled');
      } else {
        navbar.classList.remove('scrolled');
      }
    });

    // Smooth Scrolling
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
      anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
          target.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
          });
        }
      });
    });

    // Scroll Reveal Animation
    const observerOptions = {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
        }
      });
    }, observerOptions);

    document.querySelectorAll('.service-card, .specialty-card, .process-step').forEach(el => {
      el.style.opacity = '0';
      el.style.transform = 'translateY(30px)';
      el.style.transition = 'all 0.6s ease';
      observer.observe(el);
    });
  </script>
</body>
</html>