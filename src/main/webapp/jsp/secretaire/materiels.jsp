<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User, com.jee.entity.Materiel, com.jee.entity.DevisMateriel, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (user.getRole() != User.Role.SECRETAIRE && user.getRole() != User.Role.ADMIN)) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp"); return;
    }

    String ctx = request.getContextPath();
    List<Materiel> materiels = (List<Materiel>) request.getAttribute("materiels");
    List<Materiel> alertes   = (List<Materiel>) request.getAttribute("alertes");
    List<DevisMateriel> devis = (List<DevisMateriel>) request.getAttribute("devis");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Matériaux</title>

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
            <a href="<%= ctx %>/secretaire?action=patients">Patients</a>
            <a href="<%= ctx %>/secretaire?action=rdv">Rendez-vous</a>
            <a href="<%= ctx %>/secretaire?action=materiels" class="active">Matériaux</a>

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

    <% if ("devis_cree".equals(success)) { %>
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i> Devis généré avec succès
    </div>
    <% } %>

    <% if (alertes != null && !alertes.isEmpty()) { %>
    <div class="alert alert-danger">
        ⚠ <%= alertes.size() %> matériaux en alerte
    </div>
    <% } %>

    <!-- 🔷 INVENTAIRE -->
    <div class="card">
        <div class="card-header">
            <div class="card-title">
                Inventaire
                <span class="badge-count"><%= materiels != null ? materiels.size() : 0 %></span>
            </div>
        </div>

        <% if (materiels == null || materiels.isEmpty()) { %>
        <div class="empty-state">Aucun matériel</div>
        <% } else { %>

        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Nom</th>
                    <th>Quantité</th>
                    <th>État</th>
                    <th>Devis</th>
                </tr>
                </thead>

                <tbody>
                <% for (Materiel m : materiels) { %>
                <tr>
                    <td><%= m.getNom() %></td>

                    <td style="font-weight:bold;color:<%= m.isEnAlerte() ? "red" : "green" %>;">
                        <%= m.getQuantite() %>
                    </td>

                    <td>
                        <%= m.isEnAlerte() ? "Alerte" : "OK" %>
                    </td>

                    <td>
                        <button onclick="openDevisModal(<%= m.getId() %>, '<%= m.getNom() %>')"
                                class="btn btn-outline btn-sm">
                            Devis
                        </button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <% } %>
    </div>


    <!-- 🔷 HISTORIQUE DEVIS -->
    <% if (devis != null && !devis.isEmpty()) { %>
    <div class="card">
        <div class="card-header">
            <div class="card-title">
                Devis
                <span class="badge-count"><%= devis.size() %></span>
            </div>
        </div>

        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Matériel</th>
                    <th>Quantité</th>
                    <th>Prix</th>
                    <th>Date</th>
                </tr>
                </thead>

                <tbody>
                <% for (DevisMateriel d : devis) { %>
                <tr>
                    <td><%= d.getMateriel().getNom() %></td>
                    <td><%= d.getQuantiteDemandee() %></td>
                    <td><%= d.getPrixEstime() %></td>
                    <td><%= d.getDateDevis() %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>

</main>


<!-- 🔷 MODAL -->
<div class="modal-overlay" id="devisModal">
    <div class="modal-box">
        <form method="post" action="<%= ctx %>/secretaire">
            <input type="hidden" name="action" value="genererDevis">
            <input type="hidden" name="materielId" id="devisMaterielId">

            <input type="number" name="quantite" class="form-control" required min="1">

            <button class="btn btn-primary">Générer</button>
        </form>
    </div>
</div>


<!-- 🔷 SCRIPT -->
<script>
    document.getElementById('menuToggle')?.addEventListener('click', () => {
        document.getElementById('navLinks').classList.toggle('active');
    });

    function openDevisModal(id, nom) {
        document.getElementById('devisMaterielId').value = id;
        document.getElementById('devisModal').classList.add('open');
    }
</script>

</body>
</html>