<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.DossierMedical" %>
<%@ page import="com.jee.entity.Patient" %>
<%@ page import="com.jee.entity.User" %>
<%@ page import="com.jee.entity.Prescription" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Integer patientId = (Integer) request.getAttribute("patientId");
    Patient patient = (Patient) request.getAttribute("patient");
    User medecin = (User) session.getAttribute("user");
    DossierMedical dossier = (DossierMedical) request.getAttribute("dossier");
    List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    String prescriptionTemplate = (String) request.getAttribute("templateOrdonnance");
    if (patientId != null) {
        if (prescriptionTemplate == null || prescriptionTemplate.isBlank()) {
            prescriptionTemplate = "=== ORDONNANCE MÉDICALE ===\n\n" +
                    "Date : {{DATE}}\n" +
                    "Patient : {{PATIENT}}\n" +
                    "Médecin : {{MEDECIN}}\n\n" +
                    "Médicaments prescrits :\n" +
                    "1. \n" +
                    "2. \n" +
                    "3. \n\n" +
                    "Posologie : \n\n" +
                    "Durée du traitement : \n\n" +
                    "Signature du médecin";
        }
        prescriptionTemplate = prescriptionTemplate
                .replace("{{DATE}}", java.time.LocalDate.now().toString())
                .replace("{{PATIENT}}", patient != null ? patient.getPrenom() + " " + patient.getNom() : "Patient")
                .replace("{{MEDECIN}}", medecin != null ? medecin.getPrenom() + " " + medecin.getNom() : "Dr");
    }

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fiche médicale - <%= patient != null ? patient.getPrenom() + " " + patient.getNom() : "Patient" %> - MediCare Plus</title>

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
        .dossier-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* ============================================
           BREADCRUMB
           ============================================ */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.85rem;
            margin-bottom: 1rem;
        }

        .breadcrumb a {
            color: white;
            text-decoration: none;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        .page-header h1 {
            font-size: 2rem;
            font-weight: 700;
            color: white;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
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
           PATIENT CARD
           ============================================ */
        .patient-card {
            background: white;
            border-radius: 20px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
            display: flex;
            align-items: center;
            gap: 1.5rem;
            flex-wrap: wrap;
        }

        .patient-avatar-large {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
        }

        .patient-info-large h2 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 0.25rem;
        }

        .patient-info-large p {
            color: var(--gray);
            margin: 0.25rem 0;
        }

        .patient-info-large i {
            margin-right: 0.5rem;
            color: var(--primary);
        }

        /* ============================================
           TABLE
           ============================================ */
        .table-responsive {
            overflow-x: auto;
        }

        .certificats-table, .prescriptions-table {
            width: 100%;
            border-collapse: collapse;
        }

        .certificats-table thead th, .prescriptions-table thead th {
            text-align: left;
            padding: 1rem;
            background: var(--light-gray);
            font-weight: 600;
            color: var(--dark);
            border-bottom: 2px solid var(--border);
        }

        .certificats-table tbody td, .prescriptions-table tbody td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
            color: var(--gray);
            vertical-align: top;
        }

        .certificats-table tbody tr:hover, .prescriptions-table tbody tr:hover {
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

        .prescription-date {
            font-weight: 600;
            color: var(--primary);
            white-space: nowrap;
        }

        .prescription-content {
            white-space: pre-wrap;
            font-size: 0.85rem;
            line-height: 1.5;
            background: var(--light-gray);
            padding: 0.75rem;
            border-radius: 8px;
            margin: 0;
            font-family: monospace;
        }

        /* ============================================
           PATIENT INFO (petit)
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
            font-size: 1rem;
        }

        .patient-details {
            display: flex;
            flex-direction: column;
        }

        .patient-details strong {
            color: var(--dark);
            font-size: 0.9rem;
        }

        /* ============================================
           FORMULAIRE
           ============================================ */
        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-label {
            display: block;
            font-weight: 600;
            font-size: 0.85rem;
            color: var(--dark);
            margin-bottom: 0.5rem;
        }

        .form-label i {
            color: var(--primary);
            margin-right: 0.5rem;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 0.9rem;
            font-family: 'Inter', sans-serif;
            transition: var(--transition);
            resize: vertical;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
        }

        textarea.form-control {
            min-height: 100px;
        }

        .template-preview {
            background: var(--light-gray);
            border-radius: 12px;
            padding: 0.75rem;
            margin-top: 0.5rem;
            font-size: 0.8rem;
            color: var(--gray);
            border-left: 3px solid var(--primary);
        }

        .template-preview i {
            color: var(--primary);
            margin-right: 0.5rem;
        }

        /* ============================================
           BOUTONS
           ============================================ */
        .btn-group {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }

        .btn-action {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.6rem 1.2rem;
            background: white;
            color: var(--gray);
            text-decoration: none;
            border-radius: 12px;
            font-weight: 500;
            font-size: 0.85rem;
            transition: var(--transition);
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .btn-back:hover {
            background: var(--primary);
            color: white;
        }

        .btn-certificat:hover {
            background: var(--warning);
            color: white;
        }

        .btn-filter {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.8rem;
        }

        .btn-filter:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .btn-success {
            background: linear-gradient(135deg, var(--secondary), #059669);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-success:hover {
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

            .dossier-container {
                padding: 1rem;
                margin: 1rem auto;
            }

            .patient-card {
                flex-direction: column;
                text-align: center;
            }

            .patient-info-large p {
                text-align: center;
            }

            .btn-group {
                flex-direction: column;
            }

            .btn-action {
                justify-content: center;
            }

            .page-header h1 {
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

        .card, .patient-card {
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
        }

        .card:nth-child(1) { animation-delay: 0.1s; }
        .card:nth-child(2) { animation-delay: 0.15s; }
        .card:nth-child(3) { animation-delay: 0.2s; }
        .patient-card { animation-delay: 0.05s; }
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
            <a href="${pageContext.request.contextPath}/medecin?action=certificats">Certificats</a>
            <a href="${pageContext.request.contextPath}/medecin?action=patients" class="active">Patients</a>
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
<div class="dossier-container">
    <% if (patientId == null) { %>
    <!-- Liste des patients -->
    <div class="card" data-aos="fade-up" data-aos-delay="100">
        <div class="card-header">
            <h2><i class="fas fa-list"></i> Liste des patients</h2>
            <% if (patients != null && !patients.isEmpty()) { %>
            <span class="badge-count"><%= patients.size() %> patient(s)</span>
            <% } %>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="certificats-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Patient</th>
                        <th>Email</th>
                        <th>Téléphone</th>
                        <th>Actions</th>
                    </thead>
                    </thead>
                    <tbody>
                    <% if (patients == null || patients.isEmpty()) { %>
                    <tr>
                        <td colspan="5">
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-users-slash"></i>
                                </div>
                                <h3>Aucun patient</h3>
                                <p>Vous n'avez pas encore de patients</p>
                                <a href="${pageContext.request.contextPath}/medecin" class="btn-primary">
                                    <i class="fas fa-arrow-left"></i> Retour au dashboard
                                </a>
                            </div>
                            </thead>
                            </thead>
                                <% } else {
                            for (Patient p : patients) {
                                String initials = p.getPrenom().substring(0, 1).toUpperCase() +
                                                 p.getNom().substring(0, 1).toUpperCase();
                        %>
                    <tr>
                        <td data-label="ID">
                            <span class="id-badge">#<%= p.getId() %></span>
                            </thead>
                        <td data-label="Patient">
                            <div class="patient-info">
                                <div class="patient-avatar">
                                    <%= initials %>
                                </div>
                                <div class="patient-details">
                                    <strong><%= p.getPrenom() %> <%= p.getNom() %></strong>
                                </div>
                            </div>
                            </thead>
                        <td data-label="Email">
                            <i class="fas fa-envelope" style="color: var(--primary);"></i> <%= p.getEmail() %>
                            </thead>
                        <td data-label="Téléphone">
                            <i class="fas fa-phone" style="color: var(--primary);"></i> <%= p.getTelephone() %>
                            </thead>
                        <td data-label="Actions">
                            <a href="${pageContext.request.contextPath}/medecin?action=dossier&patientId=<%= p.getId() %>"
                               class="btn-filter">
                                <i class="fas fa-folder-open"></i> Ouvrir dossier
                            </a>
                            </thead>
                    </tr>
                    <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <% } else { %>
    <!-- Fiche médicale d'un patient spécifique -->
    <div class="page-header" data-aos="fade-up">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/medecin"><i class="fas fa-home"></i> Dashboard</a>
            <i class="fas fa-chevron-right"></i>
            <a href="${pageContext.request.contextPath}/medecin?action=patients">Patients</a>
            <i class="fas fa-chevron-right"></i>
            <span>Fiche médicale</span>
        </div>
        <h1><i class="fas fa-notes-medical"></i> Fiche médicale</h1>
    </div>

    <!-- Patient Info Card -->
    <div class="patient-card" data-aos="fade-up" data-aos-delay="50">
        <div class="patient-avatar-large">
            <i class="fas fa-user-circle"></i>
        </div>
        <div class="patient-info-large">
            <h2><%= patient != null ? patient.getPrenom() + " " + patient.getNom() : "Patient #" + patientId %></h2>
            <p><i class="fas fa-envelope"></i> <%= patient != null ? patient.getEmail() : "Email non disponible" %></p>
            <p><i class="fas fa-phone"></i> <%= patient != null ? patient.getTelephone() : "Téléphone non disponible" %></p>
            <p><i class="fas fa-id-card"></i> ID Patient : <%= patientId %></p>
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="btn-group" data-aos="fade-up" data-aos-delay="100">
        <a href="${pageContext.request.contextPath}/medecin?action=patients" class="btn-action btn-back">
            <i class="fas fa-arrow-left"></i> Retour à la liste
        </a>
        <a href="${pageContext.request.contextPath}/medecin?action=certificats&patientId=<%=patientId%>" class="btn-action btn-certificat">
            <i class="fas fa-file-medical"></i> Certificats
        </a>
    </div>

    <!-- Diagnostic & Notes Section -->
    <div class="card" data-aos="fade-up" data-aos-delay="150">
        <div class="card-header">
            <i class="fas fa-stethoscope"></i>
            <h2>Diagnostic et notes médicales</h2>
        </div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/medecin">
                <input type="hidden" name="action" value="saveDossier"/>
                <input type="hidden" name="patientId" value="<%=patientId%>"/>

                <div class="form-group">
                    <label class="form-label"><i class="fas fa-diagnoses"></i> Diagnostic</label>
                    <textarea class="form-control" name="diagnostic" rows="4" placeholder="Saisissez le diagnostic du patient..."><%= dossier != null && dossier.getDiagnostic() != null ? dossier.getDiagnostic() : "" %></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label"><i class="fas fa-pencil-alt"></i> Notes médicales</label>
                    <textarea class="form-control" name="notes" rows="5" placeholder="Observations, antécédents, examens complémentaires..."><%= dossier != null && dossier.getNotes() != null ? dossier.getNotes() : "" %></textarea>
                </div>

                <div style="display: flex; justify-content: flex-end;">
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-save"></i> Enregistrer
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Nouvelle Prescription Section -->
    <div class="card" data-aos="fade-up" data-aos-delay="200">
        <div class="card-header">
            <i class="fas fa-prescription-bottle"></i>
            <h2>Nouvelle prescription</h2>
        </div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/medecin">
                <input type="hidden" name="action" value="addPrescription"/>
                <input type="hidden" name="patientId" value="<%=patientId%>"/>

                <div class="form-group">
                    <label class="form-label"><i class="fas fa-file-alt"></i> Ordonnance</label>
                    <textarea class="form-control" name="contenu" rows="10"><%=prescriptionTemplate%></textarea>
                    <div class="template-preview">
                        <i class="fas fa-info-circle"></i> Variables disponibles : <strong>{{DATE}}</strong>, <strong>{{PATIENT}}</strong>, <strong>{{MEDECIN}}</strong>
                    </div>
                </div>

                <div style="display: flex; justify-content: flex-end;">
                    <button type="submit" class="btn-success">
                        <i class="fas fa-plus-circle"></i> Ajouter prescription
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Historique Prescriptions Section -->
    <div class="card" data-aos="fade-up" data-aos-delay="250">
        <div class="card-header">
            <i class="fas fa-history"></i>
            <h2>Historique des prescriptions</h2>
            <% if (prescriptions != null && !prescriptions.isEmpty()) { %>
            <span class="badge-count"><%= prescriptions.size() %></span>
            <% } %>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="prescriptions-table">
                    <thead>
                    <tr>
                        <th>Date</th>
                        <th>Prescription</th>
                    </thead>
                    </thead>
                    <tbody>
                    <% if (prescriptions == null || prescriptions.isEmpty()) { %>
                    <tr>
                        <td colspan="2">
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-prescription"></i>
                                </div>
                                <h3>Aucune prescription</h3>
                                <p>Aucune prescription médicale pour ce patient</p>
                            </div>
                            </thead>
                            </thead>
                                <% } else {
                            for (Prescription p : prescriptions) { %>
                    <tr>
                        <td data-label="Date" class="prescription-date">
                            <i class="fas fa-calendar-alt"></i> <%= p.getDatePrescription() %>
                            </thead>
                        <td data-label="Prescription">
                            <pre class="prescription-content"><%= p.getContenu() %></pre>
                            </thead>
                            </thead>
                                <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <% } %>
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
</script>
</body>
</html>