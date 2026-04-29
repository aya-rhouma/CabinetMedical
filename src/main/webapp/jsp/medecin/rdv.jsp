<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.RendezVous" %>
<%@ page import="com.jee.entity.Patient" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<RendezVous> rdvs = (List<RendezVous>) request.getAttribute("rdvs");
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    Object selectedPatientId = request.getAttribute("selectedPatientId");
    String selectedFiltre = (String) request.getAttribute("selectedFiltre");
    if (selectedFiltre == null || selectedFiltre.isBlank()) {
        selectedFiltre = "all";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Rendez-vous - Médecin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container py-4">
<h3 class="mb-3">Liste des rendez-vous</h3>
<a class="btn btn-outline-secondary btn-sm mb-3" href="<%=request.getContextPath()%>/medecin">Dashboard</a>

<form method="get" action="<%=request.getContextPath()%>/medecin" class="row g-2 mb-4">
    <input type="hidden" name="action" value="rdv"/>
    <div class="col-md-6">
        <select class="form-select" name="patientId">
            <option value="">Tous les patients</option>
            <% if (patients != null) {
                for (Patient p : patients) { %>
            <option value="<%=p.getId()%>" <%= (selectedPatientId != null && selectedPatientId.toString().equals(String.valueOf(p.getId()))) ? "selected" : "" %>>
                <%= p.getPrenom() %> <%= p.getNom() %>
            </option>
            <% }} %>
        </select>
    </div>
    <div class="col-md-3">
        <select class="form-select" name="filtre">
            <option value="all" <%= "all".equals(selectedFiltre) ? "selected" : "" %>>Tous les RDV</option>
            <option value="planifies" <%= "planifies".equals(selectedFiltre) ? "selected" : "" %>>Planifiés</option>
            <option value="termines" <%= "termines".equals(selectedFiltre) ? "selected" : "" %>>Terminés</option>
        </select>
    </div>
    <div class="col-md-3">
        <button class="btn btn-primary w-100" type="submit">Filtrer</button>
    </div>
</form>

<table class="table table-striped table-bordered">
    <thead>
    <tr>
        <th>Date</th>
        <th>Horaire</th>
        <th>Patient</th>
        <th>Statut</th>
    </tr>
    </thead>
    <tbody>
    <% if (rdvs == null || rdvs.isEmpty()) { %>
    <tr><td colspan="4" class="text-center">Aucun rendez-vous.</td></tr>
    <% } else {
        for (RendezVous rdv : rdvs) { %>
    <tr>
        <td><%= rdv.getDateRdv() %></td>
        <td><%= rdv.getHeureDebut() %> - <%= rdv.getHeureFin() %></td>
        <td><%= rdv.getPatient().getPrenom() %> <%= rdv.getPatient().getNom() %></td>
        <td><%= rdv.getStatut() %></td>
    </tr>
    <% }} %>
    </tbody>
</table>
</body>
</html>
