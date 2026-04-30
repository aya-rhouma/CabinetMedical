<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.Medecin" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    @SuppressWarnings("unchecked")
    List<Medecin> medecins = (List<Medecin>) request.getAttribute("medecins");
    @SuppressWarnings("unchecked")
    List<String> specialites = (List<String>) request.getAttribute("specialites");

    if (medecins == null || specialites == null) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Plateforme de gestion médicale moderne pour patients, médecins et secrétaires">
    <title>MediCare Plus - Centre Médical Intelligent</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <style>
        :root {
            --primary: #20a8e0;
            --secondary: #18c08d;
            --ink: #17223d;
            --muted: #667997;
            --line: #d9e2ef;
            --light-blue: #eaf7ff;
            --hero-start: #6677e6;
            --hero-end: #7375d6;
            --badge-green-bg: #d7f8df;
            --badge-green-fg: #14b86f;
            --badge-orange-bg: #ffe0b1;
            --badge-orange-fg: #f59e0b;
            --badge-red-bg: #fee2e2;
            --badge-red-fg: #dc2626;
            --footer-bg: #131d35;
            --shadow-soft: 0 10px 28px rgba(15, 23, 42, 0.08);
            --shadow-card: 0 16px 36px rgba(15, 23, 42, 0.10);
            --radius-xl: 28px;
            --radius-lg: 22px;
            --radius-md: 16px;
        }

        * {
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            margin: 0;
            font-family: "Inter", sans-serif;
            color: var(--ink);
            background: #ffffff;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        button,
        input,
        select {
            font: inherit;
        }

        .container {
            width: min(1600px, calc(100% - 120px));
            margin: 0 auto;
        }

        /* ========== HEADER SIMPLIFIÉ ========== */
        .navbar {
            position: sticky;
            top: 0;
            z-index: 50;
            background: rgba(255, 255, 255, 0.98);
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.05);
            padding: 16px 0;
        }

        .nav-container {
            width: min(1400px, calc(100% - 80px));
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 32px;
        }

        .logo {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-size: 24px;
            font-weight: 700;
            color: var(--secondary);
        }

        .logo i {
            font-size: 28px;
            color: var(--primary);
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 28px;
            color: var(--muted);
            font-size: 15px;
            font-weight: 500;
        }

        .nav-links a {
            padding: 8px 0;
            transition: color 0.2s ease;
        }

        .nav-links a:hover {
            color: var(--primary);
        }

        /* Style du bouton Connexion - MÊME STYLE QUE LES AUTRES BOUTONS */
        .btn-login {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 24px;
            border-radius: 40px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
            border: none;
            cursor: pointer;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 14px rgba(32, 168, 224, 0.3);
            color: #fff;
        }

        /* ========== HERO SECTION ========== */
        .hero {
            background: linear-gradient(180deg, var(--hero-start) 0%, var(--hero-end) 100%);
            color: #fff;
            min-height: 600px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 80px 24px;
        }

        .hero-content {
            width: min(1180px, 100%);
        }

        .hero h1 {
            margin: 0;
            font-size: clamp(42px, 5vw, 64px);
            line-height: 1.1;
            font-weight: 800;
        }

        .hero .highlight {
            color: #69ddb5;
        }

        .hero p {
            margin: 24px auto 0;
            max-width: 780px;
            font-size: clamp(16px, 1.6vw, 20px);
            line-height: 1.45;
            color: rgba(255, 255, 255, 0.94);
        }

        .hero-stats {
            margin-top: 64px;
            display: flex;
            justify-content: center;
            gap: 60px;
            flex-wrap: wrap;
        }

        .stat-number {
            font-size: clamp(36px, 3vw, 48px);
            font-weight: 800;
        }

        .stat-label {
            margin-top: 12px;
            font-size: 14px;
            color: rgba(255, 255, 255, 0.9);
        }

        /* ========== SECTION MÉDECINS ========== */
        .section {
            padding: 80px 0;
        }

        .section.doctors-section {
            background: linear-gradient(180deg, #eff9ff 0%, #edf7ff 100%);
        }

        .section-title {
            text-align: center;
            font-size: clamp(32px, 2.8vw, 42px);
            font-weight: 800;
            color: var(--ink);
            margin-bottom: 16px;
        }

        .section-subtitle {
            text-align: center;
            font-size: 16px;
            color: var(--muted);
            max-width: 700px;
            margin: 0 auto 48px;
        }

        /* Toolbar */
        .doctors-toolbar {
            margin: 0 auto 48px;
            max-width: 1100px;
            padding: 24px 28px;
            border-radius: 24px;
            background: #fff;
            box-shadow: var(--shadow-soft);
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            align-items: flex-end;
        }

        .field {
            flex: 1;
            min-width: 160px;
        }

        .field label {
            display: block;
            margin-bottom: 8px;
            font-size: 12px;
            font-weight: 700;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .field label i {
            margin-right: 6px;
        }

        .field select,
        .field input {
            width: 100%;
            height: 46px;
            border: 1.5px solid #e2e8f0;
            border-radius: 14px;
            padding: 0 16px;
            font-size: 14px;
            background: #fff;
        }

        .field select:focus,
        .field input:focus {
            outline: none;
            border-color: var(--primary);
        }

        .btn-filter,
        .btn-reset {
            height: 46px;
            padding: 0 24px;
            border: none;
            border-radius: 14px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-filter {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
        }

        .btn-reset {
            background: #e2e8f0;
            color: var(--muted);
        }

        .btn-filter:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(32, 168, 224, 0.3);
        }

        .btn-reset:hover {
            background: #cbd5e1;
        }

        /* Doctors Grid */
        .doctors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 32px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .doctor-card {
            background: #fff;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: var(--shadow-soft);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .doctor-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-card);
        }

        .doctor-top {
            padding: 24px 20px 20px;
            text-align: center;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
        }

        .doctor-avatar {
            width: 80px;
            height: 80px;
            margin: 0 auto 16px;
            border-radius: 50%;
            background: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            font-size: 34px;
        }

        .doctor-name {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
        }

        .doctor-specialty {
            margin-top: 8px;
            font-size: 13px;
            opacity: 0.9;
        }

        .doctor-status {
            display: inline-block;
            padding: 6px 16px;
            border-radius: 30px;
            margin-top: 14px;
            font-size: 12px;
            font-weight: 600;
        }

        .doctor-status.available {
            background: rgba(255, 255, 255, 0.25);
            color: #fff;
        }

        .doctor-status.limited {
            background: rgba(255, 255, 255, 0.25);
            color: #fff;
        }

        .doctor-status.unavailable {
            background: rgba(255, 255, 255, 0.25);
            color: #fff;
        }

        .doctor-body {
            padding: 20px;
        }

        .doctor-meta {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .doctor-meta li {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 0;
            color: var(--muted);
            font-size: 14px;
            border-bottom: 1px solid #f0f2f5;
        }

        .doctor-meta li:last-child {
            border-bottom: none;
        }

        .doctor-meta i {
            width: 20px;
            color: var(--primary);
            font-size: 14px;
        }

        .doctor-footer {
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid #f0f2f5;
        }

        .doctor-action {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px;
            border-radius: 40px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .doctor-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(32, 168, 224, 0.3);
        }

        .empty-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: 60px;
            background: #fff;
            border-radius: 24px;
            color: var(--muted);
        }

        /* Style pour le message d'information initial */
        .info-message {
            grid-column: 1 / -1;
            text-align: center;
            padding: 60px;
            background: #fff;
            border-radius: 24px;
            color: var(--muted);
            font-size: 16px;
        }

        .info-message i {
            font-size: 48px;
            margin-bottom: 16px;
            color: var(--primary);
            display: block;
        }

        /* ========== SERVICES ========== */
        .services-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
            margin-top: 48px;
        }

        .service-card {
            background: #fff;
            border-radius: 24px;
            padding: 28px 24px;
            box-shadow: var(--shadow-soft);
            position: relative;
            transition: transform 0.2s ease;
        }

        .service-card:hover {
            transform: translateY(-5px);
        }

        .service-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            padding: 6px 14px;
            border-radius: 30px;
            font-size: 12px;
            font-weight: 600;
        }

        .service-badge.available {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
        }

        .service-badge.restricted {
            background: #f59e0b;
            color: #fff;
        }

        .service-icon {
            font-size: 48px;
            color: var(--primary);
            margin-bottom: 20px;
        }

        .service-card h3 {
            margin: 0 0 16px;
            font-size: 24px;
            font-weight: 700;
        }

        .service-description {
            color: var(--muted);
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 24px;
        }

        .feature-list {
            list-style: none;
            margin: 0 0 24px;
            padding: 0;
        }

        .feature-list li {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 0;
            color: var(--muted);
            font-size: 14px;
        }

        .feature-list i {
            width: 18px;
            color: var(--secondary);
        }

        .btn-pill {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 14px 20px;
            border-radius: 40px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .btn-pill.locked {
            background: #cbd5e1;
            color: #fff;
        }

        .btn-pill:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(32, 168, 224, 0.3);
        }

        /* ========== AVANTAGES ========== */
        .advantages-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 30px;
            margin-top: 48px;
        }

        .advantage {
            text-align: center;
        }

        .advantage-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 32px;
        }

        .advantage h3 {
            margin: 0 0 12px;
            font-size: 18px;
            font-weight: 700;
        }

        .advantage p {
            color: var(--muted);
            font-size: 14px;
            line-height: 1.5;
        }

        /* ========== FOOTER ========== */
        .footer {
            background: var(--footer-bg);
            color: #9ab0d0;
            padding-top: 60px;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 40px;
            padding-bottom: 50px;
        }

        .footer-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 20px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 20px;
        }

        .footer-text {
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 24px;
        }

        .social-links {
            display: flex;
            gap: 12px;
        }

        .social-links a {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.08);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.2s ease;
        }

        .social-links a:hover {
            background: var(--primary);
        }

        .footer h4 {
            color: #fff;
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .footer-links,
        .footer-contact {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .footer-links li,
        .footer-contact li {
            margin-bottom: 12px;
            font-size: 14px;
        }

        .footer-links a:hover {
            color: #fff;
        }

        .footer-links i,
        .footer-contact i {
            margin-right: 8px;
            color: var(--primary);
        }

        .newsletter-form {
            display: flex;
            gap: 10px;
            margin-top: 16px;
        }

        .newsletter-form input {
            flex: 1;
            padding: 12px 16px;
            border: none;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
        }

        .newsletter-form button {
            width: 46px;
            border: none;
            border-radius: 12px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
            cursor: pointer;
        }

        .footer-bottom {
            text-align: center;
            padding: 24px 0;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 13px;
        }

        /* ========== RESPONSIVE ========== */
        @media (max-width: 1024px) {
            .services-grid,
            .advantages-grid,
            .footer-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .nav-container {
                flex-direction: column;
                gap: 16px;
            }

            .nav-links {
                flex-wrap: wrap;
                justify-content: center;
                gap: 20px;
            }

            .services-grid,
            .advantages-grid,
            .footer-grid {
                grid-template-columns: 1fr;
            }

            .doctors-toolbar {
                flex-direction: column;
            }

            .btn-filter,
            .btn-reset {
                width: 100%;
            }

            .hero-stats {
                flex-direction: column;
                gap: 24px;
            }
        }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="#accueil">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </a>

        <div class="nav-links">
            <a class="nav-item active" href="#accueil">Accueil</a>
            <a class="nav-item" href="#services">Services</a>
            <a class="nav-item" href="#apropos">À propos</a>
            <a class="nav-item" href="#contact">Contact</a>
            <a href="${pageContext.request.contextPath}/jsp/auth/login.jsp" class="btn-login">
                <i class="fas fa-right-to-bracket"></i> Connexion
            </a>
        </div>
    </div>
</nav>

<section class="hero" id="accueil">
    <div class="hero-content">
        <h1 data-aos="fade-up">Votre santé, <span class="highlight">notre priorité</span></h1>
        <p data-aos="fade-up" data-aos-delay="100">
            Une plateforme intelligente pour une gestion médicale simplifiée et efficace
        </p>

        <div class="hero-stats" data-aos="fade-up" data-aos-delay="200">
            <div class="stat">
                <div class="stat-number">5000+</div>
                <div class="stat-label">Patients satisfaits</div>
            </div>
            <div class="stat">
                <div class="stat-number">50+</div>
                <div class="stat-label">Médecins experts</div>
            </div>
            <div class="stat">
                <div class="stat-number">24/7</div>
                <div class="stat-label">Support disponible</div>
            </div>
        </div>
    </div>
</section>

<section class="section doctors-section" id="medecins">
    <div class="container">
        <h2 class="section-title" data-aos="fade-up">Nos Médecins</h2>
        <p class="section-subtitle" data-aos="fade-up">
            Consultez la liste de nos médecins par spécialité et disponibilité
        </p>

        <div class="doctors-toolbar" data-aos="fade-up" data-aos-delay="100">
            <div class="field">
                <label for="specialiteFilter"><i class="fas fa-stethoscope"></i>Spécialité</label>
                <select id="specialiteFilter">
                    <option value="all">Toutes les spécialités</option>
                    <% for (String specialite : specialites) {
                        if (specialite != null && !specialite.isBlank()) { %>
                    <option value="<%= specialite %>"><%= specialite %></option>
                    <% }} %>
                </select>
            </div>

            <div class="field">
                <label for="disponibiliteFilter"><i class="fas fa-calendar-check"></i>Disponibilité</label>
                <select id="disponibiliteFilter">
                    <option value="all">Tous</option>
                    <option value="available">Disponible</option>
                    <option value="limited">Places limitées</option>
                    <option value="unavailable">Indisponible</option>
                </select>
            </div>

            <div class="field">
                <label for="searchDoctor"><i class="fas fa-magnifying-glass"></i>Rechercher</label>
                <input id="searchDoctor" type="text" placeholder="Nom du médecin...">
            </div>

            <button class="btn-filter" id="applyFilters" type="button">
                <i class="fas fa-filter"></i> Appliquer
            </button>
            <button class="btn-reset" id="resetFilters" type="button">
                <i class="fas fa-rotate-left"></i> Réinitialiser
            </button>
        </div>

        <!-- Conteneur pour la liste des médecins (initialement vide) -->
        <div class="doctors-grid" id="doctorsGrid">
            <!-- Message d'information initial -->
            <div class="info-message" id="initialMessage">
                <i class="fas fa-filter-circle-plus"></i>
                <h3 style="margin-bottom: 8px;">Filtrez les médecins</h3>
                <p style="margin: 0;">Sélectionnez des critères et cliquez sur "Appliquer" pour afficher la liste des médecins.</p>
            </div>
        </div>
    </div>
</section>

<section class="section" id="services">
    <div class="container">
        <h2 class="section-title" data-aos="fade-up">Nos Espaces</h2>
        <p class="section-subtitle" data-aos="fade-up">
            Une plateforme adaptée à chaque utilisateur
        </p>

        <div class="services-grid">
            <article class="service-card" data-aos="fade-up">
                <span class="service-badge available"><i class="fas fa-circle-check"></i> Disponible</span>
                <div class="service-body">
                    <div class="service-icon"><i class="fas fa-circle-user"></i></div>
                    <h3>Espace Patient</h3>
                    <p class="service-description">Une expérience patient simplifiée avec des fonctionnalités avancées</p>
                    <ul class="feature-list">
                        <li><i class="fas fa-calendar-check"></i> Prise de rendez-vous en ligne</li>
                        <li><i class="fas fa-clock-rotate-left"></i> Historique médical complet</li>
                        <li><i class="fas fa-bell"></i> Notifications en temps réel</li>
                        <li><i class="fas fa-file-prescription"></i> Téléchargement des ordonnances</li>
                        <li><i class="fas fa-comments"></i> Consultation en ligne</li>
                    </ul>
                </div>
                <div class="service-footer">
                    <a class="btn-pill" href="${pageContext.request.contextPath}/jsp/auth/login.jsp?role=patient">
                        Accéder à l'espace <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </article>

            <article class="service-card" data-aos="fade-up" data-aos-delay="100">
                <span class="service-badge restricted"><i class="fas fa-lock"></i> Accès restreint</span>
                <div class="service-body">
                    <div class="service-icon"><i class="fas fa-user-doctor"></i></div>
                    <h3>Espace Médecin</h3>
                    <p class="service-description">Des outils professionnels pour une pratique médicale optimale</p>
                    <ul class="feature-list">
                        <li><i class="fas fa-notes-medical"></i> Gestion des dossiers patients</li>
                        <li><i class="fas fa-prescription-bottle-medical"></i> Prescriptions électroniques</li>
                        <li><i class="fas fa-chart-line"></i> Statistiques et rapports</li>
                        <li><i class="fas fa-video"></i> Téléconsultation intégrée</li>
                        <li><i class="fas fa-clock"></i> Agenda intelligent</li>
                    </ul>
                </div>
                <div class="service-footer">
                    <a class="btn-pill locked" href="${pageContext.request.contextPath}/jsp/auth/login.jsp?role=medecin">
                        Accès réservé <i class="fas fa-lock"></i>
                    </a>
                </div>
            </article>

            <article class="service-card" data-aos="fade-up" data-aos-delay="200">
                <span class="service-badge restricted"><i class="fas fa-lock"></i> Accès restreint</span>
                <div class="service-body">
                    <div class="service-icon"><i class="fas fa-list-check"></i></div>
                    <h3>Espace Secrétaire</h3>
                    <p class="service-description">Une gestion administrative complète et centralisée</p>
                    <ul class="feature-list">
                        <li><i class="fas fa-users"></i> Gestion des patients et médecins</li>
                        <li><i class="fas fa-calendar-days"></i> Planification des rendez-vous</li>
                        <li><i class="fas fa-credit-card"></i> Gestion des paiements</li>
                        <li><i class="fas fa-toolbox"></i> Suivi du matériel médical</li>
                        <li><i class="fas fa-file-lines"></i> Rapports quotidiens</li>
                    </ul>
                </div>
                <div class="service-footer">
                    <a class="btn-pill locked" href="${pageContext.request.contextPath}/jsp/auth/login.jsp?role=secretaire">
                        Accès réservé <i class="fas fa-lock"></i>
                    </a>
                </div>
            </article>
        </div>
    </div>
</section>

<section class="section" id="apropos">
    <div class="container">
        <h2 class="section-title" data-aos="fade-up">Pourquoi nous choisir ?</h2>
        <p class="section-subtitle" data-aos="fade-up">
            Des avantages qui font la différence
        </p>

        <div class="advantages-grid">
            <article class="advantage" data-aos="fade-up">
                <div class="advantage-icon"><i class="fas fa-shield-halved"></i></div>
                <h3>Sécurité maximale</h3>
                <p>Données médicales protégées avec chiffrement avancé</p>
            </article>
            <article class="advantage" data-aos="fade-up" data-aos-delay="100">
                <div class="advantage-icon"><i class="fas fa-bolt"></i></div>
                <h3>Rapidité</h3>
                <p>Traitement instantané des demandes et notifications</p>
            </article>
            <article class="advantage" data-aos="fade-up" data-aos-delay="200">
                <div class="advantage-icon"><i class="fas fa-mobile-screen-button"></i></div>
                <h3>Mobile First</h3>
                <p>Interface adaptée à tous les appareils</p>
            </article>
            <article class="advantage" data-aos="fade-up" data-aos-delay="300">
                <div class="advantage-icon"><i class="fas fa-headset"></i></div>
                <h3>Support 24/7</h3>
                <p>Assistance technique disponible à tout moment</p>
            </article>
        </div>
    </div>
</section>

<footer class="footer" id="contact">
    <div class="container">
        <div class="footer-grid">
            <section>
                <div class="footer-brand"><i class="fas fa-heartbeat"></i> MediCare Plus</div>
                <p class="footer-text">Une solution numérique innovante pour une gestion médicale moderne, efficace et sécurisée.</p>
                <div class="social-links">
                    <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                    <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                    <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                </div>
            </section>

            <section>
                <h4>Liens rapides</h4>
                <ul class="footer-links">
                    <li><a href="#accueil"><i class="fas fa-chevron-right"></i>Accueil</a></li>
                    <li><a href="#services"><i class="fas fa-chevron-right"></i>Services</a></li>
                    <li><a href="#apropos"><i class="fas fa-chevron-right"></i>À propos</a></li>
                    <li><a href="#"><i class="fas fa-chevron-right"></i>FAQ</a></li>
                </ul>
            </section>

            <section>
                <h4>Contact</h4>
                <ul class="footer-contact">
                    <li><i class="fas fa-location-dot"></i> Tunis, Tunisie</li>
                    <li><i class="fas fa-phone"></i> +216 70 000 000</li>
                    <li><i class="fas fa-envelope"></i> contact@medicareplus.tn</li>
                    <li><i class="fas fa-clock"></i> Lun-Ven: 8h-18h</li>
                </ul>
            </section>

            <section>
                <h4>Newsletter</h4>
                <p class="footer-text" style="margin-top:0;">Recevez nos actualités et offres</p>
                <form class="newsletter-form">
                    <input type="email" placeholder="Votre email">
                    <button type="submit" aria-label="Envoyer"><i class="fas fa-paper-plane"></i></button>
                </form>
            </section>
        </div>
    </div>

    <div class="footer-bottom">
        © 2026 MediCare Plus - Centre Médical Intelligent. Tous droits réservés.
    </div>
</footer>

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({
        duration: 900,
        once: true,
        offset: 80,
        easing: 'ease-in-out'
    });

    (function () {
        const grid = document.getElementById('doctorsGrid');
        const specialty = document.getElementById('specialiteFilter');
        const availability = document.getElementById('disponibiliteFilter');
        const search = document.getElementById('searchDoctor');
        const apply = document.getElementById('applyFilters');
        const reset = document.getElementById('resetFilters');

        if (!grid || !specialty || !availability || !search || !apply || !reset) {
            return;
        }

        // Stocker les cartes des médecins générées par JSP (cachées initialement)
        let cards = [];
        let doctorsListLoaded = false;

        // Fonction pour construire les cartes des médecins à partir des données JSP
        function buildDoctorsList() {
            if (doctorsListLoaded) return;

            const doctorsHtml = `
                <% if (!medecins.isEmpty()) {
                    for (int i = 0; i < medecins.size(); i++) {
                        Medecin medecin = medecins.get(i);
                        String prenom = medecin.getPrenom() == null ? "" : medecin.getPrenom().trim();
                        String nom = medecin.getNom() == null ? "" : medecin.getNom().trim();
                        String nomComplet = ("Dr. " + prenom + " " + nom).trim();
                        String specialite = medecin.getSpecialite() == null || medecin.getSpecialite().isBlank() ? "Généraliste" : medecin.getSpecialite();
                        String experience = medecin.getExperience() == null || medecin.getExperience().isBlank() ? "N/A" : medecin.getExperience();
                        String telephone = medecin.getTelephone() == null || medecin.getTelephone().isBlank() ? "Non renseigné" : medecin.getTelephone();
                        String email = medecin.getEmail() == null || medecin.getEmail().isBlank() ? "Non renseigné" : medecin.getEmail();

                        String statusClass;
                        String statusLabel;
                        switch (i % 3) {
                            case 1:
                                statusClass = "limited";
                                statusLabel = "Places limitées";
                                break;
                            case 2:
                                statusClass = "unavailable";
                                statusLabel = "Indisponible";
                                break;
                            default:
                                statusClass = "available";
                                statusLabel = "Disponible";
                        }
                %>
                <article class="doctor-card"
                         data-specialty="<%= specialite %>"
                         data-status="<%= statusClass %>"
                         data-name="<%= nomComplet.toLowerCase() %>">
                    <div class="doctor-top">
                        <div class="doctor-avatar"><i class="fas fa-user-doctor"></i></div>
                        <h3 class="doctor-name"><%= nomComplet %></h3>
                        <div class="doctor-specialty"><%= specialite %></div>
                        <div class="doctor-status <%= statusClass %>"><%= statusLabel %></div>
                    </div>

                    <div class="doctor-body">
                        <ul class="doctor-meta">
                            <li><i class="fas fa-briefcase-medical"></i> Expérience : <%= experience %></li>
                            <li><i class="fas fa-phone"></i> <%= telephone %></li>
                            <li><i class="fas fa-envelope"></i> <%= email %></li>
                        </ul>

                        <div class="doctor-footer">
                            <a class="doctor-action" href="${pageContext.request.contextPath}/jsp/auth/login.jsp?role=patient">
                                <i class="fas fa-calendar-plus"></i> Prendre rendez-vous
                            </a>
                        </div>
                    </div>
                </article>
                <% }} %>`;

            // Insérer les cartes des médecins dans le conteneur
            grid.innerHTML = doctorsHtml;

            // Récupérer les nouvelles cartes
            cards = Array.from(grid.querySelectorAll('.doctor-card'));
            doctorsListLoaded = true;
        }

        function renderEmptyState(show) {
            let empty = grid.querySelector('.empty-state');
            if (show) {
                if (!empty) {
                    empty = document.createElement('div');
                    empty.className = 'empty-state';
                    empty.textContent = 'Aucun médecin trouvé.';
                    grid.appendChild(empty);
                }
            } else if (empty) {
                empty.remove();
            }
        }

        function filterDoctors() {
            // Construire la liste des médecins au premier filtre
            buildDoctorsList();

            const specialtyValue = specialty.value;
            const availabilityValue = availability.value;
            const searchValue = search.value.trim().toLowerCase();

            let visibleCount = 0;
            cards.forEach((card) => {
                const matchSpecialty = specialtyValue === 'all' || card.dataset.specialty === specialtyValue;
                const matchAvailability = availabilityValue === 'all' || card.dataset.status === availabilityValue;
                const matchSearch = !searchValue || card.dataset.name.includes(searchValue);
                const visible = matchSpecialty && matchAvailability && matchSearch;
                card.style.display = visible ? '' : 'none';
                if (visible) visibleCount += 1;
            });

            renderEmptyState(visibleCount === 0);
        }

        function resetFilters() {
            specialty.value = 'all';
            availability.value = 'all';
            search.value = '';
            filterDoctors();
        }

        apply.addEventListener('click', filterDoctors);
        reset.addEventListener('click', resetFilters);
        search.addEventListener('keydown', function (event) {
            if (event.key === 'Enter') {
                event.preventDefault();
                filterDoctors();
            }
        });
    })();
</script>
</body>
</html>