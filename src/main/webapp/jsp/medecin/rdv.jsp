<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.RendezVous" %>
<%@ page import="com.jee.entity.Patient" %>
<%@ page import="com.jee.entity.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User medecin = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();

    if (medecin == null || medecin.getRole() != User.Role.MEDECIN) {
        response.sendRedirect(contextPath + "/jsp/auth/login.jsp");
        return;
    }

    List<RendezVous> rdvs = (List<RendezVous>) request.getAttribute("rdvs");
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    Object selectedPatientId = request.getAttribute("selectedPatientId");
    String selectedFiltre = (String) request.getAttribute("selectedFiltre");
    if (selectedFiltre == null || selectedFiltre.isBlank()) {
        selectedFiltre = "all";
    }

    String prenomMedecin = medecin.getPrenom();
    String nomMedecin = medecin.getNom();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rendez-vous - MediCare Plus</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/medecin.css">
</head>
<body>

<!-- Navigation -->
<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="${pageContext.request.contextPath}/medecin">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/medecin">Dashboard</a>
            <a href="${pageContext.request.contextPath}/medecin?action=certificats">Certificats</a>
            <a href="${pageContext.request.contextPath}/medecin?action=patients">Patients</a>
            <a href="${pageContext.request.contextPath}/medecin?action=rdv" class="active">Rendez-vous</a>
            <a href="${pageContext.request.contextPath}/auth/logout" class="btn-login">
                <i class="fas fa-sign-out-alt"></i> Déconnexion
            </a>
        </div>
        <div class="menu-toggle">
            <i class="fas fa-bars"></i>
        </div>
    </div>
</nav>

