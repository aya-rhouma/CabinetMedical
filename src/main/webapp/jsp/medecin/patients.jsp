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
    String initials = (prenomMedecin.substring(0, 1) + nomMedecin.substring(0, 1)).toUpperCase();
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

    <style>
        /* ============================================
           VARIABLES CSS
           ============================================ */
        :root {
            --primary: #0ea5e9;
            --primary-dark: #0284c7;
            --secondary: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --dark: #0f172a;
            --gray: #64748b;
            --light-gray: #f8fafc;
            --border: #e2e8f0;
            --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: var(--dark);
        }

        /* ============================================
           NAVIGATION
           ============================================ */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 1000;
            padding: 1rem 0;
        }

        .nav-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            text-decoration: none;
        }

        .logo i {
            color: var(--primary);
        }

        .nav-links {
            display: flex;
            gap: 1.5rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--gray);
            font-weight: 500;
            transition: var(--transition);
        }

        .nav-links a:hover {
            color: var(--primary);
        }

        .nav-links a.active {
            color: var(--primary);
        }

        .btn-login {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white !important;
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
        }

        .menu-toggle {
            display: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--dark);
        }

        /* ============================================
           CONTAINER
           ============================================ */
        .dossier-container {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* ============================================
           CARD
           ============================================ */
        .card {
            background: white;
            border-radius: 20px;
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 2rem;
            transition: var(--transition);
        }

        .card:hover {
            box-shadow: var(--shadow-lg);
        }

        .card-header {
            padding: 1.25rem 1.5rem;
            background: linear-gradient(135deg, #f8fafc, #ffffff);
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .card-header h2 {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .card-header h2 i {
            color: var(--primary);
        }

        .card-body {
            padding: 1.5rem;
        }

        .badge-count {
            display: inline-block;
            padding: 0.2rem 0.6rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
        }

        /* ============================================
           SEARCH BAR
           ============================================ */
        .search-bar {
            display: flex;
            gap: 1rem;
            margin-bottom: 0;
            flex-wrap: wrap;
            align-items: flex-end;
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

        .btn-filter {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 0.7rem 1.5rem;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-filter:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .btn-reset {
            background: var(--gray);
            margin-left: 0.5rem;
        }

        .btn-reset:hover {
            background: #475569;
        }

        /* ============================================
           TABLE
           ============================================ */
        .table-responsive {
            overflow-x: auto;
        }

        .certificats-table {
            width: 100%;
            border-collapse: collapse;
        }

        .certificats-table thead th {
            text-align: left;
            padding: 1rem;
            background: var(--light-gray);
            font-weight: 600;
            color: var(--dark);
            border-bottom: 2px solid var(--border);
        }

        .certificats-table tbody td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
            color: var(--gray);
            vertical-align: middle;
        }

        .certificats-table tbody tr:hover {
            background: var(--light-gray);
        }

        .id-badge {
            display: inline-block;
            padding: 0.2rem 0.5rem;
            background: var(--light-gray);
            color: var(--primary);
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.85rem;
        }

        /* ============================================
           PATIENT INFO
           ============================================ */
        .patient-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
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
            font-weight: 600;
        }

        .patient-details {
            display: flex;
            flex-direction: column;
        }

        .patient-details strong {
            color: var(--dark);
            font-size: 0.9rem;
        }

        /* ============================================
           ACTION ICONS
           ============================================ */
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

        /* ============================================
           EMPTY STATE
           ============================================ */
        .empty-state {
            text-align: center;
            padding: 3rem;
        }

        .empty-icon {
            width: 80px;
            height: 80px;
            background: var(--light-gray);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
        }

        .empty-icon i {
            font-size: 2.5rem;
            color: var(--gray);
        }

        .empty-state h3 {
            font-size: 1.2rem;
            color: var(--dark);
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: var(--gray);
            margin-bottom: 1.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: var(--transition);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        /* ============================================
           RESPONSIVE
           ============================================ */
        @media (max-width: 768px) {
            .menu-toggle {
                display: block;
            }

            .nav-links {
                display: none;
                position: absolute;
                top: 100%;
                left: 0;
                right: 0;
                background: white;
                flex-direction: column;
                padding: 1rem;
                gap: 1rem;
                box-shadow: var(--shadow);
            }

            .nav-links.active {
                display: flex;
            }

            .dossier-container {
                padding: 1rem;
                margin: 1rem auto;
            }

            .search-bar {
                flex-direction: column;
            }

            .search-input {
                width: 100%;
            }

            .btn-filter, .btn-reset {
                width: 100%;
                margin: 0.25rem 0;
            }

            .btn-reset {
                margin-left: 0;
            }

            .patient-info {
                flex-direction: column;
                text-align: center;
            }

            .action-icons {
                justify-content: center;
            }
        }

        /* ============================================
           ANIMATIONS
           ============================================ */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card {
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
        }

        .card:nth-child(1) { animation-delay: 0.1s; }
        .card:nth-child(2) { animation-delay: 0.15s; }
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
                            </td>
                            </thead>
                                <% } else {
                            for (Patient p : patients) {
                                String patientInitials = p.getPrenom().substring(0, 1).toUpperCase() +
                                                         p.getNom().substring(0, 1).toUpperCase();
                        %>
                    <tr>
                        <td data-label="ID">
                            <span class="id-badge">#<%= p.getId() %></span>
                            </thead>
                        <td data-label="Patient">
                            <div class="patient-info">
                                <div class="patient-avatar-small">
                                    <%= patientInitials %>
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

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({ duration: 900, once: true, offset: 80, easing: 'ease-in-out' });

    const menuToggle = document.querySelector('.menu-toggle');
    const navLinks = document.querySelector('.nav-links');
    if (menuToggle) {
        menuToggle.addEventListener('click', () => {
            navLinks.classList.toggle('active');
            const icon = menuToggle.querySelector('i');
            icon.classList.toggle('fa-bars');
            icon.classList.toggle('fa-times');
        });
    }
</script>
</body>
</html>