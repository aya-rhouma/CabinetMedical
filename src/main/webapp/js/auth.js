/**
 * Authentication JavaScript Module
 * Handles all authentication page interactions
 */

const AuthModule = (function() {
    'use strict';

    // DOM Elements
    let elements = {};

    // Configuration
    const config = {
        autoHideAlertsDelay: 5000,
        loadingTimeout: 10000,
        passwordMinLength: 6
    };

    /**
     * Initialize all authentication functionality
     */
    function init() {
        cacheElements();
        bindEvents();
        initPasswordToggles();
        initAutoHideAlerts();
        initFormValidation();
        initRememberEmail();
    }

    /**
     * Cache DOM elements
     */
    function cacheElements() {
        elements = {
            loginForm: document.getElementById('loginForm'),
            registerForm: document.getElementById('registerForm'),
            forgotForm: document.getElementById('forgotForm'),
            submitBtn: document.getElementById('submitBtn'),
            emailInput: document.getElementById('email'),
            passwordInput: document.getElementById('password'),
            confirmPassword: document.getElementById('confirmPassword'),
            togglePassword: document.getElementById('togglePassword'),
            toggleConfirmPassword: document.getElementById('toggleConfirmPassword')
        };
    }

    /**
     * Bind event listeners
     */
    function bindEvents() {
        // Login form submission
        if (elements.loginForm) {
            elements.loginForm.addEventListener('submit', handleLoginSubmit);
        }

        // Register form submission
        if (elements.registerForm) {
            elements.registerForm.addEventListener('submit', handleRegisterSubmit);
        }

        // Forgot password form submission
        if (elements.forgotForm) {
            elements.forgotForm.addEventListener('submit', handleForgotSubmit);
        }
    }

    /**
     * Initialize password visibility toggles
     */
    function initPasswordToggles() {
        // Toggle for password field
        if (elements.togglePassword && elements.passwordInput) {
            elements.togglePassword.addEventListener('click', function() {
                togglePasswordVisibility(elements.passwordInput, this);
            });
        }

        // Toggle for confirm password field
        if (elements.toggleConfirmPassword && elements.confirmPassword) {
            elements.toggleConfirmPassword.addEventListener('click', function() {
                togglePasswordVisibility(elements.confirmPassword, this);
            });
        }
    }

    /**
     * Toggle password visibility
     */
    function togglePasswordVisibility(inputField, toggleIcon) {
        const type = inputField.getAttribute('type') === 'password' ? 'text' : 'password';
        inputField.setAttribute('type', type);
        toggleIcon.classList.toggle('fa-eye');
        toggleIcon.classList.toggle('fa-eye-slash');
    }

    /**
     * Handle login form submission
     */
    function handleLoginSubmit(e) {
        let isValid = validateLoginForm();

        if (!isValid) {
            e.preventDefault();
            return false;
        }

        showLoadingState(elements.submitBtn, 'Connexion en cours...');
        return true;
    }

    /**
     * Handle register form submission
     */
    function handleRegisterSubmit(e) {
        let isValid = validateRegisterForm();

        if (!isValid) {
            e.preventDefault();
            return false;
        }

        showLoadingState(elements.submitBtn, 'Inscription en cours...');
        return true;
    }

    /**
     * Handle forgot password form submission
     */
    function handleForgotSubmit(e) {
        let isValid = validateForgotForm();

        if (!isValid) {
            e.preventDefault();
            return false;
        }

        showLoadingState(elements.submitBtn, 'Envoi en cours...');
        return true;
    }

    /**
     * Validate login form
     */
    function validateLoginForm() {
        let isValid = true;

        // Reset error states
        removeErrorStyles();

        // Email validation
        const email = elements.emailInput ? elements.emailInput.value.trim() : '';
        const emailRegex = /^[^\s@]+@([^\s@]+\.)+[^\s@]+$/;

        if (!email) {
            showFieldError(elements.emailInput, 'Veuillez entrer votre email');
            isValid = false;
        } else if (!emailRegex.test(email)) {
            showFieldError(elements.emailInput, 'Veuillez entrer une adresse email valide');
            isValid = false;
        }

        // Password validation
        const password = elements.passwordInput ? elements.passwordInput.value : '';

        if (!password) {
            showFieldError(elements.passwordInput, 'Veuillez entrer votre mot de passe');
            isValid = false;
        } else if (password.length < config.passwordMinLength) {
            showFieldError(elements.passwordInput, `Le mot de passe doit contenir au moins ${config.passwordMinLength} caractères`);
            isValid = false;
        }

        if (!isValid) {
            showTemporaryError('Veuillez corriger les erreurs ci-dessus');
        }

        return isValid;
    }

    /**
     * Validate register form
     */
    function validateRegisterForm() {
        let isValid = true;

        // Reset error states
        removeErrorStyles();

        // Get all form inputs
        const firstName = document.querySelector('input[name="firstName"]');
        const lastName = document.querySelector('input[name="lastName"]');
        const email = document.querySelector('input[name="email"]');
        const phone = document.querySelector('input[name="phone"]');
        const password = document.querySelector('input[name="password"]');
        const confirmPassword = document.querySelector('input[name="confirmPassword"]');

        // First name validation
        if (!firstName || !firstName.value.trim()) {
            showFieldError(firstName, 'Veuillez entrer votre prénom');
            isValid = false;
        } else if (firstName.value.trim().length < 2) {
            showFieldError(firstName, 'Le prénom doit contenir au moins 2 caractères');
            isValid = false;
        }

        // Last name validation
        if (!lastName || !lastName.value.trim()) {
            showFieldError(lastName, 'Veuillez entrer votre nom');
            isValid = false;
        } else if (lastName.value.trim().length < 2) {
            showFieldError(lastName, 'Le nom doit contenir au moins 2 caractères');
            isValid = false;
        }

        // Email validation
        const emailRegex = /^[^\s@]+@([^\s@]+\.)+[^\s@]+$/;
        if (!email || !email.value.trim()) {
            showFieldError(email, 'Veuillez entrer votre email');
            isValid = false;
        } else if (!emailRegex.test(email.value.trim())) {
            showFieldError(email, 'Veuillez entrer une adresse email valide');
            isValid = false;
        }

        // Phone validation
        const phoneRegex = /^[0-9+\-\s]{8,15}$/;
        if (!phone || !phone.value.trim()) {
            showFieldError(phone, 'Veuillez entrer votre numéro de téléphone');
            isValid = false;
        } else if (!phoneRegex.test(phone.value.trim())) {
            showFieldError(phone, 'Veuillez entrer un numéro de téléphone valide');
            isValid = false;
        }

        // Password validation
        if (!password || !password.value) {
            showFieldError(password, 'Veuillez entrer un mot de passe');
            isValid = false;
        } else if (password.value.length < config.passwordMinLength) {
            showFieldError(password, `Le mot de passe doit contenir au moins ${config.passwordMinLength} caractères`);
            isValid = false;
        }

        // Confirm password validation
        if (!confirmPassword || !confirmPassword.value) {
            showFieldError(confirmPassword, 'Veuillez confirmer votre mot de passe');
            isValid = false;
        } else if (password && password.value !== confirmPassword.value) {
            showFieldError(confirmPassword, 'Les mots de passe ne correspondent pas');
            isValid = false;
        }

        if (!isValid) {
            showTemporaryError('Veuillez corriger les erreurs ci-dessus');
        }

        return isValid;
    }

    /**
     * Validate forgot password form
     */
    function validateForgotForm() {
        let isValid = true;

        const email = document.querySelector('input[name="email"]');
        const emailRegex = /^[^\s@]+@([^\s@]+\.)+[^\s@]+$/;

        if (!email || !email.value.trim()) {
            showFieldError(email, 'Veuillez entrer votre email');
            isValid = false;
        } else if (!emailRegex.test(email.value.trim())) {
            showFieldError(email, 'Veuillez entrer une adresse email valide');
            isValid = false;
        }

        if (!isValid) {
            showTemporaryError('Veuillez entrer une adresse email valide');
        }

        return isValid;
    }

    /**
     * Show field error
     */
    function showFieldError(field, message) {
        if (!field) return;

        field.classList.add('error');

        // Check if error message already exists
        let errorDiv = field.parentElement.querySelector('.field-error');
        if (!errorDiv) {
            errorDiv = document.createElement('small');
            errorDiv.className = 'field-error';
            errorDiv.style.color = '#ef4444';
            errorDiv.style.fontSize = '0.75rem';
            errorDiv.style.marginTop = '0.25rem';
            errorDiv.style.display = 'block';
            field.parentElement.appendChild(errorDiv);
        }
        errorDiv.textContent = message;
    }

    /**
     * Remove all error styles
     */
    function removeErrorStyles() {
        // Remove error class from all inputs
        const errorInputs = document.querySelectorAll('.input-group input.error');
        errorInputs.forEach(input => {
            input.classList.remove('error');
        });

        // Remove all error messages
        const errorMessages = document.querySelectorAll('.field-error');
        errorMessages.forEach(msg => msg.remove());
    }

    /**
     * Show temporary error message
     */
    function showTemporaryError(message) {
        // Remove existing temporary alerts
        const existingAlert = document.querySelector('.alert-temporary');
        if (existingAlert) {
            existingAlert.remove();
        }

        // Create new alert
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-error alert-temporary';
        alertDiv.innerHTML = `
            <i class="fas fa-exclamation-circle"></i>
            <div class="alert-content">${escapeHtml(message)}</div>
        `;

        const authCard = document.querySelector('.auth-card');
        const cardHeader = document.querySelector('.card-header');
        if (authCard && cardHeader) {
            authCard.insertBefore(alertDiv, cardHeader.nextSibling);
        }

        // Remove after 3 seconds
        setTimeout(() => {
            if (alertDiv && alertDiv.parentNode) {
                alertDiv.style.animation = 'slideIn 0.3s ease reverse';
                setTimeout(() => {
                    if (alertDiv.parentNode) {
                        alertDiv.remove();
                    }
                }, 300);
            }
        }, 3000);
    }

    /**
     * Show loading state on button
     */
    function showLoadingState(button, loadingText) {
        if (!button) return;

        button.classList.add('loading');
        button.disabled = true;
        const originalContent = button.innerHTML;
        button.innerHTML = `<i class="fas fa-spinner"></i> ${loadingText}`;

        // Re-enable button after timeout (in case of network issues)
        setTimeout(() => {
            if (button.disabled) {
                button.classList.remove('loading');
                button.disabled = false;
                button.innerHTML = originalContent;
            }
        }, config.loadingTimeout);
    }

    /**
     * Initialize auto-hide for alert messages
     */
    function initAutoHideAlerts() {
        const alerts = document.querySelectorAll('.alert:not(.alert-temporary)');
        alerts.forEach(alert => {
            setTimeout(() => {
                if (alert && alert.parentNode) {
                    alert.style.animation = 'slideIn 0.3s ease reverse';
                    setTimeout(() => {
                        if (alert && alert.parentNode) {
                            alert.remove();
                        }
                    }, 300);
                }
            }, config.autoHideAlertsDelay);
        });
    }

    /**
     * Initialize remember email functionality
     */
    function initRememberEmail() {
        const urlParams = new URLSearchParams(window.location.search);
        const emailParam = urlParams.get('email');

        if (emailParam && elements.emailInput) {
            elements.emailInput.value = emailParam;
        }

        // Check for saved email in localStorage
        const savedEmail = localStorage.getItem('rememberedEmail');
        const rememberCheckbox = document.querySelector('input[name="remember"]');

        if (savedEmail && elements.emailInput && !elements.emailInput.value) {
            elements.emailInput.value = savedEmail;
            if (rememberCheckbox) {
                rememberCheckbox.checked = true;
            }
        }

        // Save email if remember me is checked
        if (elements.loginForm && rememberCheckbox) {
            elements.loginForm.addEventListener('submit', function() {
                if (rememberCheckbox.checked && elements.emailInput) {
                    localStorage.setItem('rememberedEmail', elements.emailInput.value);
                } else if (!rememberCheckbox.checked) {
                    localStorage.removeItem('rememberedEmail');
                }
            });
        }
    }

    /**
     * Initialize form validation on input
     */
    function initFormValidation() {
        // Real-time validation for login form
        if (elements.emailInput) {
            elements.emailInput.addEventListener('input', function() {
                this.classList.remove('error');
                const errorMsg = this.parentElement.querySelector('.field-error');
                if (errorMsg) errorMsg.remove();
            });
        }

        if (elements.passwordInput) {
            elements.passwordInput.addEventListener('input', function() {
                this.classList.remove('error');
                const errorMsg = this.parentElement.querySelector('.field-error');
                if (errorMsg) errorMsg.remove();
            });
        }
    }

    /**
     * Escape HTML to prevent XSS
     */
    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    /**
     * Public API
     */
    return {
        init: init,
        validateLogin: validateLoginForm,
        validateRegister: validateRegisterForm
    };
})();

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    AuthModule.init();
});