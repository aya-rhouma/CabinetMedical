<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Dashboard Médecin - MediCare Plus">
    <title>Dashboard Médecin - MediCare Plus</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <!-- AOS Animation Library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /* Styles spécifiques au dashboard */
        .dashboard-main {
            padding: 2rem 5%;
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
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
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 0.5rem;
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

        /* Grid Systems */
        .grid-3 {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .grid-4 {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        /* Stat Cards */
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
            font-size: 1rem;
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

        /* Action Cards */
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
            font-size: 1rem;
            position: relative;
            z-index: 1;
        }

        .action-card:hover .title {
            color: white;
        }

        /* Footer Note */
        .footer-note {
            text-align: center;
            padding: 1rem;
            margin-top: 2rem;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            color: var(--gray);
            font-size: 0.85rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .dashboard-main {
                padding: 1rem;
            }

            .hero-panel h1 {
                font-size: 1.5rem;
            }

            .avatar {
                width: 60px;
                height: 60px;
                font-size: 1.5rem;
            }

            .stat-card .value {
                font-size: 2rem;
            }

            .grid-3, .grid-4 {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
        }

        @media (max-width: 480px) {
            .hero-panel {
                padding: 1.5rem;
            }

            .hero-panel h1 {
                font-size: 1.2rem;
            }

            .stat-card {
                padding: 1rem;
            }
        }

        /* Animations */
        .stat-card, .action-card, .hero-panel {
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
    </style>
</head>

<body>

<%
    User medecin = (User) session.getAttribute("user");
    if (medecin == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }

    String contextPath = request.getContextPath();
    String prenom = medecin.getPrenom();
    String nom = medecin.getNom();
    String initials = prenom.substring(0, 1).toUpperCase() + nom.substring(0, 1).toUpperCase();
%>

<!-- Navigation (identique à index.jsp) -->
<nav class="navbar">
    <div class="nav-container">
        <div class="logo">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/">Accueil</a>
            <a href="#" class="active">Dashboard</a>
            <a href="${pageContext.request.contextPath}/medecin?action=patients">Mes Patients</a>
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

<!-- Main Content -->
<main class="dashboard-main">
    <!-- Hero Panel -->
    <section class="hero-panel" data-aos="fade-up">
        <h1>Bonjour, <span style="background: linear-gradient(135deg, var(--primary), var(--secondary)); -webkit-background-clip: text; background-clip: text; color: transparent;"><%= prenom %> <%= nom %></span></h1>
        <span class="role-badge">
            <i class="fas fa-user-md"></i> Médecin
        </span>
        <div class="avatar"><%= initials %></div>
    </section>

    <!-- Statistiques -->
    <div class="grid-3">
        <div class="stat-card" data-aos="fade-up" data-aos-delay="100">
            <i class="fa-solid fa-users"></i>
            <h3>Patients</h3>
            <div class="value"><%= request.getAttribute("nbPatients") != null ? request.getAttribute("nbPatients") : "0" %></div>
        </div>

        <div class="stat-card" data-aos="fade-up" data-aos-delay="200">
            <i class="fa-solid fa-calendar-check"></i>
            <h3>Rendez-vous</h3>
            <div class="value"><%= request.getAttribute("nbRdv") != null ? request.getAttribute("nbRdv") : "0" %></div>
        </div>

        <div class="stat-card" data-aos="fade-up" data-aos-delay="300">
            <i class="fa-solid fa-file-medical"></i>
            <h3>Certificats</h3>
            <div class="value"><%= request.getAttribute("nbCertificats") != null ? request.getAttribute("nbCertificats") : "0" %></div>
        </div>
    </div>

    <!-- Actions Rapides -->
    <div class="grid-4">
        <a class="action-card" href="${pageContext.request.contextPath}/medecin?action=patients" data-aos="fade-up" data-aos-delay="400">
            <i class="fa-solid fa-users"></i>
            <span class="title">Mes Patients</span>
        </a>
        <a class="action-card" href="${pageContext.request.contextPath}/medecin?action=rdv" data-aos="fade-up" data-aos-delay="500">
            <i class="fa-solid fa-calendar-check"></i>
            <span class="title">Mes Rendez-vous</span>
        </a>
        <a class="action-card" href="${pageContext.request.contextPath}/medecin?action=certificats" data-aos="fade-up" data-aos-delay="600">
            <i class="fa-solid fa-file-medical"></i>
            <span class="title">Certificats</span>
        </a>
        <a class="action-card" href="${pageContext.request.contextPath}/medecin?action=dossiers" data-aos="fade-up" data-aos-delay="700">
            <i class="fa-solid fa-folder-open"></i>
            <span class="title">Dossiers médicaux</span>
        </a>
    </div>

    <!-- Footer Note -->
    <div class="footer-note" data-aos="fade-up" data-aos-delay="800">
        <i class="fas fa-clock"></i> Dernière connexion :
        <%= request.getAttribute("lastLogin") != null ? request.getAttribute("lastLogin") : "Aujourd'hui" %>
    </div>
</main>

<!-- Scripts -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    // Initialize AOS
    AOS.init({
        duration: 1000,
        once: true,
        offset: 100,
        easing: 'ease-in-out'
    });

    // Mobile menu toggle
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

    // Active link highlighting
    const currentPath = window.location.pathname;
    const navItems = document.querySelectorAll('.nav-links a');
    navItems.forEach(item => {
        const href = item.getAttribute('href');
        if (href === '#' || href === 'javascript:void(0)') return;
        if (currentPath.includes(href.replace('${pageContext.request.contextPath}', ''))) {
            item.classList.add('active');
        }
    });
</script>
</body>
</html>