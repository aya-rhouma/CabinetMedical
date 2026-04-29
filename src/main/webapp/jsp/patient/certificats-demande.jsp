<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.Medecin" %>
<%@ page import="com.jee.entity.CertificatMedical" %>
<%@ page import="com.jee.entity.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
<<<<<<< Updated upstream
    User patient = (User) session.getAttribute("user");
    List<Medecin> medecins = (List<Medecin>) request.getAttribute("medecinsDisponibles");
    List<CertificatMedical> certificatsPatient = (List<CertificatMedical>) request.getAttribute("certificatsPatient");

    if (certificatsPatient == null) {
        certificatsPatient = (List<CertificatMedical>) request.getAttribute("demandesCertificats");
    }

    String contextPath = request.getContextPath();

    if (patient == null) {
        response.sendRedirect(contextPath + "/jsp/auth/login.jsp");
        return;
    }

    String prenom = patient.getPrenom();
    String nom = patient.getNom();
    String initials = (prenom.substring(0, 1) + (nom.isBlank() ? "P" : nom.substring(0, 1))).toUpperCase();
=======
    List<Medecin> medecins = (List<Medecin>) request.getAttribute("medecinsDisponibles");
    List<CertificatMedical> certificatsPatient = (List<CertificatMedical>) request.getAttribute("certificatsPatient");
    if (certificatsPatient == null)
        certificatsPatient = (List<CertificatMedical>) request.getAttribute("demandesCertificats");
    String ctx = request.getContextPath();
