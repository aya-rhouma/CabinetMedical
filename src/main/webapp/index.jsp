<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
    <meta name="description" content="Plateforme de gestion médicale moderne pour patients, médecins et secrétaires">
    <title>MediCare Plus - Centre Médical Intelligent</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- AOS Animation Library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/style.css">

    <style>
        /* Additional fix for any remaining alignment issues */
        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            overflow-x: hidden;
        }

        section, footer, .navbar, .hero {
            width: 100%;
            position: relative;
        }
    </style>
</head>
<body>

<!-- Navigation -->
<nav class="navbar">
    <div class="nav-container">
        <div class="logo">
            <i class="fas fa-heartbeat"></i>
            <span>MediCare Plus</span>
        </div>
        <div class="nav-links">
            <a href="#accueil">Accueil</a>
            <a href="#services">Services</a>
            <a href="#features">À propos</a>
            <a href="#contact">Contact</a>
            <a href="${pageContext.request.contextPath}/jsp/auth/login.jsp" class="btn-login">
                <i class="fas fa-sign-in-alt"></i> Connexion
            </a>
        </div>
        <div class="menu-toggle">
            <i class="fas fa-bars"></i>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero" id="accueil">
    <div class="hero-content">
        <h1 data-aos="fade-up">Votre santé, <span class="highlight">notre priorité</span></h1>
        <p data-aos="fade-up" data-aos-delay="100">
            Une plateforme intelligente pour une gestion médicale simplifiée et efficace
        </p>

        <div class="hero-stats" data-aos="fade-up" data-aos-delay="200">
            <div class="stat">
                <div class="stat-number">5000+</div>
                <div class="stat-label">Patients satisfaits</div>
            </div>
            <div class="stat">
                <div class="stat-number">50+</div>
                <div class="stat-label">Médecins experts</div>
            </div>
            <div class="stat">
                <div class="stat-number">24/7</div>
                <div class="stat-label">Support disponible</div>
            </div>
        </div>
    </div>
</section>

