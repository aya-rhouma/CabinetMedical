<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User, com.jee.entity.Materiel, java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || admin.getRole() != User.Role.ADMIN) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp?role=admin");
        return;
    }

    String ctx = request.getContextPath();
    String initials = (admin.getPrenom().substring(0,1) + admin.getNom().substring(0,1)).toUpperCase();
    List<Materiel> materiels = (List<Materiel>) request.getAttribute("materiels");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Matériaux - Admin</title>

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
            <a href="<%= ctx %>/admin?action=secretaires">Secrétaires</a>
            <a href="<%= ctx %>/admin?action=materiels" class="active">Matériaux</a>

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
        <%= "added".equals(success) ? "Matériel ajouté avec succès."
                : "updated".equals(success) ? "Matériel mis à jour avec succès."
                : "Matériel supprimé avec succès." %>
    </div>
    <% } %>

    <!-- 🔷 CARD -->
    <div class="card">
        <div class="card-header">
            <div class="card-title">
                <i class="fas fa-box-open"></i> Inventaire
                <span class="badge-count"><%= materiels != null ? materiels.size() : 0 %></span>
            </div>

            <button onclick="document.getElementById('addMaterielModal').classList.add('open')"
                    class="btn btn-primary btn-sm">
                <i class="fas fa-plus"></i> Ajouter
            </button>
        </div>

        <% if (materiels == null || materiels.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon"><i class="fas fa-box-open"></i></div>
            <h3>Aucun matériel enregistré</h3>
            <p>Cliquez sur "Ajouter" pour commencer.</p>
        </div>
        <% } else { %>

        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Matériel</th>
                    <th>Quantité</th>
                    <th>Seuil</th>
                    <th>État</th>
                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>
                <% for (Materiel m : materiels) { %>
                <tr>
                    <td><strong><%= m.getNom() %></strong></td>

                    <td style="font-weight:800;color:<%= m.isEnAlerte() ? "var(--danger)" : "var(--success)" %>;">
                        <%= m.getQuantite() %>
                    </td>

                    <td><%= m.getSeuilAlerte() %></td>

                    <td>
                        <% if (m.isEnAlerte()) { %>
                        <span class="badge badge-danger">
                                    <i class="fas fa-exclamation-triangle"></i> Alerte
                                </span>
                        <% } else { %>
                        <span class="badge badge-success">
                                    <i class="fas fa-check"></i> OK
                                </span>
                        <% } %>
                    </td>

                    <td>
                        <div style="display:flex;gap:.4rem;">
                            <button onclick="openEditModal(<%= m.getId() %>, '<%= m.getNom().replace("'","\\'") %>', <%= m.getQuantite() %>, <%= m.getSeuilAlerte() %>)"
                                    class="btn btn-outline btn-sm">
                                <i class="fas fa-edit"></i>
                            </button>

                            <form method="post" action="<%= ctx %>/admin" onsubmit="return confirm('Supprimer ?')">
                                <input type="hidden" name="action" value="deleteMateriel">
                                <input type="hidden" name="id" value="<%= m.getId() %>">
                                <button class="btn btn-danger btn-sm">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </form>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <% } %>
    </div>

</main>


<!-- 🔷 MODALS (inchangés) -->
<!-- (tu gardes tes modals tels quels, rien à changer) -->


<!-- 🔷 SCRIPT -->
<script>
    document.getElementById('menuToggle')?.addEventListener('click', () => {
        document.getElementById('navLinks').classList.toggle('active');
    });

    function openEditModal(id, nom, qte, seuil) {
        document.getElementById('editId').value = id;
        document.getElementById('editNom').value = nom;
        document.getElementById('editQte').value = qte;
        document.getElementById('editSeuil').value = seuil;
        document.getElementById('editMaterielModal').classList.add('open');
    }
</script>

</body>
</html>