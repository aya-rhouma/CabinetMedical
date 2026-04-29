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

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* ============================================
           VARIABLES CSS
           ============================================ */
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            position: relative;
        }

        /* Background decoration */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.1)" fill-opacity="1" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,122.7C672,117,768,139,864,154.7C960,171,1056,181,1152,165.3C1248,149,1344,107,1392,85.3L1440,64L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') no-repeat bottom;
            background-size: cover;
            opacity: 0.15;
        }

        /* Container */
        .auth-container {
            width: 100%;
            max-width: 480px;
            position: relative;
            z-index: 1;
            animation: fadeInUp 0.6s ease;
        }

        /* Logo */
        .logo {
            text-align: center;
            margin-bottom: 2rem;
        }

        .logo a {
            text-decoration: none;
        }

        .logo-icon {
            font-size: 3rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            display: inline-block;
        }

        .logo-text {
            font-size: 1.8rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-left: 0.5rem;
        }

        /* Auth Card */
        .auth-card {
            background: white;
            border-radius: 24px;
            box-shadow: var(--shadow-xl);
            overflow: hidden;
            transition: var(--transition);
        }

        .auth-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 40px -12px rgba(0, 0, 0, 0.25);
        }

        /* Card Header */
        .card-header {
            background: linear-gradient(135deg, #f8fafc, #ffffff);
            padding: 2rem;
            text-align: center;
            border-bottom: 1px solid var(--border);
        }

        .role-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            color: white;
            font-size: 2rem;
        }

        .card-header h2 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 0.5rem;
        }

        .card-header p {
            color: var(--gray);
            font-size: 0.9rem;
        }

        /* Alerts */
        .alert {
            padding: 1rem;
            margin: 1rem 2rem;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: slideIn 0.3s ease;
        }

        .alert-error {
            background: #fee2e2;
            color: var(--danger);
            border-left: 4px solid var(--danger);
        }

        .alert-success {
            background: #d1fae5;
            color: var(--secondary);
            border-left: 4px solid var(--secondary);
        }

        .alert i {
            font-size: 1.2rem;
        }

        .alert-content {
            flex: 1;
            font-size: 0.9rem;
        }

        /* Role Selector Horizontal */
        .role-selector-horizontal {
            display: flex;
            gap: 1rem;
            margin: 1rem 2rem;
        }

        .role-card-horizontal {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            padding: 0.75rem;
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
            font-size: 1.2rem;
            color: var(--primary);
        }

        .role-card-horizontal span {
            font-weight: 600;
            color: var(--dark);
            font-size: 0.9rem;
        }

        .role-badge {
            background: var(--warning);
            color: white;
            padding: 0.2rem 0.5rem;
            border-radius: 50px;
            font-size: 0.6rem;
            font-weight: 600;
            margin-left: 0.25rem;
        }

        .role-badge-free {
            background: var(--secondary);
        }

        /* Admin Role Selector */
        .admin-role-selector {
            display: flex;
            gap: 1rem;
            margin: 1rem 2rem;
            flex-wrap: wrap;
        }

        .admin-role-btn {
            flex: 1;
            padding: 0.6rem;
            text-align: center;
            background: var(--light-gray);
            border-radius: 12px;
            text-decoration: none;
            color: var(--gray);
            font-weight: 500;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            font-size: 0.85rem;
        }

        .admin-role-btn i {
            font-size: 1rem;
        }

        .admin-role-btn.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }

        .admin-role-btn:hover:not(.active) {
            background: var(--border);
            color: var(--dark);
            transform: translateY(-2px);
        }

        /* Login Form */
        .auth-form {
            padding: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--dark);
            font-size: 0.9rem;
        }

        .form-group label i {
            margin-right: 0.5rem;
            color: var(--primary);
        }

        .input-group {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-group i:first-child {
            position: absolute;
            left: 1rem;
            color: var(--gray);
            font-size: 1rem;
        }

        .input-group input {
            width: 100%;
            padding: 0.85rem 1rem 0.85rem 2.8rem;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 1rem;
            transition: var(--transition);
        }

        .input-group input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
        }

        .password-toggle {
            position: absolute;
            right: 1rem;
            left: auto !important;
            cursor: pointer;
            color: var(--gray);
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .checkbox {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            font-size: 0.85rem;
            color: var(--gray);
        }

        .checkbox input {
            width: 16px;
            height: 16px;
            cursor: pointer;
            accent-color: var(--primary);
        }

        .forgot-link {
            color: var(--primary);
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .forgot-link:hover {
            text-decoration: underline;
        }

        .btn-submit {
            width: 100%;
            padding: 0.85rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        /* Footer Links */
        .card-footer-links {
            padding: 1.5rem;
            text-align: center;
            border-top: 1px solid var(--border);
            background: var(--light-gray);
        }

        .card-footer-links p {
            color: var(--gray);
            font-size: 0.85rem;
        }

        .card-footer-links a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }

        .card-footer-links a:hover {
            text-decoration: underline;
        }

        .btn-back-link {
            display: inline-block;
            margin-top: 0.5rem;
            padding: 0.3rem 0.8rem;
            font-size: 0.8rem;
            text-decoration: none;
            background: var(--light-gray);
            color: var(--gray);
            border-radius: 8px;
        }

        .btn-back-link:hover {
            background: var(--border);
            color: var(--dark);
        }

        .text-muted {
            color: var(--gray);
            font-size: 0.75rem;
            margin-top: 0.5rem;
        }

        /* Back to Home */
        .back-home {
            text-align: center;
            margin-top: 2rem;
        }

        .back-home a {
            color: white;
            text-decoration: none;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            opacity: 0.8;
            transition: var(--transition);
        }

        .back-home a:hover {
            opacity: 1;
            gap: 0.75rem;
        }

        /* Modal */
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
            font-size: 1.3rem;
            margin-bottom: 0.5rem;
            color: var(--dark);
        }

        .modal-content p {
            color: var(--gray);
            margin-bottom: 1rem;
            font-size: 0.85rem;
        }

        .modal-input {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 1rem;
            margin-bottom: 1rem;
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
            padding: 0.7rem;
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

        .modal-btn-secondary {
            background: var(--light-gray);
            color: var(--gray);
        }

        .modal-error {
            color: var(--danger);
            font-size: 0.75rem;
            margin-top: -0.5rem;
            margin-bottom: 1rem;
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

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        /* Responsive */
        @media (max-width: 640px) {
            body {
                padding: 1rem;
            }

            .role-selector-horizontal,
            .admin-role-selector {
                flex-direction: column;
                margin: 1rem;
            }

            .admin-role-btn {
                width: 100%;
            }

            .auth-form {
                padding: 1.5rem;
            }

            .card-header {
                padding: 1.5rem;
            }

            .card-header h2 {
                font-size: 1.5rem;
            }

            .form-options {
                flex-direction: column;
                align-items: flex-start;
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
            <p>Vous n'avez pas de compte patient ?
                <a href="register.jsp?role=patient">Créer un compte patient</a>
            </p>
            <p class="text-muted">
                Le mode restreint est réservé aux professionnels de santé.
            </p>
            <% } else { %>
            <p class="text-muted">
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
        <p>Cette section est réservée aux professionnels de santé. Veuillez saisir le mot de passe d'accès.</p>
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