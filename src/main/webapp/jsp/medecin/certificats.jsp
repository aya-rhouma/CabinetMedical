<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.CertificatMedical" %>
<%@ page import="com.jee.entity.Patient" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<CertificatMedical> certificats = (List<CertificatMedical>) request.getAttribute("certificats");
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    Object selectedPatientId = request.getAttribute("selectedPatientId");
    String template = (String) request.getAttribute("templateCertificat");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Demandes certificats</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container py-4">
<h3 class="mb-3">Demandes de certificats</h3>
<a class="btn btn-outline-secondary btn-sm mb-3" href="<%=request.getContextPath()%>/medecin">Dashboard</a>

<form method="get" action="<%=request.getContextPath()%>/medecin" class="row g-2 mb-4">
    <input type="hidden" name="action" value="certificats"/>
    <div class="col-md-6">
        <select class="form-select" name="patientId">
            <option value="">Toutes les demandes</option>
            <% if (patients != null) {
                for (Patient p : patients) { %>
            <option value="<%=p.getId()%>" <%= (selectedPatientId != null && selectedPatientId.toString().equals(String.valueOf(p.getId()))) ? "selected" : "" %>>
                <%= p.getPrenom() %> <%= p.getNom() %>
            </option>
            <% }} %>
        </select>
    </div>
    <div class="col-md-3">
        <button class="btn btn-primary w-100" type="submit">Filtrer</button>
    </div>
</form>

<table class="table table-bordered table-striped">
    <thead>
    <tr>
        <th>ID</th>
        <th>Patient</th>
        <th>Motif demande</th>
        <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <% if (certificats == null || certificats.isEmpty()) { %>
    <tr><td colspan="4" class="text-center">Aucune demande en attente.</td></tr>
    <% } else {
        for (CertificatMedical c : certificats) { %>
    <tr>
        <td><%= c.getId() %></td>
        <td><%= c.getPatient().getPrenom() %> <%= c.getPatient().getNom() %></td>
        <td><%= c.getMotif() %></td>
        <td>
            <form method="post" action="<%=request.getContextPath()%>/medecin">
                <input type="hidden" name="action" value="genererCertificat"/>
                <input type="hidden" name="certificatId" value="<%=c.getId()%>"/>
                <input class="form-control form-control-sm mb-2" type="number" min="1" name="nbJours" value="1"
                       placeholder="Nombre de jours de repos"/>
                <textarea class="form-control form-control-sm mb-2" name="contenuTemplate" rows="4"><%=template%></textarea>
                <button class="btn btn-success btn-sm" type="submit">Générer</button>
            </form>
        </td>
    </tr>
    <% }} %>
    </tbody>
</table>
</body>
</html>
