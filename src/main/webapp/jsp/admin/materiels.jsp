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
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <style>
        /* ============================================
           VARIABLES CSS
           ============================================ */
        .btn-logout {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white !important;
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
        }

        .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }
        :root {
            --primary: #0ea5e9;
            --primary-dark: #0284c7;
            --secondary: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --dark: #0f172a;
            --gray: #64748b;
            --light-gray: #f8fafc;
            --border: #e2e8f0;
            --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: var(--dark);
        }

        /* ============================================
           NAVIGATION
           ============================================ */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 1000;
            padding: 1rem 0;
        }

        .nav-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            text-decoration: none;
        }

        .logo i {
            color: var(--primary);
        }

        .nav-links {
            display: flex;
            gap: 1.5rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--gray);
            font-weight: 500;
            transition: var(--transition);
        }

        .nav-links a:hover {
            color: var(--primary);
        }

        .nav-links a.active {
            color: var(--primary);
        }

        .menu-toggle {
            display: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--dark);
            background: none;
            border: none;
        }

        /* ============================================
           DASHBOARD MAIN
           ============================================ */
        .dashboard-main {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* ============================================
           CARD
           ============================================ */
        .card {
            background: white;
            border-radius: 24px;
            box-shadow: var(--shadow);
            overflow: hidden;
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
            animation-delay: 0.1s;
        }

        .card-header {
            padding: 1.5rem;
            background: white;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .card-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .card-title i {
            color: var(--primary);
            font-size: 1.3rem;
        }

        .badge-count {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 0.2rem 0.6rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        /* ============================================
           BUTTONS
           ============================================ */
        .btn {
            padding: 0.6rem 1.2rem;
            border-radius: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .btn-outline {
            background: transparent;
            border: 1px solid var(--border);
            color: var(--gray);
        }

        .btn-outline:hover {
            border-color: var(--primary);
            color: var(--primary);
        }

        .btn-danger {
            background: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
            transform: translateY(-2px);
        }

        .btn-ghost {
            background: transparent;
            color: var(--gray);
        }

        .btn-ghost:hover {
            background: var(--light-gray);
        }

        .btn-sm {
            padding: 0.4rem 0.8rem;
            font-size: 0.75rem;
        }

        /* ============================================
           TABLE
           ============================================ */
        .table-wrapper {
            overflow-x: auto;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table thead {
            background: var(--light-gray);
        }

        .data-table th {
            padding: 1rem 1.5rem;
            text-align: left;
            font-weight: 600;
            color: var(--dark);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .data-table td {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border);
            color: var(--dark);
        }

        .data-table tr:hover {
            background: var(--light-gray);
        }

        /* ============================================
           BADGES
           ============================================ */
        .badge {
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .badge-success {
            background: #d1fae5;
            color: #065f46;
        }

        .badge-danger {
            background: #fee2e2;
            color: #991b1b;
        }

        /* ============================================
           ALERTS
           ============================================ */
        .alert {
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert-success {
            background-color: #d1fae5;
            color: #065f46;
            border-left: 4px solid var(--secondary);
        }

        .alert i {
            font-size: 1.2rem;
        }

        /* ============================================
           EMPTY STATE
           ============================================ */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
        }

        .empty-icon {
            font-size: 4rem;
            color: var(--gray);
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            color: var(--dark);
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: var(--gray);
        }

        /* ============================================
           MODALS
           ============================================ */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
            z-index: 2000;
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.open {
            display: flex;
        }

        .modal-box {
            background: white;
            border-radius: 24px;
            width: 90%;
            max-width: 500px;
            box-shadow: var(--shadow-xl);
            animation: modalSlideIn 0.3s ease;
        }

        @keyframes modalSlideIn {
            from {
                transform: translateY(-100px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .modal-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .modal-icon {
            width: 50px;
            height: 50px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }

        .mi-cyan { background: linear-gradient(135deg, #06b6d4, #0891b2); }
        .mi-blue { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); }

        .modal-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--dark);
        }

        .modal-subtitle {
            font-size: 0.8rem;
            color: var(--gray);
        }

        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            padding: 1.5rem;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 1rem;
            transition: var(--transition);
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
        }

        .modal-footer {
            padding: 1rem 1.5rem 1.5rem;
            display: flex;
            justify-content: flex-end;
            gap: 0.75rem;
        }

        /* ============================================
           RESPONSIVE
           ============================================ */
        @media (max-width: 1024px) {
            .form-grid-2 {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .menu-toggle {
                display: block;
            }

            .nav-links {
                display: none;
                position: absolute;
                top: 100%;
                left: 0;
                right: 0;
                background: white;
                flex-direction: column;
                padding: 1rem;
                gap: 1rem;
                box-shadow: var(--shadow);
            }

            .nav-links.active {
                display: flex;
            }

            .dashboard-main {
                padding: 1rem;
            }

            .card-header {
                flex-direction: column;
                text-align: center;
            }

            .data-table th,
            .data-table td {
                padding: 0.75rem 1rem;
            }
        }

        /* ============================================
           ANIMATIONS
           ============================================ */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
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

                    <td style="font-weight:800; color:<%= m.isEnAlerte() ? "var(--danger)" : "var(--secondary)" %>;">
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

<!-- 🔷 MODAL AJOUT -->
<div class="modal-overlay" id="addMaterielModal">
    <div class="modal-box">
        <div class="modal-header">
            <div class="modal-icon mi-cyan"><i class="fas fa-box-open"></i></div>
            <div>
                <div class="modal-title">Ajouter un matériel</div>
                <div class="modal-subtitle">Nouveau stock</div>
            </div>
        </div>
        <form method="post" action="<%= ctx %>/admin">
            <input type="hidden" name="action" value="addMateriel">
            <div class="form-grid-2">
                <input type="text"   name="nom"          placeholder="Nom du matériel" class="form-control" required style="grid-column:1/-1;">
                <input type="number" name="quantite"     placeholder="Quantité"        class="form-control" required min="0">
                <input type="number" name="seuilAlerte"  placeholder="Seuil d'alerte"  class="form-control" required min="0">
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary"><i class="fas fa-save"></i> Enregistrer</button>
                <button type="button"
                        onclick="document.getElementById('addMaterielModal').classList.remove('open')"
                        class="btn btn-ghost">Annuler</button>
            </div>
        </form>
    </div>
</div>

<!-- 🔷 MODAL EDITION -->
<div class="modal-overlay" id="editMaterielModal">
    <div class="modal-box">
        <div class="modal-header">
            <div class="modal-icon mi-blue"><i class="fas fa-edit"></i></div>
            <div>
                <div class="modal-title">Modifier un matériel</div>
            </div>
        </div>
        <form method="post" action="<%= ctx %>/admin">
            <input type="hidden" name="action" value="updateMateriel">
            <input type="hidden" name="id"     id="editId">
            <div class="form-grid-2">
                <input type="text"   name="nom"         id="editNom"   placeholder="Nom du matériel" class="form-control" required style="grid-column:1/-1;">
                <input type="number" name="quantite"    id="editQte"   placeholder="Quantité"        class="form-control" required min="0">
                <input type="number" name="seuilAlerte" id="editSeuil" placeholder="Seuil d'alerte"  class="form-control" required min="0">
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary"><i class="fas fa-save"></i> Mettre à jour</button>
                <button type="button"
                        onclick="document.getElementById('editMaterielModal').classList.remove('open')"
                        class="btn btn-ghost">Annuler</button>
            </div>
        </form>
    </div>
</div>

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({ duration: 900, once: true, offset: 80, easing: 'ease-in-out' });

    // Menu toggle for mobile
    const menuToggle = document.getElementById('menuToggle');
    const navLinks = document.getElementById('navLinks');

    if (menuToggle) {
        menuToggle.addEventListener('click', () => {
            navLinks.classList.toggle('active');
            const icon = menuToggle.querySelector('i');
            if (icon.classList.contains('fa-bars')) {
                icon.classList.remove('fa-bars');
                icon.classList.add('fa-times');
            } else {
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            }
        });
    }

    // Close menu when clicking on a link
    document.querySelectorAll('.nav-links a').forEach(link => {
        link.addEventListener('click', () => {
            navLinks.classList.remove('active');
            const icon = menuToggle.querySelector('i');
            if (icon) {
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            }
        });
    });

    // Active link highlighting
    const currentPath = window.location.pathname;
    document.querySelectorAll('.nav-links a').forEach(link => {
        const href = link.getAttribute('href');
        if (!href || href === '#') return;
        if (currentPath.includes(href.replace('<%= ctx %>', ''))) {
            link.classList.add('active');
        }
    });

    // Modal close on click outside
    document.querySelectorAll('.modal-overlay').forEach(m => {
        m.addEventListener('click', e => {
            if (e.target === m) m.classList.remove('open');
        });
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