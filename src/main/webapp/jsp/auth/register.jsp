<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = request.getParameter("role");
    if (role == null) role = "patient";

    String error = request.getParameter("error");
    String errorMessage = null;
    if (error != null) {
        switch(error) {
            case "email_exists":
                errorMessage = "Cet email est déjà utilisé";
                break;
            case "cin_exists":
                errorMessage = "Ce numéro CIN est déjà utilisé";
                break;
            case "password_mismatch":
                errorMessage = "Les mots de passe ne correspondent pas";
                break;
            case "invalid_data":
                errorMessage = "Veuillez vérifier vos informations";
                break;
            case "invalid_cin":
                errorMessage = "Le numéro CIN doit contenir 8 chiffres";
                break;
            case "password_too_short":
                errorMessage = "Le mot de passe doit contenir au moins 8 caractères";
                break;
            case "password_weak":
                errorMessage = "Le mot de passe doit contenir au moins une majuscule et un chiffre";
                break;
            case "missing_specialite":
                errorMessage = "Veuillez sélectionner une spécialité";
                break;
            case "registration_failed":
                errorMessage = "Erreur lors de l'inscription. Veuillez réessayer.";
                break;
            default:
                errorMessage = "Une erreur est survenue";
        }
    }

    String success = request.getParameter("success");
    String successMessage = null;
    if (success != null && success.equals("true")) {
        successMessage = "Compte médecin créé avec succès ! Vous allez être redirigé vers votre espace.";
    }

    String roleTitle = role.equals("medecin") ? "Médecin" : "Patient";
    String roleIcon = role.equals("medecin") ? "fas fa-user-md" : "fas fa-user-circle";
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
    <style>
        /* Styles pour le sélecteur de rôle */
        .role-selector {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            padding: 0.5rem;
            background: var(--light-gray);
            border-radius: 16px;
        }

        .role-option {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            padding: 0.75rem;
            border-radius: 12px;
            cursor: pointer;
            transition: var(--transition);
            background: transparent;
            border: 2px solid transparent;
        }

        .role-option i {
            font-size: 1.2rem;
            color: var(--gray);
            transition: var(--transition);
        }

        .role-option span {
            font-weight: 500;
            color: var(--gray);
            transition: var(--transition);
        }

        .role-option:hover {
            background: rgba(14, 165, 233, 0.1);
        }

        .role-option.active {
            background: white;
            border-color: var(--primary);
            box-shadow: var(--shadow-sm);
        }

        .role-option.active i,
        .role-option.active span {
            color: var(--primary);
        }

        /* Styles spécifiques médecin */
        .medecin-fields {
            display: none;
            animation: fadeIn 0.3s ease;
        }

        .medecin-fields.show {
            display: block;
        }

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

        .info-banner {
            background: linear-gradient(135deg, #e0f2fe 0%, #f0f9ff 100%);
            padding: 0.75rem 1rem;
            border-radius: 12px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            border-left: 4px solid var(--primary);
        }

        .info-banner i {
            font-size: 1.2rem;
            color: var(--primary);
        }

        .info-banner p {
            margin: 0;
            font-size: 0.8rem;
            color: var(--gray);
        }

        .form-hint {
            font-size: 0.7rem;
            color: var(--gray);
            margin-top: 0.25rem;
        }

        .cin-input-group {
            position: relative;
        }

        .cin-input-group input {
            letter-spacing: 1px;
            font-family: monospace;
            font-size: 1.1rem;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
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
            <h2>Créer un compte</h2>
            <p>Inscription <%= roleTitle %></p>
        </div>

        <!-- Sélecteur de rôle -->
        <div class="role-selector">
            <div class="role-option <%= role.equals("patient") ? "active" : "" %>" data-role="patient">
                <i class="fas fa-user-circle"></i>
                <span>Patient</span>
            </div>
            <div class="role-option <%= role.equals("medecin") ? "active" : "" %>" data-role="medecin">
                <i class="fas fa-user-md"></i>
                <span>Médecin</span>
            </div>
        </div>

        <% if (successMessage != null) { %>
        <div class="alert alert-success" style="margin: 1rem 2rem;">
            <i class="fas fa-check-circle"></i>
            <div class="alert-content"><%= successMessage %></div>
        </div>
        <% } %>

        <% if (errorMessage != null) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <div class="alert-content"><%= errorMessage %></div>
        </div>
        <% } %>

        <!-- Formulaire Patient -->
        <form class="auth-form" id="patientForm" action="${pageContext.request.contextPath}/auth/register" method="post" style="<%= role.equals("medecin") ? "display: none;" : "" %>">
            <input type="hidden" name="role" value="patient">

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
                <label>Numéro CIN <span style="color: var(--danger);">*</span></label>
                <div class="input-group cin-input-group">
                    <i class="fas fa-id-card"></i>
                    <input type="text" name="cin" placeholder="12345678" maxlength="8"
                           pattern="[0-9]{8}" title="8 chiffres sans espaces"
                           value="<%= request.getParameter("cin") != null ? request.getParameter("cin") : "" %>" required>
                </div>
                <div class="form-hint">8 chiffres (ex: 12345678)</div>
            </div>

            <div class="form-group">
                <label>Email <span style="color: var(--danger);">*</span></label>
                <div class="input-group">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" required>
                </div>
            </div>

            <div class="form-group">
                <label>Téléphone <span style="color: var(--danger);">*</span></label>
                <div class="input-group">
                    <i class="fas fa-phone"></i>
                    <input type="tel" name="phone" value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Mot de passe <span style="color: var(--danger);">*</span></label>
                    <div class="input-group">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="passwordPatient" name="password" required>
                        <i class="fas fa-eye password-toggle" data-target="passwordPatient"></i>
                    </div>
                    <div class="form-hint">Minimum 8 caractères, 1 majuscule, 1 chiffre</div>
                </div>
                <div class="form-group">
                    <label>Confirmer <span style="color: var(--danger);">*</span></label>
                    <div class="input-group">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="confirmPasswordPatient" name="confirmPassword" required>
                        <i class="fas fa-eye password-toggle" data-target="confirmPasswordPatient"></i>
                    </div>
                </div>
            </div>

            <!-- Conditions pour patient -->
            <div class="form-group">
                <label class="checkbox" style="justify-content: center;">
                    <input type="checkbox" name="terms" required>
                    <span style="font-size: 0.8rem;">J'accepte les <a href="#" style="color: var(--primary);">conditions d'utilisation</a> et la <a href="#" style="color: var(--primary);">politique de confidentialité</a></span>
                </label>
            </div>

            <button type="submit" class="btn-submit">
                <i class="fas fa-user-plus"></i> Créer mon compte patient
            </button>
        </form>

        <!-- Formulaire Médecin -->
        <form class="auth-form" id="medecinForm" action="${pageContext.request.contextPath}/auth/register-medecin" method="post" enctype="multipart/form-data" style="<%= role.equals("medecin") ? "" : "display: none;" %>">
            <input type="hidden" name="role" value="medecin">

            <!-- Bannière information -->
            <div class="info-banner">
                <i class="fas fa-info-circle"></i>
                <p>Les médecins doivent fournir des informations professionnelles valides. Toutes les inscriptions sont vérifiées par notre équipe.</p>
            </div>

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
                <label>Numéro CIN <span style="color: var(--danger);">*</span></label>
                <div class="input-group cin-input-group">
                    <i class="fas fa-id-card"></i>
                    <input type="text" name="cin" placeholder="12345678" maxlength="8"
                           pattern="[0-9]{8}" title="8 chiffres sans espaces"
                           value="<%= request.getParameter("cin") != null ? request.getParameter("cin") : "" %>" required>
                </div>
                <div class="form-hint">8 chiffres (ex: 12345678)</div>
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
                            <option value="1-3 ans" <%= "1-3 ans".equals(request.getParameter("experience")) ? "selected" : "" %>>1-3 ans</option>
                            <option value="4-6 ans" <%= "4-6 ans".equals(request.getParameter("experience")) ? "selected" : "" %>>4-6 ans</option>
                            <option value="7-10 ans" <%= "7-10 ans".equals(request.getParameter("experience")) ? "selected" : "" %>>7-10 ans</option>
                            <option value="10+ ans" <%= "10+ ans".equals(request.getParameter("experience")) ? "selected" : "" %>>10+ ans</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Mot de passe <span style="color: var(--danger);">*</span></label>
                    <div class="input-group">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="passwordMedecin" name="password" required>
                        <i class="fas fa-eye password-toggle" data-target="passwordMedecin"></i>
                    </div>
                    <div class="form-hint">Minimum 8 caractères, 1 majuscule, 1 chiffre</div>
                </div>
                <div class="form-group">
                    <label>Confirmer <span style="color: var(--danger);">*</span></label>
                    <div class="input-group">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="confirmPasswordMedecin" name="confirmPassword" required>
                        <i class="fas fa-eye password-toggle" data-target="confirmPasswordMedecin"></i>
                    </div>
                </div>
            </div>

            <!-- Conditions pour médecin -->
            <div class="form-group">
                <label class="checkbox" style="justify-content: center;">
                    <input type="checkbox" name="terms" required>
                    <span style="font-size: 0.8rem;">Je certifie sur l'honneur l'exactitude des informations fournies et j'accepte les <a href="#" style="color: var(--primary);">conditions d'utilisation</a></span>
                </label>
            </div>

            <button type="submit" class="btn-submit">
                <i class="fas fa-user-md"></i> Créer mon compte médecin
            </button>
        </form>

        <div class="card-footer-links">
            <p>Déjà inscrit ? <a href="login.jsp?role=<%= role %>">Se connecter</a></p>
            <p style="margin-top: 0.5rem; font-size: 0.8rem;">
                <a href="${pageContext.request.contextPath}/">← Retour à l'accueil</a>
            </p>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/auth.js"></script>
<script>
    // Gestion du sélecteur de rôle
    const roleOptions = document.querySelectorAll('.role-option');
    const patientForm = document.getElementById('patientForm');
    const medecinForm = document.getElementById('medecinForm');
    const roleIcon = document.querySelector('.role-icon i');
    const cardHeader = document.querySelector('.card-header');

    function updateRole(role) {
        // Mettre à jour l'URL sans recharger
        const url = new URL(window.location.href);
        url.searchParams.set('role', role);
        window.history.pushState({}, '', url);

        // Mettre à jour les classes active
        roleOptions.forEach(opt => {
            if (opt.dataset.role === role) {
                opt.classList.add('active');
            } else {
                opt.classList.remove('active');
            }
        });

        // Afficher/masquer les formulaires
        if (role === 'patient') {
            patientForm.style.display = 'block';
            medecinForm.style.display = 'none';
            roleIcon.className = 'fas fa-user-circle';
            document.querySelector('.card-header p').textContent = 'Inscription Patient (compte client)';
        } else {
            patientForm.style.display = 'none';
            medecinForm.style.display = 'block';
            roleIcon.className = 'fas fa-user-md';
            document.querySelector('.card-header p').textContent = 'Inscription Médecin (professionnel de santé)';
        }
    }

    roleOptions.forEach(option => {
        option.addEventListener('click', () => {
            const role = option.dataset.role;
            updateRole(role);
        });
    });

    // Gestion de l'affichage des mots de passe
    document.querySelectorAll('.password-toggle').forEach(toggle => {
        toggle.addEventListener('click', function() {
            const targetId = this.dataset.target;
            const input = document.getElementById(targetId);
            if (input) {
                const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
                input.setAttribute('type', type);
                this.classList.toggle('fa-eye');
                this.classList.toggle('fa-eye-slash');
            }
        });
    });

    // Validation du format CIN
    function validateCIN(cin) {
        const cinRegex = /^[0-9]{8}$/;
        return cinRegex.test(cin);
    }

    // Validation des formulaires
    function validatePassword(password, confirm, errorPrefix) {
        if (password.length < 8) {
            alert('Le mot de passe doit contenir au moins 8 caractères');
            return false;
        }
        if (password !== confirm) {
            alert('Les mots de passe ne correspondent pas');
            return false;
        }
        if (!/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
            alert('Le mot de passe doit contenir au moins une majuscule et un chiffre');
            return false;
        }
        return true;
    }

    // Validation patient
    if (patientForm) {
        patientForm.addEventListener('submit', function(e) {
            const cin = document.querySelector('#patientForm input[name="cin"]').value;
            if (!validateCIN(cin)) {
                e.preventDefault();
                alert('Le numéro CIN doit contenir exactement 8 chiffres');
                return;
            }

            const password = document.getElementById('passwordPatient').value;
            const confirm = document.getElementById('confirmPasswordPatient').value;
            if (!validatePassword(password, confirm, 'patient')) {
                e.preventDefault();
            }

            const terms = document.querySelector('#patientForm input[name="terms"]');
            if (terms && !terms.checked) {
                e.preventDefault();
                alert('Veuillez accepter les conditions d\'utilisation');
            }
        });
    }

    // Validation médecin
    if (medecinForm) {
        medecinForm.addEventListener('submit', function(e) {
            const cin = document.querySelector('#medecinForm input[name="cin"]').value;
            if (!validateCIN(cin)) {
                e.preventDefault();
                alert('Le numéro CIN doit contenir exactement 8 chiffres');
                return;
            }

            const password = document.getElementById('passwordMedecin').value;
            const confirm = document.getElementById('confirmPasswordMedecin').value;
            if (!validatePassword(password, confirm, 'medecin')) {
                e.preventDefault();
            }

            const terms = document.querySelector('#medecinForm input[name="terms"]');
            if (terms && !terms.checked) {
                e.preventDefault();
                alert('Veuillez accepter les conditions d\'utilisation');
            }
        });
    }

    // Formatage automatique du CIN (uniquement chiffres)
    document.querySelectorAll('input[name="cin"]').forEach(input => {
        input.addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '').slice(0, 8);
        });
    });
</script>
</body>
</html>