<!-- Main Container -->
<div class="dossier-container">


    <!-- Filter Card -->
    <div class="card" data-aos="fade-up" data-aos-delay="50">
        <div class="card-header">
            <h2><i class="fas fa-filter"></i> Filtrer les rendez-vous</h2>
        </div>
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/medecin" class="filter-bar">
                <input type="hidden" name="action" value="rdv"/>
                <div class="filter-group">
                    <label><i class="fas fa-user"></i> Patient</label>
                    <select name="patientId">
                        <option value="">Tous les patients</option>
                        <% if (patients != null) {
                            for (Patient p : patients) { %>
                        <option value="<%=p.getId()%>" <%= (selectedPatientId != null && selectedPatientId.toString().equals(String.valueOf(p.getId()))) ? "selected" : "" %>>
                            <%= p.getPrenom() %> <%= p.getNom() %>
                        </option>
                        <% }} %>
                    </select>
                </div>
                <div class="filter-group">
                    <label><i class="fas fa-clock"></i> Statut</label>
                    <select name="filtre">
                        <option value="all" <%= "all".equals(selectedFiltre) ? "selected" : "" %>>Tous les RDV</option>
                        <option value="planifies" <%= "planifies".equals(selectedFiltre) ? "selected" : "" %>>Planifiés</option>
                        <option value="termines" <%= "termines".equals(selectedFiltre) ? "selected" : "" %>>Terminés</option>
                        <option value="annules" <%= "annules".equals(selectedFiltre) ? "selected" : "" %>>Annulés</option>
                    </select>
                </div>
                <div>
                    <button class="btn-filter" type="submit">
                        <i class="fas fa-search"></i> Filtrer
                    </button>
                    <a href="${pageContext.request.contextPath}/medecin?action=rdv" class="btn-filter btn-reset">
                        <i class="fas fa-undo"></i> Réinitialiser
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Rendez-vous List Card -->
    <div class="card" data-aos="fade-up" data-aos-delay="100">
        <div class="card-header">
            <h2><i class="fas fa-list"></i> Liste des rendez-vous</h2>
            <% if (rdvs != null && !rdvs.isEmpty()) { %>
            <span class="badge-count"><%= rdvs.size() %> rendez-vous</span>
            <% } %>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="certificats-table">
                    <thead>
                    <tr>
                        <th>Date</th>
                        <th>Horaire</th>
                        <th>Patient</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </thead>
                    </thead>
                    <tbody>
                    <% if (rdvs == null || rdvs.isEmpty()) { %>
                    <tr>
                        <td colspan="5">
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-calendar-times"></i>
                                </div>
                                <h3>Aucun rendez-vous</h3>
                                <p>Il n'y a actuellement aucun rendez-vous pour le moment</p>
                                <a href="${pageContext.request.contextPath}/medecin" class="btn-primary">
                                    <i class="fas fa-arrow-left"></i> Retour au dashboard
                                </a>
                            </div>
                            </thead>
                            </thead>
                                <% } else {
                            for (RendezVous rdv : rdvs) {
                                String statutClass = "";
                                String statutIcon = "";
                                switch (rdv.getStatut()) {
                                    case "PLANIFIE":
                                        statutClass = "status-pending";
                                        statutIcon = "fa-clock";
                                        break;
                                    case "CONFIRME":
                                        statutClass = "status-approved";
                                        statutIcon = "fa-check-circle";
                                        break;
                                    case "TERMINE":
                                        statutClass = "status-completed";
                                        statutIcon = "fa-check-double";
                                        break;
                                    case "ANNULE":
                                        statutClass = "status-rejected";
                                        statutIcon = "fa-times-circle";
                                        break;
                                    default:
                                        statutClass = "status-pending";
                                        statutIcon = "fa-clock";
                                }
                        %>
                    <tr>
                        <td data-label="Date">
                            <i class="fas fa-calendar-day" style="color: var(--primary);"></i> <%= rdv.getDateRdv() %>
                            </thead>
                        <td data-label="Horaire">
                            <i class="fas fa-clock" style="color: var(--primary);"></i> <%= rdv.getHeureDebut() %> - <%= rdv.getHeureFin() %>
                            </thead>
                        <td data-label="Patient">
                            <div class="patient-info">
                                <div class="patient-avatar-small" style="width: 35px; height: 35px; font-size: 0.9rem;">
                                    <%= rdv.getPatient().getPrenom().substring(0, 1).toUpperCase() %><%= rdv.getPatient().getNom().substring(0, 1).toUpperCase() %>
                                </div>
                                <div class="patient-details">
                                    <strong><%= rdv.getPatient().getPrenom() %> <%= rdv.getPatient().getNom() %></strong>
                                    <small><i class="fas fa-phone"></i> <%= rdv.getPatient().getTelephone() %></small>
                                </div>
                            </div>
                            </thead>
                        <td data-label="Statut">
                                <span class="status-badge <%= statutClass %>">
                                    <i class="fas <%= statutIcon %>"></i> <%= rdv.getStatut() %>
                                </span>
                            </thead>
                        <td data-label="Actions">
                            <div class="action-icons">
                                <a href="${pageContext.request.contextPath}/medecin?action=dossier&patientId=<%= rdv.getPatient().getId() %>"
                                   class="action-icon" title="Voir dossier">
                                    <i class="fas fa-folder-open"></i>
                                </a>
                                <% if ("PLANIFIE".equals(rdv.getStatut()) || "CONFIRME".equals(rdv.getStatut())) { %>
                                <button onclick="confirmerRdv(<%= rdv.getId() %>)"
                                        class="action-icon" title="Confirmer" style="background: var(--secondary); color: white;">
                                    <i class="fas fa-check"></i>
                                </button>
                                <button onclick="annulerRdv(<%= rdv.getId() %>)"
                                        class="action-icon danger" title="Annuler" style="background: var(--danger); color: white;">
                                    <i class="fas fa-times"></i>
                                </button>
                                <% } %>
                            </div>
                            </thead>
                            </thead>
                                <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({
        duration: 800,
        once: true,
        offset: 100,
        easing: 'ease-in-out'
    });

    const menuToggle = document.querySelector('.menu-toggle');
    const navLinks = document.querySelector('.nav-links');
    if (menuToggle) {
        menuToggle.addEventListener('click', () => {
            navLinks.classList.toggle('active');
            const icon = menuToggle.querySelector('i');
            if (icon.classList.contains('fa-bars')) {
                icon.classList.remove('fa-bars');
                icon.classList.add('fa-times');
            } else {
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            }
        });
    }

    function confirmerRdv(rdvId) {
        if (confirm('Confirmer ce rendez-vous ?')) {
            window.location.href = '${pageContext.request.contextPath}/medecin?action=confirmerRdv&rdvId=' + rdvId;
        }
    }

    function annulerRdv(rdvId) {
        if (confirm('Annuler ce rendez-vous ? Cette action est irréversible.')) {
            window.location.href = '${pageContext.request.contextPath}/medecin?action=annulerRdv&rdvId=' + rdvId;
        }
    }
</script>
</body>
</html>