<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.RendezVous" %>
<%@ page import="com.jee.entity.Medecin" %>
<%@ page import="com.jee.entity.CertificatMedical" %>
<%@ page import="com.jee.entity.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<RendezVous> rdvPlanifies = (List<RendezVous>) request.getAttribute("rdvPlanifies");
    List<RendezVous> rdvPasses = (List<RendezVous>) request.getAttribute("rdvPasses");
    List<String> notifications = (List<String>) request.getAttribute("notifications");
    List<Medecin> medecins = (List<Medecin>) request.getAttribute("medecinsDisponibles");
    List<CertificatMedical> demandesCertificats = (List<CertificatMedical>) request.getAttribute("demandesCertificats");
    String specialite = (String) request.getAttribute("specialite");
    User patient = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();

    // Vérification session
    if (patient == null) {
        response.sendRedirect(contextPath + "/jsp/auth/login.jsp");
        return;
    }

    String prenom = patient.getPrenom();
    String nom = patient.getNom();
    String initials = (prenom.substring(0, 1) + (nom.isBlank() ? "P" : nom.substring(0, 1))).toUpperCase();
    int nbPlanifies = rdvPlanifies == null ? 0 : rdvPlanifies.size();
    int nbPasses = rdvPasses == null ? 0 : rdvPasses.size();
    int nbDemandes = demandesCertificats == null ? 0 : demandesCertificats.size();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Dashboard Patient - MediCare Plus">
    <title>Dashboard Patient - MediCare Plus</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <!-- AOS Animation Library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /* Styles spécifiques au dashboard patient */
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

        .grid-2 {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
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

        /* Section Cards */
        .section-card {
            background: white;
            border-radius: 20px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow);
            transition: var(--transition);
        }

        .section-card:hover {
            box-shadow: var(--shadow-lg);
        }

        .section-card h2 {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 1.2rem;
            color: var(--dark);
            border-left: 4px solid var(--primary);
            padding-left: 1rem;
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

        /* Forms */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1rem;
            align-items: end;
        }

        .form-grid input, .form-grid select {
            width: 100%;
            padding: 0.7rem 1rem;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 0.9rem;
            font-family: 'Inter', sans-serif;
            transition: var(--transition);
        }

        .form-grid input:focus, .form-grid select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
        }

        /* Tables */
        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead th {
            text-align: left;
            padding: 0.75rem;
            background: var(--light-gray);
            font-weight: 600;
            color: var(--dark);
            border-bottom: 2px solid var(--border);
        }

        tbody td {
            padding: 0.75rem;
            border-bottom: 1px solid var(--border);
            color: var(--gray);
        }

        tbody tr:hover {
            background: var(--light-gray);
        }

        .muted {
            text-align: center;
            color: var(--gray);
            padding: 2rem;
        }

        /* Buttons */
        .btn {
            padding: 0.7rem 1.2rem;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.85rem;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-family: 'Inter', sans-serif;
        }

        .btn-success {
            background: linear-gradient(135deg, var(--secondary), #059669);
            color: white;
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--danger), #dc2626);
            color: white;
        }

        .btn-outline {
            background: transparent;
            border: 2px solid var(--primary);
            color: var(--primary);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        /* Alert */
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

        /* Notification List */
        #notification-list {
            list-style: none;
        }

        #notification-list li {
            padding: 0.75rem;
            background: var(--light-gray);
            margin-bottom: 0.5rem;
            border-radius: 10px;
            border-left: 3px solid var(--primary);
        }

        .d-none {
            display: none;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .grid-2 {
                grid-template-columns: 1fr;
            }
        }

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

            .grid-3, .grid-4, .grid-2 {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            table {
                font-size: 0.85rem;
                overflow-x: auto;
                display: block;
            }

            .btn {
                padding: 0.5rem 0.8rem;
                font-size: 0.8rem;
            }
        }

        @media (max-width: 480px) {
            .hero-panel {
                padding: 1.5rem;
            }

            .section-card {
                padding: 1rem;
            }

            .section-card h2 {
                font-size: 1.1rem;
            }
        }

        /* Animations */
        .stat-card, .action-card, .hero-panel, .section-card {
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
            <a href="#reservation">Prendre RDV</a>
            <a href="#rdv-planifies">Mes RDV</a>
            <a href="#certificats">Certificats</a>
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
            <i class="fas fa-user-circle"></i> Patient
        </span>
        <div class="avatar"><%= initials %></div>
    </section>

    <!-- Statistiques -->
    <div class="grid-3">
        <div class="stat-card" data-aos="fade-up" data-aos-delay="100">
            <i class="fa-solid fa-calendar-check"></i>
            <h3>RDV planifiés</h3>
            <div class="value"><%= nbPlanifies %></div>
        </div>
        <div class="stat-card" data-aos="fade-up" data-aos-delay="200">
            <i class="fa-solid fa-clock-rotate-left"></i>
            <h3>RDV passés</h3>
            <div class="value"><%= nbPasses %></div>
        </div>
        <div class="stat-card" data-aos="fade-up" data-aos-delay="300">
            <i class="fa-solid fa-file-medical"></i>
            <h3>Demandes certificats</h3>
            <div class="value"><%= nbDemandes %></div>
        </div>
    </div>

    <!-- Actions Rapides -->
    <div class="grid-4">
        <a class="action-card" href="#reservation" data-aos="fade-up" data-aos-delay="400">
            <i class="fa-solid fa-calendar-plus"></i>
            <span class="title">Réserver RDV</span>
        </a>
        <a class="action-card" href="#rdv-planifies" data-aos="fade-up" data-aos-delay="500">
            <i class="fa-solid fa-list-check"></i>
            <span class="title">Mes RDV</span>
        </a>
        <a class="action-card" href="#notifications" data-aos="fade-up" data-aos-delay="600">
            <i class="fa-solid fa-bell"></i>
            <span class="title">Notifications</span>
        </a>
        <a class="action-card" href="#certificats" data-aos="fade-up" data-aos-delay="700">
            <i class="fa-solid fa-file-circle-plus"></i>
            <span class="title">Certificats</span>
        </a>
    </div>

    <!-- Alert Error -->
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger" data-aos="fade-up">
        <i class="fas fa-exclamation-circle"></i>
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <!-- Section Notifications -->
    <section class="section-card" id="notifications" data-aos="fade-up">
        <h2><i class="fas fa-bell"></i> Notifications en temps réel</h2>
        <div id="notification-empty" class="muted <%= (notifications == null || notifications.isEmpty()) ? "" : "d-none" %>">
            <i class="fas fa-inbox"></i> Aucune nouvelle notification.
        </div>
        <ul id="notification-list" class="<%= (notifications == null || notifications.isEmpty()) ? "d-none" : "" %>">
            <% if (notifications != null) {
                for (String n : notifications) { %>
            <li><i class="fas fa-circle" style="font-size: 0.6rem; color: var(--primary);"></i> <%= n %></li>
            <% }} %>
        </ul>
    </section>

    <!-- Section Réservation -->
    <section class="section-card" id="reservation" data-aos="fade-up">
        <h2><i class="fas fa-calendar-plus"></i> Réserver un rendez-vous</h2>

        <!-- Formulaire de filtre -->
        <form method="get" action="${pageContext.request.contextPath}/patient" class="form-grid">
            <div>
                <input type="text" name="specialite" placeholder="Spécialité" value="<%= specialite != null ? specialite : "" %>">
            </div>
            <div>
                <input type="date" name="dateRdv">
            </div>
            <div>
                <input type="time" name="heureDebut">
            </div>
            <div>
                <input type="time" name="heureFin">
            </div>
            <div>
                <button class="btn btn-outline" type="submit">
                    <i class="fas fa-search"></i> Filtrer
                </button>
            </div>
        </form>

        <hr style="margin: 1rem 0; border-color: var(--border);">

        <!-- Formulaire de réservation -->
        <form method="post" action="${pageContext.request.contextPath}/patient" class="form-grid">
            <input type="hidden" name="action" value="reserverRdv">
            <div>
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
                <input type="date" name="dateRdv" required>
            </div>
            <div>
                <input type="time" name="heureDebut" required>
            </div>
            <div>
                <input type="time" name="heureFin" required>
            </div>
            <div>
                <button class="btn btn-success" type="submit">
                    <i class="fas fa-check"></i> Réserver
                </button>
            </div>
        </form>
    </section>

    <!-- Sections RDV Planifiés et Passés -->
    <div class="grid-2">
        <!-- RDV Planifiés -->
        <section class="section-card" id="rdv-planifies" data-aos="fade-up">
            <h2><i class="fas fa-calendar-check"></i> Rendez-vous planifiés</h2>
            <table>
                <thead>
                <tr>
                    <th>Date</th>
                    <th>Heure</th>
                    <th>Médecin</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% if (rdvPlanifies == null || rdvPlanifies.isEmpty()) { %>
                <tr>
                    <td colspan="4" class="muted">Aucun rendez-vous planifié</td>
                </tr>
                <% } else {
                    for (RendezVous r : rdvPlanifies) { %>
                <tr>
                    <td><%= r.getDateRdv() %></td>
                    <td><%= r.getHeureDebut() %> - <%= r.getHeureFin() %></td>
                    <td><%= r.getMedecin().getPrenom() %> <%= r.getMedecin().getNom() %></td>
                    <td>
                        <form method="post" action="${pageContext.request.contextPath}/patient" style="display:inline;">
                            <input type="hidden" name="action" value="annulerRdv">
                            <input type="hidden" name="rdvId" value="<%= r.getId() %>">
                            <button type="submit" class="btn btn-danger">
                                <i class="fas fa-times"></i> Annuler
                            </button>
                        </form>
                        <a class="btn btn-outline" href="${pageContext.request.contextPath}/patient?action=calendar&rdvId=<%= r.getId() %>">
                            <i class="fas fa-calendar-alt"></i> Calendrier
                        </a>
                    </td>
                </tr>
                <% }} %>
                </tbody>
            </table>
        </section>

        <!-- RDV Passés -->
        <section class="section-card" data-aos="fade-up">
            <h2><i class="fas fa-history"></i> Rendez-vous passés</h2>
            <table>
                <thead>
                <tr>
                    <th>Date</th>
                    <th>Heure</th>
                    <th>Médecin</th>
                </tr>
                </thead>
                <tbody>
                <% if (rdvPasses == null || rdvPasses.isEmpty()) { %>
                <tr>
                    <td colspan="3" class="muted">Aucun rendez-vous passé</td>
                </tr>
                <% } else {
                    for (RendezVous r : rdvPasses) { %>
                <tr>
                    <td><%= r.getDateRdv() %></td>
                    <td><%= r.getHeureDebut() %> - <%= r.getHeureFin() %></td>
                    <td><%= r.getMedecin().getPrenom() %> <%= r.getMedecin().getNom() %></td>
                </tr>
                <% }} %>
                </tbody>
            </table>
        </section>
    </div>

    <!-- Section Certificats -->
    <section class="section-card" id="certificats" data-aos="fade-up">
        <h2><i class="fas fa-file-medical"></i> Demandes de certificats</h2>

        <form method="post" action="${pageContext.request.contextPath}/patient" class="form-grid">
            <input type="hidden" name="action" value="demanderCertificat">
            <div>
                <select name="medecinId" required>
                    <option value="">Médecin concerné</option>
                    <% if (medecins != null) {
                        for (Medecin m : medecins) { %>
                    <option value="<%= m.getId() %>">
                        <%= m.getPrenom() %> <%= m.getNom() %> - <%= m.getSpecialite() %>
                    </option>
                    <% }} %>
                </select>
            </div>
            <div>
                <input type="text" name="motif" placeholder="Motif de la demande" required>
            </div>
            <div>
                <button class="btn btn-primary" type="submit">
                    <i class="fas fa-paper-plane"></i> Envoyer
                </button>
            </div>
        </form>

        <hr style="margin: 1.5rem 0; border-color: var(--border);">

        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Médecin</th>
                <th>Motif</th>
                <th>Statut</th>
            </tr>
            </thead>
            <tbody>
            <% if (demandesCertificats == null || demandesCertificats.isEmpty()) { %>
            <tr>
                <td colspan="4" class="muted">Aucune demande</td>
            </tr>
            <% } else {
                for (CertificatMedical c : demandesCertificats) { %>
            <tr>
                <td><%= c.getId() %></td>
                <td><%= c.getMedecin().getPrenom() %> <%= c.getMedecin().getNom() %></td>
                <td><%= c.getMotif() %></td>
                <td>
                        <span class="role-badge" style="background:
                            <%= c.getStatut().equals("APPROUVE") ? "var(--secondary)" :
                               c.getStatut().equals("REJETE") ? "var(--danger)" : "var(--warning)" %>;">
                            <%= c.getStatut() %>
                        </span>
                </td>
            </tr>
            <% }} %>
            </tbody>
        </table>
    </section>
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
        if (href === '#') return;
        if (href && currentPath.includes(href.replace('${pageContext.request.contextPath}', ''))) {
            item.classList.add('active');
        }
    });

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;

            const target = document.querySelector(targetId);
            if (target) {
                e.preventDefault();
                if (navLinks.classList.contains('active')) {
                    navLinks.classList.remove('active');
                    const icon = menuToggle.querySelector('i');
                    icon.classList.remove('fa-times');
                    icon.classList.add('fa-bars');
                }
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Notification polling
    (function() {
        const ctx = '<%= contextPath %>';
        const list = document.getElementById('notification-list');
        const empty = document.getElementById('notification-empty');

        function appendNotifications(items) {
            if (!items || !items.length) return;
            items.forEach((message) => {
                const li = document.createElement('li');
                li.innerHTML = '<i class="fas fa-circle" style="font-size: 0.6rem; color: var(--primary);"></i> ' + message;
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
            } catch (e) {
                // ignore
            }
        }

        setInterval(pollNotifications, 8000);
    })();
</script>
</body>
</html>