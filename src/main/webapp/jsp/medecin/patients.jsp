<%@ page import="java.util.List" %>
<%@ page import="com.jee.entity.Patient" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Patients - Médecin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container py-4">
<h3 class="mb-3">Mes patients</h3>
<a class="btn btn-outline-secondary btn-sm mb-3" href="<%=request.getContextPath()%>/medecin">Dashboard</a>

<table class="table table-striped table-bordered">
    <thead>
    <tr>
        <th>ID</th>
        <th>Patient</th>
        <th>Date naissance</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <% if (patients == null || patients.isEmpty()) { %>
    <tr><td colspan="4" class="text-center">Aucun patient.</td></tr>
    <% } else {
        for (Patient p : patients) { %>
    <tr>
        <td><%= p.getId() %></td>
        <td><%= p.getPrenom() %> <%= p.getNom() %></td>
        <td><%= p.getDateNaissance() %></td>
        <td>
            <a class="btn btn-sm btn-primary"
               href="<%=request.getContextPath()%>/medecin?action=dossier&patientId=<%=p.getId()%>">Fiche médicale</a>
            <a class="btn btn-sm btn-outline-info"
               href="<%=request.getContextPath()%>/medecin?action=rdv&patientId=<%=p.getId()%>">RDV</a>
            <a class="btn btn-sm btn-outline-success"
               href="<%=request.getContextPath()%>/medecin?action=certificats&patientId=<%=p.getId()%>">Certificats</a>
        </td>
    </tr>
    <% }} %>
    </tbody>
</table>
</body>
</html>
