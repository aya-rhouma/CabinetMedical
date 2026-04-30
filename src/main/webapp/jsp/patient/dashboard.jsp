<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.RendezVous" %>
<%@ page import="com.jee.entity.CertificatMedical" %>
<%@ page import="com.jee.entity.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<RendezVous> rdvPlanifies = (List<RendezVous>) request.getAttribute("rdvPlanifies");
    List<RendezVous> rdvPasses    = (List<RendezVous>) request.getAttribute("rdvPasses");
    List<String> notifications    = (List<String>) request.getAttribute("notifications");
    List<CertificatMedical> demandesCertificats = (List<CertificatMedical>) request.getAttribute("demandesCertificats");
    User patient = (User) session.getAttribute("user");
    String ctx = request.getContextPath();

    if (patient == null) {
        response.sendRedirect(ctx + "/jsp/auth/login.jsp");
        return;
    }

    String prenom = patient.getPrenom();
    String nom = patient.getNom();
    String initials = (prenom.substring(0, 1) + (nom.isBlank() ? "P" : nom.substring(0, 1))).toUpperCase();

    int nbPlanifies = rdvPlanifies == null ? 0 : rdvPlanifies.size();
    int nbPasses = rdvPasses == null ? 0 : rdvPasses.size();
    int nbDemandes = demandesCertificats == null ? 0 : demandesCertificats.size();
    int nbNotifications = notifications == null ? 0 : notifications.size();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Patient - MediCare Plus</title>

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

        /* Navigation */
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

        /* Dashboard Main */
        .dashboard-main {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
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

        /* Stats Grid */
        .stats-grid {
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

        /* Actions Grid - VERSION CENTREE */
        .actions-grid {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 1.5rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
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
            flex: 0 1 auto;
            min-width: 180px;
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

        /* Notification Widget */
        .notification-widget {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            z-index: 1000;
        }

        .notification-btn {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            color: white;
            font-size: 1.5rem;
            cursor: pointer;
            box-shadow: var(--shadow-lg);
            transition: var(--transition);
            position: relative;
        }

        .notification-btn:hover {
            transform: scale(1.05);
            box-shadow: var(--shadow-xl);
        }

        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: var(--danger);
            color: white;
            border-radius: 50%;
            width: 22px;
            height: 22px;
            font-size: 0.7rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }

        .notification-panel {
            position: absolute;
            bottom: 70px;
            right: 0;
            width: 300px;
            background: white;
            border-radius: 16px;
            box-shadow: var(--shadow-xl);
            overflow: hidden;
            display: none;
        }

        .notification-panel.show {
            display: block;
            animation: fadeInUp 0.3s ease;
        }

        .notification-header {
            padding: 0.75rem 1rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            font-weight: 600;
        }

        .notification-list {
            max-height: 300px;
            overflow-y: auto;
        }

        .notification-list li {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.85rem;
            color: var(--dark);
            list-style: none;
        }

        .notification-list li:last-child {
            border-bottom: none;
        }

        .notification-list li:hover {
            background: var(--light-gray);
        }

        .notification-empty {
            padding: 1.5rem;
            text-align: center;
            color: var(--gray);
            font-size: 0.85rem;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .stats-grid {
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
            .stats-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            .stat-card .value {
                font-size: 2rem;
            }
            .actions-grid {
                gap: 1rem;
            }
            .action-card {
                min-width: 160px;
                padding: 1rem;
            }
            .notification-widget {
                bottom: 1rem;
                right: 1rem;
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
        .hero-panel { animation-delay: 0s; }
    </style>
</head>

<body>

<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="<%= ctx %>/">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </a>

        <div class="nav-links" id="navLinks">
            <a href="<%= ctx %>/patient" class="active">Dashboard</a>
            <a href="<%= ctx %>/patient?action=reservationForm">Prendre RDV</a>
            <a href="<%= ctx %>/patient?action=mesRdv">Mes RDV</a>
            <a href="<%= ctx %>/patient?action=demandeCertificat">Certificats</a>
            <a href="<%= ctx %>/auth/logout" class="btn-logout">
                <i class="fas fa-sign-out-alt"></i> Déconnexion
            </a>
        </div>

        <button class="menu-toggle" id="menuToggle">
            <i class="fas fa-bars"></i>
        </button>
    </div>
</nav>

<main class="dashboard-main">
    <!-- Hero Panel -->
    <div class="hero-panel">
        <h1>
            Bonjour,
            <span class="gradient-text"><%= prenom %> <%= nom %></span>
        </h1>
        <div class="role-badge">
            <i class="fas fa-user-circle"></i> Patient
        </div>
        <div class="avatar"><%= initials %></div>
    </div>

    <!-- Statistics -->
    <div class="stats-grid">
        <div class="stat-card">
            <i class="fas fa-calendar-check"></i>
            <h3>RDV planifiés</h3>
            <div class="value"><%= nbPlanifies %></div>
        </div>
        <div class="stat-card">
            <i class="fas fa-calendar-week"></i>
            <h3>RDV passés</h3>
            <div class="value"><%= nbPasses %></div>
        </div>
        <div class="stat-card">
            <i class="fas fa-file-medical"></i>
            <h3>Certificats</h3>
            <div class="value"><%= nbDemandes %></div>
        </div>
        <div class="stat-card">
            <i class="fas fa-bell"></i>
            <h3>Notifications</h3>
            <div class="value"><%= nbNotifications %></div>
        </div>
    </div>

    <!-- Actions - Version centrée avec 3 éléments -->
    <div class="actions-grid">
        <a class="action-card" href="<%= ctx %>/patient?action=reservationForm">
            <i class="fas fa-calendar-plus"></i>
            <span class="title">Prendre RDV</span>
        </a>
        <a class="action-card" href="<%= ctx %>/patient?action=mesRdv">
            <i class="fas fa-calendar-alt"></i>
            <span class="title">Mes RDV</span>
        </a>
        <a class="action-card" href="<%= ctx %>/patient?action=demandeCertificat">
            <i class="fas fa-file-medical"></i>
            <span class="title">Demander un certificat</span>
        </a>
    </div>
</main>

<!-- Notification Widget -->
<div class="notification-widget">
    <button class="notification-btn" onclick="toggleNotifications()">
        <i class="fas fa-bell"></i>
        <% if (nbNotifications > 0) { %>
        <span class="notification-badge"><%= nbNotifications > 9 ? "9+" : nbNotifications %></span>
        <% } %>
    </button>
    <div class="notification-panel" id="notificationPanel">
        <div class="notification-header">
            <i class="fas fa-bell"></i> Notifications
        </div>
        <ul class="notification-list">
            <% if (notifications != null && !notifications.isEmpty()) {
                for (String n : notifications) { %>
            <li><%= n %></li>
            <% }
            } else { %>
            <li class="notification-empty">Aucune notification</li>
            <% } %>
        </ul>
    </div>
</div>

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

    function toggleNotifications() {
        const panel = document.getElementById('notificationPanel');
        panel.classList.toggle('show');
    }

    // Fermer le panneau en cliquant ailleurs
    document.addEventListener('click', function(event) {
        const widget = document.querySelector('.notification-widget');
        const panel = document.getElementById('notificationPanel');
        if (widget && !widget.contains(event.target) && panel.classList.contains('show')) {
            panel.classList.remove('show');
        }
    });
</script>

</body>
</html>