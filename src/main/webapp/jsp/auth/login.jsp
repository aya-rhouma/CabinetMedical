<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    // Gestion des paramètres de requête
    String error = request.getParameter("error");
    String logout = request.getParameter("logout");

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

    // Récupérer le rôle
    String role = request.getParameter("role");
    String roleTitle = "";
    String roleIcon = "";
    String roleColor = "";

    if (role == null) role = "";

    switch(role) {
        case "patient":
            roleTitle = "Espace Patient";
            roleIcon = "fas fa-user-circle";
            roleColor = "#0ea5e9";
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
            roleTitle = "Connexion";
            roleIcon = "fas fa-sign-in-alt";
            roleColor = "#0ea5e9";
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
        <div class="role-selector">
            <a href="?role=patient" class="role-btn <%= role.equals("patient") ? "active" : "" %>">
                <i class="fas fa-user-circle"></i> Patient
            </a>
            <a href="?role=medecin" class="role-btn <%= role.equals("medecin") ? "active" : "" %>">
                <i class="fas fa-user-md"></i> Médecin
            </a>
            <a href="?role=secretaire" class="role-btn <%= role.equals("secretaire") ? "active" : "" %>">
                <i class="fas fa-tasks"></i> Secrétaire
            </a>
        </div>

        <!-- Login Form -->
        <form class="auth-form" id="loginForm" action="${pageContext.request.contextPath}/auth/login" method="post">
            <input type="hidden" name="role" value="<%= role %>">

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
            <p>Vous n'avez pas de compte ?
                <a href="register.jsp?role=patient">Créer un compte client</a>
            </p>
            <% if ("medecin".equals(role) || "secretaire".equals(role)) { %>
            <p class="mt-2 mb-0 text-muted">
                Les comptes médecin et secrétaire sont créés par l'administration.
            </p>
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

<!-- Auth JS -->
<script src="${pageContext.request.contextPath}/js/auth.js"></script>
</body>
</html>
