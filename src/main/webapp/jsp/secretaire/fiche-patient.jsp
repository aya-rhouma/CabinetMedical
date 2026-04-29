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
    if (patient == null) { response.sendRedirect(ctx + "/secretaire?action=patients"); return; }
    String pInit = (patient.getPrenom().substring(0,1) + patient.getNom().substring(0,1)).toUpperCase();
%>
<%!
    private String statutBadge(String s) {
        if (s == null) return "<span class=\"badge badge-gray\">—</span>";
        if ("CONFIRME".equals(s)) return "<span class=\"badge badge-success\"><i class=\"fas fa-check-circle\"></i> Confirmé</span>";
        if ("ANNULE".equals(s))   return "<span class=\"badge badge-danger\"><i class=\"fas fa-times-circle\"></i> Annulé</span>";
        if ("EFFECTUE".equals(s)) return "<span class=\"badge badge-info\"><i class=\"fas fa-check-double\"></i> Effectué</span>";
        if ("TERMINE".equals(s))  return "<span class=\"badge badge-violet\"><i class=\"fas fa-flag\"></i> Terminé</span>";
        return "<span class=\"badge badge-warning\"><i class=\"fas fa-clock\"></i> Planifié</span>";
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fiche Patient - MediCare Plus</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/secretaire.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="<%= ctx %>/"><i class="fas fa-heartbeat"></i><span>MediCare Plus</span></a>
        <div class="nav-links" id="navLinks">
            <a href="<%= ctx %>/secretaire">Dashboard</a>
            <a href="<%= ctx %>/secretaire?action=patients" class="active">Patients</a>
            <a href="<%= ctx %>/secretaire?action=rdv">Rendez-vous</a>
            <a href="<%= ctx %>/secretaire?action=materiels">Matériaux</a>
            <a href="<%= ctx %>/auth/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </div>
        <button class="menu-toggle" id="menuToggle"><i class="fas fa-bars"></i></button>
    </div>
</nav>

<main class="dashboard-main">
    <div class="page-breadcrumb">
        <a href="<%= ctx %>/secretaire">Dashboard</a>
        <i class="fas fa-chevron-right"></i>
        <a href="<%= ctx %>/secretaire?action=patients">Patients</a>
        <i class="fas fa-chevron-right"></i>
        <span><%= patient.getPrenom() %> <%= patient.getNom() %></span>
    </div>

    <div class="patient-hero">
        <div class="ph-avatar"><%= pInit %></div>
        <div class="ph-info">
            <h2><%= patient.getPrenom() %> <%= patient.getNom() %></h2>
            <p>
                <i class="fas fa-envelope"></i> <%= patient.getEmail() %>
                <% if (patient.getTelephone() != null && !patient.getTelephone().isBlank()) { %>
                &nbsp;&nbsp;<i class="fas fa-phone"></i> <%= patient.getTelephone() %>
                <% } %>
            </p>
        </div>
        <a href="<%= ctx %>/secretaire?action=patients" class="btn btn-ghost btn-sm" style="position:relative;z-index:1;">
            <i class="fas fa-arrow-left"></i> Retour
        </a>
    </div>

    <div class="card">
        <div class="card-header">
            <div class="card-title"><i class="fas fa-user-circle"></i> Informations administratives</div>
        </div>
        <div class="card-body">
            <div class="info-grid">
                <div class="info-item"><div class="info-label"><i class="fas fa-user"></i> Prénom</div><div class="info-value"><%= patient.getPrenom() %></div></div>
                <div class="info-item"><div class="info-label"><i class="fas fa-user"></i> Nom</div><div class="info-value"><%= patient.getNom() %></div></div>
                <div class="info-item"><div class="info-label"><i class="fas fa-envelope"></i> Email</div><div class="info-value" style="font-size:.85rem;"><%= patient.getEmail() %></div></div>
                <div class="info-item"><div class="info-label"><i class="fas fa-phone"></i> Téléphone</div><div class="info-value"><%= patient.getTelephone() != null ? patient.getTelephone() : "—" %></div></div>
                <div class="info-item"><div class="info-label"><i class="fas fa-birthday-cake"></i> Naissance</div><div class="info-value"><%= patient.getDateNaissance() != null ? patient.getDateNaissance() : "—" %></div></div>
                <div class="info-item"><div class="info-label"><i class="fas fa-map-marker-alt"></i> Adresse</div><div class="info-value" style="font-size:.85rem;"><%= patient.getAdresse() != null && !patient.getAdresse().isBlank() ? patient.getAdresse() : "—" %></div></div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <div class="card-title"><i class="fas fa-calendar-alt"></i> Historique des rendez-vous <span class="badge-count"><%= rdvsPatient != null ? rdvsPatient.size() : 0 %></span></div>
        </div>
        <% if (rdvsPatient == null || rdvsPatient.isEmpty()) { %>
        <div class="empty-state"><div class="empty-icon"><i class="fas fa-calendar-times"></i></div><h3>Aucun rendez-vous</h3></div>
        <% } else { %>
        <div class="table-wrapper">
            <table class="data-table">
                <thead><tr><th>#</th><th>Date</th><th>Horaire</th><th>Médecin</th><th>Statut</th><th>Paiement</th></tr></thead>
                <tbody>
                <% for (RendezVous r : rdvsPatient) { %>
                <tr>
                    <td><span class="id-badge">#<%= r.getId() %></span></td>
                    <td><strong><%= r.getDateRdv() %></strong></td>
                    <td class="text-muted"><i class="fas fa-clock" style="color:var(--accent);"></i> <%= r.getHeureDebut() %> – <%= r.getHeureFin() %></td>
                    <td>
                        <div class="user-cell">
                            <div class="user-av blue"><i class="fas fa-user-doctor"></i></div>
                            <div><div class="cell-name">Dr <%= r.getMedecin().getNom() %></div><div class="cell-sub"><%= r.getMedecin().getSpecialite() %></div></div>
                        </div>
                    </td>
                    <td><%= statutBadge(r.getStatut()) %></td>
                    <td>
                        <% if (r.isPaye()) { %>
                        <span class="badge badge-success"><i class="fas fa-check"></i> Payé</span>
                        <% } else { %>
                        <span class="badge badge-warning"><i class="fas fa-hourglass-half"></i> En attente</span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</main>

<script>
    document.getElementById('menuToggle')?.addEventListener('click',()=>{
        document.getElementById('navLinks').classList.toggle('active');
    });
</script>
</body>
</html>
