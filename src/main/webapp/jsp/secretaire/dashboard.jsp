<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User, com.jee.entity.RendezVous, com.jee.entity.Materiel, java.util.List, java.time.LocalDate" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (user.getRole() != User.Role.SECRETAIRE && user.getRole() != User.Role.ADMIN)) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp"); return;
    }
    String ctx = request.getContextPath();
    String prenom = user.getPrenom(), nom = user.getNom();
    String initials = (prenom.substring(0,1) + nom.substring(0,1)).toUpperCase();
    Long nbPatients = (Long) request.getAttribute("nbPatients");
    Long nbMedecins = (Long) request.getAttribute("nbMedecins");
    Long nbRdv      = (Long) request.getAttribute("nbRdv");
    Long nbRdvJour  = (Long) request.getAttribute("nbRdvDuJour");
    List<RendezVous> rdvJour = (List<RendezVous>) request.getAttribute("rdvDuJour");
    List<Materiel>   alertes = (List<Materiel>) request.getAttribute("alertes");
    String error = (String) request.getAttribute("error");
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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Secrétaire - MediCare Plus</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <style>
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

        .role-tag {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 0.4rem 1rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-logout {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white !important;
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
        }

        .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .menu-toggle {
            display: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--dark);
            background: none;
            border: none;
        }

        .dashboard-main {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

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

        .role-badge i {
            margin-right: 0.5rem;
        }

        .avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 1rem auto 0;
            color: white;
            font-size: 2rem;
            font-weight: 700;
            box-shadow: var(--shadow);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 1.5rem;
            text-align: center;
            transition: var(--transition);
            box-shadow: var(--shadow);
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
        }

        .stat-card i {
            font-size: 2.5rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-bottom: 0.75rem;
        }

        .stat-card h3 {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--gray);
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-card .value {
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--dark), var(--primary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .action-card {
            background: white;
            border-radius: 20px;
            padding: 1.5rem;
            text-align: center;
            text-decoration: none;
            transition: var(--transition);
            box-shadow: var(--shadow);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.75rem;
            color: var(--dark);
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }

        .action-card::before {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 0;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            transition: var(--transition);
            z-index: 0;
        }

        .action-card:hover::before {
            height: 100%;
        }

        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
            color: white;
        }

        .action-card i {
            font-size: 2rem;
            color: var(--primary);
            transition: var(--transition);
            position: relative;
            z-index: 1;
        }

        .action-card:hover i {
            color: white;
            transform: scale(1.1);
        }

        .action-card .title {
            font-weight: 600;
            font-size: 0.9rem;
            position: relative;
            z-index: 1;
        }

        .action-card:hover .title {
            color: white;
        }

        /* Badges pour les statuts */
        .badge {
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
        }

        .badge-success { background: #d1fae5; color: #065f46; }
        .badge-danger { background: #fee2e2; color: #991b1b; }
        .badge-warning { background: #fed7aa; color: #9b3412; }
        .badge-info { background: #dbeafe; color: #1e40af; }
        .badge-violet { background: #ede9fe; color: #5b21b6; }
        .badge-gray { background: #f1f5f9; color: var(--gray); }

        /* Alertes */
        .alert {
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert-danger {
            background-color: #fee2e2;
            color: #991b1b;
            border-left: 4px solid var(--danger);
        }

        .alert i {
            font-size: 1.2rem;
        }

        /* Cartes internes */
        .card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: var(--shadow);
        }

        .card-header {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-title {
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .badge-count {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 0.2rem 0.6rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
        }

        .btn-outline {
            background: transparent;
            border: 1px solid var(--border);
            padding: 0.3rem 0.8rem;
            border-radius: 10px;
            font-size: 0.7rem;
            text-decoration: none;
            color: var(--gray);
            transition: var(--transition);
        }

        .btn-outline:hover {
            border-color: var(--primary);
            color: var(--primary);
        }

        .table-wrapper {
            overflow-x: auto;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th {
            padding: 0.75rem 1rem;
            text-align: left;
            font-size: 0.7rem;
            font-weight: 600;
            color: var(--gray);
            text-transform: uppercase;
            background: var(--light-gray);
        }

        .data-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.85rem;
        }

        .data-table tr:hover {
            background: var(--light-gray);
        }

        .empty-state {
            text-align: center;
            padding: 2rem;
        }

        .empty-icon {
            font-size: 2.5rem;
            color: var(--gray);
            margin-bottom: 0.5rem;
        }

        .empty-state h3 {
            font-size: 0.9rem;
            color: var(--gray);
        }

        .text-muted {
            color: var(--gray);
        }

        @media (max-width: 1024px) {
            .stats-grid, .actions-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

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
                width: 60px;
                height: 60px;
                font-size: 1.5rem;
            }
            .stats-grid, .actions-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            .stat-card .value {
                font-size: 2rem;
            }
        }

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

        .stat-card, .action-card, .hero-panel {
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
        }

        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stat-card:nth-child(4) { animation-delay: 0.4s; }
        .action-card:nth-child(1) { animation-delay: 0.5s; }
        .action-card:nth-child(2) { animation-delay: 0.6s; }
        .action-card:nth-child(3) { animation-delay: 0.7s; }
        .action-card:nth-child(4) { animation-delay: 0.8s; }
        .hero-panel { animation-delay: 0s; }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="<%= ctx %>/"><i class="fas fa-heartbeat"></i><span>MediCare Plus</span></a>
        <div class="nav-links" id="navLinks">
            <a href="<%= ctx %>/secretaire" class="active">Dashboard</a>
            <a href="<%= ctx %>/secretaire?action=patients">Patients</a>
            <a href="<%= ctx %>/secretaire?action=rdv">Rendez-vous</a>
            <a href="<%= ctx %>/secretaire?action=materiels">Matériaux</a>
            <a href="<%= ctx %>/auth/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </div>
        <button class="menu-toggle" id="menuToggle"><i class="fas fa-bars"></i></button>
    </div>
</nav>

<main class="dashboard-main">
    <% if (error != null) { %>
    <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
    <% } %>

    <div class="hero-panel">
        <h1>Bonjour, <span class="gradient-text"><%= prenom %> <%= nom %></span></h1>
        <div class="role-badge"><i class="fas fa-user-tie"></i> Secrétaire</div>
        <div class="avatar"><%= initials %></div>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <i class="fas fa-users"></i>
            <h3>Patients</h3>
            <div class="value"><%= nbPatients != null ? nbPatients : 0 %></div>
        </div>
        <div class="stat-card">
            <i class="fas fa-user-md"></i>
            <h3>Médecins</h3>
            <div class="value"><%= nbMedecins != null ? nbMedecins : 0 %></div>
        </div>
        <div class="stat-card">
            <i class="fas fa-calendar-alt"></i>
            <h3>RDV total</h3>
            <div class="value"><%= nbRdv != null ? nbRdv : 0 %></div>
        </div>
        <div class="stat-card">
            <i class="fas fa-calendar-day"></i>
            <h3>RDV aujourd'hui</h3>
            <div class="value"><%= nbRdvJour != null ? nbRdvJour : 0 %></div>
        </div>
    </div>

    <div class="actions-grid">
        <a class="action-card" href="<%= ctx %>/secretaire?action=patients">
            <i class="fas fa-users"></i>
            <span class="title">Patients</span>
        </a>
        <a class="action-card" href="<%= ctx %>/secretaire?action=rdv">
            <i class="fas fa-calendar-check"></i>
            <span class="title">Rendez-vous</span>
        </a>
        <a class="action-card" href="<%= ctx %>/secretaire?action=materiels">
            <i class="fas fa-boxes-stacked"></i>
            <span class="title">Matériaux</span>
        </a>
        <a class="action-card" href="<%= ctx %>/secretaire?action=rdv&statut=PLANIFIE">
            <i class="fas fa-clock"></i>
            <span class="title">À confirmer</span>
        </a>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:1.5rem;">
        <div class="card">
            <div class="card-header">
                <div class="card-title"><i class="fas fa-calendar-day"></i> RDV du jour <span class="badge-count"><%= rdvJour != null ? rdvJour.size() : 0 %></span></div>
                <a href="<%= ctx %>/secretaire?action=rdv" class="btn-outline">Voir tout</a>
            </div>
            <% if (rdvJour == null || rdvJour.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-calendar-times"></i></div>
                <h3>Aucun RDV aujourd'hui</h3>
            </div>
            <% } else { %>
            <div class="table-wrapper">
                <table class="data-table">
                    <thead><tr><th>Horaire</th><th>Patient</th><th>Médecin</th><th>Statut</th></thead>
                    <tbody>
                    <% for (RendezVous r : rdvJour) { %>
                    <tr>
                        <td><strong><%= r.getHeureDebut() %></strong> – <%= r.getHeureFin() %></td>
                        <td><%= r.getPatient().getPrenom() %> <%= r.getPatient().getNom() %></td>
                        <td>Dr <%= r.getMedecin().getNom() %></td>
                        <td><%= statutBadge(r.getStatut()) %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>

        <div class="card">
            <div class="card-header">
                <div class="card-title"><i class="fas fa-exclamation-triangle" style="color:var(--warning);"></i> Alertes stock <span class="badge-count" style="background:var(--warning);"><%= alertes != null ? alertes.size() : 0 %></span></div>
                <a href="<%= ctx %>/secretaire?action=materiels" class="btn-outline">Inventaire</a>
            </div>
            <% if (alertes == null || alertes.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-check-circle" style="color:var(--secondary);"></i></div>
                <h3>Stocks OK</h3>
            </div>
            <% } else { %>
            <div class="table-wrapper">
                <table class="data-table">
                    <thead><tr><th>Matériel</th><th>Qté</th><th>Seuil</th></thead>
                    <tbody>
                    <% for (Materiel m : alertes) { %>
                    <tr>
                        <td><strong><%= m.getNom() %></strong></td>
                        <td style="color:var(--danger);font-weight:700;"><%= m.getQuantite() %></td>
                        <td class="text-muted"><%= m.getSeuilAlerte() %></td>
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

    document.getElementById('menuToggle')?.addEventListener('click', () => {
        document.getElementById('navLinks').classList.toggle('active');
        const icon = document.getElementById('menuToggle').querySelector('i');
        if (icon.classList.contains('fa-bars')) {
            icon.classList.remove('fa-bars');
            icon.classList.add('fa-times');
        } else {
            icon.classList.remove('fa-times');
            icon.classList.add('fa-bars');
        }
    });

    document.querySelectorAll('.nav-links a').forEach(link => {
        link.addEventListener('click', () => {
            document.getElementById('navLinks').classList.remove('active');
            const icon = document.getElementById('menuToggle').querySelector('i');
            if (icon) {
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            }
        });
    });
</script>
</body>
</html>