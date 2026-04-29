<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.RendezVous" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<RendezVous> rdvPlanifies = (List<RendezVous>) request.getAttribute("rdvPlanifies");
    List<RendezVous> rdvPasses = (List<RendezVous>) request.getAttribute("rdvPasses");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mes Rendez-vous - MediCare Plus</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/dashboard.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="logo">
                <i class="fas fa-heartbeat"></i>
                <span>MediCare Plus</span>
            </div>
            <div class="nav-links">
                <a href="<%= contextPath %>/patient">Retour au Dashboard</a>
            </div>
        </div>
    </nav>

    <main class="dashboard-main">
        <section class="section-card">
            <h2><i class="fas fa-calendar-check"></i> Mes Rendez-vous</h2>
            
            <div class="grid-2">
                <!-- RDV Planifiés -->
                <div>
                    <h3>Planifiés</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Heure</th>
                                <th>Médecin</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (rdvPlanifies == null || rdvPlanifies.isEmpty()) { %>
                            <tr><td colspan="4" class="muted">Aucun RDV planifié</td></tr>
                            <% } else {
                                for (RendezVous r : rdvPlanifies) { %>
                            <tr>
                                <td><%= r.getDateRdv() %></td>
                                <td><%= r.getHeureDebut() %> - <%= r.getHeureFin() %></td>
                                <td><%= r.getMedecin().getPrenom() %> <%= r.getMedecin().getNom() %></td>
                                <td>
                                    <form method="post" action="<%= contextPath %>/patient" style="display:inline;">
                                        <input type="hidden" name="action" value="annulerRdv">
                                        <input type="hidden" name="rdvId" value="<%= r.getId() %>">
                                        <button type="submit" class="btn btn-danger btn-sm">Annuler</button>
                                    </form>
                                </td>
                            </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>

                <!-- RDV Passés -->
                <div>
                    <h3>Historique (Passés)</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Heure</th>
                                <th>Médecin</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (rdvPasses == null || rdvPasses.isEmpty()) { %>
                            <tr><td colspan="3" class="muted">Aucun historique</td></tr>
                            <% } else {
                                for (RendezVous r : rdvPasses) { %>
                            <tr>
                                <td><%= r.getDateRdv() %></td>
                                <td><%= r.getHeureDebut() %> - <%= r.getHeureFin() %></td>
                                <td><%= r.getMedecin().getPrenom() %> <%= r.getMedecin().getNom() %></td>
                            </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>
</body>
</html>

