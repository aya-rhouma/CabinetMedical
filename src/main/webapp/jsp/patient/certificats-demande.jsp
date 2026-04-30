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
    String prenom = patient != null ? patient.getPrenom() : "";
    String nom = patient != null ? patient.getNom() : "";
    String initials = (prenom.substring(0, 1) + (nom.isBlank() ? "P" : nom.substring(0, 1))).toUpperCase();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Certificats - MediCare Plus</title>

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

        /* Cards */
        .section-card {
            background: white;
            border-radius: 24px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
            transition: var(--transition);
        }

        .section-card:hover {
            box-shadow: var(--shadow-lg);
        }

        .section-card h2, .section-card h3 {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-card h2 i, .section-card h3 i {
            color: var(--primary);
        }

        /* Form */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
        }

        .form-grid div {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .form-grid label {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--dark);
        }

        .form-grid select {
            padding: 0.75rem;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 0.9rem;
            font-family: inherit;
            transition: var(--transition);
            background: white;
        }

        .form-grid select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        /* Table */
        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table thead {
            background: var(--light-gray);
            border-radius: 12px;
        }

        .data-table th {
            padding: 0.75rem 1rem;
            text-align: left;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .data-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.85rem;
            color: var(--dark);
        }

        .data-table tr:hover {
            background: var(--light-gray);
        }

        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
        }

        .status-badge.approuve, .status-badge.gener {
            background: #d1fae5;
            color: #065f46;
        }

        .status-badge.rejete {
            background: #fee2e2;
            color: #991b1b;
        }

        .status-badge.attente {
            background: #fed7aa;
            color: #9b3412;
        }

        .text-muted {
            color: var(--gray);
            text-align: center;
            padding: 2rem;
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
            .form-grid {
                grid-template-columns: 1fr;
            }
            .hero-panel h1 {
                font-size: 1.3rem;
            }
            .avatar {
                width: 60px;
                height: 60px;
                font-size: 1.5rem;
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

        .hero-panel, .section-card {
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
        }

        .hero-panel { animation-delay: 0s; }
        .section-card:first-of-type { animation-delay: 0.1s; }
        .section-card:last-of-type { animation-delay: 0.2s; }
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
            <a href="<%= contextPath %>/patient?action=mesRdv">Mes RDV</a>
            <a href="<%= contextPath %>/patient?action=demandeCertificat" class="active">Certificats</a>
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
        <h1>
            Bonjour,
            <span class="gradient-text"><%= prenom %> <%= nom %></span>
        </h1>
        <div class="role-badge">
            <i class="fas fa-user-circle"></i> Patient
        </div>
        <div class="avatar"><%= initials %></div>
    </div>

    <!-- Demande Certificat -->
    <div class="section-card">
        <h2>
            <i class="fas fa-file-medical"></i>
            Demander un certificat médical
        </h2>

        <form method="post" action="<%= contextPath %>/patient" class="form-grid">
            <input type="hidden" name="action" value="demanderCertificat"/>

            <div>
                <label>Médecin concerné *</label>
                <select name="medecinId" required>
                    <option value="">-- Choisir un médecin --</option>
                    <% if (medecins != null && !medecins.isEmpty()) {
                        for (Medecin m : medecins) { %>
                    <option value="<%= m.getId() %>">
                        Dr <%= m.getPrenom() %> <%= m.getNom() %> – <%= m.getSpecialite() %>
                    </option>
                    <% }} %>
                </select>
            </div>

            <div>
                <label>Motif de la demande *</label>
                <select name="motif" required>
                    <option value="repos" selected>Certificat de repos</option>
                    <option value="sport">Certificat sportif</option>
                    <option value="scolaire">Certificat scolaire</option>
                    <option value="travail">Certificat de travail</option>
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
    <div class="section-card">
        <h3>
            <i class="fas fa-list"></i>
            Mes certificats
        </h3>

        <table class="data-table">
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
                <td colspan="3" class="text-muted">
                    Aucun certificat demandé
                </td>
            </tr>
            <% } else {
                for (CertificatMedical c : certificatsPatient) {
                    String statut = c.getStatut() == null ? "EN ATTENTE" : c.getStatut();
                    String statusClass = "";
                    if ("GENERE".equals(statut) || "APPROUVE".equals(statut)) {
                        statusClass = "approuve";
                    } else if ("REJETE".equals(statut)) {
                        statusClass = "rejete";
                    } else {
                        statusClass = "attente";
                    }
            %>
            <tr>
                <td>
                    Dr <%= c.getMedecin().getPrenom() %> <%= c.getMedecin().getNom() %>
                </td>
                <td>
                    <%= c.getMotif() %>
                </td>
                <td>
                        <span class="status-badge <%= statusClass %>">
                            <%= statut %>
                        </span>
                </td>
            </tr>
            <% }
            } %>
            </tbody>
        </table>
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