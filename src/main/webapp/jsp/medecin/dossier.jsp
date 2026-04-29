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

    <!-- CSS Unifié -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/medecin.css">

    <style>
        /* Styles spécifiques pour la page dossier */
        .dossier-header {
            margin-bottom: 2rem;
        }

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
            margin: 0;
        }

        .patient-info-large i {
            margin-right: 0.5rem;
            color: var(--primary);
        }

        .section-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-title i {
            color: var(--primary);
        }

        .btn-group {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }

        .btn-sm {
            padding: 0.4rem 1rem;
            font-size: 0.8rem;
        }

        @media (max-width: 768px) {
            .patient-card {
                flex-direction: column;
                text-align: center;
            }
        }
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
                            </td>
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
    <!-- Header -->
    <div class="dossier-header" data-aos="fade-up">
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
        <a href="${pageContext.request.contextPath}/medecin?action=patients" class="btn-action btn-back btn-sm">
            <i class="fas fa-arrow-left"></i> Retour
        </a>
        <a href="${pageContext.request.contextPath}/medecin?action=certificats&patientId=<%=patientId%>" class="btn-action btn-certificat btn-sm">
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
                                <% }} %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
    <% } %>

<!-- Scripts -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({
        duration: 800,
        once: true,
        offset: 100,
        easing: 'ease-in-out'
    });

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