<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.Medecin" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Medecin> medecins = (List<Medecin>) request.getAttribute("medecinsDisponibles");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Réserver un RDV - MediCare Plus</title>
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
            <h2><i class="fas fa-calendar-plus"></i> Réserver un rendez-vous</h2>
            
            <form method="post" action="<%= contextPath %>/patient" class="form-grid">
                <input type="hidden" name="action" value="reserverRdv">
                <div>
                    <label>Médecin</label>
                    <select name="medecinId" required>
                        <option value="">Choisir un médecin</option>
                        <% if (medecins != null) {
                            for (Medecin m : medecins) { %>
                        <option value="<%= m.getId() %>">
                            <%= m.getPrenom() %> <%= m.getNom() %> - <%= m.getSpecialite() %>
                        </option>
                        <% }} %>
                    </select>
                </div>
                <div>
                    <label>Date</label>
                    <input type="date" name="dateRdv" required title="Date du rendez-vous">
                </div>
                <div>
                    <label>Heure de début</label>
                    <input type="time" name="heureDebut" required title="Heure de début">
                </div>
                <div>
                    <label>Heure de fin</label>
                    <input type="time" name="heureFin" required title="Heure de fin">
                </div>
                <div>
                    <button class="btn btn-success" type="submit">
                        <i class="fas fa-check"></i> Confirmer la réservation
                    </button>
                </div>
            </form>
        </section>
    </main>
</body>
</html>

