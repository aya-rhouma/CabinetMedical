<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User, com.jee.entity.RendezVous, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (user.getRole() != User.Role.SECRETAIRE && user.getRole() != User.Role.ADMIN)) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp"); return;
    }
    String ctx = request.getContextPath();
    List<RendezVous> rdvs = (List<RendezVous>) request.getAttribute("rdvs");
    String selectedStatut = (String) request.getAttribute("selectedStatut");
    String selectedDate   = (String) request.getAttribute("selectedDate");
    if (selectedStatut == null) selectedStatut = "";
    if (selectedDate   == null) selectedDate   = "";
%>
<%!
    private String statutBadge(String s) {
        if (s == null) return "<span class=\"badge badge-gray\">—</span>";
        if ("CONFIRME".equals(s)) return "<span class=\"badge badge-success\"><i class=\"fas fa-check-circle\"></i> Confirmé</span>";
        if ("ANNULE".equals(s))   return "<span class=\"badge badge-danger\"><i class=\"fas fa-times-circle\"></i> Annulé</span>";
        if ("EFFECTUE".equals(s)) return "<span class=\"badge badge-info\"><i class=\"fas fa-check-double\"></i> Effectué</span>";
        if ("TERMINE".equals(s))  return "<span class=\"badge badge-violet\"><i class=\"fas fa-flag\"></i> Terminé</span>";
        return "<span class=\"badge badge-warning\"><i class=\"fas fa-clock\"></i> Planifié</span>";
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rendez-vous - MediCare Plus</title>
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

        /* Card */
        .card {
            background: white;
            border-radius: 24px;
            box-shadow: var(--shadow);
            overflow: hidden;
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
            animation-delay: 0.1s;
        }

        .card:hover {
            box-shadow: var(--shadow-lg);
        }

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

        /* Filter Bar */
        .filter-bar {
            padding: 1rem 1.5rem;
            display: flex;
            flex-wrap: wrap;
            align-items: flex-end;
            gap: 1rem;
            background: var(--light-gray);
            border-bottom: 1px solid var(--border);
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .filter-label {
            font-size: 0.7rem;
            font-weight: 600;
            color: var(--gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .filter-control {
            padding: 0.5rem 0.75rem;
            border: 1px solid var(--border);
            border-radius: 10px;
            font-size: 0.8rem;
            background: white;
            font-family: inherit;
        }

        .filter-control:focus {
            outline: none;
            border-color: var(--primary);
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

        .fw-bold {
            font-weight: 600;
        }

        .text-muted {
            color: var(--gray);
            font-size: 0.75rem;
        }

        /* User Cell */
        .user-cell {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .user-av {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 700;
            color: white;
        }

        .user-av.cyan {
            background: linear-gradient(135deg, #06b6d4, #0891b2);
        }

        .user-av.blue {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
        }

        .cell-name {
            font-weight: 600;
            font-size: 0.85rem;
            color: var(--dark);
        }

        .cell-sub {
            font-size: 0.7rem;
            color: var(--gray);
        }

        /* ID Badge */
        .id-badge {
            background: var(--light-gray);
            padding: 0.2rem 0.5rem;
            border-radius: 6px;
            font-family: monospace;
            font-size: 0.7rem;
            font-weight: 600;
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
        .badge-warning { background: #fed7aa; color: #9b3412; }
        .badge-info { background: #dbeafe; color: #1e40af; }
        .badge-violet { background: #ede9fe; color: #5b21b6; }
        .badge-gray { background: #f1f5f9; color: var(--gray); }

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

        .btn-icon {
            padding: 0.3rem 0.6rem;
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
            color: var(--dark);
            font-weight: 500;
            margin-bottom: 0.25rem;
        }

        .empty-state p {
            font-size: 0.8rem;
            color: var(--gray);
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

        .mi-cyan { background: linear-gradient(135deg, #06b6d4, #0891b2); }
        .mi-amber { background: linear-gradient(135deg, #f59e0b, #d97706); }

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
            padding: 1rem 1.5rem 0.5rem;
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
            font-size: 0.9rem;
            transition: var(--transition);
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
        }

        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            padding: 1rem 1.5rem;
        }

        .modal-footer {
            padding: 1rem 1.5rem 1.5rem;
            display: flex;
            justify-content: flex-end;
            gap: 0.75rem;
        }

        /* Responsive */
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
            .filter-bar {
                flex-direction: column;
                align-items: stretch;
            }
            .filter-group {
                width: 100%;
            }
            .filter-control {
                width: 100%;
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
            <a href="<%= ctx %>/secretaire?action=rdv" class="active">Rendez-vous</a>
            <a href="<%= ctx %>/secretaire?action=materiels">Matériaux</a>
            <a href="<%= ctx %>/auth/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </div>
        <button class="menu-toggle" id="menuToggle"><i class="fas fa-bars"></i></button>
    </div>
</nav>

<main class="dashboard-main">
    <div class="card">
        <form method="get" action="<%= ctx %>/secretaire">
            <input type="hidden" name="action" value="rdv">
            <div class="filter-bar">
                <div class="filter-group">
                    <span class="filter-label">Statut</span>
                    <select name="statut" class="filter-control">
                        <option value="">Tous les statuts</option>
                        <% String[] statuts = {"PLANIFIE","CONFIRME","ANNULE","EFFECTUE","TERMINE"};
                            String[] labels  = {"Planifié","Confirmé","Annulé","Effectué","Terminé"};
                            for (int i=0; i<statuts.length; i++) { %>
                        <option value="<%= statuts[i] %>" <%= selectedStatut.equals(statuts[i]) ? "selected" : "" %>><%= labels[i] %></option>
                        <% } %>
                    </select>
                </div>
                <div class="filter-group">
                    <span class="filter-label">Date</span>
                    <input type="date" name="dateRdv" class="filter-control" value="<%= selectedDate %>">
                </div>
                <div style="display:flex;gap:.5rem;align-items:flex-end;">
                    <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-filter"></i> Filtrer</button>
                    <a href="<%= ctx %>/secretaire?action=rdv" class="btn btn-ghost btn-sm"><i class="fas fa-times"></i> Reset</a>
                </div>
            </div>
        </form>

        <div class="card-header" style="border-top:1px solid var(--border);">
            <div class="card-title">
                <i class="fas fa-list"></i> Résultats
                <span class="badge-count"><%= rdvs != null ? rdvs.size() : 0 %></span>
            </div>
        </div>

        <% if (rdvs == null || rdvs.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon"><i class="fas fa-calendar-xmark"></i></div>
            <h3>Aucun rendez-vous trouvé</h3>
            <p>Modifiez les filtres.</p>
        </div>
        <% } else { %>
        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                <tr><th>#</th><th>Date &amp; Heure</th><th>Patient</th><th>Médecin</th><th>Statut</th><th>Paiement</th><th>Actions</th></tr>
                </thead>
                <tbody>
                <% for (RendezVous r : rdvs) { %>
                <tr>
                    <td><span class="id-badge">#<%= r.getId() %></span></td>
                    <td>
                        <div class="fw-bold"><%= r.getDateRdv() %></div>
                        <div class="text-muted"><i class="fas fa-clock" style="color:var(--primary);"></i> <%= r.getHeureDebut() %> – <%= r.getHeureFin() %></div>
                    </td>
                    <td>
                        <div class="user-cell">
                            <div class="user-av cyan"><%= r.getPatient().getPrenom().substring(0,1) %><%= r.getPatient().getNom().substring(0,1) %></div>
                            <div class="cell-name"><%= r.getPatient().getPrenom() %> <%= r.getPatient().getNom() %></div>
                        </div>
                    </td>
                    <td>
                        <div class="user-cell">
                            <div class="user-av blue"><i class="fas fa-user-doctor"></i></div>
                            <div><div class="cell-name">Dr <%= r.getMedecin().getNom() %></div><div class="cell-sub"><%= r.getMedecin().getSpecialite() %></div></div>
                        </div>
                    </td>
                    <td><%= statutBadge(r.getStatut()) %></td>
                    <td>
                        <% if (r.isPaye()) { %>
                        <span class="badge badge-success"><i class="fas fa-check"></i> Payé</span>
                        <% } else { %>
                        <form method="post" action="<%= ctx %>/secretaire" style="margin:0;">
                            <input type="hidden" name="action" value="marquerPaiement">
                            <input type="hidden" name="rdvId" value="<%= r.getId() %>">
                            <input type="hidden" name="paye" value="true">
                            <button type="submit" class="btn btn-outline btn-sm"><i class="fas fa-credit-card"></i> Marquer payé</button>
                        </form>
                        <% } %>
                    </td>
                    <td>
                        <div style="display:flex;gap:.4rem;">
                            <button onclick="openStatutModal(<%= r.getId() %>, '<%= r.getStatut() != null ? r.getStatut() : "" %>')"
                                    class="btn btn-primary btn-sm btn-icon" title="Changer statut">
                                <i class="fas fa-exchange-alt"></i>
                            </button>
                            <button onclick="openHoraireModal(<%= r.getId() %>, '<%= r.getDateRdv() %>', '<%= r.getHeureDebut() %>', '<%= r.getHeureFin() %>')"
                                    class="btn btn-outline btn-sm btn-icon" title="Modifier horaire">
                                <i class="fas fa-clock"></i>
                            </button>
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

<!-- Modal Statut -->
<div class="modal-overlay" id="statutModal">
    <div class="modal-box">
        <div class="modal-header">
            <div class="modal-icon mi-cyan"><i class="fas fa-exchange-alt"></i></div>
            <div><div class="modal-title">Changer le statut</div><div class="modal-subtitle">RDV #<span id="statutRdvId"></span></div></div>
        </div>
        <form method="post" action="<%= ctx %>/secretaire">
            <input type="hidden" name="action" value="changerStatut">
            <input type="hidden" name="rdvId" id="statutRdvIdInput">
            <div class="form-group">
                <label class="form-label">Nouveau statut</label>
                <select name="statut" id="statutSelect" class="form-control">
                    <option value="PLANIFIE">Planifié</option>
                    <option value="CONFIRME">Confirmé</option>
                    <option value="ANNULE">Annulé</option>
                    <option value="EFFECTUE">Effectué</option>
                    <option value="TERMINE">Terminé</option>
                </select>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Enregistrer</button>
                <button type="button" onclick="document.getElementById('statutModal').classList.remove('open')" class="btn btn-ghost">Annuler</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Horaire -->
<div class="modal-overlay" id="horaireModal">
    <div class="modal-box">
        <div class="modal-header">
            <div class="modal-icon mi-amber"><i class="fas fa-clock"></i></div>
            <div><div class="modal-title">Modifier l'horaire</div><div class="modal-subtitle">RDV #<span id="horaireRdvId"></span></div></div>
        </div>
        <form method="post" action="<%= ctx %>/secretaire">
            <input type="hidden" name="action" value="modifierHoraire">
            <input type="hidden" name="rdvId" id="horaireRdvIdInput">
            <div class="form-grid-2">
                <div class="form-group" style="grid-column:1/-1; padding:0;">
                    <label class="form-label">Date</label>
                    <input type="date" name="dateRdv" id="horaireDate" class="form-control" required>
                </div>
                <div class="form-group" style="padding:0;">
                    <label class="form-label">Heure début</label>
                    <input type="time" name="heureDebut" id="horaireDebut" class="form-control" required>
                </div>
                <div class="form-group" style="padding:0;">
                    <label class="form-label">Heure fin</label>
                    <input type="time" name="heureFin" id="horaireFin" class="form-control" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Enregistrer</button>
                <button type="button" onclick="document.getElementById('horaireModal').classList.remove('open')" class="btn btn-ghost">Annuler</button>
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

    function openStatutModal(id, statut) {
        document.getElementById('statutRdvId').textContent = id;
        document.getElementById('statutRdvIdInput').value  = id;
        document.getElementById('statutSelect').value = statut || 'PLANIFIE';
        document.getElementById('statutModal').classList.add('open');
    }

    function openHoraireModal(id, date, debut, fin) {
        document.getElementById('horaireRdvId').textContent = id;
        document.getElementById('horaireRdvIdInput').value  = id;
        document.getElementById('horaireDate').value  = date;
        document.getElementById('horaireDebut').value = debut;
        document.getElementById('horaireFin').value   = fin;
        document.getElementById('horaireModal').classList.add('open');
    }

    document.querySelectorAll('.modal-overlay').forEach(m => {
        m.addEventListener('click', e => {
            if (e.target === m) m.classList.remove('open');
        });
    });
</script>
</body>
</html>