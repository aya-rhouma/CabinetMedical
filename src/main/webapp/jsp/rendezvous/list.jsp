<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.RendezVous" %>
<%@ page import="com.jee.entity.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User patient = (User) session.getAttribute("user");
    List<RendezVous> rdvPlanifies = (List<RendezVous>) request.getAttribute("rdvPlanifies");
    List<RendezVous> rdvPasses = (List<RendezVous>) request.getAttribute("rdvPasses");
    String contextPath = request.getContextPath();

    if (patient == null) {
        response.sendRedirect(contextPath + "/jsp/auth/login.jsp");
        return;
    }

    String prenom = patient.getPrenom();
    String nom = patient.getNom();
    String initials = (prenom.substring(0, 1) + (nom.isBlank() ? "P" : nom.substring(0, 1))).toUpperCase();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Mes rendez-vous médicaux - MediCare Plus">
    <title>Mes Rendez-vous - MediCare Plus</title>

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

        .btn-logout {
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
            background: none;
            border: none;
        }

        /* ============================================
           DASHBOARD MAIN
           ============================================ */
        .dashboard-main {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* Breadcrumb */
        .page-header {
            margin-bottom: 2rem;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            font-size: 0.85rem;
            color: var(--gray);
        }

        .breadcrumb a {
            color: var(--primary);
            text-decoration: none;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        .breadcrumb i {
            font-size: 0.7rem;
        }

        .page-header h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--dark);
        }

        .page-header h1 i {
            color: var(--primary);
            margin-right: 0.75rem;
        }

        /* Hero Panel */
        .hero-panel {
            background: white;
            border-radius: 24px;
            padding: 2rem;
            margin-bottom: 2rem;
            text-align: center;
            box-shadow: var(--shadow);
            transition: var(--transition);
        }

        .hero-panel:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
        }

        .hero-panel h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 0.5rem;
        }

        .gradient-text {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .role-badge {
            display: inline-block;
            padding: 0.4rem 1rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            margin: 0.5rem 0;
        }

        .avatar {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 1rem auto 0;
            color: white;
            font-size: 1.8rem;
            font-weight: 700;
            box-shadow: var(--shadow);
        }

        /* Card */
        .card {
            background: white;
            border-radius: 24px;
            box-shadow: var(--shadow);
            overflow: hidden;
            transition: var(--transition);
            margin-bottom: 2rem;
        }

        .card:hover {
            box-shadow: var(--shadow-lg);
        }

        .card-header {
            padding: 1.25rem 1.5rem;
            background: white;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .card-header h2 {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .card-header h2 i {
            color: var(--primary);
        }

        .badge-count {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 0.2rem 0.6rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            margin-left: 0.5rem;
        }

        .card-body {
            padding: 1.5rem;
        }

        /* Buttons */
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.85rem;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .btn-action {
            background: transparent;
            border: 1px solid var(--border);
            color: var(--gray);
            padding: 0.4rem 0.8rem;
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.75rem;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            text-decoration: none;
        }

        .btn-action:hover {
            border-color: var(--danger);
            color: var(--danger);
        }

        /* Table */
        .table-responsive {
            overflow-x: auto;
        }

        .certificats-table {
            width: 100%;
            border-collapse: collapse;
        }

        .certificats-table thead {
            background: var(--light-gray);
        }

        .certificats-table th {
            padding: 0.75rem 1rem;
            text-align: left;
            font-size: 0.7rem;
            font-weight: 600;
            color: var(--gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .certificats-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.85rem;
            color: var(--dark);
        }

        .certificats-table tr:hover {
            background: var(--light-gray);
        }

        /* Patient Info */
        .patient-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .patient-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.8rem;
        }

        .patient-details {
            display: flex;
            flex-direction: column;
        }

        .patient-details strong {
            font-size: 0.85rem;
            color: var(--dark);
        }

        .patient-details small {
            font-size: 0.7rem;
            color: var(--gray);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 2rem;
        }

        .empty-icon {
            font-size: 3rem;
            color: var(--gray);
            margin-bottom: 0.5rem;
        }

        .empty-state h3 {
            font-size: 0.9rem;
            color: var(--dark);
            margin-bottom: 0.25rem;
        }

        .empty-state p {
            font-size: 0.8rem;
            color: var(--gray);
        }

        /* Responsive */
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

            .dashboard-main {
                padding: 1rem;
            }

            .hero-panel h1 {
                font-size: 1.3rem;
            }

            .avatar {
                width: 55px;
                height: 55px;
                font-size: 1.3rem;
            }

            .page-header h1 {
                font-size: 1.4rem;
            }

            .card-header {
                flex-direction: column;
                text-align: center;
            }
        }

        /* Animations */
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

        .hero-panel, .card, .page-header {
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
        }

        .page-header { animation-delay: 0s; }
        .hero-panel { animation-delay: 0.05s; }
        .card:first-of-type { animation-delay: 0.1s; }
        .card:last-of-type { animation-delay: 0.2s; }
    </style>
</head>

<body>

<!-- Navigation -->
<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="<%= contextPath %>/">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </a>

        <div class="nav-links" id="navLinks">
            <a href="<%= contextPath %>/patient">Dashboard</a>
            <a href="<%= contextPath %>/patient?action=reservationForm">Prendre RDV</a>
            <a href="<%= contextPath %>/patient?action=mesRdv" class="active">Mes RDV</a>
            <a href="<%= contextPath %>/patient?action=demandeCertificat">Certificats</a>
            <a href="<%= contextPath %>/auth/logout" class="btn-logout">
                <i class="fas fa-sign-out-alt"></i> Déconnexion
            </a>
        </div>

        <button class="menu-toggle" id="menuToggle">
            <i class="fas fa-bars"></i>
        </button>
    </div>
</nav>

<!-- Main Content -->
<main class="dashboard-main">
    <!-- Hero Panel -->
    <div class="hero-panel">
        <h1>Bonjour, <span class="gradient-text"><%= prenom %> <%= nom %></span></h1>
        <div class="role-badge">
            <i class="fas fa-user-circle"></i> Patient
        </div>
        <div class="avatar"><%= initials %></div>
    </div>

    <!-- RDV Planifiés -->
    <div class="card">
        <div class="card-header">
            <h2>
                <i class="fas fa-calendar-check"></i> RDV à venir
                <span class="badge-count"><%= rdvPlanifies != null ? rdvPlanifies.size() : 0 %></span>
            </h2>
            <a href="<%= contextPath %>/patient?action=reservationForm" class="btn-primary">
                <i class="fas fa-plus"></i> Nouveau RDV
            </a>
        </div>
        <div class="card-body">
            <% if (rdvPlanifies == null || rdvPlanifies.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-calendar-times"></i></div>
                <h3>Aucun RDV planifié</h3>
                <p>Prenez votre premier rendez-vous dès maintenant.</p>
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="certificats-table">
                    <thead>
                    <tr><th>Date</th><th>Horaire</th><th>Médecin</th><th>Statut</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                    <% for (RendezVous r : rdvPlanifies) { %>
                    <tr>
                        <td><strong><%= r.getDateRdv() %></strong></td>
                        <td style="color:var(--gray);">
                            <i class="fas fa-clock" style="color:var(--primary);"></i>
                            <%= r.getHeureDebut() %> – <%= r.getHeureFin() %>
                        </td>
                        <td>
                            <div class="patient-info">
                                <div class="patient-avatar"><i class="fas fa-user-doctor"></i></div>
                                <div class="patient-details">
                                    <strong>Dr <%= r.getMedecin().getPrenom() %> <%= r.getMedecin().getNom() %></strong>
                                    <small><%= r.getMedecin().getSpecialite() %></small>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span style="background:#fef3c7;color:#92400e;padding:.2rem .7rem;border-radius:50px;font-size:.75rem;font-weight:600;">
                                <i class="fas fa-clock"></i> <%= r.getStatut() != null ? r.getStatut() : "PLANIFIÉ" %>
                            </span>
                        </td>
                        <td>
                            <form method="post" action="<%= contextPath %>/patient" style="margin:0;"
                                  onsubmit="return confirm('Annuler ce rendez-vous ?')">
                                <input type="hidden" name="action" value="annulerRdv">
                                <input type="hidden" name="rdvId" value="<%= r.getId() %>">
                                <button type="submit" class="btn-action" style="background:#fee2e2;color:#991b1b;">
                                    <i class="fas fa-times"></i> Annuler
                                </button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Historique -->
    <div class="card">
        <div class="card-header">
            <h2>
                <i class="fas fa-history"></i> Historique
                <span class="badge-count"><%= rdvPasses != null ? rdvPasses.size() : 0 %></span>
            </h2>
        </div>
        <div class="card-body">
            <% if (rdvPasses == null || rdvPasses.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-clock-rotate-left"></i></div>
                <h3>Aucun historique</h3>
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="certificats-table">
                    <thead>
                    <tr><th>Date</th><th>Horaire</th><th>Médecin</th><th>Statut</th></tr>
                    </thead>
                    <tbody>
                    <% for (RendezVous r : rdvPasses) { %>
                    <tr>
                        <td><strong><%= r.getDateRdv() %></strong></td>
                        <td style="color:var(--gray);">
                            <i class="fas fa-clock" style="color:var(--primary);"></i>
                            <%= r.getHeureDebut() %> – <%= r.getHeureFin() %>
                        </td>
                        <td>
                            <div class="patient-info">
                                <div class="patient-avatar"><i class="fas fa-user-doctor"></i></div>
                                <div class="patient-details">
                                    <strong>Dr <%= r.getMedecin().getPrenom() %> <%= r.getMedecin().getNom() %></strong>
                                    <small><%= r.getMedecin().getSpecialite() %></small>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span style="background:#d1fae5;color:#065f46;padding:.2rem .7rem;border-radius:50px;font-size:.75rem;font-weight:600;">
                                <i class="fas fa-check-double"></i> <%= r.getStatut() != null ? r.getStatut() : "EFFECTUÉ" %>
                            </span>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
</main>

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({ duration: 900, once: true, offset: 80, easing: 'ease-in-out' });

    const menuToggle = document.getElementById('menuToggle');
    const navLinks = document.getElementById('navLinks');

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

    document.querySelectorAll('.nav-links a').forEach(link => {
        link.addEventListener('click', () => {
            navLinks.classList.remove('active');
            const icon = menuToggle?.querySelector('i');
            if (icon) {
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            }
        });
    });
</script>
</body>
</html>