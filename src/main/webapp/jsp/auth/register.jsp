<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Inscription publique autorisée uniquement pour les patients.
    String role = "patient";

    String error = request.getParameter("error");
    String errorMessage = null;
    if (error != null) {
        switch(error) {
            case "email_exists":
                errorMessage = "Cet email est déjà utilisé";
                break;
            case "password_mismatch":
                errorMessage = "Les mots de passe ne correspondent pas";
                break;
            case "invalid_data":
                errorMessage = "Veuillez vérifier vos informations";
                break;
            default:
                errorMessage = "Une erreur est survenue";
        }
    }

    String roleTitle = "Patient";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription <%= roleTitle %> - MediCare Plus</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>

<div class="auth-container">
    <div class="logo">
        <a href="${pageContext.request.contextPath}/">
            <i class="fas fa-heartbeat logo-icon"></i>
            <span class="logo-text">MediCare Plus</span>
        </a>
    </div>

    <div class="auth-card">
        <div class="card-header">
            <h2>Créer un compte</h2>
            <p>Inscription <%= roleTitle %> (compte client)</p>
        </div>

        <% if (errorMessage != null) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <div class="alert-content"><%= errorMessage %></div>
        </div>
        <% } %>

        <form class="auth-form" id="registerForm" action="${pageContext.request.contextPath}/auth/register" method="post">
            <input type="hidden" name="role" value="patient">

            <div class="form-row">
                <div class="form-group">
                    <label>Prénom</label>
                    <div class="input-group">
                        <i class="fas fa-user"></i>
                        <input type="text" name="firstName" value="<%= request.getParameter("firstName") != null ? request.getParameter("firstName") : "" %>" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Nom</label>
                    <div class="input-group">
                        <i class="fas fa-user"></i>
                        <input type="text" name="lastName" value="<%= request.getParameter("lastName") != null ? request.getParameter("lastName") : "" %>" required>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label>Email</label>
                <div class="input-group">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" required>
                </div>
            </div>

            <div class="form-group">
                <label>Téléphone</label>
                <div class="input-group">
                    <i class="fas fa-phone"></i>
                    <input type="tel" name="phone" value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Mot de passe</label>
                    <div class="input-group">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="password" name="password" required>
                        <i class="fas fa-eye password-toggle" id="togglePassword"></i>
                    </div>
                </div>
                <div class="form-group">
                    <label>Confirmer</label>
                    <div class="input-group">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                        <i class="fas fa-eye password-toggle" id="toggleConfirmPassword"></i>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn-submit" id="submitBtn">
                <i class="fas fa-user-plus"></i> S'inscrire
            </button>
        </form>

        <div class="card-footer-links">
            <p>Déjà inscrit ? <a href="login.jsp?role=<%= role %>">Se connecter</a></p>
        </div>
    </div>

    <div class="back-home">
        <a href="${pageContext.request.contextPath}/">
            <i class="fas fa-arrow-left"></i> Retour à l'accueil
        </a>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/auth.js"></script>
</body>
</html>
