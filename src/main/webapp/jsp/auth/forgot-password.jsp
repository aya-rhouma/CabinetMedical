<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = request.getParameter("message");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mot de passe oublié - MediCare Plus</title>
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
            <div class="role-icon" style="background: linear-gradient(135deg, #f59e0b, #10b981);">
                <i class="fas fa-key"></i>
            </div>
            <h2>Mot de passe oublié</h2>
            <p>Nous vous enverrons un lien de réinitialisation</p>
        </div>

        <% if (message != null) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <div class="alert-content"><%= message %></div>
        </div>
        <% } %>

        <% if (error != null) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <div class="alert-content">Email non trouvé dans notre système</div>
        </div>
        <% } %>

        <form class="auth-form" id="forgotForm" action="${pageContext.request.contextPath}/auth/forgot-password" method="post">
            <div class="form-group">
                <label for="email">
                    <i class="fas fa-envelope"></i> Email
                </label>
                <div class="input-group">
                    <i class="fas fa-envelope"></i>
                    <input type="email" id="email" name="email"
                           placeholder="exemple@medicareplus.tn" required autofocus>
                </div>
            </div>

            <button type="submit" class="btn-submit" id="submitBtn">
                <i class="fas fa-paper-plane"></i>
                <span>Envoyer le lien</span>
            </button>
        </form>

        <div class="card-footer-links">
            <p><a href="login.jsp">Retour à la connexion</a></p>
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