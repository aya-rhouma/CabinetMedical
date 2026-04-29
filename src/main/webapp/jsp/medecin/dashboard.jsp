<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.Secretaire" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Dashboard Médecin - MediCare Plus">
    <title>Dashboard Médecin - MediCare Plus</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <style>
        /* ============================================
           VARIABLES CSS
           ============================================ */
        :root {
            --primary: #0ea5e9;
            --primary-dark: #0284c7;
            --secondary: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --dark: #0f172a;
            --gray: #64748b;
            --light-gray: #f8fafc;
            --border: #e2e8f0;
            --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: var(--dark);
        }

        /* ============================================
           NAVIGATION
           ============================================ */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 1000;
            padding: 1rem 0;
        }

        .nav-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            text-decoration: none;
        }

        .logo i {
            color: var(--primary);
        }

        .nav-links {
            display: flex;
            gap: 1.5rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--gray);
            font-weight: 500;
            transition: var(--transition);
        }

        .nav-links a:hover {
            color: var(--primary);
        }

        .nav-links a.active {
            color: var(--primary);
        }

        .btn-login {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white !important;
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
        }

        .menu-toggle {
            display: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--dark);
        }

        /* ============================================
           DASHBOARD MAIN
           ============================================ */
        .dashboard-main {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* ============================================
           HERO PANEL
           ============================================ */
        .hero-panel {
            background: white;
            border-radius: 24px;
            padding: 2rem;
            margin-bottom: 2rem;
            text-align: center;
            box-shadow: var(--shadow);
            transition: var(--transition);
        }

        .hero-panel:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
        }

        .hero-panel h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 0.5rem;
        }

        .gradient-text {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .role-badge {
            display: inline-block;
            padding: 0.4rem 1rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            margin: 0.5rem 0;
        }

        .role-badge i {
            margin-right: 0.5rem;
        }

        .avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 1rem auto 0;
            color: white;
            font-size: 2rem;
            font-weight: 700;
            box-shadow: var(--shadow);
        }

        /* ============================================
           GRID SYSTEMS
           ============================================ */
        .grid-3 {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .grid-4 {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        /* ============================================
           STAT CARDS
           ============================================ */
        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 1.5rem;
            text-align: center;
            transition: var(--transition);
            box-shadow: var(--shadow);
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
        }

        .stat-card i {
            font-size: 2.5rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-bottom: 0.75rem;
        }

        .stat-card h3 {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--gray);
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-card .value {
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--dark), var(--primary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        /* ============================================
           ACTION CARDS
           ============================================ */
        .action-card {
            background: white;
            border-radius: 20px;
            padding: 1.5rem;
            text-align: center;
            text-decoration: none;
            transition: var(--transition);
            box-shadow: var(--shadow);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.75rem;
            color: var(--dark);
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }

        .action-card::before {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 0;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            transition: var(--transition);
            z-index: 0;
        }

        .action-card:hover::before {
            height: 100%;
        }

        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
            color: white;
        }

        .action-card i {
            font-size: 2rem;
            color: var(--primary);
            transition: var(--transition);
            position: relative;
            z-index: 1;
        }

        .action-card:hover i {
            color: white;
            transform: scale(1.1);
        }

        .action-card .title {
            font-weight: 600;
            font-size: 0.9rem;
            position: relative;
            z-index: 1;
        }

        .action-card:hover .title {
            color: white;
        }

        /* ============================================
           MODAL STYLES
           ============================================ */
        .modal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            backdrop-filter: blur(5px);
        }

        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 0;
            border-radius: 24px;
            width: 90%;
            max-width: 600px;
            box-shadow: var(--shadow-xl);
            animation: modalSlideIn 0.3s ease;
        }

        @keyframes modalSlideIn {
            from {
                transform: translateY(-100px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .modal-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h2 {
            font-size: 1.5rem;
            color: var(--dark);
        }

        .close {
            font-size: 2rem;
            font-weight: bold;
            cursor: pointer;
            color: var(--gray);
            transition: var(--transition);
        }

        .close:hover {
            color: var(--danger);
        }

        .modal-body {
            padding: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--dark);
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 1rem;
            transition: var(--transition);
            font-family: inherit;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .btn-submit {
            width: 100%;
            padding: 0.875rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .alert {
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert-success {
            background-color: #d1fae5;
            color: #065f46;
            border-left: 4px solid var(--secondary);
        }

        .alert-error {
            background-color: #fee2e2;
            color: #991b1b;
            border-left: 4px solid var(--danger);
        }

        /* Liste des secrétaires */
        .secretaires-list {
            margin-top: 2rem;
            background: white;
            border-radius: 20px;
            padding: 1.5rem;
            box-shadow: var(--shadow);
        }

        .secretaires-list h3 {
            margin-bottom: 1rem;
            color: var(--dark);
            font-size: 1.2rem;
        }

        .secretaire-item {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .secretaire-item:last-child {
            border-bottom: none;
        }

        .secretaire-info {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .secretaire-nom {
            font-weight: 600;
            color: var(--dark);
        }

        .secretaire-email {
            font-size: 0.85rem;
            color: var(--gray);
        }

        .secretaire-status {
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .status-actif {
            background-color: #d1fae5;
            color: #065f46;
        }

        .status-inactif {
            background-color: #fee2e2;
            color: #991b1b;
        }

        .btn-delete {
            background: none;
            border: none;
            color: var(--danger);
            cursor: pointer;
            padding: 0.5rem;
            border-radius: 8px;
            transition: var(--transition);
        }

        .btn-delete:hover {
            background-color: #fee2e2;
        }

        /* ============================================
           FOOTER NOTE
           ============================================ */
        .footer-note {
            text-align: center;
            padding: 1rem;
            margin-top: 2rem;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            color: var(--gray);
            font-size: 0.85rem;
        }

        /* ============================================
           RESPONSIVE
           ============================================ */
        @media (max-width: 1024px) {
            .grid-3, .grid-4 {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .menu-toggle {
                display: block;
            }

            .nav-links {
                display: none;
                position: absolute;
                top: 100%;
                left: 0;
                right: 0;
                background: white;
                flex-direction: column;
                padding: 1rem;
                gap: 1rem;
                box-shadow: var(--shadow);
            }

            .nav-links.active {
                display: flex;
            }

            .dashboard-main {
                padding: 1rem;
            }

            .hero-panel h1 {
                font-size: 1.3rem;
            }

            .avatar {
                width: 60px;
                height: 60px;
                font-size: 1.5rem;
            }

            .grid-3, .grid-4 {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .stat-card .value {
                font-size: 2rem;
            }

            .form-row {
                grid-template-columns: 1fr;
            }
        }

        /* ============================================
           ANIMATIONS
           ============================================ */
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

        .stat-card, .action-card, .hero-panel, .secretaires-list {
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
        }

        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .action-card:nth-child(1) { animation-delay: 0.4s; }
        .action-card:nth-child(2) { animation-delay: 0.5s; }
        .action-card:nth-child(3) { animation-delay: 0.6s; }
        .action-card:nth-child(4) { animation-delay: 0.7s; }
        .action-card:nth-child(5) { animation-delay: 0.8s; }
        .hero-panel { animation-delay: 0s; }
        .secretaires-list { animation-delay: 0.9s; }
    </style>
</head>

<body>

<%
    User medecin = (User) session.getAttribute("user");
    if (medecin == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }

    String prenom = medecin.getPrenom();
    String nom = medecin.getNom();
    String initials = prenom.substring(0, 1).toUpperCase() + nom.substring(0, 1).toUpperCase();
    String contextPath = request.getContextPath();

    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    List<Secretaire> secretaires = (List<Secretaire>) request.getAttribute("secretaires");
%>

<!-- Navigation -->
<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="<%= contextPath %>/">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </a>
        <div class="nav-links">
            <a href="<%= contextPath %>/">Accueil</a>
            <a href="#" class="active">Dashboard</a>
            <a href="<%= contextPath %>/medecin?action=patients">Mes Patients</a>
            <a href="<%= contextPath %>/medecin?action=rdv">Rendez-vous</a>
            <a href="<%= contextPath %>/medecin?action=certificats">Certificats</a>
            <a href="<%= contextPath %>/auth/logout" class="btn-login">
                <i class="fas fa-sign-out-alt"></i> Déconnexion
            </a>
        </div>
        <div class="menu-toggle">
            <i class="fas fa-bars"></i>
        </div>
    </div>
</nav>

<!-- Main Content -->
<main class="dashboard-main">
    <!-- Hero Panel -->
    <div class="hero-panel" data-aos="fade-up">
        <h1>
            Bonjour,
            <span class="gradient-text"><%= prenom %> <%= nom %></span>
        </h1>
        <div class="role-badge">
            <i class="fas fa-user-md"></i> Médecin
        </div>
        <div class="avatar"><%= initials %></div>
    </div>

    <!-- Statistics -->
    <div class="grid-3">
        <div class="stat-card" data-aos="fade-up">
            <i class="fa-solid fa-users"></i>
            <h3>Patients</h3>
            <div class="value">
                <%= request.getAttribute("nbPatients") != null ? request.getAttribute("nbPatients") : "0" %>
            </div>
        </div>

        <div class="stat-card" data-aos="fade-up" data-aos-delay="100">
            <i class="fa-solid fa-calendar-check"></i>
            <h3>Rendez-vous</h3>
            <div class="value">
                <%= request.getAttribute("nbRdv") != null ? request.getAttribute("nbRdv") : "0" %>
            </div>
        </div>

        <div class="stat-card" data-aos="fade-up" data-aos-delay="200">
            <i class="fa-solid fa-file-medical"></i>
            <h3>Certificats</h3>
            <div class="value">
                <%= request.getAttribute("nbCertificats") != null ? request.getAttribute("nbCertificats") : "0" %>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="grid-4">
        <a class="action-card" href="<%= contextPath %>/medecin?action=patients" data-aos="fade-up" data-aos-delay="400">
            <i class="fa-solid fa-users"></i>
            <span class="title">Mes Patients</span>
        </a>

        <a class="action-card" href="<%= contextPath %>/medecin?action=rdv" data-aos="fade-up" data-aos-delay="500">
            <i class="fa-solid fa-calendar-check"></i>
            <span class="title">Mes Rendez-vous</span>
        </a>

        <a class="action-card" href="<%= contextPath %>/medecin?action=certificats" data-aos="fade-up" data-aos-delay="600">
            <i class="fa-solid fa-file-medical"></i>
            <span class="title">Certificats</span>
        </a>

        <a class="action-card" href="<%= contextPath %>/medecin?action=dossiers" data-aos="fade-up" data-aos-delay="700">
            <i class="fa-solid fa-folder-open"></i>
            <span class="title">Dossiers médicaux</span>
        </a>

        <!-- Nouvelle carte pour la secrétaire -->
        <a class="action-card" href="<%= contextPath %>/medecin?action=secretaires" data-aos="fade-up" data-aos-delay="800">
            <i class="fa-solid fa-user-plus"></i>
            <span class="title">Gérer Secrétaire</span>
        </a>
    </div>

    <!-- Liste des secrétaires -->
    <% if (secretaires != null && !secretaires.isEmpty()) { %>
    <div class="secretaires-list" data-aos="fade-up" data-aos-delay="900">
        <h3><i class="fa-solid fa-users-between"></i> Mes Secrétaires</h3>
        <% for (Secretaire secretaire : secretaires) { %>
        <div class="secretaire-item">
            <div class="secretaire-info">
                <span class="secretaire-nom">
                    <i class="fa-solid fa-user"></i>
                    <%= secretaire.getPrenom() %> <%= secretaire.getNom() %>
                </span>
                <span class="secretaire-email">
                    <i class="fa-solid fa-envelope"></i>
                    <%= secretaire.getEmail() %>
                </span>
                <span class="secretaire-email">
                    <i class="fa-solid fa-phone"></i>
                    <%= secretaire.getTelephone() %>
                </span>
            </div>
            <div>
                <span class="secretaire-status status-actif">
                    Liee au medecin
                </span>
                <button class="btn-delete" onclick="deleteSecretaire(<%= secretaire.getId() %>)">
                    <i class="fa-solid fa-trash"></i>
                </button>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

    <!-- Modal pour créer un compte secrétaire -->
    <div id="secretaireModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2><i class="fa-solid fa-user-plus"></i> Créer un compte secrétaire</h2>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            <div class="modal-body">
                <% if (message != null) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-check-circle"></i>
                    <%= message %>
                </div>
                <% } %>
                <% if (error != null) { %>
                <div class="alert alert-error">
                    <i class="fa-solid fa-exclamation-triangle"></i>
                    <%= error %>
                </div>
                <% } %>

                <form id="createSecretaireForm" action="<%= contextPath %>/medecin" method="POST">
                    <input type="hidden" name="action" value="createSecretaire">

                    <div class="form-row">
                        <div class="form-group">
                            <label for="prenom">Prénom *</label>
                            <input type="text" id="prenom" name="prenom" required>
                        </div>

                        <div class="form-group">
                            <label for="nom">Nom *</label>
                            <input type="text" id="nom" name="nom" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" required>
                    </div>

                    <div class="form-group">
                        <label for="telephone">Téléphone</label>
                        <input type="tel" id="telephone" name="telephone">
                    </div>

                    <div class="form-group">
                        <label for="password">Mot de passe *</label>
                        <input type="password" id="password" name="password" required>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirmer le mot de passe *</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>

                    <button type="submit" class="btn-submit">
                        <i class="fa-solid fa-user-plus"></i> Créer le compte
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer-note" data-aos="fade-up" data-aos-delay="1000">
        <i class="fas fa-clock"></i>
        Dernière connexion :
        <%= request.getAttribute("lastLogin") != null ? request.getAttribute("lastLogin") : "Aujourd'hui" %>
    </div>
</main>

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({ duration: 900, once: true, offset: 80, easing: 'ease-in-out' });

    const menuToggle = document.querySelector('.menu-toggle');
    const navLinks = document.querySelector('.nav-links');
    const contextPath = '<%= contextPath %>';
    const modal = document.getElementById('secretaireModal');

    if (menuToggle) {
        menuToggle.addEventListener('click', () => {
            navLinks.classList.toggle('active');
            const icon = menuToggle.querySelector('i');
            if (icon.classList.contains('fa-bars')) {
                icon.classList.remove('fa-bars');
                icon.classList.add('fa-times');
            } else {
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            }
        });
    }

    // Active link highlighting
    const currentPath = window.location.pathname;
    document.querySelectorAll('.nav-links a').forEach(link => {
        const href = link.getAttribute('href');
        if (!href || href === '#') return;
        if (href === contextPath + '/medecin' || href === contextPath + '/medecin/') {
            if (currentPath === contextPath + '/medecin' || currentPath === contextPath + '/medecin/') {
                link.classList.add('active');
            }
        } else if (currentPath.includes(href.replace(contextPath, ''))) {
            link.classList.add('active');
        }
    });

    // Modal functions
    function openModal() {
        modal.style.display = 'block';
        // Clear form fields
        document.getElementById('createSecretaireForm').reset();
        // Clear alerts
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => alert.remove());
    }

    function closeModal() {
        modal.style.display = 'none';
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        if (event.target == modal) {
            closeModal();
        }
    }

    // Form validation
    document.getElementById('createSecretaireForm').addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (password !== confirmPassword) {
            e.preventDefault();
            alert('Les mots de passe ne correspondent pas !');
            return false;
        }

        if (password.length < 6) {
            e.preventDefault();
            alert('Le mot de passe doit contenir au moins 6 caractères !');
            return false;
        }

        return true;
    });

    // Delete secretaire function
    function deleteSecretaire(id) {
        if (confirm('Êtes-vous sûr de vouloir supprimer cette secrétaire ?')) {
            window.location.href = contextPath + '/medecin?action=deleteSecretaire&id=' + id;
        }
    }

    // Open modal if there's a message or error
    <% if (message != null || error != null) { %>
    openModal();
    <% } %>
</script>
</body>
</html>
