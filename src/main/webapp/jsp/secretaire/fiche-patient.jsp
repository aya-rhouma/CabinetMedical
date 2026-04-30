<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User, com.jee.entity.Patient, com.jee.entity.RendezVous, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (user.getRole() != User.Role.SECRETAIRE && user.getRole() != User.Role.ADMIN)) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp"); return;
    }
    String ctx = request.getContextPath();
    Patient patient = (Patient) request.getAttribute("patient");
    List<RendezVous> rdvsPatient = (List<RendezVous>) request.getAttribute("rdvsPatient");
    if (patient == null) { response.sendRedirect(ctx + "/secretaire?action=patients"); return; }
    String pInit = (patient.getPrenom().substring(0,1) + patient.getNom().substring(0,1)).toUpperCase();
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
    <title>Fiche Patient - MediCare Plus</title>
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

        /* Breadcrumb */
        .page-breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            flex-wrap: wrap;
            margin-bottom: 1.5rem;
            padding: 0.75rem 1rem;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            font-size: 0.85rem;
        }

        .page-breadcrumb a {
            color: var(--primary);
            text-decoration: none;
        }

        .page-breadcrumb a:hover {
            text-decoration: underline;
        }

        .page-breadcrumb span {
            color: var(--dark);
            font-weight: 500;
        }

        .page-breadcrumb i {
            color: var(--gray);
            font-size: 0.7rem;
        }

        /* Patient Hero */
        .patient-hero {
            background: white;
            border-radius: 24px;
            padding: 2rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1.5rem;
            flex-wrap: wrap;
            box-shadow: var(--shadow);
            transition: var(--transition);
            position: relative;
        }

        .patient-hero:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
        }

        .ph-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            font-weight: 700;
            box-shadow: var(--shadow);
        }

        .ph-info {
            flex: 1;
        }

        .ph-info h2 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 0.25rem;
        }

        .ph-info p {
            color: var(--gray);
            font-size: 0.85rem;
        }

        .ph-info p i {
            color: var(--primary);
            margin-right: 0.3rem;
        }

        /* Card */
        .card {
            background: white;
            border-radius: 20px;
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 1.5rem;
            transition: var(--transition);
        }

        .card:hover {
            box-shadow: var(--shadow-lg);
        }

        .card-header {
            padding: 1rem 1.5rem;
            background: white;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .card-title {
            font-weight: 600;
            font-size: 1rem;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .card-title i {
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

        /* Info Grid */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 1rem;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .info-label {
            font-size: 0.7rem;
            font-weight: 600;
            color: var(--gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-label i {
            margin-right: 0.3rem;
            color: var(--primary);
        }

        .info-value {
            font-size: 0.9rem;
            font-weight: 500;
            color: var(--dark);
        }

        /* Table */
        .table-wrapper {
            overflow-x: auto;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table thead {
            background: var(--light-gray);
        }

        .data-table th {
            padding: 0.75rem 1rem;
            text-align: left;
            font-size: 0.7rem;
            font-weight: 600;
            color: var(--gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .data-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.85rem;
        }

        .data-table tr:hover {
            background: var(--light-gray);
        }

        .id-badge {
            background: var(--light-gray);
            padding: 0.2rem 0.5rem;
            border-radius: 6px;
            font-family: monospace;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--gray);
        }

        .text-muted {
            color: var(--gray);
            font-size: 0.8rem;
        }

        .user-cell {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .user-av {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            font-size: 0.8rem;
        }

        .user-av.blue {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
        }

        .cell-name {
            font-weight: 600;
            font-size: 0.85rem;
        }

        .cell-sub {
            font-size: 0.7rem;
            color: var(--gray);
        }

        /* Badges */
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

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
        }

        .empty-icon {
            font-size: 3rem;
            color: var(--gray);
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            font-size: 1rem;
            color: var(--gray);
            font-weight: 500;
        }

        /* Button */
        .btn {
            padding: 0.5rem 1rem;
            border-radius: 10px;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            font-size: 0.8rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-ghost {
            background: transparent;
            border: 1px solid var(--border);
            color: var(--gray);
        }

        .btn-ghost:hover {
            border-color: var(--primary);
            color: var(--primary);
        }

        .btn-sm {
            padding: 0.3rem 0.8rem;
            font-size: 0.7rem;
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
            .patient-hero {
                flex-direction: column;
                text-align: center;
            }
            .info-grid {
                grid-template-columns: 1fr;
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

        .page-breadcrumb, .patient-hero, .card {
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
        }

        .page-breadcrumb { animation-delay: 0s; }
        .patient-hero { animation-delay: 0.1s; }
        .card:first-of-type { animation-delay: 0.2s; }
        .card:last-of-type { animation-delay: 0.3s; }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="<%= ctx %>/"><i class="fas fa-heartbeat"></i><span>MediCare Plus</span></a>
        <div class="nav-links" id="navLinks">
            <a href="<%= ctx %>/secretaire">Dashboard</a>
            <a href="<%= ctx %>/secretaire?action=patients" class="active">Patients</a>
            <a href="<%= ctx %>/secretaire?action=rdv">Rendez-vous</a>
            <a href="<%= ctx %>/secretaire?action=materiels">Matériaux</a>
            <a href="<%= ctx %>/auth/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </div>
        <button class="menu-toggle" id="menuToggle"><i class="fas fa-bars"></i></button>
    </div>
</nav>

<main class="dashboard-main">


    <div class="patient-hero">
        <div class="ph-avatar"><%= pInit %></div>
        <div class="ph-info">
            <h2><%= patient.getPrenom() %> <%= patient.getNom() %></h2>
            <p>
                <i class="fas fa-envelope"></i> <%= patient.getEmail() %>
                <% if (patient.getTelephone() != null && !patient.getTelephone().isBlank()) { %>
                &nbsp;&nbsp;<i class="fas fa-phone"></i> <%= patient.getTelephone() %>
                <% } %>
            </p>
        </div>
        <a href="<%= ctx %>/secretaire?action=patients" class="btn btn-ghost btn-sm">
            <i class="fas fa-arrow-left"></i> Retour
        </a>
    </div>

    <div class="card">
        <div class="card-header">
            <div class="card-title"><i class="fas fa-user-circle"></i> Informations administratives</div>
        </div>
        <div class="card-body">
            <div class="info-grid">
                <div class="info-item"><div class="info-label"><i class="fas fa-user"></i> Prénom</div><div class="info-value"><%= patient.getPrenom() %></div></div>
                <div class="info-item"><div class="info-label"><i class="fas fa-user"></i> Nom</div><div class="info-value"><%= patient.getNom() %></div></div>
                <div class="info-item"><div class="info-label"><i class="fas fa-envelope"></i> Email</div><div class="info-value" style="font-size:.85rem;"><%= patient.getEmail() %></div></div>
                <div class="info-item"><div class="info-label"><i class="fas fa-phone"></i> Téléphone</div><div class="info-value"><%= patient.getTelephone() != null ? patient.getTelephone() : "—" %></div></div>
                <div class="info-item"><div class="info-label"><i class="fas fa-birthday-cake"></i> Naissance</div><div class="info-value"><%= patient.getDateNaissance() != null ? patient.getDateNaissance() : "—" %></div></div>
                <div class="info-item"><div class="info-label"><i class="fas fa-map-marker-alt"></i> Adresse</div><div class="info-value" style="font-size:.85rem;"><%= patient.getAdresse() != null && !patient.getAdresse().isBlank() ? patient.getAdresse() : "—" %></div></div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <div class="card-title"><i class="fas fa-calendar-alt"></i> Historique des rendez-vous <span class="badge-count"><%= rdvsPatient != null ? rdvsPatient.size() : 0 %></span></div>
        </div>
        <% if (rdvsPatient == null || rdvsPatient.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon"><i class="fas fa-calendar-times"></i></div>
            <h3>Aucun rendez-vous</h3>
        </div>
        <% } else { %>
        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                <tr><th>#</th><th>Date</th><th>Horaire</th><th>Médecin</th><th>Statut</th><th>Paiement</th></tr>
                </thead>
                <tbody>
                <% for (RendezVous r : rdvsPatient) { %>
                <tr>
                    <td><span class="id-badge">#<%= r.getId() %></span></td>
                    <td><strong><%= r.getDateRdv() %></strong></td>
                    <td class="text-muted"><i class="fas fa-clock" style="color:var(--primary);"></i> <%= r.getHeureDebut() %> – <%= r.getHeureFin() %></td>
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
                        <span class="badge badge-warning"><i class="fas fa-hourglass-half"></i> En attente</span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
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