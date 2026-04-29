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
    String nom    = patient.getNom();
    String initials = (prenom.substring(0,1) + (nom.isBlank() ? "P" : nom.substring(0,1))).toUpperCase();
    int nbPlanifies = rdvPlanifies  == null ? 0 : rdvPlanifies.size();
    int nbPasses    = rdvPasses     == null ? 0 : rdvPasses.size();
    int nbDemandes  = demandesCertificats == null ? 0 : demandesCertificats.size();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Patient - MediCare Plus</title>
<<<<<<< Updated upstream

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
           DASHBOARD MAIN
           ============================================ */
        .dashboard-main {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* ============================================
           HERO PANEL
           ============================================ */
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
            font-size: 2rem;
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

        /* ============================================
           GRID SYSTEMS
           ============================================ */
        .grid-3 {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .grid-4 {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        /* ============================================
           STAT CARDS
           ============================================ */
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

        /* ============================================
           ACTION CARDS
           ============================================ */
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

        /* ============================================
           CARD
           ============================================ */
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
            background: linear-gradient(135deg, #f8fafc, #ffffff);
            border-bottom: 1px solid var(--border);
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

        .card-body {
            padding: 1.5rem;
        }

        /* ============================================
           ALERT
           ============================================ */
        .alert {
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert-danger {
            background: #fee2e2;
            color: var(--danger);
            border-left: 4px solid var(--danger);
        }

        .alert i {
            font-size: 1.2rem;
        }

        /* ============================================
           NOTIFICATIONS
           ============================================ */
        .empty-state {
            text-align: center;
            padding: 2rem;
        }

        .empty-icon {
            width: 60px;
            height: 60px;
            background: var(--light-gray);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
        }

        .empty-icon i {
            font-size: 1.5rem;
            color: var(--gray);
        }

        .empty-state h3 {
            font-size: 1rem;
            color: var(--dark);
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: var(--gray);
            font-size: 0.85rem;
        }

        .notification-list {
            list-style: none;
        }

        .notification-list li {
            padding: 0.75rem;
            background: var(--light-gray);
            margin-bottom: 0.5rem;
            border-radius: 10px;
            border-left: 3px solid var(--primary);
            transition: var(--transition);
        }

        .notification-list li:hover {
            background: #e2e8f0;
            transform: translateX(5px);
        }

        .notification-list li i {
            margin-right: 0.5rem;
            color: var(--primary);
        }

        .d-none {
            display: none;
        }

        /* ============================================
           RESPONSIVE
           ============================================ */
        @media (max-width: 1024px) {
            .grid-3, .grid-4 {
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

            .grid-3, .grid-4 {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .stat-card .value {
                font-size: 2rem;
            }
        }

        @media (max-width: 480px) {
            .hero-panel {
                padding: 1rem;
            }

            .stat-card {
                padding: 1rem;
            }

            .action-card {
                padding: 1rem;
            }

            .action-card i {
                font-size: 1.5rem;
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

        .stat-card, .action-card, .hero-panel, .card {
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
        }

        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .action-card:nth-child(1) { animation-delay: 0.4s; }
        .action-card:nth-child(2) { animation-delay: 0.5s; }
        .action-card:nth-child(3) { animation-delay: 0.6s; }
        .action-card:nth-child(4) { animation-delay: 0.7s; }
        .hero-panel { animation-delay: 0s; }
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
        <div class="nav-links">
            <a href="<%= contextPath %>/">Accueil</a>
            <a href="#" class="active">Dashboard</a>
            <a href="<%= contextPath %>/patient?action=reservationForm">Prendre RDV</a>
            <a href="<%= contextPath %>/patient?action=mesRdv">Mes RDV</a>
            <a href="<%= contextPath %>/patient?action=demandeCertificat">Certificats</a>
            <a href="<%= contextPath %>/auth/logout" class="btn-login">
                <i class="fas fa-sign-out-alt"></i> Déconnexion
            </a>
        </div>
        <div class="menu-toggle">
            <i class="fas fa-bars"></i>
=======
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/medecin.css">
</head>
<body>

<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="<%= ctx %>/"><i class="fas fa-heartbeat"></i><span>MediCare Plus</span></a>
        <div class="nav-links">
            <a href="<%= ctx %>/patient" class="active">Dashboard</a>
            <a href="<%= ctx %>/patient?action=reservationForm">Prendre RDV</a>
            <a href="<%= ctx %>/patient?action=mesRdv">Mes RDV</a>
            <a href="<%= ctx %>/patient?action=demandeCertificat">Certificats</a>
            <a href="<%= ctx %>/auth/logout" class="btn-login"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
>>>>>>> Stashed changes
        </div>
        <div class="menu-toggle"><i class="fas fa-bars"></i></div>
    </div>
</nav>

<main class="dashboard-main">
<<<<<<< Updated upstream
    <!-- Hero Panel -->
    <div class="hero-panel" data-aos="fade-up">
        <h1>Bonjour, <span class="gradient-text"><%= prenom %> <%= nom %></span></h1>
        <span class="role-badge">
            <i class="fas fa-user-circle"></i> Patient
        </span>
=======

    <% if (request.getAttribute("error") != null) { %>
    <div style="background:#fee2e2;border-left:4px solid #ef4444;padding:1rem 1.5rem;border-radius:12px;margin-bottom:1.5rem;color:#991b1b;">
        <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <section class="hero-panel" data-aos="fade-up">
        <h1>Bonjour, <span class="gradient-text"><%= prenom %> <%= nom %></span></h1>
        <span class="role-badge"><i class="fas fa-user-circle"></i> Patient</span>
>>>>>>> Stashed changes
        <div class="avatar"><%= initials %></div>
    </div>

    <div class="grid-3" data-aos="fade-up" data-aos-delay="100">
        <div class="stat-card">
            <i class="fa-solid fa-calendar-check"></i>
            <h3>RDV planifiés</h3>
            <div class="value"><%= nbPlanifies %></div>
        </div>
        <div class="stat-card">
            <i class="fa-solid fa-clock-rotate-left"></i>
            <h3>RDV passés</h3>
            <div class="value"><%= nbPasses %></div>
        </div>
        <div class="stat-card">
            <i class="fa-solid fa-file-medical"></i>
            <h3>Certificats</h3>
            <div class="value"><%= nbDemandes %></div>
        </div>
    </div>

<<<<<<< Updated upstream
    <!-- Actions Rapides -->
    <div class="grid-4">
        <a class="action-card" href="<%= contextPath %>/patient?action=reservationForm" data-aos="fade-up" data-aos-delay="400">
            <i class="fa-solid fa-calendar-plus"></i>
            <span class="title">Réserver RDV</span>
        </a>
        <a class="action-card" href="<%= contextPath %>/patient?action=mesRdv" data-aos="fade-up" data-aos-delay="500">
=======
    <div class="grid-4" data-aos="fade-up" data-aos-delay="200">
        <a class="action-card" href="<%= ctx %>/patient?action=reservationForm">
            <i class="fa-solid fa-calendar-plus"></i>
            <span class="title">Réserver RDV</span>
        </a>
        <a class="action-card" href="<%= ctx %>/patient?action=mesRdv">
>>>>>>> Stashed changes
            <i class="fa-solid fa-list-check"></i>
            <span class="title">Mes RDV</span>
        </a>
        <a class="action-card" href="#notifications">
            <i class="fa-solid fa-bell"></i>
            <span class="title">Notifications</span>
        </a>
<<<<<<< Updated upstream
        <a class="action-card" href="<%= contextPath %>/patient?action=demandeCertificat" data-aos="fade-up" data-aos-delay="700">
=======
        <a class="action-card" href="<%= ctx %>/patient?action=demandeCertificat">
>>>>>>> Stashed changes
            <i class="fa-solid fa-file-circle-plus"></i>
            <span class="title">Certificats</span>
        </a>
    </div>

<<<<<<< Updated upstream
    <!-- Alert Error -->
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger" data-aos="fade-up">
        <i class="fas fa-exclamation-circle"></i>
        <span><%= request.getAttribute("error") %></span>
    </div>
    <% } %>

    <!-- Section Notifications -->
    <div class="card" id="notifications" data-aos="fade-up">
=======
    <!-- Notifications -->
    <div class="card" id="notifications" data-aos="fade-up" data-aos-delay="300">
>>>>>>> Stashed changes
        <div class="card-header">
            <h2><i class="fas fa-bell"></i> Notifications</h2>
        </div>
        <div class="card-body">
<<<<<<< Updated upstream
            <div id="notification-empty" class="empty-state <%= (notifications != null && !notifications.isEmpty()) ? "d-none" : "" %>">
                <div class="empty-icon"><i class="fas fa-inbox"></i></div>
                <h3>Aucune notification</h3>
                <p>Vous n'avez aucune nouvelle notification.</p>
            </div>
            <ul id="notification-list" class="notification-list <%= (notifications == null || notifications.isEmpty()) ? "d-none" : "" %>">
                <% if (notifications != null) {
                    for (String n : notifications) { %>
                <li>
                    <i class="fas fa-circle"></i> <%= n %>
                </li>
                <% }} %>
            </ul>
        </div>
    </div>
=======
            <div id="notification-empty" style="<%= (notifications == null || notifications.isEmpty()) ? "" : "display:none;" %>">
                <div class="empty-state" style="padding:1.5rem;">
                    <div class="empty-icon"><i class="fas fa-inbox"></i></div>
                    <h3>Aucune nouvelle notification</h3>
                </div>
            </div>
            <ul id="notification-list" style="list-style:none;<%= (notifications == null || notifications.isEmpty()) ? "display:none;" : "" %>">
                <% if (notifications != null) { for (String n : notifications) { %>
                <li style="padding:.75rem;background:#f0f9ff;margin-bottom:.5rem;border-radius:10px;border-left:3px solid var(--primary);">
                    <i class="fas fa-circle" style="font-size:.6rem;color:var(--primary);margin-right:.5rem;"></i> <%= n %>
                </li>
                <% } } %>
            </ul>
        </div>
    </div>

>>>>>>> Stashed changes
</main>

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
<<<<<<< Updated upstream
    AOS.init({ duration: 900, once: true, offset: 80, easing: 'ease-in-out' });

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
=======
    AOS.init({ duration: 800, once: true });
    document.querySelector('.menu-toggle')?.addEventListener('click', () => {
        document.querySelector('.nav-links').classList.toggle('active');
    });
>>>>>>> Stashed changes

    // Notification polling
    (function() {
        const ctx = '<%= ctx %>';
        const list = document.getElementById('notification-list');
        const empty = document.getElementById('notification-empty');

<<<<<<< Updated upstream
        function appendNotifications(items) {
            if (!items || !items.length) return;
            items.forEach((message) => {
                const li = document.createElement('li');
                li.innerHTML = '<i class="fas fa-circle"></i> ' + message;
                list.prepend(li);
            });
            list.classList.remove('d-none');
            if (empty) empty.classList.add('d-none');
        }

        async function pollNotifications() {
            try {
                const response = await fetch(ctx + '/patient?action=notifications', { cache: 'no-store' });
                if (!response.ok) return;
                const data = await response.json();
                appendNotifications(data.notifications || []);
            } catch (e) {}
=======
        async function pollNotifications() {
            try {
                const res = await fetch(ctx + '/patient?action=notifications', { cache: 'no-store' });
                if (!res.ok) return;
                const data = await res.json();
                if (data.notifications && data.notifications.length > 0) {
                    data.notifications.forEach(msg => {
                        const li = document.createElement('li');
                        li.style.cssText = 'padding:.75rem;background:#f0f9ff;margin-bottom:.5rem;border-radius:10px;border-left:3px solid var(--primary);';
                        li.innerHTML = '<i class="fas fa-circle" style="font-size:.6rem;color:var(--primary);margin-right:.5rem;"></i> ' + msg;
                        list.prepend(li);
                    });
                    list.style.display = '';
                    empty.style.display = 'none';
                }
            } catch(e) {}
>>>>>>> Stashed changes
        }
        setInterval(pollNotifications, 8000);
    })();
</script>
</body>
</html>