>>>>>>> Stashed changes
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<<<<<<< Updated upstream
    <meta name="description" content="Demande de certificats médicaux - MediCare Plus">
    <title>Certificats médicaux - MediCare Plus</title>

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
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* ============================================
           SECTION CARD
           ============================================ */
        .section-card {
            background: white;
            border-radius: 24px;
            padding: 1.8rem;
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

        .section-card h3 {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1.2rem;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-card h3 i {
            color: var(--primary);
        }

        /* ============================================
           FORMULAIRE
           ============================================ */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
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

        .form-grid select {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 0.9rem;
            font-family: 'Inter', sans-serif;
            background: white;
            transition: var(--transition);
            cursor: pointer;
        }

        .form-grid select:focus {
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

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        /* ============================================
           TABLEAU
           ============================================ */
        .table-responsive {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead th {
            text-align: left;
            padding: 1rem;
            background: var(--light-gray);
            font-weight: 600;
            color: var(--dark);
            border-bottom: 2px solid var(--border);
        }

        tbody td {
            padding: 1rem;
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

        .muted i {
            margin-right: 0.5rem;
        }

        /* ============================================
           STATUS BADGE
           ============================================ */
        .role-badge {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            color: white;
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

            .form-grid {
                grid-template-columns: 1fr;
            }

            .section-card {
                padding: 1.2rem;
            }

            table {
                font-size: 0.85rem;
            }

            thead th, tbody td {
                padding: 0.5rem;
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

        .section-card {
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
        }

        .section-card:nth-child(1) { animation-delay: 0.1s; }
        .section-card:nth-child(2) { animation-delay: 0.2s; }
    </style>
=======
    <title>Certificats médicaux - MediCare Plus</title>
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
            <a href="#" class="active">Certificats</a>
            <a href="<%= contextPath %>/patient?action=reservationForm">Prendre RDV</a>
            <a href="<%= contextPath %>/patient?action=mesRdv">Mes RDV</a>
            <a href="<%= contextPath %>/auth/logout" class="btn-login">
                <i class="fas fa-sign-out-alt"></i> Déconnexion
            </a>
        </div>
        <div class="menu-toggle">
            <i class="fas fa-bars"></i>
=======
<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="<%= ctx %>/"><i class="fas fa-heartbeat"></i><span>MediCare Plus</span></a>
        <div class="nav-links">
            <a href="<%= ctx %>/patient">Dashboard</a>
            <a href="<%= ctx %>/patient?action=reservationForm">Prendre RDV</a>
            <a href="<%= ctx %>/patient?action=mesRdv">Mes RDV</a>
            <a href="<%= ctx %>/patient?action=demandeCertificat" class="active">Certificats</a>
            <a href="<%= ctx %>/auth/logout" class="btn-login"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
>>>>>>> Stashed changes
        </div>
        <div class="menu-toggle"><i class="fas fa-bars"></i></div>
    </div>
</nav>

<<<<<<< Updated upstream
<!-- Main Content -->
<main class="dashboard-main">
    <!-- Demande de certificat -->
    <div class="section-card" data-aos="fade-up">
        <h2>
            <i class="fas fa-file-medical"></i>
            Demander un certificat médical
        </h2>

        <form method="post" action="<%= contextPath %>/patient" class="form-grid">
            <input type="hidden" name="action" value="demanderCertificat"/>

            <div>
                <label><i class="fas fa-user-md"></i> Médecin concerné</label>
                <select name="medecinId" required>
                    <option value="">-- Choisir un médecin --</option>
                    <% if (medecins != null && !medecins.isEmpty()) {
                        for (Medecin m : medecins) { %>
                    <option value="<%= m.getId() %>">
                        Dr <%= m.getPrenom() %> <%= m.getNom() %> – <%= m.getSpecialite() %>
                    </option>
                    <% }} else { %>
                    <option value="" disabled>Aucun médecin disponible</option>
                    <% } %>
                </select>
            </div>

            <div>
                <label><i class="fas fa-quote-left"></i> Motif de la demande</label>
                <select name="motif" required>
                    <option value="repos" selected>Certificat de repos</option>
                    <option value="sport">Certificat sportif</option>
                    <option value="scolaire">Certificat scolaire</option>
                </select>
            </div>

            <div>
                <button class="btn btn-primary" type="submit">
                    <i class="fas fa-paper-plane"></i>
                    Envoyer la demande
                </button>
            </div>
        </form>
    </div>

    <!-- Liste des certificats -->
    <div class="section-card" data-aos="fade-up">
        <h3>
            <i class="fas fa-list"></i>
            Mes certificats
        </h3>

        <div class="table-responsive">
            <table>
                <thead>
                <tr>
                    <th>Médecin</th>
                    <th>Motif</th>
                    <th>Statut</th>
                </tr>
                </thead>
                <tbody>
                <% if (certificatsPatient == null || certificatsPatient.isEmpty()) { %>
                <tr>
                    <td colspan="3" class="muted">
                        <i class="fas fa-inbox"></i> Aucun certificat demandé
                    </td>
                </tr>
                <% } else {
                    for (CertificatMedical c : certificatsPatient) {
                        String statut = c.getStatut() == null ? "EN ATTENTE" : c.getStatut();
                        String bgColor = "";
                        if ("GENERE".equals(statut) || "APPROUVE".equals(statut)) {
                            bgColor = "var(--secondary)";
                        } else if ("REJETE".equals(statut)) {
                            bgColor = "var(--danger)";
                        } else {
                            bgColor = "var(--warning)";
                        }
                %>
                <tr>
                    <td>
                        <i class="fas fa-user-md" style="color: var(--primary); width: 20px;"></i>
                        Dr <%= c.getMedecin().getPrenom() %> <%= c.getMedecin().getNom() %>
                    </td>
                    <td>
                        <i class="fas fa-file-alt" style="color: var(--primary); width: 20px;"></i>
                        <%= c.getMotif() %>
                    </td>
                    <td>
                            <span class="role-badge" style="background: <%= bgColor %>;">
                                <%= statut %>
                            </span>
                    </td>
                </tr>
                <% }} %>
                </tbody>
            </table>
=======
<main class="dashboard-main">
    <div class="page-header" data-aos="fade-up">
        <div class="breadcrumb">
            <a href="<%= ctx %>/patient">Dashboard</a>
            <i class="fas fa-chevron-right"></i>
            <span>Certificats médicaux</span>
        </div>
        <h1><i class="fas fa-file-medical"></i> Certificats médicaux</h1>
    </div>

    <!-- Formulaire de demande -->
    <div class="card" data-aos="fade-up" data-aos-delay="100">
        <div class="card-header">
            <h2><i class="fas fa-file-circle-plus"></i> Nouvelle demande</h2>
        </div>
        <div class="card-body">
            <form method="post" action="<%= ctx %>/patient">
                <input type="hidden" name="action" value="demanderCertificat">
                <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:1.2rem;">
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-user-doctor"></i> Médecin concerné *</label>
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
                        <label class="form-label"><i class="fas fa-clipboard-list"></i> Motif *</label>
                        <select name="motif" class="form-control" required>
                            <option value="repos">Certificat de repos</option>
                            <option value="sport">Certificat sportif</option>
                            <option value="scolaire">Certificat scolaire</option>
                        </select>
                    </div>
                </div>
                <div style="margin-top:1rem;">
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-paper-plane"></i> Envoyer la demande
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Historique certificats -->
    <div class="card" data-aos="fade-up" data-aos-delay="200">
        <div class="card-header">
            <h2>
                <i class="fas fa-list"></i> Mes certificats
                <span class="badge-count"><%= certificatsPatient != null ? certificatsPatient.size() : 0 %></span>
            </h2>
        </div>
        <div class="card-body">
            <% if (certificatsPatient == null || certificatsPatient.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-file-medical"></i></div>
                <h3>Aucun certificat demandé</h3>
                <p>Faites votre première demande ci-dessus.</p>
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="certificats-table">
                    <thead>
                        <tr><th>Médecin</th><th>Motif</th><th>Statut</th></tr>
                    </thead>
                    <tbody>
                    <% for (CertificatMedical c : certificatsPatient) {
                        String statut = c.getStatut() == null ? "EN ATTENTE" : c.getStatut();
                        String bg = "GENERE".equals(statut) || "APPROUVE".equals(statut) ? "#d1fae5" :
                                    "REJETE".equals(statut) ? "#fee2e2" : "#fef3c7";
                        String fg = "GENERE".equals(statut) || "APPROUVE".equals(statut) ? "#065f46" :
                                    "REJETE".equals(statut) ? "#991b1b" : "#92400e";
                    %>
                    <tr>
                        <td>
                            <div class="patient-info">
                                <div class="patient-avatar"><i class="fas fa-user-doctor"></i></div>
                                <div class="patient-details">
                                    <strong>Dr <%= c.getMedecin().getPrenom() %> <%= c.getMedecin().getNom() %></strong>
                                    <small><%= c.getMedecin().getSpecialite() %></small>
                                </div>
                            </div>
                        </td>
                        <td><%= c.getMotif() %></td>
                        <td>
                            <span style="background:<%= bg %>;color:<%= fg %>;padding:.2rem .7rem;border-radius:50px;font-size:.75rem;font-weight:600;">
                                <%= statut %>
                            </span>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
>>>>>>> Stashed changes
        </div>
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
=======
    AOS.init({ duration: 800, once: true });
    document.querySelector('.menu-toggle')?.addEventListener('click', () => {
        document.querySelector('.nav-links').classList.toggle('active');
    });
>>>>>>> Stashed changes
</script>
</body>
</html>
