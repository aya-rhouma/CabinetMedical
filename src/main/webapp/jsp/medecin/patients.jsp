<%@ page import="java.util.List" %>
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

    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    String searchNom = (String) request.getAttribute("searchNom");

    String prenomMedecin = medecin.getPrenom();
    String nomMedecin = medecin.getNom();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes patients - MediCare Plus</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/medecin.css">

    <style>
        .search-bar {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }

        .search-input {
            flex: 1;
            min-width: 250px;
            padding: 0.7rem 1rem;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 0.9rem;
            font-family: 'Inter', sans-serif;
            transition: var(--transition);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
        }

        .patient-avatar-small {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1rem;
        }

        .action-icons {
            display: flex;
            gap: 0.5rem;
        }

        .action-icon {
            width: 32px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            background: var(--light-gray);
            color: var(--gray);
            transition: var(--transition);
            text-decoration: none;
        }

        .action-icon:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-2px);
        }

        .action-icon.danger:hover {
            background: var(--danger);
        }

        @media (max-width: 768px) {
            .patient-info {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
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
            <a href="${pageContext.request.contextPath}/medecin?action=patients" class="active">Patients</a>
            <a href="${pageContext.request.contextPath}/medecin?action=rdv">Rendez-vous</a>
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
    <!-- Search Bar -->
    <div class="card" data-aos="fade-up" data-aos-delay="50">
        <div class="card-header">
            <h2><i class="fas fa-search"></i> Rechercher un patient</h2>
        </div>
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/medecin" class="search-bar">
                <input type="hidden" name="action" value="patients"/>
                <input type="text" name="searchNom" class="search-input"
                       placeholder="Rechercher par nom, prénom ou email..."
                       value="<%= searchNom != null ? searchNom : "" %>">
                <button type="submit" class="btn-filter">
                    <i class="fas fa-search"></i> Rechercher
                </button>
                <% if (searchNom != null && !searchNom.isEmpty()) { %>
                <a href="${pageContext.request.contextPath}/medecin?action=patients" class="btn-filter btn-reset">
                    <i class="fas fa-undo"></i> Réinitialiser
                </a>
                <% } %>
            </form>
        </div>
    </div>

    <!-- Patients List -->
    <div class="card" data-aos="fade-up" data-aos-delay="100">
        <div class="card-header">
            <h2><i class="fas fa-list"></i> Liste des patients</h2>
            <% if (patients != null && !patients.isEmpty()) { %>
            <span class="badge-count"><%= patients.size() %> patient(s)</span>
            <% } %>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="certificats-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Patient</th>
                        <th>Email</th>
                        <th>Téléphone</th>
                        <th>Date inscription</th>
                        <th>Actions</th>
                    </thead>
                    </thead>
                    <tbody>
                    <% if (patients == null || patients.isEmpty()) { %>
                    <tr>
                        <td colspan="6">
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-users-slash"></i>
                                </div>
                                <h3>Aucun patient</h3>
                                <p>
                                    <% if (searchNom != null && !searchNom.isEmpty()) { %>
                                    Aucun patient trouvé pour "<%= searchNom %>"
                                    <% } else { %>
                                    Vous n'avez pas encore de patients
                                    <% } %>
                                </p>
                                <a href="${pageContext.request.contextPath}/medecin" class="btn-primary">
                                    <i class="fas fa-arrow-left"></i> Retour au dashboard
                                </a>
                            </div>
                            </thead>
                            </thead>
                                <% } else {
                            for (Patient p : patients) {
                                String initials = p.getPrenom().substring(0, 1).toUpperCase() +
                                                 p.getNom().substring(0, 1).toUpperCase();
                        %>
                    <tr>
                        <td data-label="ID">
                            <span class="id-badge">#<%= p.getId() %></span>
                            </thead>
                        <td data-label="Patient">
                            <div class="patient-info">
                                <div class="patient-avatar-small">
                                    <%= initials %>
                                </div>
                                <div class="patient-details">
                                    <strong><%= p.getPrenom() %> <%= p.getNom() %></strong>
                                </div>
                            </div>
                            </thead>
                        <td data-label="Email">
                            <i class="fas fa-envelope" style="color: var(--primary);"></i> <%= p.getEmail() %>
                            </thead>
                        <td data-label="Téléphone">
                            <i class="fas fa-phone" style="color: var(--primary);"></i> <%= p.getTelephone() %>
                            </thead>
                        <td data-label="Date inscription">
                            <i class="fas fa-calendar-alt" style="color: var(--primary);"></i> <%= p.getCreatedAt() != null ? p.getCreatedAt() : "N/A" %>
                            </thead>
                        <td data-label="Actions">
                            <div class="action-icons">
                                <a href="${pageContext.request.contextPath}/medecin?action=dossier&patientId=<%= p.getId() %>"
                                   class="action-icon" title="Voir dossier">
                                    <i class="fas fa-folder-open"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/medecin?action=rdv&patientId=<%= p.getId() %>"
                                   class="action-icon" title="Voir rendez-vous">
                                    <i class="fas fa-calendar-alt"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/medecin?action=certificats&patientId=<%= p.getId() %>"
                                   class="action-icon" title="Certificats">
                                    <i class="fas fa-file-medical"></i>
                                </a>
                            </div>
                            </thead>
                    </tr>
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
</script>
</body>
</html>