<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.Medecin" %>
<%@ page import="com.jee.entity.CertificatMedical" %>
<%@ page import="com.jee.entity.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
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
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
        </div>
    </div>
</nav>

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
        </div>
    </div>
</main>

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
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
</script>
</body>
</html>