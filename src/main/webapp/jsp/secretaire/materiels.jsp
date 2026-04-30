<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User, com.jee.entity.Materiel, com.jee.entity.DevisMateriel, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (user.getRole() != User.Role.SECRETAIRE && user.getRole() != User.Role.ADMIN)) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp"); return;
    }
    String ctx = request.getContextPath();
    List<Materiel>      materiels = (List<Materiel>)      request.getAttribute("materiels");
    List<Materiel>      alertes   = (List<Materiel>)      request.getAttribute("alertes");
    List<DevisMateriel> devis     = (List<DevisMateriel>) request.getAttribute("devis");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Matériaux - MediCare Plus</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <style>
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

        .menu-toggle {
            display: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--dark);
            background: none;
            border: none;
        }

        .dashboard-main {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* Stock Banner */
        .stock-banner {
            background: linear-gradient(135deg, #fff3e0, #ffe8cc);
            border-left: 4px solid var(--warning);
            border-radius: 16px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .stock-banner i {
            font-size: 1.5rem;
            color: var(--warning);
        }

        .stock-banner strong {
            color: var(--dark);
        }

        .stock-banner p {
            color: var(--gray);
            font-size: 0.8rem;
            margin-top: 0.2rem;
        }

        /* Alert */
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

        /* Card */
        .card {
            background: white;
            border-radius: 24px;
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 1.5rem;
            transition: var(--transition);
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
        }

        .card:hover {
            box-shadow: var(--shadow-lg);
        }

        .card:first-of-type { animation-delay: 0.1s; }
        .card:last-of-type { animation-delay: 0.2s; }

        .card-header {
            padding: 1rem 1.5rem;
            background: white;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .card-title {
            font-size: 1rem;
            font-weight: 700;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .card-title i {
            color: var(--primary);
            font-size: 1.1rem;
        }

        .badge-count {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 0.2rem 0.6rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            margin-left: 0.5rem;
        }

        /* Table */
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
            padding: 0.75rem 1rem;
            text-align: left;
            font-size: 0.7rem;
            font-weight: 600;
            color: var(--gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .data-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.85rem;
        }

        .data-table tr:hover {
            background: var(--light-gray);
        }

        .text-dark {
            color: var(--dark);
        }

        .text-muted {
            color: var(--gray);
        }

        /* Badges */
        .badge {
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
        }

        .badge-success { background: #d1fae5; color: #065f46; }
        .badge-danger { background: #fee2e2; color: #991b1b; }

        /* Buttons */
        .btn {
            padding: 0.4rem 1rem;
            border-radius: 10px;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            font-size: 0.75rem;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            text-decoration: none;
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

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .btn-ghost {
            background: transparent;
            border: 1px solid var(--border);
            color: var(--gray);
        }

        .btn-ghost:hover {
            background: var(--light-gray);
        }

        .btn-sm {
            padding: 0.3rem 0.8rem;
            font-size: 0.7rem;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
        }

        .empty-icon {
            font-size: 3rem;
            color: var(--gray);
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            font-size: 1rem;
            color: var(--gray);
            font-weight: 500;
        }

        /* Modal */
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
            max-width: 450px;
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

        .mi-cyan {
            background: linear-gradient(135deg, #06b6d4, #0891b2);
        }

        .modal-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--dark);
        }

        .modal-subtitle {
            font-size: 0.8rem;
            color: var(--gray);
        }

        .form-group {
            padding: 1rem 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            font-size: 0.85rem;
            color: var(--dark);
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

        /* Responsive */
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
            .stock-banner {
                flex-direction: column;
                text-align: center;
            }
        }

        /* Animations */
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

<nav class="navbar">
    <div class="nav-container">
        <a class="logo" href="<%= ctx %>/"><i class="fas fa-heartbeat"></i><span>MediCare Plus</span></a>
        <div class="nav-links" id="navLinks">
            <a href="<%= ctx %>/secretaire">Dashboard</a>
            <a href="<%= ctx %>/secretaire?action=patients">Patients</a>
            <a href="<%= ctx %>/secretaire?action=rdv">Rendez-vous</a>
            <a href="<%= ctx %>/secretaire?action=materiels" class="active">Matériaux</a>
            <a href="<%= ctx %>/auth/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </div>
        <button class="menu-toggle" id="menuToggle"><i class="fas fa-bars"></i></button>
    </div>
</nav>

<main class="dashboard-main">
    <% if ("devis_cree".equals(success)) { %>
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i> Devis généré avec succès.
    </div>
    <% } %>

    <% if (alertes != null && !alertes.isEmpty()) { %>
    <div class="stock-banner">
        <i class="fas fa-exclamation-triangle"></i>
        <div>
            <strong><%= alertes.size() %> matériau(x) en alerte de stock</strong>
            <p>Vérifiez l'inventaire et générez des devis si nécessaire.</p>
        </div>
    </div>
    <% } %>

    <div class="card">
        <div class="card-header">
            <div class="card-title"><i class="fas fa-box-open"></i> Inventaire <span class="badge-count"><%= materiels != null ? materiels.size() : 0 %></span></div>
        </div>
        <% if (materiels == null || materiels.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon"><i class="fas fa-box-open"></i></div>
            <h3>Aucun matériel enregistré</h3>
        </div>
        <% } else { %>
        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                <tr><th>Matériel</th><th>Quantité</th><th>Seuil alerte</th><th>État</th><th>Devis</th></tr>
                </thead>
                <tbody>
                <% for (Materiel m : materiels) { %>
                <tr>
                    <td><strong class="text-dark"><%= m.getNom() %></strong></td>
                    <td><span style="font-size:1rem;font-weight:700;color:<%= m.isEnAlerte() ? "var(--danger)" : "var(--secondary)" %>;"><%= m.getQuantite() %></span></td>
                    <td class="text-muted"><%= m.getSeuilAlerte() %></td>
                    <td>
                        <% if (m.isEnAlerte()) { %>
                        <span class="badge badge-danger"><i class="fas fa-exclamation-triangle"></i> Alerte</span>
                        <% } else { %>
                        <span class="badge badge-success"><i class="fas fa-check"></i> OK</span>
                        <% } %>
                    </td>
                    <td>
                        <button onclick="openDevisModal(<%= m.getId() %>, '<%= m.getNom().replace("'","\\'") %>')"
                                class="btn btn-outline btn-sm"><i class="fas fa-file-invoice"></i> Devis</button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

    <% if (devis != null && !devis.isEmpty()) { %>
    <div class="card">
        <div class="card-header">
            <div class="card-title"><i class="fas fa-file-invoice"></i> Historique des devis <span class="badge-count"><%= devis.size() %></span></div>
        </div>
        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                <tr><th>Matériel</th><th>Quantité demandée</th><th>Date</th></tr>
                </thead>
                <tbody>
                <% for (DevisMateriel d : devis) { %>
                <tr>
                    <td><strong><%= d.getMateriel().getNom() %></strong></td>
                    <td><strong style="color:var(--primary);"><%= d.getQuantiteDemandee() %></strong></td>
                    <td class="text-muted"><%= d.getDateDevis() != null ? d.getDateDevis().toString().substring(0,10) : "—" %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>
</main>

<!-- Modal Devis -->
<div class="modal-overlay" id="devisModal">
    <div class="modal-box">
        <div class="modal-header">
            <div class="modal-icon mi-cyan"><i class="fas fa-file-invoice"></i></div>
            <div>
                <div class="modal-title">Générer un devis</div>
                <div class="modal-subtitle" id="devisNom"></div>
            </div>
        </div>
        <form method="post" action="<%= ctx %>/secretaire">
            <input type="hidden" name="action" value="genererDevis">
            <input type="hidden" name="materielId" id="devisMaterielId">
            <div class="form-group">
                <label class="form-label">Quantité souhaitée</label>
                <input type="number" name="quantite" class="form-control" required min="1" value="10">
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary"><i class="fas fa-file-invoice"></i> Générer</button>
                <button type="button" onclick="document.getElementById('devisModal').classList.remove('open')" class="btn btn-ghost">Annuler</button>
            </div>
        </form>
    </div>
</div>

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({ duration: 900, once: true, offset: 80, easing: 'ease-in-out' });

    document.getElementById('menuToggle')?.addEventListener('click', () => {
        document.getElementById('navLinks').classList.toggle('active');
        const icon = document.getElementById('menuToggle').querySelector('i');
        if (icon.classList.contains('fa-bars')) {
            icon.classList.remove('fa-bars');
            icon.classList.add('fa-times');
        } else {
            icon.classList.remove('fa-times');
            icon.classList.add('fa-bars');
        }
    });

    document.querySelectorAll('.nav-links a').forEach(link => {
        link.addEventListener('click', () => {
            document.getElementById('navLinks').classList.remove('active');
            const icon = document.getElementById('menuToggle').querySelector('i');
            if (icon) {
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            }
        });
    });

    function openDevisModal(id, nom) {
        document.getElementById('devisMaterielId').value = id;
        document.getElementById('devisNom').textContent = nom;
        document.getElementById('devisModal').classList.add('open');
    }

    document.querySelectorAll('.modal-overlay').forEach(m => {
        m.addEventListener('click', e => {
            if (e.target === m) m.classList.remove('open');
        });
    });
</script>
</body>
</html>