<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.Medecin" %>
<%@ page import="com.jee.entity.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User patient = (User) session.getAttribute("user");
    List<Medecin> medecins = (List<Medecin>) request.getAttribute("medecinsDisponibles");
<<<<<<< Updated upstream
    String contextPath = request.getContextPath();

    if (patient == null) {
        response.sendRedirect(contextPath + "/jsp/auth/login.jsp");
        return;
    }

    String prenom = patient.getPrenom();
    String nom = patient.getNom();
    String initials = (prenom.substring(0, 1) + (nom.isBlank() ? "P" : nom.substring(0, 1))).toUpperCase();
=======
    String ctx = request.getContextPath();
>>>>>>> Stashed changes
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<<<<<<< Updated upstream
    <meta name="description" content="Réserver un rendez-vous médical - MediCare Plus">
    <title>Réserver un RDV - MediCare Plus</title>

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
           DASHBOARD MAIN
           ============================================ */
        .dashboard-main {
            max-width: 1200px;
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

        /* ============================================
           SECTION CARD
           ============================================ */
        .section-card {
            background: white;
            border-radius: 24px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
            transition: var(--transition);
        }

        .section-card:hover {
            box-shadow: var(--shadow-lg);
        }

        .section-card h2 {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--dark);
            border-left: 4px solid var(--primary);
            padding-left: 1rem;
        }

        .section-card h2 i {
            color: var(--primary);
            margin-right: 0.5rem;
        }

        /* ============================================
           FORMULAIRE
           ============================================ */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
            align-items: end;
        }

        .form-grid div {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .form-grid label {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-grid label i {
            margin-right: 0.5rem;
            color: var(--primary);
        }

        .form-grid select,
        .form-grid input {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 0.9rem;
            font-family: 'Inter', sans-serif;
            background: white;
            transition: var(--transition);
        }

        .form-grid select:focus,
        .form-grid input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
        }

        /* ============================================
           BOUTONS
           ============================================ */
        .btn {
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-family: 'Inter', sans-serif;
        }

        .btn-success {
            background: linear-gradient(135deg, var(--secondary), #059669);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        /* ============================================
           ALERTES
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

        .alert-success {
            background: #d1fae5;
            color: var(--secondary);
            border-left: 4px solid var(--secondary);
        }

        .alert i {
            font-size: 1.2rem;
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

            .form-grid {
                grid-template-columns: 1fr;
            }

            .section-card {
                padding: 1.2rem;
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

        .hero-panel, .section-card {
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
        }

        .hero-panel { animation-delay: 0s; }
        .section-card { animation-delay: 0.1s; }
    </style>
=======
    <title>Réserver un RDV - MediCare Plus</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/medecin.css">
>>>>>>> Stashed changes
</head>

<body>
<<<<<<< Updated upstream

<!-- Navigation -->
<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="<%= contextPath %>/">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </a>
        <div class="nav-links">
            <a href="<%= contextPath %>/patient">Dashboard</a>
            <a href="<%= contextPath %>/patient?action=mesRdv">Mes RDV</a>
            <a href="<%= contextPath %>/patient?action=certificats">Certificats</a>
            <a href="<%= contextPath %>/auth/logout" class="btn-login">
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
    <div class="hero-panel" data-aos="fade-up">
        <h1>Bonjour, <span class="gradient-text"><%= prenom %> <%= nom %></span></h1>
        <div class="role-badge">
            <i class="fas fa-user-circle"></i> Patient
        </div>
        <div class="avatar"><%= initials %></div>
    </div>

    <!-- Formulaire de réservation -->
    <div class="section-card" data-aos="fade-up">
        <h2><i class="fas fa-calendar-plus"></i> Réserver un rendez-vous</h2>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i>
            <span><%= request.getAttribute("error") %></span>
        </div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span><%= request.getAttribute("success") %></span>
        </div>
        <% } %>

        <form method="post" action="<%= contextPath %>/patient" class="form-grid">
            <input type="hidden" name="action" value="reserverRdv">

            <div>
                <label><i class="fas fa-user-md"></i> Médecin</label>
                <select name="medecinId" required>
                    <option value="">-- Choisir un médecin --</option>
                    <% if (medecins != null && !medecins.isEmpty()) {
                        for (Medecin m : medecins) { %>
                    <option value="<%= m.getId() %>">
                        Dr <%= m.getPrenom() %> <%= m.getNom() %> - <%= m.getSpecialite() %>
                    </option>
                    <% } } else { %>
                    <option value="" disabled>Aucun médecin disponible</option>
                    <% } %>
                </select>
            </div>

            <div>
                <label><i class="fas fa-calendar-day"></i> Date</label>
                <input type="date" name="dateRdv" required>
            </div>

            <div>
                <label><i class="fas fa-clock"></i> Heure de début</label>
                <input type="time" name="heureDebut" required>
            </div>

            <div>
                <label><i class="fas fa-clock"></i> Heure de fin</label>
                <input type="time" name="heureFin" required>
            </div>

            <div>
                <button class="btn btn-success" type="submit">
                    <i class="fas fa-check"></i> Confirmer la réservation
                </button>
            </div>
        </form>
=======

<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="<%= ctx %>/"><i class="fas fa-heartbeat"></i><span>MediCare Plus</span></a>
        <div class="nav-links">
            <a href="<%= ctx %>/patient">Dashboard</a>
            <a href="<%= ctx %>/patient?action=reservationForm" class="active">Prendre RDV</a>
            <a href="<%= ctx %>/patient?action=mesRdv">Mes RDV</a>
            <a href="<%= ctx %>/patient?action=demandeCertificat">Certificats</a>
            <a href="<%= ctx %>/auth/logout" class="btn-login"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </div>
        <div class="menu-toggle"><i class="fas fa-bars"></i></div>
    </div>
</nav>

<main class="dashboard-main">
    <div class="page-header" data-aos="fade-up">
        <div class="breadcrumb">
            <a href="<%= ctx %>/patient">Dashboard</a>
            <i class="fas fa-chevron-right"></i>
            <span>Réserver un RDV</span>
        </div>
        <h1><i class="fas fa-calendar-plus"></i> Prendre un rendez-vous</h1>
    </div>

    <div class="card" data-aos="fade-up" data-aos-delay="100">
        <div class="card-header">
            <h2><i class="fas fa-calendar-plus"></i> Nouvelle réservation</h2>
        </div>
        <div class="card-body">
            <form method="post" action="<%= ctx %>/patient">
                <input type="hidden" name="action" value="reserverRdv">
                <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:1.2rem;">
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-user-doctor"></i> Médecin *</label>
                        <select name="medecinId" class="form-control" required>
                            <option value="">-- Choisir un médecin --</option>
                            <% if (medecins != null) { for (Medecin m : medecins) { %>
                            <option value="<%= m.getId() %>">
                                Dr <%= m.getPrenom() %> <%= m.getNom() %> — <%= m.getSpecialite() %>
                            </option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-calendar"></i> Date *</label>
                        <input type="date" name="dateRdv" class="form-control" required
                               min="<%= java.time.LocalDate.now().toString() %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-clock"></i> Heure début *</label>
                        <input type="time" name="heureDebut" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-clock"></i> Heure fin *</label>
                        <input type="time" name="heureFin" class="form-control" required>
                    </div>
                </div>
                <div style="display:flex;gap:1rem;margin-top:1rem;">
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-check"></i> Confirmer la réservation
                    </button>
                    <a href="<%= ctx %>/patient" class="btn-action">
                        <i class="fas fa-arrow-left"></i> Annuler
                    </a>
                </div>
            </form>
        </div>
>>>>>>> Stashed changes
    </div>
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

    // Date min = aujourd'hui
    const dateInput = document.querySelector('input[name="dateRdv"]');
    if (dateInput) {
        const today = new Date().toISOString().split('T')[0];
        dateInput.min = today;
    }
</script>
</body>
</html>
=======
    AOS.init({ duration: 800, once: true });
    document.querySelector('.menu-toggle')?.addEventListener('click', () => {
        document.querySelector('.nav-links').classList.toggle('active');
    });
</script>
</body>
</html>
>>>>>>> Stashed changes
