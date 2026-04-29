<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User, com.jee.entity.Patient, com.jee.entity.RendezVous, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (user.getRole() != User.Role.SECRETAIRE && user.getRole() != User.Role.ADMIN)) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp"); return;
    }

    String ctx = request.getContextPath();
    Patient patient = (Patient) request.getAttribute("patient");
    List<RendezVous> rdvsPatient = (List<RendezVous>) request.getAttribute("rdvsPatient");

    if (patient == null) {
        response.sendRedirect(ctx + "/secretaire?action=patients");
        return;
    }

    String pInit = (patient.getPrenom().substring(0,1) + patient.getNom().substring(0,1)).toUpperCase();
%>

<%!
    private String statutBadge(String s) {
        if (s == null) return "<span class=\"badge badge-gray\">—</span>";
        if ("CONFIRME".equals(s)) return "<span class=\"badge badge-success\">Confirmé</span>";
        if ("ANNULE".equals(s)) return "<span class=\"badge badge-danger\">Annulé</span>";
        return "<span class=\"badge badge-warning\">Planifié</span>";
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Fiche Patient</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/secretaire.css">
</head>

<body>

<!-- 🔷 NAVBAR -->
<nav class="navbar">
    <div class="nav-container">

        <a class="logo" href="<%= ctx %>/">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </a>

        <div class="nav-links" id="navLinks">
            <span class="role-tag">
                <i class="fas fa-user-tie"></i> Secrétaire
            </span>

            <a href="<%= ctx %>/secretaire">Dashboard</a>
            <a href="<%= ctx %>/secretaire?action=patients" class="active">Patients</a>
            <a href="<%= ctx %>/secretaire?action=rdv">Rendez-vous</a>
            <a href="<%= ctx %>/secretaire?action=materiels">Matériaux</a>

            <a href="<%= ctx %>/auth/logout" class="btn-logout">
                Déconnexion
            </a>
        </div>

        <button class="menu-toggle" id="menuToggle">
            <i class="fas fa-bars"></i>
        </button>
    </div>
</nav>


<!-- 🔷 MAIN -->
<main class="dashboard-main">

    <!-- 🔷 HEADER PATIENT -->
    <div class="hero-panel">
        <div class="hero-avatar"><%= pInit %></div>

        <div class="hero-content">
            <h1><%= patient.getPrenom() %> <%= patient.getNom() %></h1>
            <p><%= patient.getEmail() %></p>
        </div>
    </div>


    <!-- 🔷 INFOS -->
    <div class="card">
        <div class="card-header">
            <div class="card-title">Informations</div>
        </div>

        <div class="card-body">
            <div class="info-grid">
                <div>Nom : <%= patient.getNom() %></div>
                <div>Prénom : <%= patient.getPrenom() %></div>
                <div>Email : <%= patient.getEmail() %></div>
                <div>Téléphone : <%= patient.getTelephone() != null ? patient.getTelephone() : "—" %></div>
            </div>
        </div>
    </div>


    <!-- 🔷 RDV -->
    <div class="card">
        <div class="card-header">
            <div class="card-title">
                Rendez-vous
                <span class="badge-count"><%= rdvsPatient != null ? rdvsPatient.size() : 0 %></span>
            </div>
        </div>

        <% if (rdvsPatient == null || rdvsPatient.isEmpty()) { %>
        <div class="empty-state">Aucun RDV</div>
        <% } else { %>

        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Date</th>
                    <th>Médecin</th>
                    <th>Statut</th>
                </tr>
                </thead>

                <tbody>
                <% for (RendezVous r : rdvsPatient) { %>
                <tr>
                    <td><%= r.getDateRdv() %></td>
                    <td>Dr <%= r.getMedecin().getNom() %></td>
                    <td><%= statutBadge(r.getStatut()) %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <% } %>
    </div>

</main>


<!-- 🔷 SCRIPT -->
<script>
    document.getElementById('menuToggle')?.addEventListener('click', () => {
        document.getElementById('navLinks').classList.toggle('active');
    });
</script>

</body>
</html>