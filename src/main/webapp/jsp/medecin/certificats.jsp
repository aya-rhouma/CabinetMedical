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

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/medecin.css">
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
    AOS.init({ duration: 1000, once: true, offset: 100, easing: 'ease-in-out' });

    // Mobile menu toggle
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

    // Pré-remplir le premier formulaire
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