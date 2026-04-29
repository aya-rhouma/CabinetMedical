<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Dashboard Médecin - MediCare Plus">
    <title>Dashboard Médecin - MediCare Plus</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <!-- AOS Animation Library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/medecin.css">
</head>

<body>

<%
    User medecin = (User) session.getAttribute("user");
    if (medecin == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }

    String contextPath = request.getContextPath();
    String prenom = medecin.getPrenom();
    String nom = medecin.getNom();
    String initials = prenom.substring(0, 1).toUpperCase() + nom.substring(0, 1).toUpperCase();
%>

<!-- Navigation -->
<nav class="navbar">
    <div class="nav-container">
        <div class="logo">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/">Accueil</a>
            <a href="#" class="active">Dashboard</a>
            <a href="${pageContext.request.contextPath}/medecin?action=patients">Mes Patients</a>
            <a href="${pageContext.request.contextPath}/medecin?action=rdv">Rendez-vous</a>
            <a href="${pageContext.request.contextPath}/medecin?action=certificats">Certificats</a>
            <a href="${pageContext.request.contextPath}/secretaire" class="btn-secretaire">
                <i class="fas fa-tasks"></i> Espace Secrétaire
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout" class="btn-login">
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
    <section class="hero-panel" data-aos="fade-up">
        <h1>Bonjour, <span class="gradient-text"><%= prenom %> <%= nom %></span></h1>
        <span class="role-badge">
            <i class="fas fa-user-md"></i> Médecin
        </span>
        <div class="avatar"><%= initials %></div>
    </section>

    <!-- Statistiques -->
    <div class="grid-3">
        <div class="stat-card" data-aos="fade-up" data-aos-delay="100">
            <i class="fa-solid fa-users"></i>
            <h3>Patients</h3>
            <div class="value"><%= request.getAttribute("nbPatients") != null ? request.getAttribute("nbPatients") : "0" %></div>
        </div>

        <div class="stat-card" data-aos="fade-up" data-aos-delay="200">
            <i class="fa-solid fa-calendar-check"></i>
            <h3>Rendez-vous</h3>
            <div class="value"><%= request.getAttribute("nbRdv") != null ? request.getAttribute("nbRdv") : "0" %></div>
        </div>

        <div class="stat-card" data-aos="fade-up" data-aos-delay="300">
            <i class="fa-solid fa-file-medical"></i>
            <h3>Certificats</h3>
            <div class="value"><%= request.getAttribute("nbCertificats") != null ? request.getAttribute("nbCertificats") : "0" %></div>
        </div>
    </div>

    <!-- Actions Rapides -->
    <div class="grid-4">
        <a class="action-card" href="${pageContext.request.contextPath}/medecin?action=patients" data-aos="fade-up" data-aos-delay="400">
            <i class="fa-solid fa-users"></i>
            <span class="title">Mes Patients</span>
        </a>
        <a class="action-card" href="${pageContext.request.contextPath}/medecin?action=rdv" data-aos="fade-up" data-aos-delay="500">
            <i class="fa-solid fa-calendar-check"></i>
            <span class="title">Mes Rendez-vous</span>
        </a>
        <a class="action-card" href="${pageContext.request.contextPath}/medecin?action=certificats" data-aos="fade-up" data-aos-delay="600">
            <i class="fa-solid fa-file-medical"></i>
            <span class="title">Certificats</span>
        </a>
        <a class="action-card" href="${pageContext.request.contextPath}/medecin?action=dossiers" data-aos="fade-up" data-aos-delay="700">
            <i class="fa-solid fa-folder-open"></i>
            <span class="title">Dossiers médicaux</span>
        </a>
    </div>

    <!-- Section Secrétaire (optionnel) -->
    <div class="card" data-aos="fade-up" data-aos-delay="800">
        <div class="card-header">
            <i class="fas fa-tasks"></i>
            <h2>Espace Secrétaire</h2>
        </div>
        <div class="card-body">
            <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/secretaire?action=gestionRdv" class="btn-primary" style="text-decoration: none;">
                    <i class="fas fa-calendar-alt"></i> Gérer les rendez-vous
                </a>
                <a href="${pageContext.request.contextPath}/secretaire?action=gestionPatients" class="btn-primary" style="text-decoration: none; background: linear-gradient(135deg, var(--warning), #d97706);">
                    <i class="fas fa-users"></i> Gérer les patients
                </a>
                <a href="${pageContext.request.contextPath}/secretaire?action=gestionMedecins" class="btn-primary" style="text-decoration: none; background: linear-gradient(135deg, var(--gray), #475569);">
                    <i class="fas fa-user-md"></i> Gérer les médecins
                </a>
            </div>
            <p class="footer-note" style="margin-top: 1rem; background: none; padding: 0; text-align: left;">
                <i class="fas fa-info-circle"></i> L'espace secrétaire vous permet de gérer la partie administrative du cabinet.
            </p>
        </div>
    </div>

    <!-- Footer Note -->
    <div class="footer-note" data-aos="fade-up" data-aos-delay="900">
        <i class="fas fa-clock"></i> Dernière connexion :
        <%= request.getAttribute("lastLogin") != null ? request.getAttribute("lastLogin") : "Aujourd'hui" %>
    </div>
</main>

<!-- Scripts -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({
        duration: 1000,
        once: true,
        offset: 100,
        easing: 'ease-in-out'
    });

    const menuToggle = document.querySelector('.menu-toggle');
    const navLinks = document.querySelector('.nav-links');

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

    const currentPath = window.location.pathname;
    const navItems = document.querySelectorAll('.nav-links a');
    navItems.forEach(item => {
        const href = item.getAttribute('href');
        if (href === '#' || href === 'javascript:void(0)') return;
        if (currentPath.includes(href.replace('${pageContext.request.contextPath}', ''))) {
            item.classList.add('active');
        }
    });
</script>
</body>
</html>