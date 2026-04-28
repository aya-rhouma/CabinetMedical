<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User" %>
<%
    User secretaire = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();
    String prenom = secretaire != null ? secretaire.getPrenom() : "Secrétaire";
    String nom = secretaire != null ? secretaire.getNom() : "";
    String initials = (prenom.substring(0, 1) + (nom.isBlank() ? "S" : nom.substring(0, 1))).toUpperCase();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <title>Dashboard Secrétaire</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= contextPath %>/css/dashboard.css">
</head>
<body class="dashboard-body">
<nav class="dashboard-nav">
    <div class="dashboard-nav-content">
        <a class="logo" href="<%= contextPath %>/">
            <i class="fas fa-heartbeat"></i> MediCare Plus
        </a>
        <div class="nav-actions">
            <a class="btn-pill btn-outline" href="<%= contextPath %>/">Accueil</a>
            <a class="btn-pill" href="<%= contextPath %>/auth/logout">Déconnexion</a>
        </div>
    </div>
</nav>

<main class="dashboard-container">
    <section class="hero-panel">
        <h1>Welcome, <%= prenom %> <%= nom %></h1>
        <span class="role-badge">Role: Secrétaire</span>
        <div class="avatar"><%= initials %></div>
    </section>

    <section class="grid grid-3">
        <div class="stat-card">
            <i class="fa-solid fa-user-injured"></i>
            <h3>Patients</h3>
            <div class="value"><%= request.getAttribute("nbPatients") %></div>
        </div>
        <div class="stat-card">
            <i class="fa-solid fa-user-doctor"></i>
            <h3>Médecins</h3>
            <div class="value"><%= request.getAttribute("nbMedecins") %></div>
        </div>
        <div class="stat-card">
            <i class="fa-solid fa-calendar-check"></i>
            <h3>Rendez-vous</h3>
            <div class="value"><%= request.getAttribute("nbRdv") %></div>
        </div>
    </section>

    <section class="grid grid-4">
        <a class="action-card" href="<%= contextPath %>/secretaire">
            <i class="fa-solid fa-gauge-high"></i>
            <span class="title">Dashboard</span>
        </a>
        <a class="action-card" href="<%= contextPath %>/secretaire">
            <i class="fa-solid fa-users"></i>
            <span class="title">Patients</span>
        </a>
        <a class="action-card" href="<%= contextPath %>/secretaire">
            <i class="fa-solid fa-list-check"></i>
            <span class="title">Rendez-vous</span>
        </a>
        <a class="action-card" href="<%= contextPath %>/auth/logout">
            <i class="fa-solid fa-right-from-bracket"></i>
            <span class="title">Déconnexion</span>
        </a>
    </section>

    <div class="footer-note">
        Dernière connexion : <%= request.getAttribute("lastLogin") %>
    </div>
</main>
</body>
</html>
