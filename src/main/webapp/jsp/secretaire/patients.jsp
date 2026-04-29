<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User, com.jee.entity.Patient, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (user.getRole() != User.Role.SECRETAIRE && user.getRole() != User.Role.ADMIN)) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp"); return;
    }
    String ctx = request.getContextPath();
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patients - MediCare Plus</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/secretaire.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="<%= ctx %>/"><i class="fas fa-heartbeat"></i><span>MediCare Plus</span></a>
        <div class="nav-links" id="navLinks">
            <a href="<%= ctx %>/secretaire">Dashboard</a>
            <a href="<%= ctx %>/secretaire?action=patients" class="active">Patients</a>
            <a href="<%= ctx %>/secretaire?action=rdv">Rendez-vous</a>
            <a href="<%= ctx %>/secretaire?action=materiels">Matériaux</a>
            <a href="<%= ctx %>/auth/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </div>
        <button class="menu-toggle" id="menuToggle"><i class="fas fa-bars"></i></button>
    </div>
</nav>

<main class="dashboard-main">
    <div class="card">
        <div class="card-header">
            <div class="card-title">
                <i class="fas fa-users"></i> Patients
                <span class="badge-count"><%= patients != null ? patients.size() : 0 %></span>
            </div>
            <div class="search-bar">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput" placeholder="Rechercher un patient…" oninput="filterTable()">
            </div>
        </div>

        <% if (patients == null || patients.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon"><i class="fas fa-user-slash"></i></div>
            <h3>Aucun patient enregistré</h3>
        </div>
        <% } else { %>
        <div class="table-wrapper">
            <table class="data-table" id="patientsTable">
                <thead>
                    <tr><th>#</th><th>Patient</th><th>Email</th><th>Téléphone</th><th>Naissance</th><th>Adresse</th><th>Fiche</th></tr>
                </thead>
                <tbody>
                <% for (com.jee.entity.Patient p : patients) { %>
                <tr>
                    <td><span class="id-badge">#<%= p.getId() %></span></td>
                    <td>
                        <div class="user-cell">
                            <div class="user-av cyan"><%= p.getPrenom().substring(0,1).toUpperCase() %><%= p.getNom().substring(0,1).toUpperCase() %></div>
                            <div><div class="cell-name"><%= p.getPrenom() %> <%= p.getNom() %></div></div>
                        </div>
                    </td>
                    <td class="text-muted"><%= p.getEmail() %></td>
                    <td><%= p.getTelephone() != null ? p.getTelephone() : "—" %></td>
                    <td><%= p.getDateNaissance() != null ? p.getDateNaissance() : "—" %></td>
                    <td class="text-muted" style="max-width:160px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                        <%= p.getAdresse() != null && !p.getAdresse().isBlank() ? p.getAdresse() : "—" %>
                    </td>
                    <td>
                        <a href="<%= ctx %>/secretaire?action=fichePatient&patientId=<%= p.getId() %>"
                           class="btn btn-outline btn-sm"><i class="fas fa-id-card"></i> Fiche</a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</main>

<script>
    document.getElementById('menuToggle')?.addEventListener('click',()=>{
        document.getElementById('navLinks').classList.toggle('active');
    });
    function filterTable() {
        const q = document.getElementById('searchInput').value.toLowerCase();
        document.querySelectorAll('#patientsTable tbody tr').forEach(tr => {
            tr.style.display = tr.innerText.toLowerCase().includes(q) ? '' : 'none';
        });
    }
</script>
</body>
</html>
