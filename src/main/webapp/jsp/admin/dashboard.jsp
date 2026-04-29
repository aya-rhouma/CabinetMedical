<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User, java.time.LocalDate" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || admin.getRole() != User.Role.ADMIN) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp?role=admin");
        return;
    }

    String ctx = request.getContextPath();
    String initials = (admin.getPrenom().substring(0,1) + admin.getNom().substring(0,1)).toUpperCase();

    Long nbPatients     = (Long) request.getAttribute("nbPatients");
    Long nbMedecins     = (Long) request.getAttribute("nbMedecins");
    Long nbSecretaires  = (Long) request.getAttribute("nbSecretaires");
    Long nbRdv          = (Long) request.getAttribute("nbRdv");

    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - MediCare Plus</title>

    <!-- Fonts + Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <!-- CSS (même que secrétaire) -->
    <link rel="stylesheet" href="<%= ctx %>/css/secretaire.css">
</head>

<body class="role-admin">

<!-- 🔷 NAVBAR -->
<nav class="navbar">
    <div class="nav-container">

        <a class="logo" href="<%= ctx %>/">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </a>

        <div class="nav-links" id="navLinks">
            <span class="role-tag">
                <i class="fas fa-shield-alt"></i> Admin
            </span>

            <a href="<%= ctx %>/admin" class="active">Dashboard</a>
            <a href="<%= ctx %>/admin?action=medecins">Médecins</a>
            <a href="<%= ctx %>/admin?action=secretaires">Secrétaires</a>
            <a href="<%= ctx %>/admin?action=materiels">Matériaux</a>

            <a href="<%= ctx %>/auth/logout" class="btn-logout">
                <i class="fas fa-sign-out-alt"></i> Déconnexion
            </a>
        </div>

        <button class="menu-toggle" id="menuToggle">
            <i class="fas fa-bars"></i>
        </button>
    </div>
</nav>


<!-- 🔷 MAIN -->
<main class="dashboard-main">

    <% if (error != null) { %>
    <div class="alert alert-danger">
        <i class="fas fa-exclamation-circle"></i> <%= error %>
    </div>
    <% } %>

    <!-- 🔷 HERO -->
    <div class="hero-panel">
        <div class="hero-avatar"><%= initials %></div>

        <div class="hero-content">
            <h1>Bonjour, <%= admin.getPrenom() %> <%= admin.getNom() %></h1>
            <p>Espace administration — <%= LocalDate.now() %></p>
        </div>

        <span class="hero-badge">
            <i class="fas fa-shield-alt"></i> Admin
        </span>
    </div>


    <!-- 🔷 STATS -->
    <div class="stats-grid">

        <div class="stat-card">
            <div class="stat-icon si-cyan">
                <i class="fas fa-users"></i>
            </div>
            <div class="stat-body">
                <div class="stat-value"><%= nbPatients != null ? nbPatients : 0 %></div>
                <div class="stat-label">Patients</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon si-blue">
                <i class="fas fa-user-doctor"></i>
            </div>
            <div class="stat-body">
                <div class="stat-value"><%= nbMedecins != null ? nbMedecins : 0 %></div>
                <div class="stat-label">Médecins</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon si-amber">
                <i class="fas fa-user-tie"></i>
            </div>
            <div class="stat-body">
                <div class="stat-value"><%= nbSecretaires != null ? nbSecretaires : 0 %></div>
                <div class="stat-label">Secrétaires</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon si-violet">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div class="stat-body">
                <div class="stat-value"><%= nbRdv != null ? nbRdv : 0 %></div>
                <div class="stat-label">RDV total</div>
            </div>
        </div>

    </div>


    <!-- 🔷 ACTIONS -->
    <div class="actions-grid">

        <a class="action-card" href="<%= ctx %>/admin?action=medecins">
            <i class="fas fa-user-doctor"></i>
            <span class="ac-title">Médecins</span>
        </a>

        <a class="action-card" href="<%= ctx %>/admin?action=secretaires">
            <i class="fas fa-user-tie"></i>
            <span class="ac-title">Secrétaires</span>
        </a>

        <a class="action-card" href="<%= ctx %>/admin?action=materiels">
            <i class="fas fa-boxes-stacked"></i>
            <span class="ac-title">Matériaux</span>
        </a>

        <a class="action-card" href="<%= ctx %>/secretaire">
            <i class="fas fa-tasks"></i>
            <span class="ac-title">Espace Secrétaire</span>
        </a>

    </div>

</main>


<!-- 🔷 SCRIPT MENU MOBILE -->
<script>
    document.getElementById('menuToggle')?.addEventListener('click', () => {
        document.getElementById('navLinks').classList.toggle('active');
    });
</script>

</body>
</html>