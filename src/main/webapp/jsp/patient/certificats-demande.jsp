<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.Medecin" %>
<%@ page import="com.jee.entity.CertificatMedical" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Medecin> medecins =
            (List<Medecin>) request.getAttribute("medecinsDisponibles");

    List<CertificatMedical> certificatsPatient =
            (List<CertificatMedical>) request.getAttribute("certificatsPatient");

    if (certificatsPatient == null) {
        certificatsPatient =
                (List<CertificatMedical>) request.getAttribute("demandesCertificats");
    }

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Demander un certificat - MediCare Plus</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/dashboard.css">
</head>

<body>

<!-- =================== NAVBAR =================== -->
<nav class="navbar">
    <div class="nav-container">
        <div class="logo">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </div>
        <div class="nav-links">
            <a href="<%= contextPath %>/patient">Retour au Dashboard</a>
        </div>
    </div>
</nav>

<!-- =================== MAIN =================== -->
<main class="dashboard-main">

    <!-- ======= DEMANDE CERTIFICAT ======= -->
    <section class="section-card">
        <h2>
            <i class="fas fa-file-medical"></i>
            Demander un certificat médical
        </h2>

        <form method="post" action="<%= contextPath %>/patient" class="form-grid">
            <input type="hidden" name="action" value="demanderCertificat"/>

            <!-- ===== Médecin ===== -->
            <div>
                <label>Médecin concerné</label>
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

            <!-- ===== Motif (LISTE DÉROULANTE) ===== -->
            <div>
                <label>Motif de la demande</label>
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
    </section>

    <!-- ======= LISTE DES CERTIFICATS ======= -->
    <section class="section-card">
        <h3>
            <i class="fas fa-list"></i>
            Mes certificats
        </h3>

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
                    Aucun certificat demandé
                </td>
            </tr>
            <% } else {
                for (CertificatMedical c : certificatsPatient) {
                    String statut = c.getStatut() == null ? "EN ATTENTE" : c.getStatut();
            %>
            <tr>
                <td>
                    Dr <%= c.getMedecin().getPrenom() %> <%= c.getMedecin().getNom() %>
                </td>
                <td>
                    <%= c.getMotif() %>
                </td>
                <td>
                    <span class="role-badge"
                          style="background:
                              <%= "GENERE".equals(statut) || "APPROUVE".equals(statut)
                                  ? "var(--secondary)"
                                  : "REJETE".equals(statut)
                                  ? "var(--danger)"
                                  : "var(--warning)" %>;">
                        <%= statut %>
                    </span>
                </td>
            </tr>
            <% }} %>
            </tbody>
        </table>
    </section>

</main>

</body>
</html>