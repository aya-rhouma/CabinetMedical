/**
 * DASHBOARD.JS - Dashboard unifié
 * Fonctions communes pour tous les dashboards (Médecin, Patient, Secrétaire)
 */

// Dashboard Module
const Dashboard = (function() {
    'use strict';

    // Configuration
    const config = {
        notificationPollingInterval: 8000,
        autoHideAlertDelay: 5000,
        aosDuration: 1000,
        aosOffset: 100,
        debounceDelay: 300
    };

    // DOM Elements cache
    let elements = {};

    /**
     * Initialize dashboard
     */
    function init() {
        cacheElements();
        initAOS();
        initMobileMenu();
        initSmoothScroll();
        initActiveLinks();
        initAutoHideAlerts();
        initFormValidation();
        initTableSorting();
        initSearchFilters();
        initDeleteConfirmations();
        if (elements.notificationList) {
            initNotificationPolling(getContextPath());
        }
    }

    /**
     * Cache DOM elements
     */
    function cacheElements() {
        elements = {
            menuToggle: document.querySelector('.menu-toggle'),
            navLinks: document.querySelector('.nav-links'),
            alerts: document.querySelectorAll('.alert:not(.alert-temporary)'),
            forms: document.querySelectorAll('form[data-validate="true"]'),
            deleteButtons: document.querySelectorAll('.btn-delete, .delete-btn'),
            searchInputs: document.querySelectorAll('.search-input, .filter-search'),
            sortableHeaders: document.querySelectorAll('.sortable'),
            notificationList: document.querySelector('.notification-list'),
            notificationEmpty: document.querySelector('.notification-empty')
        };
    }

    /**
     * Initialize AOS animations
     */
    function initAOS() {
        if (typeof AOS !== 'undefined') {
            AOS.init({
                duration: config.aosDuration,
                once: true,
                offset: config.aosOffset,
                easing: 'ease-in-out'
            });
        }
    }

    /**
     * Initialize mobile menu toggle
     */
    function initMobileMenu() {
        if (elements.menuToggle && elements.navLinks) {
            elements.menuToggle.addEventListener('click', () => {
                elements.navLinks.classList.toggle('active');
                const icon = elements.menuToggle.querySelector('i');
                if (icon) {
                    if (icon.classList.contains('fa-bars')) {
                        icon.classList.remove('fa-bars');
                        icon.classList.add('fa-times');
                    } else {
                        icon.classList.remove('fa-times');
                        icon.classList.add('fa-bars');
                    }
                }
            });
        }
    }

    /**
     * Initialize smooth scroll for anchor links
     */
    function initSmoothScroll() {
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function(e) {
                const targetId = this.getAttribute('href');
                if (targetId === '#') return;

                const target = document.querySelector(targetId);
                if (target) {
                    e.preventDefault();

                    // Close mobile menu if open
                    if (elements.navLinks && elements.navLinks.classList.contains('active')) {
                        elements.navLinks.classList.remove('active');
                        if (elements.menuToggle) {
                            const icon = elements.menuToggle.querySelector('i');
                            if (icon) {
                                icon.classList.remove('fa-times');
                                icon.classList.add('fa-bars');
                            }
                        }
                    }

                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });

                    // Update URL without jumping
                    history.pushState(null, null, targetId);
                }
            });
        });
    }

    /**
     * Initialize active link highlighting
     */
    function initActiveLinks() {
        const currentPath = window.location.pathname;
        const currentHash = window.location.hash;
        const navItems = document.querySelectorAll('.nav-links a');

        navItems.forEach(item => {
            const href = item.getAttribute('href');
            if (!href || href === '#') return;

            // Skip logout button
            if (href.includes('logout')) return;

            // Check for path match
            if (href !== '#' && currentPath.includes(href.replace(/^\.\.\/|\.\./g, ''))) {
                navItems.forEach(nav => nav.classList.remove('active'));
                item.classList.add('active');
            }

            // Check for hash match
            if (currentHash && href === currentHash) {
                navItems.forEach(nav => nav.classList.remove('active'));
                item.classList.add('active');
            }
        });

        // Handle hash change
        window.addEventListener('hashchange', () => {
            const hash = window.location.hash;
            navItems.forEach(item => {
                if (item.getAttribute('href') === hash) {
                    navItems.forEach(nav => nav.classList.remove('active'));
                    item.classList.add('active');
                }
            });
        });
    }

    /**
     * Initialize auto-hide for alerts
     */
    function initAutoHideAlerts() {
        if (elements.alerts) {
            elements.alerts.forEach(alert => {
                setTimeout(() => {
                    if (alert && alert.parentNode) {
                        alert.style.animation = 'fadeInUp 0.3s ease reverse';
                        setTimeout(() => {
                            if (alert && alert.parentNode) {
                                alert.remove();
                            }
                        }, 300);
                    }
                }, config.autoHideAlertDelay);
            });
        }
    }

    /**
     * Initialize form validation
     */
    function initFormValidation() {
        elements.forms.forEach(form => {
            form.addEventListener('submit', function(e) {
                const isValid = validateForm(this);
                if (!isValid) {
                    e.preventDefault();
                    showError('Veuillez remplir tous les champs obligatoires');
                }
            });

            // Real-time validation on inputs
            form.querySelectorAll('input[required], select[required]').forEach(field => {
                field.addEventListener('blur', function() {
                    validateField(this);
                });
            });
        });
    }

    /**
     * Validate a single form field
     */
    function validateField(field) {
        const isValid = field.value.trim() !== '';
        if (!isValid) {
            field.classList.add('error');
            showFieldError(field, 'Ce champ est obligatoire');
        } else {
            field.classList.remove('error');
            removeFieldError(field);
        }
        return isValid;
    }

    /**
     * Validate entire form
     */
    function validateForm(form) {
        let isValid = true;
        const requiredFields = form.querySelectorAll('input[required], select[required]');

        requiredFields.forEach(field => {
            if (!validateField(field)) {
                isValid = false;
            }
        });

        return isValid;
    }

    /**
     * Show field error message
     */
    function showFieldError(field, message) {
        removeFieldError(field);
        const errorDiv = document.createElement('small');
        errorDiv.className = 'field-error';
        errorDiv.style.cssText = 'color: #ef4444; font-size: 0.7rem; margin-top: 0.25rem; display: block;';
        errorDiv.textContent = message;
        field.parentNode.appendChild(errorDiv);
    }

    /**
     * Remove field error message
     */
    function removeFieldError(field) {
        const existingError = field.parentNode.querySelector('.field-error');
        if (existingError) existingError.remove();
    }

    /**
     * Initialize table sorting
     */
    function initTableSorting() {
        elements.sortableHeaders.forEach(header => {
            header.style.cursor = 'pointer';
            header.addEventListener('click', () => {
                const table = header.closest('table');
                const columnIndex = Array.from(header.parentNode.children).indexOf(header);
                const tbody = table.querySelector('tbody');
                const rows = Array.from(tbody.querySelectorAll('tr'));
                const isAscending = header.classList.contains('asc');

                // Remove sorting classes from all headers
                elements.sortableHeaders.forEach(h => {
                    h.classList.remove('asc', 'desc');
                });

                // Sort rows
                rows.sort((a, b) => {
                    const aValue = a.children[columnIndex]?.textContent.trim() || '';
                    const bValue = b.children[columnIndex]?.textContent.trim() || '';

                    if (!isNaN(aValue) && !isNaN(bValue)) {
                        return isAscending ? bValue - aValue : aValue - bValue;
                    }
                    return isAscending ? bValue.localeCompare(aValue) : aValue.localeCompare(bValue);
                });

                // Reorder rows
                rows.forEach(row => tbody.appendChild(row));
                header.classList.add(isAscending ? 'desc' : 'asc');
            });
        });
    }

    /**
     * Initialize search/filter functionality
     */
    function initSearchFilters() {
        const debounce = (func, delay) => {
            let timeout;
            return function() {
                clearTimeout(timeout);
                timeout = setTimeout(() => func.apply(this, arguments), delay);
            };
        };

        elements.searchInputs.forEach(input => {
            input.addEventListener('input', debounce((e) => {
                const searchTerm = e.target.value.toLowerCase();
                const targetTable = document.querySelector(input.dataset.target || 'table');

                if (targetTable) {
                    const rows = targetTable.querySelectorAll('tbody tr');
                    rows.forEach(row => {
                        const text = row.textContent.toLowerCase();
                        row.style.display = text.includes(searchTerm) ? '' : 'none';
                    });
                }
            }, config.debounceDelay));
        });
    }

    /**
     * Initialize delete confirmations
     */
    function initDeleteConfirmations() {
        elements.deleteButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                const confirmed = confirm('Êtes-vous sûr de vouloir supprimer cet élément ? Cette action est irréversible.');
                if (!confirmed) {
                    e.preventDefault();
                }
            });
        });
    }

    /**
     * Show error message
     */
    function showError(message, type = 'danger') {
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type} alert-temporary`;
        alertDiv.style.animation = 'fadeInUp 0.3s ease';
        alertDiv.innerHTML = `
            <i class="fas fa-${type === 'danger' ? 'exclamation-circle' : type === 'success' ? 'check-circle' : 'info-circle'}"></i>
            <div class="alert-content">${escapeHtml(message)}</div>
        `;

        const heroPanel = document.querySelector('.hero-panel');
        if (heroPanel && heroPanel.parentNode) {
            heroPanel.insertAdjacentElement('afterend', alertDiv);
        } else {
            const container = document.querySelector('.dashboard-main');
            if (container) {
                container.insertAdjacentElement('afterbegin', alertDiv);
            }
        }

        setTimeout(() => {
            if (alertDiv && alertDiv.parentNode) {
                alertDiv.style.animation = 'fadeInUp 0.3s ease reverse';
                setTimeout(() => alertDiv.remove(), 300);
            }
        }, config.autoHideAlertDelay);
    }

    /**
     * Show success message
     */
    function showSuccess(message) {
        showError(message, 'success');
    }

    /**
     * Show loading state on button
     */
    function showLoading(button, loadingText) {
        if (!button) return;

        button.classList.add('loading');
        button.disabled = true;
        const originalContent = button.innerHTML;
        button.innerHTML = `<i class="fas fa-spinner fa-spin"></i> ${loadingText}`;

        // Store original content to restore
        button.dataset.originalContent = originalContent;
    }

    /**
     * Hide loading state on button
     */
    function hideLoading(button) {
        if (!button) return;

        button.classList.remove('loading');
        button.disabled = false;
        if (button.dataset.originalContent) {
            button.innerHTML = button.dataset.originalContent;
        }
    }

    /**
     * Get application context path from the page metadata
     */
    function getContextPath() {
        const meta = document.querySelector('meta[name="context-path"]');
        return meta ? meta.getAttribute('content') || '' : '';
    }

    /**
     * Format date for display
     */
    function formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        return date.toLocaleDateString('fr-FR', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric'
        });
    }

    /**
     * Format time for display
     */
    function formatTime(timeString) {
        if (!timeString) return '';
        return timeString.substring(0, 5);
    }

    /**
     * Get role badge color
     */
    function getRoleBadgeColor(role) {
        switch(role) {
            case 'medecin': return 'var(--primary)';
            case 'patient': return 'var(--secondary)';
            case 'secretaire': return 'var(--warning)';
            default: return 'var(--gray)';
        }
    }

    /**
     * Initialize notification polling (for patient dashboard)
     */
    function initNotificationPolling(contextPath, fetchUrl) {
        function appendNotifications(items) {
            if (!items || !items.length) return;

            items.forEach((notification) => {
                const li = document.createElement('li');
                li.className = 'notification-item';
                const message = typeof notification === 'string' ? notification : notification.message;
                const time = typeof notification === 'object' ? notification.time : new Date().toLocaleTimeString();

                const icon = document.createElement('i');
                icon.className = 'fas fa-circle notification-icon';

                const messageSpan = document.createElement('span');
                messageSpan.className = 'notification-message';
                messageSpan.textContent = message || '';

                const timeSpan = document.createElement('span');
                timeSpan.className = 'notification-time';
                timeSpan.textContent = time || '';

                li.append(icon, messageSpan, timeSpan);

                if (elements.notificationList) {
                    elements.notificationList.prepend(li);
                    elements.notificationList.classList.remove('d-none');
                }
                if (elements.notificationEmpty) {
                    elements.notificationEmpty.classList.add('d-none');
                }
            });
        }

        async function pollNotifications() {
            try {
                const response = await fetch(fetchUrl || contextPath + '/patient?action=notifications', {
                    cache: 'no-store',
                    headers: { 'Accept': 'application/json' }
                });

                if (!response.ok) return;
                const data = await response.json();
                appendNotifications(data.notifications || []);
            } catch (e) {
                console.debug('Notification polling error:', e);
            }
        }

        // Start polling if notification list exists
        if (elements.notificationList) {
            setInterval(pollNotifications, config.notificationPollingInterval);
        }
    }

    /**
     * Public API
     */
    return {
        init: init,
        showError: showError,
        showSuccess: showSuccess,
        showLoading: showLoading,
        hideLoading: hideLoading,
        formatDate: formatDate,
        formatTime: formatTime,
        getRoleBadgeColor: getRoleBadgeColor,
        initNotificationPolling: initNotificationPolling,
        validateForm: validateForm
    };
})();

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    Dashboard.init();
});