<!-- Cards Section -->
<section class="cards-section" id="services">
    <div class="container">
        <h2 class="section-title" data-aos="fade-up">Nos Espaces</h2>
        <p class="section-subtitle" data-aos="fade-up">Une plateforme adaptée à chaque utilisateur</p>

        <div class="cards-container">
            <!-- Patient Card -->
            <div class="card" data-aos="fade-up" data-aos-delay="100">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <div class="card-badge badge-primary">
                        <i class="fas fa-check-circle"></i> Disponible
                    </div>
                    <h3>Espace Patient</h3>
                </div>
                <div class="card-content">
                    <p>Une expérience patient simplifiée avec des fonctionnalités avancées</p>
                    <ul class="feature-list">
                        <li><i class="fas fa-calendar-check"></i> Prise de rendez-vous en ligne</li>
                        <li><i class="fas fa-history"></i> Historique médical complet</li>
                        <li><i class="fas fa-bell"></i> Notifications en temps réel</li>
                        <li><i class="fas fa-file-prescription"></i> Téléchargement des ordonnances</li>
                        <li><i class="fas fa-comments"></i> Consultation en ligne</li>
                    </ul>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/jsp/auth/login.jsp" class="btn-access">
                        Accéder à l'espace <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- Doctor Card -->
            <div class="card" data-aos="fade-up" data-aos-delay="200">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="card-badge badge-primary">
                        <i class="fas fa-check-circle"></i> Disponible
                    </div>
                    <h3>Espace Médecin</h3>
                </div>
                <div class="card-content">
                    <p>Des outils professionnels pour une pratique médicale optimale</p>
                    <ul class="feature-list">
                        <li><i class="fas fa-notes-medical"></i> Gestion des dossiers patients</li>
                        <li><i class="fas fa-prescription-bottle"></i> Prescriptions électroniques</li>
                        <li><i class="fas fa-chart-line"></i> Statistiques et rapports</li>
                        <li><i class="fas fa-video"></i> Téléconsultation intégrée</li>
                        <li><i class="fas fa-clock"></i> Agenda intelligent</li>
                    </ul>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/jsp/auth/login.jsp" class="btn-access">
                        Accéder à l'espace <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- Secretary Card -->
            <div class="card" data-aos="fade-up" data-aos-delay="300">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-tasks"></i>
                    </div>
                    <div class="card-badge badge-secondary">
                        <i class="fas fa-lock"></i> Accès restreint
                    </div>
                    <h3>Espace Secrétaire</h3>
                </div>
                <div class="card-content">
                    <p>Une gestion administrative complète et centralisée</p>
                    <ul class="feature-list">
                        <li><i class="fas fa-users"></i> Gestion des patients et médecins</li>
                        <li><i class="fas fa-calendar-alt"></i> Planification des rendez-vous</li>
                        <li><i class="fas fa-credit-card"></i> Gestion des paiements</li>
                        <li><i class="fas fa-boxes"></i> Suivi du matériel médical</li>
                        <li><i class="fas fa-chart-bar"></i> Rapports quotidiens</li>
                    </ul>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/jsp/auth/login.jsp" class="btn-access">
                        Accéder à l'espace <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="features-section" id="features">
    <div class="container">
        <h2 class="section-title" data-aos="fade-up">Pourquoi nous choisir ?</h2>
        <p class="section-subtitle" data-aos="fade-up">Des avantages qui font la différence</p>

        <div class="features-grid">
            <div class="feature-item" data-aos="fade-up">
                <div class="feature-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h3>Sécurité maximale</h3>
                <p>Données médicales protégées avec chiffrement avancé</p>
            </div>

            <div class="feature-item" data-aos="fade-up" data-aos-delay="100">
                <div class="feature-icon">
                    <i class="fas fa-bolt"></i>
                </div>
                <h3>Rapidité</h3>
                <p>Traitement instantané des demandes et notifications</p>
            </div>

            <div class="feature-item" data-aos="fade-up" data-aos-delay="200">
                <div class="feature-icon">
                    <i class="fas fa-mobile-alt"></i>
                </div>
                <h3>Mobile First</h3>
                <p>Interface adaptée à tous les appareils</p>
            </div>

            <div class="feature-item" data-aos="fade-up" data-aos-delay="300">
                <div class="feature-icon">
                    <i class="fas fa-headset"></i>
                </div>
                <h3>Support 24/7</h3>
                <p>Assistance technique disponible à tout moment</p>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="footer" id="contact">
    <div class="footer-content">
        <div class="footer-section">
            <h4><i class="fas fa-heartbeat"></i> MediCare Plus</h4>
            <p>Une solution numérique innovante pour une gestion médicale moderne, efficace et sécurisée.</p>
            <div class="social-links">
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-linkedin-in"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
            </div>
        </div>

        <div class="footer-section">
            <h4>Liens rapides</h4>
            <ul class="footer-links">
                <li><a href="#accueil"><i class="fas fa-chevron-right"></i> Accueil</a></li>
                <li><a href="#services"><i class="fas fa-chevron-right"></i> Services</a></li>
                <li><a href="#features"><i class="fas fa-chevron-right"></i> À propos</a></li>
                <li><a href="#"><i class="fas fa-chevron-right"></i> FAQ</a></li>
            </ul>
        </div>

        <div class="footer-section">
            <h4>Contact</h4>
            <ul class="contact-info">
                <li><i class="fas fa-map-marker-alt"></i> Tunis, Tunisie</li>
                <li><i class="fas fa-phone"></i> +216 70 000 000</li>
                <li><i class="fas fa-envelope"></i> contact@medicareplus.tn</li>
                <li><i class="fas fa-clock"></i> Lun-Ven: 8h-18h</li>
            </ul>
        </div>

        <div class="footer-section">
            <h4>Newsletter</h4>
            <p>Recevez nos actualités et offres</p>
            <form class="newsletter-form">
                <input type="email" placeholder="Votre email" required>
                <button type="submit">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </form>
        </div>
    </div>

    <div class="copyright">
        <p>&copy; 2026 MediCare Plus - Centre Médical Intelligent. Tous droits réservés.</p>
    </div>
</footer>

<!-- Scripts -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script src="js/main.js"></script>
</body>
</html>
