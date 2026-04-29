<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User, com.jee.entity.Materiel, com.jee.entity.DevisMateriel, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (user.getRole() != User.Role.SECRETAIRE && user.getRole() != User.Role.ADMIN)) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp"); return;
    }
    String ctx = request.getContextPath();
    List<Materiel>      materiels = (List<Materiel>)      request.getAttribute("materiels");
    List<Materiel>      alertes   = (List<Materiel>)      request.getAttribute("alertes");
    List<DevisMateriel> devis     = (List<DevisMateriel>) request.getAttribute("devis");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Matériaux - MediCare Plus</title>
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
            <a href="<%= ctx %>/secretaire?action=patients">Patients</a>
            <a href="<%= ctx %>/secretaire?action=rdv">Rendez-vous</a>
            <a href="<%= ctx %>/secretaire?action=materiels" class="active">Matériaux</a>
            <a href="<%= ctx %>/auth/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </div>
        <button class="menu-toggle" id="menuToggle"><i class="fas fa-bars"></i></button>
    </div>
</nav>

<main class="dashboard-main">
    <% if ("devis_cree".equals(success)) { %>
    <div class="alert alert-success"><i class="fas fa-check-circle"></i> Devis généré avec succès.</div>
    <% } %>

    <% if (alertes != null && !alertes.isEmpty()) { %>
    <div class="stock-banner">
        <i class="fas fa-exclamation-triangle"></i>
        <div>
            <strong><%= alertes.size() %> matériau(x) en alerte de stock</strong>
            <p>Vérifiez l'inventaire et générez des devis si nécessaire.</p>
        </div>
    </div>
    <% } %>

    <div class="card">
        <div class="card-header">
            <div class="card-title"><i class="fas fa-box-open"></i> Inventaire <span class="badge-count"><%= materiels != null ? materiels.size() : 0 %></span></div>
        </div>
        <% if (materiels == null || materiels.isEmpty()) { %>
        <div class="empty-state"><div class="empty-icon"><i class="fas fa-box-open"></i></div><h3>Aucun matériel enregistré</h3></div>
        <% } else { %>
        <div class="table-wrapper">
            <table class="data-table">
                <thead><tr><th>Matériel</th><th>Quantité</th><th>Seuil alerte</th><th>État</th><th>Devis</th></tr></thead>
                <tbody>
                <% for (Materiel m : materiels) { %>
                <tr>
                    <td><strong class="text-dark"><%= m.getNom() %></strong></td>
                    <td><span style="font-size:1.1rem;font-weight:800;color:<%= m.isEnAlerte() ? "var(--danger)" : "var(--success)" %>;"><%= m.getQuantite() %></span></td>
                    <td class="text-muted"><%= m.getSeuilAlerte() %></td>
                    <td>
                        <% if (m.isEnAlerte()) { %>
                        <span class="badge badge-danger"><i class="fas fa-exclamation-triangle"></i> Alerte</span>
                        <% } else { %>
                        <span class="badge badge-success"><i class="fas fa-check"></i> OK</span>
                        <% } %>
                    </td>
                    <td>
                        <button onclick="openDevisModal(<%= m.getId() %>, '<%= m.getNom().replace("'","\\'") %>')"
                                class="btn btn-outline btn-sm"><i class="fas fa-file-invoice"></i> Devis</button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

    <% if (devis != null && !devis.isEmpty()) { %>
    <div class="card">
        <div class="card-header">
            <div class="card-title"><i class="fas fa-file-invoice"></i> Historique des devis <span class="badge-count"><%= devis.size() %></span></div>
        </div>
        <div class="table-wrapper">
            <table class="data-table">
                <thead><tr><th>Matériel</th><th>Quantité demandée</th><th>Date</th></tr></thead>
                <tbody>
                <% for (DevisMateriel d : devis) { %>
                <tr>
                    <td><strong><%= d.getMateriel().getNom() %></strong></td>
                    <td><strong style="color:var(--accent);"><%= d.getQuantiteDemandee() %></strong></td>
                    <td class="text-muted"><%= d.getDateDevis() != null ? d.getDateDevis().toString().substring(0,10) : "—" %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>
</main>

<!-- Modal Devis -->
<div class="modal-overlay" id="devisModal">
    <div class="modal-box">
        <div class="modal-header">
            <div class="modal-icon mi-cyan"><i class="fas fa-file-invoice"></i></div>
            <div><div class="modal-title">Générer un devis</div><div class="modal-subtitle" id="devisNom"></div></div>
        </div>
        <form method="post" action="<%= ctx %>/secretaire">
            <input type="hidden" name="action" value="genererDevis">
            <input type="hidden" name="materielId" id="devisMaterielId">
            <div class="form-group">
                <label class="form-label">Quantité souhaitée</label>
                <input type="number" name="quantite" class="form-control" required min="1" value="10">
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary"><i class="fas fa-file-invoice"></i> Générer</button>
                <button type="button" onclick="document.getElementById('devisModal').classList.remove('open')" class="btn btn-ghost">Annuler</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.getElementById('menuToggle')?.addEventListener('click',()=>{
        document.getElementById('navLinks').classList.toggle('active');
    });
    function openDevisModal(id, nom) {
        document.getElementById('devisMaterielId').value = id;
        document.getElementById('devisNom').textContent = nom;
        document.getElementById('devisModal').classList.add('open');
    }
    document.querySelectorAll('.modal-overlay').forEach(m => {
        m.addEventListener('click', e => { if (e.target === m) m.classList.remove('open'); });
    });
</script>
</body>
</html>
