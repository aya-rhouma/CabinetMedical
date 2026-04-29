<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jee.entity.User" %>
<%
    // Vérifier si l'utilisateur est admin ou si un token d'invitation est présent
    User currentUser = (User) session.getAttribute("user");
    String invitationToken = request.getParameter("token");

    boolean isAdmin = (currentUser != null && currentUser.getRole() == User.Role.ADMIN);
    boolean hasValidToken = "MEDECIN_INVITE_2026".equals(invitationToken); // Token temporaire

    // Rediriger si ni admin ni token valide
    if (!isAdmin && !hasValidToken) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }

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

    String success = request.getParameter("success");
    String successMessage = null;
    if (success != null && success.equals("true")) {
        successMessage = "Compte médecin créé avec succès ! Un email de confirmation a été envoyé.";
    }

    String roleTitle = "Médecin";
    String roleIcon = "fas fa-user-md";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription Médecin - MediCare Plus</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
    <style>
        /* Styles supplémentaires pour le formulaire médecin */
        .specialite-select {
            width: 100%;
            padding: 0.85rem 1rem;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 1rem;
            font-family: 'Inter', sans-serif;
            transition: var(--transition);
            background: white;
        }

        .specialite-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
        }

        .specialite-select option {
            padding: 0.5rem;
        }

        .info-banner {
            background: linear-gradient(135deg, #e0f2fe 0%, #f0f9ff 100%);
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            border-left: 4px solid var(--primary);
        }

        .info-banner i {
            font-size: 1.5rem;
            color: var(--primary);
        }

        .info-banner p {
            margin: 0;
            font-size: 0.85rem;
            color: var(--gray);
        }

        .admin-badge {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 0.2rem 0.8rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            margin-left: 0.5rem;
        }

        .form-hint {
            font-size: 0.7rem;
            color: var(--gray);
            margin-top: 0.25rem;
        }

        .diplome-upload {
            border: 2px dashed var(--border);
            border-radius: 12px;
            padding: 1rem;
            text-align: center;
            cursor: pointer;
            transition: var(--transition);
        }

        .diplome-upload:hover {
            border-color: var(--primary);
            background: var(--light-gray);
        }

        .diplome-upload i {
            font-size: 2rem;
            color: var(--gray);
            margin-bottom: 0.5rem;
        }

        .diplome-upload p {
            font-size: 0.8rem;
            color: var(--gray);
            margin: 0;
        }

        .file-name {
            font-size: 0.7rem;
            color: var(--primary);
            margin-top: 0.5rem;
        }
    </style>
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
            <div class="role-icon" style="background: linear-gradient(135deg, var(--primary), var(--secondary));">
                <i class="<%= roleIcon %>"></i>
            </div>
            <h2>Créer un compte médecin</h2>
            <p>Inscription réservée aux professionnels de santé</p>
        </div>

        <!-- Bannière d'information -->
        <div class="info-banner" style="margin: 1rem 2rem 0 2rem;">
            <i class="fas fa-info-circle"></i>
            <p>Les médecins doivent fournir des informations professionnelles valides. Toutes les inscriptions sont vérifiées par notre équipe.</p>
        </div>

        <% if (isAdmin) { %>
        <div style="margin: 1rem 2rem 0 2rem; text-align: center;">
            <span class="admin-badge">
                <i class="fas fa-user-shield"></i> Création par administrateur
            </span>
        </div>
        <% } %>

        <% if (successMessage != null) { %>
        <div class="alert alert-success" style="margin: 1rem 2rem;">
            <i class="fas fa-check-circle"></i>
            <div class="alert-content"><%= successMessage %></div>
        </div>
        <% } %>

        <% if (errorMessage != null) { %>
        <div class="alert alert-error" style="margin: 1rem 2rem;">
            <i class="fas fa-exclamation-circle"></i>
            <div class="alert-content"><%= errorMessage %></div>
        </div>
        <% } %>

        <form class="auth-form" id="registerForm" action="${pageContext.request.contextPath}/auth/register-medecin" method="post" enctype="multipart/form-data">
            <input type="hidden" name="role" value="medecin">
            <% if (isAdmin) { %>
            <input type="hidden" name="createdByAdmin" value="true">
            <% } %>

            <!-- Informations personnelles -->
            <div class="form-row">
                <div class="form-group">
                    <label>Prénom <span style="color: var(--danger);">*</span></label>
                    <div class="input-group">
                        <i class="fas fa-user"></i>
                        <input type="text" name="firstName" value="<%= request.getParameter("firstName") != null ? request.getParameter("firstName") : "" %>" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Nom <span style="color: var(--danger);">*</span></label>
                    <div class="input-group">
                        <i class="fas fa-user"></i>
                        <input type="text" name="lastName" value="<%= request.getParameter("lastName") != null ? request.getParameter("lastName") : "" %>" required>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label>Email professionnel <span style="color: var(--danger);">*</span></label>
                <div class="input-group">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" placeholder="dr.nom@medecin.tn" value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" required>
                </div>
                <div class="form-hint">Utilisez votre email professionnel pour recevoir les communications officielles.</div>
            </div>

            <div class="form-group">
                <label>Téléphone <span style="color: var(--danger);">*</span></label>
                <div class="input-group">
                    <i class="fas fa-phone"></i>
                    <input type="tel" name="phone" placeholder="+216 XX XXX XXX" value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>" required>
                </div>
            </div>

            <!-- Informations professionnelles -->
            <div class="form-group">
                <label>Spécialité médicale <span style="color: var(--danger);">*</span></label>
                <div class="input-group">
                    <i class="fas fa-stethoscope"></i>
                    <select name="specialite" class="specialite-select" required>
                        <option value="">Sélectionnez une spécialité</option>
                        <option value="Cardiologue" <%= "Cardiologue".equals(request.getParameter("specialite")) ? "selected" : "" %>>Cardiologue</option>
                        <option value="Dermatologue" <%= "Dermatologue".equals(request.getParameter("specialite")) ? "selected" : "" %>>Dermatologue</option>
                        <option value="Pédiatre" <%= "Pédiatre".equals(request.getParameter("specialite")) ? "selected" : "" %>>Pédiatre</option>
                        <option value="Gynécologue" <%= "Gynécologue".equals(request.getParameter("specialite")) ? "selected" : "" %>>Gynécologue</option>
                        <option value="Ophtalmologue" <%= "Ophtalmologue".equals(request.getParameter("specialite")) ? "selected" : "" %>>Ophtalmologue</option>
                        <option value="Orthopédiste" <%= "Orthopédiste".equals(request.getParameter("specialite")) ? "selected" : "" %>>Orthopédiste</option>
                        <option value="Psychiatre" <%= "Psychiatre".equals(request.getParameter("specialite")) ? "selected" : "" %>>Psychiatre</option>
                        <option value="Généraliste" <%= "Généraliste".equals(request.getParameter("specialite")) ? "selected" : "" %>>Médecin Généraliste</option>
                        <option value="Neurologue" <%= "Neurologue".equals(request.getParameter("specialite")) ? "selected" : "" %>>Neurologue</option>
                        <option value="Radiologue" <%= "Radiologue".equals(request.getParameter("specialite")) ? "selected" : "" %>>Radiologue</option>
                        <option value="Urologue" <%= "Urologue".equals(request.getParameter("specialite")) ? "selected" : "" %>>Urologue</option>
                        <option value="ORL" <%= "ORL".equals(request.getParameter("specialite")) ? "selected" : "" %>>ORL</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Numéro de licence/RPPS</label>
                    <div class="input-group">
                        <i class="fas fa-id-card"></i>
                        <input type="text" name="licenceNumber" placeholder="Numéro d'inscription à l'ordre" value="<%= request.getParameter("licenceNumber") != null ? request.getParameter("licenceNumber") : "" %>">
                    </div>
                    <div class="form-hint">Optionnel mais recommandé pour la vérification</div>
                </div>
                <div class="form-group">
                    <label>Années d'expérience</label>
                    <div class="input-group">
                        <i class="fas fa-briefcase"></i>
                        <select name="experience" class="specialite-select">
                            <option value="">Sélectionnez</option>
                            <option value="1-3 ans">1-3 ans</option>
                            <option value="4-6 ans">4-6 ans</option>
                            <option value="7-10 ans">7-10 ans</option>
                            <option value="10+ ans">10+ ans</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label>Diplôme/certificat (PDF)</label>
                <div class="diplome-upload" onclick="document.getElementById('diplomeFile').click()">
                    <i class="fas fa-cloud-upload-alt"></i>
                    <p>Cliquez pour télécharger votre diplôme</p>
                    <input type="file" id="diplomeFile" name="diplome" accept=".pdf,.jpg,.png" style="display: none;">
                    <div id="fileName" class="file-name"></div>
                </div>
                <div class="form-hint">Format PDF, JPG ou PNG. Max 5 Mo.</div>
            </div>

            <!-- Sécurité -->
            <div class="form-row">
                <div class="form-group">
                    <label>Mot de passe <span style="color: var(--danger);">*</span></label>
                    <div class="input-group">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="password" name="password" required>
                        <i class="fas fa-eye password-toggle" id="togglePassword"></i>
                    </div>
                    <div class="form-hint">Minimum 8 caractères, 1 majuscule, 1 chiffre</div>
                </div>
                <div class="form-group">
                    <label>Confirmer <span style="color: var(--danger);">*</span></label>
                    <div class="input-group">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                        <i class="fas fa-eye password-toggle" id="toggleConfirmPassword"></i>
                    </div>
                </div>
            </div>

            <!-- Conditions -->
            <div class="form-group">
                <label class="checkbox" style="justify-content: center;">
                    <input type="checkbox" name="terms" required>
                    <span style="font-size: 0.8rem;">J'accepte les <a href="#" style="color: var(--primary);">conditions d'utilisation</a> et la <a href="#" style="color: var(--primary);">politique de confidentialité</a></span>
                </label>
            </div>

            <button type="submit" class="btn-submit" id="submitBtn">
                <i class="fas fa-user-md"></i> Créer mon compte médecin
            </button>
        </form>

        <div class="card-footer-links">
            <p>Déjà un compte ? <a href="login.jsp?role=medecin">Se connecter</a></p>
            <p style="margin-top: 0.5rem; font-size: 0.8rem;">
                <a href="${pageContext.request.contextPath}/">← Retour à l'accueil</a>
            </p>
        </div>
    </div>

    <% if (!isAdmin) { %>
    <div class="back-home">
        <p style="color: white; font-size: 0.8rem; opacity: 0.7;">
            Vous êtes un médecin ? Créez votre compte pour commencer à consulter vos patients.
        </p>
    </div>
    <% } %>
</div>

<script src="${pageContext.request.contextPath}/js/auth.js"></script>
<script>
    // Affichage du nom du fichier sélectionné
    const fileInput = document.getElementById('diplomeFile');
    const fileNameSpan = document.getElementById('fileName');

    if (fileInput) {
        fileInput.addEventListener('change', function() {
            if (this.files && this.files[0]) {
                fileNameSpan.textContent = this.files[0].name;
                fileNameSpan.style.color = 'var(--secondary)';
            } else {
                fileNameSpan.textContent = '';
            }
        });
    }

    // Validation du mot de passe
    const registerForm = document.getElementById('registerForm');
    const passwordInput = document.getElementById('password');
    const confirmInput = document.getElementById('confirmPassword');

    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            const password = passwordInput.value;
            const confirm = confirmInput.value;

            // Vérification longueur
            if (password.length < 8) {
                e.preventDefault();
                alert('Le mot de passe doit contenir au moins 8 caractères');
                passwordInput.focus();
                return;
            }

            // Vérification correspondance
            if (password !== confirm) {
                e.preventDefault();
                alert('Les mots de passe ne correspondent pas');
                confirmInput.focus();
                return;
            }

            // Vérification majuscule et chiffre
            if (!/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
                e.preventDefault();
                alert('Le mot de passe doit contenir au moins une majuscule et un chiffre');
                passwordInput.focus();
                return;
            }
        });
    }

    // Password visibility toggle
    const togglePassword = document.getElementById('togglePassword');
    const toggleConfirm = document.getElementById('toggleConfirmPassword');

    if (togglePassword) {
        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });
    }

    if (toggleConfirm) {
        toggleConfirm.addEventListener('click', function() {
            const type = confirmInput.getAttribute('type') === 'password' ? 'text' : 'password';
            confirmInput.setAttribute('type', type);
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });
    }
</script>
</body>
</html>
