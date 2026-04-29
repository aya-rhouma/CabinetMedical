// Initialize AOS animations
AOS.init({
    duration: 1000,
    once: true,
    offset: 100,
    easing: 'ease-in-out'
});

// Mobile menu toggle
const menuToggle = document.querySelector('.menu-toggle');
const navLinks = document.querySelector('.nav-links');

if (menuToggle) {
    menuToggle.addEventListener('click', () => {
        navLinks.classList.toggle('active');
        const icon = menuToggle.querySelector('i');
        if (icon.classList.contains('fa-bars')) {
            icon.classList.remove('fa-bars');
            icon.classList.add('fa-times');
        } else {
            icon.classList.remove('fa-times');
            icon.classList.add('fa-bars');
        }
    });
}

// Smooth scroll for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            // Close mobile menu if open
            if (navLinks.classList.contains('active')) {
                navLinks.classList.remove('active');
                const icon = menuToggle.querySelector('i');
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            }

            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Sticky navigation background change on scroll
const navbar = document.querySelector('.navbar');
window.addEventListener('scroll', () => {
    if (window.scrollY > 50) {
        navbar.style.background = 'rgba(255, 255, 255, 0.98)';
        navbar.style.boxShadow = '0 2px 20px rgba(0,0,0,0.1)';
    } else {
        navbar.style.background = 'rgba(255, 255, 255, 0.95)';
        navbar.style.boxShadow = 'var(--shadow)';
    }

    // Active link highlighting
    const sections = document.querySelectorAll('section[id]');
    let current = '';

    sections.forEach(section => {
        const sectionTop = section.offsetTop - 100;
        const sectionHeight = section.clientHeight;
        if (window.scrollY >= sectionTop && window.scrollY < sectionTop + sectionHeight) {
            current = section.getAttribute('id');
        }
    });

    const navItems = document.querySelectorAll('.nav-links a');
    navItems.forEach(item => {
        item.classList.remove('active');
        if (item.getAttribute('href') === `#${current}`) {
            item.classList.add('active');
        }
    });
});

// Newsletter form submission
const newsletterForm = document.querySelector('.newsletter-form');
if (newsletterForm) {
    newsletterForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const input = newsletterForm.querySelector('input');
        const email = input.value;

        if (email && email.includes('@')) {
            alert(`Merci pour votre inscription ! Un email de confirmation a été envoyé à ${email}`);
            input.value = '';
        } else {
            alert('Veuillez entrer une adresse email valide.');
        }
    });
}

// Add loading animation
window.addEventListener('load', () => {
    document.body.style.opacity = '1';
});

// Card click animation
const cards = document.querySelectorAll('.card');
cards.forEach(card => {
    card.addEventListener('click', (e) => {
        if (!e.target.closest('.btn-access')) {
            card.style.transform = 'scale(0.98)';
            setTimeout(() => {
                card.style.transform = '';
            }, 200);
        }
    });
});

// ============================================
// DOCTORS SECTION FUNCTIONS
// ============================================

function showToast(message, type = 'success') {
    let toast = document.querySelector('.toast-notification');
    if (toast) toast.remove();

    toast = document.createElement('div');
    toast.className = 'toast-notification';
    toast.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : 'info-circle'}"></i>
        <span>${message}</span>
    `;
    document.body.appendChild(toast);

    setTimeout(() => {
        toast.style.animation = 'fadeInUp 0.3s ease reverse';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

function initDoctorsDomFiltering() {
    const grid = document.getElementById('doctorsGrid');
    if (!grid) return;

    const applyBtn = document.getElementById('applyFilters');
    const resetBtn = document.getElementById('resetFilters');
    const searchInput = document.getElementById('searchDoctor');
    const specialtySelect = document.getElementById('specialiteFilter');
    const availabilitySelect = document.getElementById('disponibiliteFilter');

    const getCards = () => Array.from(grid.querySelectorAll('.doctor-card'));
    const ensureEmptyState = () => {
        let empty = grid.querySelector('.empty-doctors');
        if (!empty) {
            empty = document.createElement('div');
            empty.className = 'empty-doctors';
            empty.innerHTML = `
                <i class="fas fa-search"></i>
                <p>Aucun médecin trouvé</p>
            `;
            grid.appendChild(empty);
        }
        return empty;
    };

    const applyFilters = () => {
        const specialty = specialtySelect?.value || 'all';
        const availability = availabilitySelect?.value || 'all';
        const searchTerm = (searchInput?.value || '').toLowerCase();

        const cards = getCards();
        let visibleCount = 0;

        cards.forEach(card => {
            const cardSpecialty = (card.dataset.specialty || '').trim();
            const cardAvailability = (card.dataset.availability || '').trim();
            const cardName = (card.querySelector('.doctor-name')?.textContent || '').toLowerCase();

            const matchesSpecialty = specialty === 'all' || cardSpecialty === specialty;
            const matchesAvailability = availability === 'all' || cardAvailability === availability;
            const matchesSearch = !searchTerm || cardName.includes(searchTerm);

            const isVisible = matchesSpecialty && matchesAvailability && matchesSearch;
            card.style.display = isVisible ? '' : 'none';
            if (isVisible) visibleCount++;
        });

        const empty = ensureEmptyState();
        empty.style.display = visibleCount === 0 ? '' : 'none';
    };

    const resetFilters = () => {
        if (specialtySelect) specialtySelect.value = 'all';
        if (availabilitySelect) availabilitySelect.value = 'all';
        if (searchInput) searchInput.value = '';

        getCards().forEach(card => {
            card.style.display = '';
        });

        const empty = grid.querySelector('.empty-doctors');
        if (empty) empty.style.display = 'none';

        showToast('Filtres réinitialisés', 'success');
    };

    if (applyBtn) applyBtn.addEventListener('click', applyFilters);
    if (resetBtn) resetBtn.addEventListener('click', resetFilters);
    if (searchInput) {
        searchInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') applyFilters();
        });
    }
}

document.addEventListener('DOMContentLoaded', () => {
    initDoctorsDomFiltering();
});
