<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User, com.jee.entity.RendezVous, com.jee.entity.Materiel, java.util.List, java.time.LocalDate" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (user.getRole() != User.Role.SECRETAIRE && user.getRole() != User.Role.ADMIN)) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp"); return;
    }
    String ctx = request.getContextPath();
    String prenom = user.getPrenom(), nom = user.getNom();
    String initials = (prenom.substring(0,1) + nom.substring(0,1)).toUpperCase();
    Long nbPatients = (Long) request.getAttribute("nbPatients");
    Long nbMedecins = (Long) request.getAttribute("nbMedecins");
    Long nbRdv      = (Long) request.getAttribute("nbRdv");
    Long nbRdvJour  = (Long) request.getAttribute("nbRdvDuJour");
    List<RendezVous> rdvJour = (List<RendezVous>) request.getAttribute("rdvDuJour");
    List<Materiel>   alertes = (List<Materiel>) request.getAttribute("alertes");
    String error = (String) request.getAttribute("error");
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
    <title>Dashboard Secrétaire - MediCare Plus</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/secretaire.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="<%= ctx %>/"><i class="fas fa-heartbeat"></i><span>MediCare Plus</span></a>
        <div class="nav-links" id="navLinks">
            <span class="role-tag"><i class="fas fa-user-tie"></i> Secrétaire</span>
            <a href="<%= ctx %>/secretaire" class="active">Dashboard</a>
            <a href="<%= ctx %>/secretaire?action=patients">Patients</a>
            <a href="<%= ctx %>/secretaire?action=rdv">Rendez-vous</a>
            <a href="<%= ctx %>/secretaire?action=materiels">Matériaux</a>
            <a href="<%= ctx %>/auth/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </div>
        <button class="menu-toggle" id="menuToggle"><i class="fas fa-bars"></i></button>
    </div>
</nav>

<main class="dashboard-main">
    <% if (error != null) { %>
    <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
    <% } %>

    <div class="hero-panel" data-aos="fade-up">
        <div class="hero-avatar"><%= initials %></div>
        <div class="hero-content">
            <h1>Bonjour, <%= prenom %> <%= nom %></h1>
            <p>Espace secrétariat &mdash; <%= LocalDate.now() %></p>
        </div>
        <span class="hero-badge"><i class="fas fa-user-tie"></i> Secrétaire</span>
    </div>

    <div class="stats-grid" data-aos="fade-up" data-aos-delay="100">
        <div class="stat-card">
            <div class="stat-icon si-cyan"><i class="fas fa-users"></i></div>
            <div class="stat-body"><div class="stat-value"><%= nbPatients != null ? nbPatients : 0 %></div><div class="stat-label">Patients</div></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon si-blue"><i class="fas fa-user-doctor"></i></div>
            <div class="stat-body"><div class="stat-value"><%= nbMedecins != null ? nbMedecins : 0 %></div><div class="stat-label">Médecins</div></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon si-violet"><i class="fas fa-calendar-alt"></i></div>
            <div class="stat-body"><div class="stat-value"><%= nbRdv != null ? nbRdv : 0 %></div><div class="stat-label">RDV total</div></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon si-green"><i class="fas fa-calendar-day"></i></div>
            <div class="stat-body"><div class="stat-value"><%= nbRdvJour != null ? nbRdvJour : 0 %></div><div class="stat-label">RDV aujourd'hui</div></div>
        </div>
    </div>

    <div class="actions-grid" data-aos="fade-up" data-aos-delay="150">
        <a class="action-card" href="<%= ctx %>/secretaire?action=patients"><i class="fas fa-users"></i><span class="ac-title">Patients</span></a>
        <a class="action-card" href="<%= ctx %>/secretaire?action=rdv"><i class="fas fa-calendar-check"></i><span class="ac-title">Rendez-vous</span></a>
        <a class="action-card" href="<%= ctx %>/secretaire?action=materiels"><i class="fas fa-boxes-stacked"></i><span class="ac-title">Matériaux</span></a>
        <a class="action-card" href="<%= ctx %>/secretaire?action=rdv&statut=PLANIFIE"><i class="fas fa-clock"></i><span class="ac-title">À confirmer</span></a>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:1.5rem;" data-aos="fade-up" data-aos-delay="200">
        <div class="card">
            <div class="card-header">
                <div class="card-title"><i class="fas fa-calendar-day"></i> RDV du jour <span class="badge-count"><%= rdvJour != null ? rdvJour.size() : 0 %></span></div>
                <a href="<%= ctx %>/secretaire?action=rdv" class="btn btn-outline btn-sm">Voir tout</a>
            </div>
            <% if (rdvJour == null || rdvJour.isEmpty()) { %>
            <div class="empty-state"><div class="empty-icon"><i class="fas fa-calendar-times"></i></div><h3>Aucun RDV aujourd'hui</h3></div>
            <% } else { %>
            <div class="table-wrapper">
                <table class="data-table">
                    <thead><tr><th>Horaire</th><th>Patient</th><th>Médecin</th><th>Statut</th></tr></thead>
                    <tbody>
                    <% for (RendezVous r : rdvJour) { %>
                    <tr>
                        <td><strong><%= r.getHeureDebut() %></strong> – <%= r.getHeureFin() %></td>
                        <td><%= r.getPatient().getPrenom() %> <%= r.getPatient().getNom() %></td>
                        <td>Dr <%= r.getMedecin().getNom() %></td>
                        <td><%= statutBadge(r.getStatut()) %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>

        <div class="card">
            <div class="card-header">
                <div class="card-title"><i class="fas fa-exclamation-triangle" style="color:var(--warning);"></i> Alertes stock <span class="badge-count" style="background:var(--warning);"><%= alertes != null ? alertes.size() : 0 %></span></div>
                <a href="<%= ctx %>/secretaire?action=materiels" class="btn btn-outline btn-sm">Inventaire</a>
            </div>
            <% if (alertes == null || alertes.isEmpty()) { %>
            <div class="empty-state"><div class="empty-icon" style="background:#d1fae5;color:#059669;"><i class="fas fa-check"></i></div><h3>Stocks OK</h3></div>
            <% } else { %>
            <div class="table-wrapper">
                <table class="data-table">
                    <thead><tr><th>Matériel</th><th>Qté</th><th>Seuil</th></tr></thead>
                    <tbody>
                    <% for (Materiel m : alertes) { %>
                    <tr>
                        <td><strong><%= m.getNom() %></strong></td>
                        <td style="color:var(--danger);font-weight:700;"><%= m.getQuantite() %></td>
                        <td class="text-muted"><%= m.getSeuilAlerte() %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
</main>

<script>
    document.getElementById('menuToggle')?.addEventListener('click',()=>{
        document.getElementById('navLinks').classList.toggle('active');
    });
</script>
</body>
</html>
