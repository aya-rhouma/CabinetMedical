<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User" %>
<%@ page import="com.jee.entity.Secretaire" %>
<%@ page import="java.util.List" %>
<%
    User medecin = (User) session.getAttribute("user");
    if (medecin == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }

    String contextPath = request.getContextPath();
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    List<Secretaire> secretaires = (List<Secretaire>) request.getAttribute("secretaires");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gérer Secrétaire</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary: #0ea5e9;
            --secondary: #10b981;
            --danger: #ef4444;
            --dark: #0f172a;
            --gray: #64748b;
            --light: #f8fafc;
            --border: #e2e8f0;
            --shadow: 0 10px 25px rgba(15, 23, 42, 0.08);
            --radius: 20px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: var(--dark);
            min-height: 100vh;
        }

        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 12px rgba(15, 23, 42, 0.08);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .nav-container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 18px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }

        .logo {
            color: var(--primary);
            text-decoration: none;
            font-size: 1.35rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav-links {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 18px;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--gray);
            font-weight: 500;
        }

        .nav-links a.active {
            color: var(--primary);
        }

        .btn-logout {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff !important;
            padding: 10px 18px;
            border-radius: 999px;
        }

        .page {
            max-width: 1280px;
            margin: 32px auto;
            padding: 0 24px 40px;
        }

        .hero,
        .panel {
            background: #fff;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
        }

        .hero {
            padding: 28px;
            margin-bottom: 24px;
        }

        .hero h1 {
            font-size: 1.9rem;
            margin-bottom: 8px;
        }

        .hero p {
            color: var(--gray);
            line-height: 1.6;
        }

        .hero .actions {
            margin-top: 18px;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn-primary,
        .btn-secondary,
        .btn-danger {
            border: 0;
            cursor: pointer;
            border-radius: 12px;
            font-weight: 600;
            padding: 12px 16px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
        }

        .btn-secondary {
            background: var(--light);
            color: var(--dark);
        }

        .btn-danger {
            background: #fee2e2;
            color: #b91c1c;
            padding: 8px 12px;
        }

        .panel {
            padding: 24px;
        }

        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .search-box {
            flex: 1;
            min-width: 240px;
            max-width: 360px;
            position: relative;
        }

        .search-box i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray);
        }

        .search-box input {
            width: 100%;
            padding: 12px 14px 12px 40px;
            border: 1px solid var(--border);
            border-radius: 12px;
            font: inherit;
        }

        .alert {
            border-radius: 14px;
            padding: 14px 16px;
            margin-bottom: 16px;
            font-weight: 500;
        }

        .alert-success {
            background: #dcfce7;
            color: #166534;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
        }

        .table-wrap {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 14px 12px;
            text-align: left;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
        }

        th {
            color: var(--gray);
            font-size: 0.9rem;
            font-weight: 700;
        }

        .empty {
            text-align: center;
            color: var(--gray);
            padding: 36px 16px;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 12px;
            border-radius: 999px;
            background: #dbeafe;
            color: #1d4ed8;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .modal {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.45);
            padding: 20px;
            z-index: 20;
        }

        .modal-content {
            max-width: 640px;
            margin: 40px auto;
            background: #fff;
            border-radius: 24px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .modal-header,
        .modal-body {
            padding: 24px;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border);
        }

        .close {
            font-size: 1.8rem;
            cursor: pointer;
            line-height: 1;
            color: var(--gray);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
        }

        input {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 12px 14px;
            font: inherit;
        }

        @media (max-width: 768px) {
            .nav-container,
            .nav-links {
                flex-direction: column;
                align-items: flex-start;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .page {
                padding-left: 16px;
                padding-right: 16px;
            }
        }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="<%= contextPath %>/">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </a>
        <div class="nav-links">
            <a href="<%= contextPath %>/medecin">Dashboard</a>
            <a href="<%= contextPath %>/medecin?action=patients">Mes Patients</a>
            <a href="<%= contextPath %>/medecin?action=rdv">Rendez-vous</a>
            <a href="<%= contextPath %>/medecin?action=certificats">Certificats</a>
            <a href="<%= contextPath %>/medecin?action=secretaires" class="active">Secrétaires</a>
            <a href="<%= contextPath %>/auth/logout" class="btn-logout">
                <i class="fas fa-sign-out-alt"></i> Déconnexion
            </a>
        </div>
    </div>
</nav>

<main class="page">
    <section class="hero">
        <h1>Gérer mes secrétaires</h1>
        <p>Créer et administrer les comptes secrétaires rattachés au médecin connecté.</p>
        <div class="actions">
            <button type="button" class="btn-primary" onclick="openModal()">
                <i class="fas fa-user-plus"></i> Ajouter une secrétaire
            </button>
            <a class="btn-secondary" href="<%= contextPath %>/medecin">
                <i class="fas fa-arrow-left"></i> Retour au dashboard
            </a>
        </div>
    </section>

    <section class="panel">
        <% if (message != null) { %>
        <div class="alert alert-success"><%= message %></div>
        <% } %>
        <% if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
        <% } %>

        <div class="toolbar">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput" placeholder="Rechercher une secrétaire">
            </div>
        </div>

        <div class="table-wrap">
            <table id="secretaireTable">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Nom complet</th>
                    <th>Email</th>
                    <th>Téléphone</th>
                    <th>Créé le</th>
                    <th>Statut</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <% if (secretaires != null && !secretaires.isEmpty()) {
                    int index = 1;
                    for (Secretaire secretaire : secretaires) {
                %>
                <tr>
                    <td><%= index++ %></td>
                    <td><strong><%= secretaire.getPrenom() %> <%= secretaire.getNom() %></strong></td>
                    <td><%= secretaire.getEmail() %></td>
                    <td><%= secretaire.getTelephone() == null || secretaire.getTelephone().isBlank() ? "-" : secretaire.getTelephone() %></td>
                    <td><%= secretaire.getCreatedAt() == null ? "-" : secretaire.getCreatedAt() %></td>
                    <td><span class="badge"><i class="fas fa-link"></i> Liée au médecin</span></td>
                    <td>
                        <button type="button" class="btn-danger" onclick="deleteSecretaire(<%= secretaire.getId() %>)">
                            <i class="fas fa-trash"></i> Supprimer
                        </button>
                    </td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="7" class="empty">
                        Aucune secrétaire liée à ce médecin.
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</main>

<div id="secretaireModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2><i class="fas fa-user-plus"></i> Créer un compte secrétaire</h2>
            <span class="close" onclick="closeModal()">&times;</span>
        </div>
        <div class="modal-body">
            <form id="createSecretaireForm" action="<%= contextPath %>/medecin" method="post">
                <input type="hidden" name="action" value="createSecretaire">

                <div class="form-grid">
                    <div class="form-group">
                        <label for="prenom">Prénom *</label>
                        <input type="text" id="prenom" name="prenom" required>
                    </div>
                    <div class="form-group">
                        <label for="nom">Nom *</label>
                        <input type="text" id="nom" name="nom" required>
                    </div>
                    <div class="form-group full">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    <div class="form-group full">
                        <label for="telephone">Téléphone</label>
                        <input type="text" id="telephone" name="telephone">
                    </div>
                    <div class="form-group">
                        <label for="password">Mot de passe *</label>
                        <input type="password" id="password" name="password" required>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirmer le mot de passe *</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>
                </div>

                <button type="submit" class="btn-primary">
                    <i class="fas fa-check"></i> Créer le compte
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    const contextPath = '<%= contextPath %>';
    const modal = document.getElementById('secretaireModal');
    const searchInput = document.getElementById('searchInput');

    function openModal() {
        modal.style.display = 'block';
    }

    function closeModal() {
        modal.style.display = 'none';
    }

    function deleteSecretaire(id) {
        if (confirm('Supprimer cette secrétaire ?')) {
            window.location.href = contextPath + '/medecin?action=deleteSecretaire&id=' + id;
        }
    }

    window.addEventListener('click', function (event) {
        if (event.target === modal) {
            closeModal();
        }
    });

    searchInput.addEventListener('input', function () {
        const term = this.value.toLowerCase();
        const rows = document.querySelectorAll('#secretaireTable tbody tr');

        rows.forEach(function (row) {
            if (row.children.length === 1) {
                return;
            }
            row.style.display = row.textContent.toLowerCase().includes(term) ? '' : 'none';
        });
    });

    document.getElementById('createSecretaireForm').addEventListener('submit', function (event) {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (password !== confirmPassword) {
            event.preventDefault();
            alert('Les mots de passe ne correspondent pas.');
            return;
        }

        if (password.length < 8) {
            event.preventDefault();
            alert('Le mot de passe doit contenir au moins 8 caractères.');
        }
    });

    <% if (error != null) { %>
    openModal();
    <% } %>
</script>
</body>
</html>
