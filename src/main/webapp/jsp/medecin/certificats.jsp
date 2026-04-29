<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.jee.entity.CertificatMedical" %>
<%@ page import="com.jee.entity.Patient" %>
<%@ page import="com.jee.entity.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User medecin = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();

    if (medecin == null || medecin.getRole() != User.Role.MEDECIN) {
        response.sendRedirect(contextPath + "/jsp/auth/login.jsp");
        return;
    }

    List<CertificatMedical> certificats = (List<CertificatMedical>) request.getAttribute("certificats");
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    Object selectedPatientId = request.getAttribute("selectedPatientId");

    String prenomMedecin = medecin.getPrenom();
    String nomMedecin = medecin.getNom();
    String nomCompletMedecin = prenomMedecin + " " + nomMedecin;

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    String dateAujourdHui = LocalDate.now().format(formatter);

    String initials = (prenomMedecin.substring(0, 1) + nomMedecin.substring(0, 1)).toUpperCase();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des certificats - MediCare Plus</title>

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
           CONTAINER
           ============================================ */
        .certificats-container {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* ============================================
           CARD
           ============================================ */
        .card {
            background: white;
            border-radius: 20px;
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 2rem;
            transition: var(--transition);
        }

        .card:hover {
            box-shadow: var(--shadow-lg);
        }

        .card-header {
            padding: 1.25rem 1.5rem;
            background: linear-gradient(135deg, #f8fafc, #ffffff);
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .card-header h2 {
            font-size: 1.3rem;
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

        .badge-count {
            display: inline-block;
            padding: 0.2rem 0.6rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
        }

        /* ============================================
           FILTER BAR
           ============================================ */
        .filter-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            align-items: flex-end;
        }

        .filter-group {
            flex: 1;
            min-width: 200px;
        }

        .filter-group label {
            display: block;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--gray);
            margin-bottom: 0.5rem;
            text-transform: uppercase;
        }

        .filter-group select {
            width: 100%;
            padding: 0.7rem 1rem;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 0.9rem;
            background: white;
            cursor: pointer;
        }

        .filter-group select:focus {
            outline: none;
            border-color: var(--primary);
        }

        .btn-filter {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 0.7rem 1.5rem;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-filter:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .btn-reset {
            background: var(--gray);
            margin-left: 0.5rem;
        }

        .btn-reset:hover {
            background: #475569;
        }

        /* ============================================
           TABLE
           ============================================ */
        .table-responsive {
            overflow-x: auto;
        }

        .certificats-table {
            width: 100%;
            border-collapse: collapse;
        }

        .certificats-table thead th {
            text-align: left;
            padding: 1rem;
            background: var(--light-gray);
            font-weight: 600;
            color: var(--dark);
            border-bottom: 2px solid var(--border);
        }

        .certificats-table tbody td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
            color: var(--gray);
            vertical-align: top;
        }

        .certificats-table tbody tr:hover {
            background: var(--light-gray);
        }

        .id-badge {
            display: inline-block;
            padding: 0.2rem 0.5rem;
            background: var(--light-gray);
            color: var(--primary);
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.85rem;
        }

        /* ============================================
           PATIENT INFO
           ============================================ */
        .patient-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .patient-avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
        }

        .patient-details {
            display: flex;
            flex-direction: column;
        }

        .patient-details strong {
            color: var(--dark);
            font-size: 0.9rem;
        }

        .patient-details small {
            color: var(--gray);
            font-size: 0.7rem;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        /* ============================================
           MOTIF PREVIEW
           ============================================ */
        .motif-preview {
            background: var(--light-gray);
            padding: 0.5rem;
            border-radius: 8px;
            font-size: 0.8rem;
            color: var(--gray);
            line-height: 1.4;
        }

        .motif-preview i {
            color: var(--primary);
            margin-right: 0.25rem;
        }

        /* ============================================
           FORM
           ============================================ */
        .form-certificat {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .form-row {
            margin-bottom: 0.5rem;
        }

        .form-field {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-field label {
            font-size: 0.75rem;
            font-weight: 500;
            color: var(--gray);
        }

        .form-field .form-control {
            width: 80px;
            text-align: center;
            padding: 0.3rem;
            border: 2px solid var(--border);
            border-radius: 8px;
        }

        .form-control {
            width: 100%;
            padding: 0.6rem 0.8rem;
            border: 2px solid var(--border);
            border-radius: 10px;
            font-size: 0.8rem;
            font-family: 'Inter', sans-serif;
            resize: vertical;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
        }

        /* ============================================
           TEMPLATE BUTTONS
           ============================================ */
        .template-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .template-btn {
            padding: 0.3rem 0.6rem;
            background: var(--light-gray);
            border: none;
            border-radius: 6px;
            font-size: 0.7rem;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
        }

        .template-btn:hover {
            background: var(--primary);
            color: white;
        }

        /* ============================================
           GENERATE BUTTON
           ============================================ */
        .btn-generate {
            width: 100%;
            padding: 0.5rem;
            background: linear-gradient(135deg, var(--secondary), #059669);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.8rem;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-generate:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        /* ============================================
           EMPTY STATE
           ============================================ */
        .empty-state {
            text-align: center;
            padding: 3rem;
        }

        .empty-icon {
            width: 80px;
            height: 80px;
            background: var(--light-gray);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
        }

        .empty-icon i {
            font-size: 2.5rem;
            color: var(--gray);
        }

        .empty-state h3 {
            font-size: 1.2rem;
            color: var(--dark);
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: var(--gray);
            margin-bottom: 1.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
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

            .certificats-container {
                padding: 1rem;
                margin: 1rem auto;
            }

            .filter-bar {
                flex-direction: column;
            }

            .filter-group {
                width: 100%;
            }

            .btn-filter, .btn-reset {
                width: 100%;
                margin: 0.25rem 0;
            }

            .btn-reset {
                margin-left: 0;
            }

            .patient-info {
                flex-direction: column;
                text-align: center;
            }

            .patient-details small {
                justify-content: center;
            }

            .template-buttons {
                flex-direction: column;
            }

            .template-btn {
                width: 100%;
                justify-content: center;
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

        .card {
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
        }

        .card:nth-child(1) { animation-delay: 0.1s; }
        .card:nth-child(2) { animation-delay: 0.2s; }
    </style>
</head>
<body>

<!-- Navigation -->
<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="${pageContext.request.contextPath}/medecin">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/medecin">Dashboard</a>
            <a href="#" class="active">Certificats</a>
            <a href="${pageContext.request.contextPath}/medecin?action=patients">Patients</a>
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

<!-- Main Container -->
<div class="certificats-container">
    <!-- Filter Card -->
    <div class="card" data-aos="fade-up" data-aos-delay="100">
        <div class="card-header">
            <h2><i class="fas fa-filter"></i> Filtrer les demandes</h2>
        </div>
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/medecin" class="filter-bar">
                <input type="hidden" name="action" value="certificats"/>
                <div class="filter-group">
                    <label><i class="fas fa-user"></i> Patient</label>
                    <select name="patientId">
                        <option value="">🔍 Toutes les demandes</option>
                        <% if (patients != null && !patients.isEmpty()) {
                            for (Patient p : patients) { %>
                        <option value="<%=p.getId()%>" <%= (selectedPatientId != null && selectedPatientId.toString().equals(String.valueOf(p.getId()))) ? "selected" : "" %>>
                            👤 <%= p.getPrenom() %> <%= p.getNom() %> - <%= p.getEmail() %>
                        </option>
                        <% }
                        } else { %>
                        <option value="" disabled>Aucun patient disponible</option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <button class="btn-filter" type="submit">
                        <i class="fas fa-search"></i> Appliquer le filtre
                    </button>
                    <a href="${pageContext.request.contextPath}/medecin?action=certificats" class="btn-filter btn-reset">
                        <i class="fas fa-undo"></i> Réinitialiser
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Certificats Table Card -->
    <div class="card" data-aos="fade-up" data-aos-delay="200">
        <div class="card-header">
            <h2><i class="fas fa-list"></i> Demandes en attente</h2>
            <% if (certificats != null && !certificats.isEmpty()) { %>
            <span class="badge-count"><%= certificats.size() %> demande(s)</span>
            <% } %>
        </div>
        <div class="card-body">
            <% if (certificats == null || certificats.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-file-medical"></i>
                </div>
                <h3>Aucune demande de certificat</h3>
                <p>Il n'y a actuellement aucune demande de certificat médical en attente.</p>
                <a href="${pageContext.request.contextPath}/medecin" class="btn-primary">
                    <i class="fas fa-arrow-left"></i> Retour au dashboard
                </a>
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="certificats-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Patient</th>
                        <th>Motif</th>
                        <th>Action</th>
                    </thead>
                    </thead>
                    <tbody>
                    <% for (CertificatMedical c : certificats) {
                        String nomPatient = c.getPatient().getPrenom() + " " + c.getPatient().getNom();
                    %>
                    <tr>
                        <td data-label="ID">
                            <span class="id-badge">#<%= c.getId() %></span>
                            </thead>
                        <td data-label="Patient">
                            <div class="patient-info">
                                <div class="patient-avatar">
                                    <i class="fas fa-user-circle"></i>
                                </div>
                                <div class="patient-details">
                                    <strong><%= nomPatient %></strong>
                                    <small><i class="fas fa-envelope"></i> <%= c.getPatient().getEmail() %></small>
                                    <small><i class="fas fa-phone"></i> <%= c.getPatient().getTelephone() %></small>
                                </div>
                            </div>
                            </thead>
                        <td data-label="Motif">
                            <div class="motif-preview">
                                <i class="fas fa-quote-left"></i>
                                <%= c.getMotif().length() > 100 ? c.getMotif().substring(0, 100) + "..." : c.getMotif() %>
                            </div>
                            </thead>
                        <td data-label="Action">
                            <form method="post" action="${pageContext.request.contextPath}/medecin" class="form-certificat">
                                <input type="hidden" name="action" value="genererCertificat"/>
                                <input type="hidden" name="certificatId" value="<%= c.getId() %>"/>
                                <input type="hidden" class="medecinNom" value="<%= nomCompletMedecin %>"/>
                                <input type="hidden" class="patientNom" value="<%= nomPatient %>"/>
                                <input type="hidden" class="dateJour" value="<%= dateAujourdHui %>"/>

                                <div class="form-row">
                                    <div class="form-field">
                                        <label><i class="fas fa-calendar-day"></i> Jours de repos</label>
                                        <input type="number" name="nbJours" value="1" min="1" max="90" class="form-control">
                                    </div>
                                </div>

                                <textarea name="contenuTemplate" class="contenuTemplate form-control" rows="3" placeholder="Sélectionnez un template ci-dessous..."></textarea>

                                <div class="template-buttons">
                                    <button type="button" class="template-btn" onclick="applyTemplate(this, 'repos')">
                                        <i class="fas fa-bed"></i> Repos
                                    </button>
                                    <button type="button" class="template-btn" onclick="applyTemplate(this, 'sport')">
                                        <i class="fas fa-futbol"></i> Sport
                                    </button>
                                    <button type="button" class="template-btn" onclick="applyTemplate(this, 'scolaire')">
                                        <i class="fas fa-graduation-cap"></i> Scolaire
                                    </button>
                                </div>

                                <button type="submit" class="btn-generate">
                                    <i class="fas fa-file-pdf"></i> Générer le certificat
                                </button>
                            </form>
                            </thead>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({ duration: 900, once: true, offset: 80, easing: 'ease-in-out' });

    const menuToggle = document.querySelector('.menu-toggle');
    const navLinks = document.querySelector('.nav-links');
    if (menuToggle) {
        menuToggle.addEventListener('click', () => {
            navLinks.classList.toggle('active');
            const icon = menuToggle.querySelector('i');
            icon.classList.toggle('fa-bars');
            icon.classList.toggle('fa-times');
        });
    }

    // Templates
    const templates = {
        repos: `Certificat médical d'arrêt de travail

Je soussigné Dr. [NOM], certifie avoir examiné [PATIENT] le [DATE].

Je prescrit un arrêt de travail de [NOMBRE] jours.

Fait à Tunis, le [DATE]`,

        sport: `Certificat médical d'aptitude sportive

Je soussigné Dr. [NOM], certifie avoir examiné [PATIENT] le [DATE].

Absence de contre-indication à la pratique sportive.

Fait à Tunis, le [DATE]`,

        scolaire: `Certificat médical scolaire

Je soussigné Dr. [NOM], certifie avoir examiné [PATIENT] le [DATE].

État de santé compatible avec la scolarité.

Fait à Tunis, le [DATE]`
    };

    function applyTemplate(button, type) {
        const form = button.closest("form");
        if (!form) return;

        const medecin = form.querySelector(".medecinNom")?.value || "";
        const patient = form.querySelector(".patientNom")?.value || "";
        const date = form.querySelector(".dateJour")?.value || "";
        const days = form.querySelector("input[name='nbJours']")?.value || "1";

        let text = templates[type];
        text = text.replace(/\[NOM\]/g, medecin);
        text = text.replace(/\[PATIENT\]/g, patient);
        text = text.replace(/\[DATE\]/g, date);
        text = text.replace(/\[NOMBRE\]/g, days);

        const textarea = form.querySelector(".contenuTemplate");
        if (textarea) {
            textarea.value = text;
            textarea.style.backgroundColor = "#e0f2fe";
            setTimeout(() => textarea.style.backgroundColor = "", 500);
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        const firstForm = document.querySelector('.form-certificat');
        if (firstForm) {
            const firstBtn = firstForm.querySelector('.template-btn');
            if (firstBtn) firstBtn.click();
        }
    });
</script>
</body>
</html>