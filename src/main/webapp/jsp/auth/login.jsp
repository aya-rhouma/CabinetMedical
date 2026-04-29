<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    // Gestion des paramètres de requête
    String error = request.getParameter("error");
    String logout = request.getParameter("logout");
    String adminAccess = request.getParameter("adminAccess");

    // Map des messages d'erreur
    Map<String, String> errorMessages = new HashMap<>();
    errorMessages.put("invalid_credentials", "Email ou mot de passe incorrect");
    errorMessages.put("account_locked", "Votre compte est verrouillé. Veuillez contacter l'administrateur");
    errorMessages.put("session_expired", "Votre session a expiré. Veuillez vous reconnecter");
    errorMessages.put("access_denied", "Vous n'avez pas les droits d'accès nécessaires");
    errorMessages.put("required_fields", "Veuillez remplir tous les champs obligatoires");

    String errorMessage = null;
    if (error != null && errorMessages.containsKey(error)) {
        errorMessage = errorMessages.get(error);
    } else if (error != null) {
        errorMessage = "Une erreur est survenue. Veuillez réessayer";
    }

    String successMessage = null;
    if (logout != null && logout.equals("success")) {
        successMessage = "Vous avez été déconnecté avec succès";
    }

    // Vérifier si l'accès restreint est activé
    boolean isRestrictedMode = "true".equals(adminAccess);

    // Récupérer le rôle
    String role = request.getParameter("role");
    String roleTitle = "";
    String roleIcon = "";
    String roleColor = "";

    if (role == null) role = "";

    // Définir les rôles selon le mode
    if (isRestrictedMode) {
        switch(role) {
            case "admin":
                roleTitle = "Espace Administrateur";
                roleIcon = "fas fa-user-shield";
                roleColor = "#ef4444";
                break;
            case "medecin":
                roleTitle = "Espace Médecin";
                roleIcon = "fas fa-user-md";
                roleColor = "#10b981";
                break;
            case "secretaire":
                roleTitle = "Espace Secrétaire";
                roleIcon = "fas fa-tasks";
                roleColor = "#f59e0b";
                break;
            default:
                roleTitle = "Mode Restreint";
                roleIcon = "fas fa-lock";
                roleColor = "#f59e0b";
        }
    } else {
        switch(role) {
            case "patient":
                roleTitle = "Espace Patient";
                roleIcon = "fas fa-user-circle";
                roleColor = "#0ea5e9";
                break;
            default:
                roleTitle = "Espace Patient";
                roleIcon = "fas fa-user-circle";
                roleColor = "#0ea5e9";
        }
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
    <meta name="description" content="Connexion à l'espace sécurisé de MediCare Plus">
    <title><%= roleTitle %> - MediCare Plus</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Auth CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">

    <style>
        /* Styles pour le modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9999;
            align-items: center;
            justify-content: center;
        }

        .modal.active {
            display: flex;
        }

        .modal-content {
            background: white;
            border-radius: 24px;
            padding: 2rem;
            max-width: 400px;
            width: 90%;
            text-align: center;
            animation: fadeInUp 0.3s ease;
        }

        .modal-icon {
            font-size: 3rem;
            color: var(--warning);
            margin-bottom: 1rem;
        }

        .modal-content h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: var(--dark);
        }

        .modal-content p {
            color: var(--gray);
            margin-bottom: 1.5rem;
        }

        .modal-input {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 1rem;
            margin-bottom: 1rem;
            font-family: 'Inter', sans-serif;
        }

        .modal-input:focus {
            outline: none;
            border-color: var(--primary);
        }

        .modal-buttons {
            display: flex;
            gap: 1rem;
        }

        .modal-btn {
            flex: 1;
            padding: 0.8rem;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
        }

        .modal-btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }

        .modal-btn-primary:hover {
            transform: translateY(-2px);
        }

        .modal-btn-secondary {
            background: var(--light-gray);
            color: var(--gray);
        }

        .modal-btn-secondary:hover {
            background: var(--border);
        }

        .modal-error {
            color: var(--danger);
            font-size: 0.8rem;
            margin-top: -0.5rem;
            margin-bottom: 1rem;
        }

        /* Style pour le sélecteur horizontal */
        .role-selector-horizontal {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .role-card-horizontal {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            padding: 1rem;
            background: var(--light-gray);
            border-radius: 16px;
            cursor: pointer;
            transition: var(--transition);
            border: 2px solid transparent;
            text-decoration: none;
        }

        .role-card-horizontal:hover {
            background: white;
            transform: translateY(-2px);
        }

        .role-card-horizontal.active {
            background: white;
            border-color: var(--primary);
            box-shadow: var(--shadow);
        }

        .role-card-horizontal i {
            font-size: 1.3rem;
            color: var(--primary);
        }

        .role-card-horizontal span {
            font-weight: 600;
            color: var(--dark);
        }

        .role-badge {
            background: var(--warning);
            color: white;
            padding: 0.2rem 0.6rem;
            border-radius: 50px;
            font-size: 0.65rem;
            font-weight: 600;
            margin-left: 0.5rem;
        }

        .role-badge-free {
            background: var(--secondary);
        }

        /* Style pour le mode restreint (3 rôles) */
        .admin-role-selector {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }

        .admin-role-btn {
            flex: 1;
            padding: 0.75rem;
            text-align: center;
            background: var(--light-gray);
            border-radius: 12px;
            text-decoration: none;
            color: var(--gray);
            font-weight: 500;
            transition: var(--transition);
        }

        .admin-role-btn i {
            margin-right: 0.5rem;
        }

        .admin-role-btn.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }

        .admin-role-btn:hover:not(.active) {
            background: var(--border);
            color: var(--dark);
        }

        .btn-back-link {
            display: inline-block;
            margin-top: 0.75rem;
            padding: 0.3rem 0.8rem;
            font-size: 0.8rem;
            text-decoration: none;
            background: var(--light-gray);
            color: var(--gray);
            border-radius: 8px;
            transition: var(--transition);
        }

        .btn-back-link:hover {
            background: var(--border);
            color: var(--dark);
        }

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

        @media (max-width: 480px) {
            .role-selector-horizontal {
                flex-direction: column;
            }

            .admin-role-selector {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<div class="auth-container">
    <!-- Logo -->
    <div class="logo">
        <a href="${pageContext.request.contextPath}/">
            <i class="fas fa-heartbeat logo-icon"></i>
            <span class="logo-text">MediCare Plus</span>
        </a>
    </div>

    <!-- Login Card -->
    <div class="auth-card">
        <div class="card-header">
            <div class="role-icon" style="background: linear-gradient(135deg, <%= roleColor %>, var(--secondary));">
                <i class="<%= roleIcon %>"></i>
            </div>
            <h2><%= roleTitle %></h2>
            <p>Connectez-vous à votre espace sécurisé</p>
        </div>

        <!-- Error Messages -->
        <% if (errorMessage != null) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <div class="alert-content"><%= errorMessage %></div>
        </div>
        <% } %>

        <% if (successMessage != null) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <div class="alert-content"><%= successMessage %></div>
        </div>
        <% } %>

        <!-- Role Selector -->
        <% if (isRestrictedMode) { %>
        <!-- Mode Restreint - 3 rôles horizontaux -->
        <div class="admin-role-selector">
            <a href="?adminAccess=true&role=admin" class="admin-role-btn <%= role.equals("admin") ? "active" : "" %>">
                <i class="fas fa-user-shield"></i> Administrateur
            </a>
            <a href="?adminAccess=true&role=medecin" class="admin-role-btn <%= role.equals("medecin") ? "active" : "" %>">
                <i class="fas fa-user-md"></i> Médecin
            </a>
            <a href="?adminAccess=true&role=secretaire" class="admin-role-btn <%= role.equals("secretaire") ? "active" : "" %>">
                <i class="fas fa-tasks"></i> Secrétaire
            </a>
        </div>
        <% } else { %>
        <!-- Mode Normal - 2 options horizontales -->
        <div class="role-selector-horizontal">
            <a href="?role=patient" class="role-card-horizontal <%= role.equals("patient") || role.isEmpty() ? "active" : "" %>">
                <i class="fas fa-user-circle"></i>
                <span>Patient</span>
                <span class="role-badge role-badge-free">Accès libre</span>
            </a>
            <div class="role-card-horizontal" onclick="openAdminModal(event)">
                <i class="fas fa-lock"></i>
                <span>Mode restreint</span>
                <span class="role-badge">Accès sécurisé</span>
            </div>
        </div>
        <% } %>

        <!-- Login Form -->
        <form class="auth-form" id="loginForm" action="${pageContext.request.contextPath}/auth/login" method="post">
            <input type="hidden" name="role" id="roleInput" value="<%= isRestrictedMode ? role : "patient" %>">

            <div class="form-group">
                <label for="email">
                    <i class="fas fa-envelope"></i> Email
                </label>
                <div class="input-group">
                    <i class="fas fa-envelope"></i>
                    <input type="email" id="email" name="email"
                           placeholder="exemple@medicareplus.tn"
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                           required autofocus>
                </div>
            </div>

            <div class="form-group">
                <label for="password">
                    <i class="fas fa-lock"></i> Mot de passe
                </label>
                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" id="password" name="password"
                           placeholder="••••••••" required>
                    <i class="fas fa-eye password-toggle" id="togglePassword"></i>
                </div>
            </div>

            <div class="form-options">
                <label class="checkbox">
                    <input type="checkbox" name="remember" value="true">
                    Se souvenir de moi
                </label>
                <a href="forgot-password.jsp" class="forgot-link">
                    Mot de passe oublié ?
                </a>
            </div>

            <button type="submit" class="btn-submit" id="submitBtn">
                <i class="fas fa-sign-in-alt"></i>
                <span>Se connecter</span>
            </button>
        </form>

        <!-- Footer Links -->
        <div class="card-footer-links">
            <% if (!isRestrictedMode) { %>
            <!-- Mode normal : afficher le lien création compte patient -->
            <p>Vous n'avez pas de compte patient ?
                <a href="register.jsp?role=patient">Créer un compte patient</a>
            </p>
            <p class="mt-2 mb-0 text-muted">
                Le mode restreint est réservé aux professionnels de santé.
            </p>
            <% } else { %>
            <!-- Mode restreint : ne pas afficher le lien création compte -->
            <p class="mt-2 mb-0 text-muted">
                <i class="fas fa-lock"></i> Mode restreint activé
            </p>
            <a href="?role=patient" class="btn-back-link">
                <i class="fas fa-arrow-left"></i> Retour espace patient
            </a>
            <% } %>
        </div>
    </div>

    <!-- Back to Home -->
    <div class="back-home">
        <a href="${pageContext.request.contextPath}/">
            <i class="fas fa-arrow-left"></i>
            Retour à l'accueil
        </a>
    </div>
</div>

<!-- Modal pour accès restreint -->
<div id="adminModal" class="modal">
    <div class="modal-content">
        <div class="modal-icon">
            <i class="fas fa-lock"></i>
        </div>
        <h3>Accès mode restreint</h3>
        <p>Cette section est réservée aux professionnels de santé (Administrateurs, Médecins, Secrétaires). Veuillez saisir le mot de passe d'accès.</p>
        <input type="password" id="accessPassword" class="modal-input" placeholder="Mot de passe d'accès">
        <div id="modalError" class="modal-error"></div>
        <div class="modal-buttons">
            <button class="modal-btn modal-btn-secondary" onclick="closeModal()">Annuler</button>
            <button class="modal-btn modal-btn-primary" onclick="verifyAccess()">Vérifier</button>
        </div>
    </div>
</div>

<script>
    const RESTRICTED_PASSWORD = "MediCarePlusRestricted";

    function openAdminModal(event) {
        if (event) event.preventDefault();
        const modal = document.getElementById('adminModal');
        const passwordInput = document.getElementById('accessPassword');
        const errorDiv = document.getElementById('modalError');

        passwordInput.value = '';
        errorDiv.textContent = '';
        modal.classList.add('active');
        passwordInput.focus();
    }

    function verifyAccess() {
        const password = document.getElementById('accessPassword').value;
        const errorDiv = document.getElementById('modalError');

        if (password === RESTRICTED_PASSWORD) {
            closeModal();
            window.location.href = '?adminAccess=true&role=admin';
        } else {
            errorDiv.textContent = 'Mot de passe incorrect. Accès refusé.';
        }
    }

    function closeModal() {
        const modal = document.getElementById('adminModal');
        modal.classList.remove('active');
    }

    // Fermer le modal en cliquant en dehors
    window.onclick = function(event) {
        const modal = document.getElementById('adminModal');
        if (event.target === modal) {
            closeModal();
        }
    }

    // Enter key on modal
    const passwordField = document.getElementById('accessPassword');
    if (passwordField) {
        passwordField.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                verifyAccess();
            }
        });
    }

    // Toggle password visibility
    const togglePassword = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');
    if (togglePassword) {
        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });
    }
</script>
</body>
</html>