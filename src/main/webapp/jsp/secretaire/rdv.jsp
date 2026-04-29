<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User, com.jee.entity.RendezVous, java.util.List" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || (user.getRole() != User.Role.SECRETAIRE && user.getRole() != User.Role.ADMIN)) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }

    String ctx = request.getContextPath();
    List<RendezVous> rdvs = (List<RendezVous>) request.getAttribute("rdvs");

    String selectedStatut = (String) request.getAttribute("selectedStatut");
    String selectedDate   = (String) request.getAttribute("selectedDate");

    if (selectedStatut == null) selectedStatut = "";
    if (selectedDate == null) selectedDate = "";
%>

<%!
    private String statutBadge(String s) {
        if (s == null) return "<span class=\"badge badge-gray\">—</span>";
        if ("CONFIRME".equals(s)) return "<span class=\"badge badge-success\"><i class=\"fas fa-check-circle\"></i> Confirmé</span>";
        if ("ANNULE".equals(s)) return "<span class=\"badge badge-danger\"><i class=\"fas fa-times-circle\"></i> Annulé</span>";
        if ("EFFECTUE".equals(s)) return "<span class=\"badge badge-info\"><i class=\"fas fa-check-double\"></i> Effectué</span>";
        if ("TERMINE".equals(s)) return "<span class=\"badge badge-violet\"><i class=\"fas fa-flag\"></i> Terminé</span>";
        return "<span class=\"badge badge-warning\"><i class=\"fas fa-clock\"></i> Planifié</span>";
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Rendez-vous</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/secretaire.css">
</head>

<body>

<!-- 🔷 NAVBAR (IDENTIQUE PATIENTS) -->
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
            <a href="<%= ctx %>/secretaire?action=patients">Patients</a>
            <a href="<%= ctx %>/secretaire?action=rdv" class="active">Rendez-vous</a>
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

    <div class="card">

        <!-- 🔷 FILTRES -->
        <form method="get" action="<%= ctx %>/secretaire">
            <input type="hidden" name="action" value="rdv">

            <div class="filter-bar">
                <div class="filter-group">
                    <span class="filter-label">Statut</span>
                    <select name="statut" class="filter-control">
                        <option value="">Tous les statuts</option>

                        <% String[] statuts = {"PLANIFIE","CONFIRME","ANNULE","EFFECTUE","TERMINE"};
                            String[] labels  = {"Planifié","Confirmé","Annulé","Effectué","Terminé"};

                            for (int i=0; i<statuts.length; i++) { %>

                        <option value="<%= statuts[i] %>"
                                <%= selectedStatut.equals(statuts[i]) ? "selected" : "" %>>
                            <%= labels[i] %>
                        </option>

                        <% } %>
                    </select>
                </div>

                <div class="filter-group">
                    <span class="filter-label">Date</span>
                    <input type="date" name="dateRdv" class="filter-control" value="<%= selectedDate %>">
                </div>

                <div style="display:flex;gap:.5rem;align-items:flex-end;">
                    <button class="btn btn-primary btn-sm">
                        <i class="fas fa-filter"></i> Filtrer
                    </button>

                    <a href="<%= ctx %>/secretaire?action=rdv" class="btn btn-ghost btn-sm">
                        <i class="fas fa-times"></i> Reset
                    </a>
                </div>
            </div>
        </form>


        <!-- 🔷 HEADER -->
        <div class="card-header">
            <div class="card-title">
                <i class="fas fa-list"></i> Résultats
                <span class="badge-count"><%= rdvs != null ? rdvs.size() : 0 %></span>
            </div>
        </div>


        <!-- 🔷 TABLE -->
        <% if (rdvs == null || rdvs.isEmpty()) { %>

        <div class="empty-state">
            <div class="empty-icon"><i class="fas fa-calendar-xmark"></i></div>
            <h3>Aucun rendez-vous trouvé</h3>
        </div>

        <% } else { %>

        <div class="table-wrapper">
            <table class="data-table">

                <thead>
                <tr>
                    <th>#</th>
                    <th>Date & Heure</th>
                    <th>Patient</th>
                    <th>Médecin</th>
                    <th>Statut</th>
                </tr>
                </thead>

                <tbody>
                <% for (RendezVous r : rdvs) { %>

                <tr>
                    <td>#<%= r.getId() %></td>

                    <td>
                        <strong><%= r.getDateRdv() %></strong><br>
                        <small><%= r.getHeureDebut() %> – <%= r.getHeureFin() %></small>
                    </td>

                    <td>
                        <%= r.getPatient().getPrenom() %> <%= r.getPatient().getNom() %>
                    </td>

                    <td>
                        Dr <%= r.getMedecin().getNom() %>
                    </td>

                    <td>
                        <%= statutBadge(r.getStatut()) %>
                    </td>
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