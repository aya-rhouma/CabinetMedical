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
    String prescriptionTemplate = (String) request.getAttribute("templateOrdonnance");
    if (prescriptionTemplate == null || prescriptionTemplate.isBlank()) {
        prescriptionTemplate = "ORDONNANCE MEDICALE";
    }
    prescriptionTemplate = prescriptionTemplate
            .replace("{{DATE}}", java.time.LocalDate.now().toString())
            .replace("{{PATIENT}}", patient != null ? patient.getPrenom() + " " + patient.getNom() : "Patient")
            .replace("{{MEDECIN}}", medecin != null ? medecin.getPrenom() + " " + medecin.getNom() : "Dr");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Fiche médicale patient</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container py-4">
<h3 class="mb-3">
    Fiche médicale -
    <% if (patient != null) { %>
    <%= patient.getPrenom() %> <%= patient.getNom() %> (ID <%= patient.getId() %>)
    <% } else { %>
    Patient #<%= patientId %>
    <% } %>
</h3>
<a class="btn btn-outline-secondary btn-sm mb-3" href="<%=request.getContextPath()%>/medecin?action=patients">Retour patients</a>
<a class="btn btn-outline-success btn-sm mb-3" href="<%=request.getContextPath()%>/medecin?action=certificats&patientId=<%=patientId%>">Demandes certificat</a>

<div class="card mb-4">
    <div class="card-header">Diagnostic & notes</div>
    <div class="card-body">
        <form method="post" action="<%=request.getContextPath()%>/medecin">
            <input type="hidden" name="action" value="saveDossier"/>
            <input type="hidden" name="patientId" value="<%=patientId%>"/>

            <div class="mb-3">
                <label class="form-label">Diagnostic</label>
                <textarea class="form-control" rows="3" name="diagnostic"><%= dossier != null && dossier.getDiagnostic() != null ? dossier.getDiagnostic() : "" %></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">Notes</label>
                <textarea class="form-control" rows="4" name="notes"><%= dossier != null && dossier.getNotes() != null ? dossier.getNotes() : "" %></textarea>
            </div>

            <button class="btn btn-primary" type="submit">Enregistrer fiche</button>
        </form>
    </div>
</div>

<div class="card mb-4">
    <div class="card-header">Nouvelle ordonnance (template prêt)</div>
    <div class="card-body">
        <form method="post" action="<%=request.getContextPath()%>/medecin">
            <input type="hidden" name="action" value="addPrescription"/>
            <input type="hidden" name="patientId" value="<%=patientId%>"/>
            <div class="mb-3">
                <textarea class="form-control" rows="12" name="contenu"><%=prescriptionTemplate%></textarea>
            </div>
            <button class="btn btn-success" type="submit">Ajouter prescription</button>
        </form>
    </div>
</div>

<div class="card">
    <div class="card-header">Historique prescriptions</div>
    <div class="card-body">
        <table class="table table-striped table-bordered mb-0">
            <thead>
            <tr><th>Date</th><th>Contenu</th></tr>
            </thead>
            <tbody>
            <% if (prescriptions == null || prescriptions.isEmpty()) { %>
            <tr><td colspan="2" class="text-center">Aucune prescription.</td></tr>
            <% } else {
                for (Prescription p : prescriptions) { %>
            <tr>
                <td><%= p.getDatePrescription() %></td>
                <td><pre class="mb-0"><%= p.getContenu() %></pre></td>
            </tr>
            <% }} %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
