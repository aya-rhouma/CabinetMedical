<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User, com.jee.entity.Secretaire, com.jee.entity.Medecin, java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || admin.getRole() != User.Role.ADMIN) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp?role=admin");
        return;
    }

    String ctx = request.getContextPath();
    List<Secretaire> secretaires = (List<Secretaire>) request.getAttribute("secretaires");
    List<Medecin> medecins = (List<Medecin>) request.getAttribute("medecins");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secrétaires - Admin</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/secretaire.css">
</head>

<body>

<!-- 🔷 NAVBAR -->
<nav class="navbar">
    <div class="nav-container">

        <a class="logo" href="<%= ctx %>/">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </a>

        <div class="nav-links" id="navLinks">
            <span class="role-tag">
                <i class="fas fa-shield-alt"></i> Admin
            </span>

            <a href="<%= ctx %>/admin">Dashboard</a>
            <a href="<%= ctx %>/admin?action=medecins">Médecins</a>
            <a href="<%= ctx %>/admin?action=secretaires" class="active">Secrétaires</a>
            <a href="<%= ctx %>/admin?action=materiels">Matériaux</a>

            <a href="<%= ctx %>/auth/logout" class="btn-logout">
                <i class="fas fa-sign-out-alt"></i> Déconnexion
            </a>
        </div>

        <button class="menu-toggle" id="menuToggle">
            <i class="fas fa-bars"></i>
        </button>
    </div>
</nav>


<!-- 🔷 MAIN -->
<main class="dashboard-main">

    <% if (success != null) { %>
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i>
        <%= "added".equals(success) ? "Secrétaire ajouté(e) avec succès." : "Secrétaire supprimé(e) avec succès." %>
    </div>
    <% } %>

    <div class="card">
        <div class="card-header">
            <div class="card-title">
                <i class="fas fa-user-tie"></i> Secrétaires
                <span class="badge-count"><%= secretaires != null ? secretaires.size() : 0 %></span>
            </div>

            <button onclick="document.getElementById('addSecretaireModal').classList.add('open')"
                    class="btn btn-primary btn-sm">
                <i class="fas fa-plus"></i> Ajouter
            </button>
        </div>

        <% if (secretaires == null || secretaires.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon"><i class="fas fa-user-tie"></i></div>
            <h3>Aucune secrétaire enregistrée</h3>
        </div>
        <% } else { %>

        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Nom</th>
                    <th>Email</th>
                    <th>Téléphone</th>
                    <th>Médecin</th>
                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>
                <% for (Secretaire s : secretaires) { %>
                <tr>
                    <td>#<%= s.getId() %></td>

                    <td><strong><%= s.getPrenom() %> <%= s.getNom() %></strong></td>

                    <td><%= s.getEmail() %></td>
                    <td><%= s.getTelephone() != null ? s.getTelephone() : "—" %></td>

                    <td>
                        <% if (s.getMedecin() != null) { %>
                        Dr <%= s.getMedecin().getPrenom() %> <%= s.getMedecin().getNom() %>
                        <% } else { %>
                        —
                        <% } %>
                    </td>

                    <td>
                        <form method="post" action="<%= ctx %>/admin"
                              onsubmit="return confirm('Supprimer ?')">

                            <input type="hidden" name="action" value="deleteSecretaire">
                            <input type="hidden" name="id" value="<%= s.getId() %>">

                            <button class="btn btn-danger btn-sm">
                                <i class="fas fa-trash"></i>
                            </button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <% } %>
    </div>

</main>


<!-- 🔷 MODAL -->
<div class="modal-overlay" id="addSecretaireModal">
    <div class="modal-box">
        <div class="modal-header">
            <div class="modal-icon mi-amber"><i class="fas fa-user-tie"></i></div>
            <div>
                <div class="modal-title">Ajouter une Secrétaire</div>
            </div>
        </div>

        <form method="post" action="<%= ctx %>/admin">
            <input type="hidden" name="action" value="addSecretaire">

            <div class="form-grid-2">
                <input type="text" name="nom" placeholder="Nom" class="form-control" required>
                <input type="text" name="prenom" placeholder="Prénom" class="form-control" required>
                <input type="email" name="email" placeholder="Email" class="form-control" required>
                <input type="tel" name="telephone" placeholder="Téléphone" class="form-control">
                <input type="password" name="password" placeholder="Mot de passe" class="form-control" required>

                <select name="medecinId" class="form-control" style="grid-column:1/-1;">
                    <option value="">-- Aucun médecin --</option>
                    <% if (medecins != null) {
                        for (Medecin m : medecins) { %>
                    <option value="<%= m.getId() %>">
                        Dr <%= m.getPrenom() %> <%= m.getNom() %>
                    </option>
                    <% }} %>
                </select>
            </div>

            <div class="modal-footer">
                <button class="btn btn-primary">Enregistrer</button>
                <button type="button"
                        onclick="document.getElementById('addSecretaireModal').classList.remove('open')"
                        class="btn btn-ghost">Annuler</button>
            </div>
        </form>
    </div>
</div>


<!-- 🔷 SCRIPT -->
<script>
    document.getElementById('menuToggle')?.addEventListener('click', () => {
        document.getElementById('navLinks').classList.toggle('active');
    });

    document.querySelectorAll('.modal-overlay').forEach(m => {
        m.addEventListener('click', e => {
            if (e.target === m) m.classList.remove('open');
        });
    });
</script>

</body>
</html>