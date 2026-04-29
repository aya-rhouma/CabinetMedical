<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User, com.jee.entity.RendezVous, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (user.getRole() != User.Role.SECRETAIRE && user.getRole() != User.Role.ADMIN)) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp"); return;
    }
    String ctx = request.getContextPath();
    List<RendezVous> rdvs = (List<RendezVous>) request.getAttribute("rdvs");
    String selectedStatut = (String) request.getAttribute("selectedStatut");
    String selectedDate   = (String) request.getAttribute("selectedDate");
    if (selectedStatut == null) selectedStatut = "";
    if (selectedDate   == null) selectedDate   = "";
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
    <title>Rendez-vous - MediCare Plus</title>
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
            <a href="<%= ctx %>/secretaire?action=rdv" class="active">Rendez-vous</a>
            <a href="<%= ctx %>/secretaire?action=materiels">Matériaux</a>
            <a href="<%= ctx %>/auth/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </div>
        <button class="menu-toggle" id="menuToggle"><i class="fas fa-bars"></i></button>
    </div>
</nav>

<main class="dashboard-main">
    <div class="card">
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
                        <option value="<%= statuts[i] %>" <%= selectedStatut.equals(statuts[i]) ? "selected" : "" %>><%= labels[i] %></option>
                        <% } %>
                    </select>
                </div>
                <div class="filter-group">
                    <span class="filter-label">Date</span>
                    <input type="date" name="dateRdv" class="filter-control" value="<%= selectedDate %>">
                </div>
                <div style="display:flex;gap:.5rem;align-items:flex-end;">
                    <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-filter"></i> Filtrer</button>
                    <a href="<%= ctx %>/secretaire?action=rdv" class="btn btn-ghost btn-sm"><i class="fas fa-times"></i> Reset</a>
                </div>
            </div>
        </form>

        <div class="card-header" style="border-top:1px solid var(--border);">
            <div class="card-title">
                <i class="fas fa-list"></i> Résultats
                <span class="badge-count"><%= rdvs != null ? rdvs.size() : 0 %></span>
            </div>
        </div>

        <% if (rdvs == null || rdvs.isEmpty()) { %>
        <div class="empty-state"><div class="empty-icon"><i class="fas fa-calendar-xmark"></i></div><h3>Aucun rendez-vous trouvé</h3><p>Modifiez les filtres.</p></div>
        <% } else { %>
        <div class="table-wrapper">
            <table class="data-table">
                <thead><tr><th>#</th><th>Date &amp; Heure</th><th>Patient</th><th>Médecin</th><th>Statut</th><th>Paiement</th><th>Actions</th></tr></thead>
                <tbody>
                <% for (RendezVous r : rdvs) { %>
                <tr>
                    <td><span class="id-badge">#<%= r.getId() %></span></td>
                    <td>
                        <div class="fw-bold"><%= r.getDateRdv() %></div>
                        <div class="text-muted" style="font-size:.75rem;"><i class="fas fa-clock" style="color:var(--accent);"></i> <%= r.getHeureDebut() %> – <%= r.getHeureFin() %></div>
                    </td>
                    <td>
                        <div class="user-cell">
                            <div class="user-av cyan"><%= r.getPatient().getPrenom().substring(0,1) %><%= r.getPatient().getNom().substring(0,1) %></div>
                            <div class="cell-name"><%= r.getPatient().getPrenom() %> <%= r.getPatient().getNom() %></div>
                        </div>
                    </td>
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
                        <form method="post" action="<%= ctx %>/secretaire" style="margin:0;">
                            <input type="hidden" name="action" value="marquerPaiement">
                            <input type="hidden" name="rdvId" value="<%= r.getId() %>">
                            <input type="hidden" name="paye" value="true">
                            <button type="submit" class="btn btn-outline btn-sm"><i class="fas fa-credit-card"></i> Marquer payé</button>
                        </form>
                        <% } %>
                    </td>
                    <td>
                        <div style="display:flex;gap:.4rem;">
                            <button onclick="openStatutModal(<%= r.getId() %>, '<%= r.getStatut() != null ? r.getStatut() : "" %>')"
                                    class="btn btn-primary btn-sm btn-icon" title="Changer statut">
                                <i class="fas fa-exchange-alt"></i>
                            </button>
                            <button onclick="openHoraireModal(<%= r.getId() %>, '<%= r.getDateRdv() %>', '<%= r.getHeureDebut() %>', '<%= r.getHeureFin() %>')"
                                    class="btn btn-outline btn-sm btn-icon" title="Modifier horaire">
                                <i class="fas fa-clock"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</main>

<!-- Modal Statut -->
<div class="modal-overlay" id="statutModal">
    <div class="modal-box">
        <div class="modal-header">
            <div class="modal-icon mi-cyan"><i class="fas fa-exchange-alt"></i></div>
            <div><div class="modal-title">Changer le statut</div><div class="modal-subtitle">RDV #<span id="statutRdvId"></span></div></div>
        </div>
        <form method="post" action="<%= ctx %>/secretaire">
            <input type="hidden" name="action" value="changerStatut">
            <input type="hidden" name="rdvId" id="statutRdvIdInput">
            <div class="form-group">
                <label class="form-label">Nouveau statut</label>
                <select name="statut" id="statutSelect" class="form-control">
                    <option value="PLANIFIE">Planifié</option>
                    <option value="CONFIRME">Confirmé</option>
                    <option value="ANNULE">Annulé</option>
                    <option value="EFFECTUE">Effectué</option>
                    <option value="TERMINE">Terminé</option>
                </select>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Enregistrer</button>
                <button type="button" onclick="document.getElementById('statutModal').classList.remove('open')" class="btn btn-ghost">Annuler</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Horaire -->
<div class="modal-overlay" id="horaireModal">
    <div class="modal-box">
        <div class="modal-header">
            <div class="modal-icon mi-amber"><i class="fas fa-clock"></i></div>
            <div><div class="modal-title">Modifier l'horaire</div><div class="modal-subtitle">RDV #<span id="horaireRdvId"></span></div></div>
        </div>
        <form method="post" action="<%= ctx %>/secretaire">
            <input type="hidden" name="action" value="modifierHoraire">
            <input type="hidden" name="rdvId" id="horaireRdvIdInput">
            <div class="form-grid-2">
                <div class="form-group" style="grid-column:1/-1;">
                    <label class="form-label">Date</label>
                    <input type="date" name="dateRdv" id="horaireDate" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Heure début</label>
                    <input type="time" name="heureDebut" id="horaireDebut" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Heure fin</label>
                    <input type="time" name="heureFin" id="horaireFin" class="form-control" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Enregistrer</button>
                <button type="button" onclick="document.getElementById('horaireModal').classList.remove('open')" class="btn btn-ghost">Annuler</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.getElementById('menuToggle')?.addEventListener('click',()=>{
        document.getElementById('navLinks').classList.toggle('active');
    });
    function openStatutModal(id, statut) {
        document.getElementById('statutRdvId').textContent = id;
        document.getElementById('statutRdvIdInput').value  = id;
        document.getElementById('statutSelect').value = statut || 'PLANIFIE';
        document.getElementById('statutModal').classList.add('open');
    }
    function openHoraireModal(id, date, debut, fin) {
        document.getElementById('horaireRdvId').textContent = id;
        document.getElementById('horaireRdvIdInput').value  = id;
        document.getElementById('horaireDate').value  = date;
        document.getElementById('horaireDebut').value = debut;
        document.getElementById('horaireFin').value   = fin;
        document.getElementById('horaireModal').classList.add('open');
    }
    document.querySelectorAll('.modal-overlay').forEach(m => {
        m.addEventListener('click', e => { if (e.target === m) m.classList.remove('open'); });
    });
</script>
</body>
</html>
