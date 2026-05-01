package com.jee.servlet;

import com.jee.ejb.interfaces.AuthServiceLocal;
import com.jee.entity.Patient;
import com.jee.entity.Medecin;
import com.jee.entity.User;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/auth/*")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 5,   // 5 MB
        maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class AuthServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AuthServlet.class.getName());

    @EJB
    private AuthServiceLocal authService;

    private static final String UPLOAD_DIR = "uploads/diplomes";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path = req.getPathInfo();
        if (path == null || "/".equals(path)) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp");
            return;
        }

        if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp?logout=success");
            return;
        }

        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String path = req.getPathInfo();
        if (path == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        switch (path) {
            case "/login" -> login(req, resp);
            case "/register" -> registerPatient(req, resp);
            case "/register-medecin" -> registerMedecin(req, resp);
            case "/forgot-password" -> forgotPassword(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void login(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = value(req.getParameter("email"));
        String password = value(req.getParameter("password"));
        String roleParam = value(req.getParameter("role")).toLowerCase(Locale.ROOT);
        String role = roleParam.isBlank() ? "patient" : roleParam;

        try {
            if (email.isBlank() || password.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp?role=" + role + "&error=required_fields");
                return;
            }

            User.Role userRole = switch (role) {
                case "patient" -> User.Role.PATIENT;
                case "medecin" -> User.Role.MEDECIN;
                case "secretaire" -> User.Role.SECRETAIRE;
                case "admin" -> User.Role.ADMIN;
                default -> null;
            };

            if (userRole == null) {
                resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp?error=invalid_credentials");
                return;
            }

            User user = authService.authenticate(email, userRole, password);
            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp?role=" + role + "&error=invalid_credentials");
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("user", toSessionUser(user));

            User.Role effectiveRole = user.getRole();
            if (effectiveRole == null) {
                resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp?role=" + role + "&error=invalid_credentials");
                return;
            }

            switch (effectiveRole) {
                case PATIENT -> resp.sendRedirect(req.getContextPath() + "/patient");
                case MEDECIN -> resp.sendRedirect(req.getContextPath() + "/medecin");
                case SECRETAIRE -> resp.sendRedirect(req.getContextPath() + "/secretaire");
                case ADMIN -> resp.sendRedirect(req.getContextPath() + "/admin");
                default -> resp.sendRedirect(req.getContextPath() + "/");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur pendant l'authentification de " + email, e);
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp?role=" + role + "&error=invalid_credentials");
        }
    }

    private User toSessionUser(User source) {
        User sessionUser = new User();
        sessionUser.setId(source.getId());
        sessionUser.setCIN(source.getCIN());
        sessionUser.setRole(source.getRole());
        sessionUser.setNom(source.getNom());
        sessionUser.setPrenom(source.getPrenom());
        sessionUser.setEmail(source.getEmail());
        sessionUser.setTelephone(source.getTelephone());
        sessionUser.setMotDePasse(source.getMotDePasse());
        return sessionUser;
    }

    private void registerPatient(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String firstName = value(req.getParameter("firstName"));
        String lastName = value(req.getParameter("lastName"));
        String email = value(req.getParameter("email"));
        String phone = value(req.getParameter("phone"));
        String password = value(req.getParameter("password"));
        String confirmPassword = value(req.getParameter("confirmPassword"));

        if (firstName.isBlank() || lastName.isBlank() || email.isBlank() || phone.isBlank() || password.isBlank() || confirmPassword.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/register.jsp?error=invalid_data");
            return;
        }

        if (!password.equals(confirmPassword)) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/register.jsp?error=password_mismatch");
            return;
        }

        // Validation du mot de passe (minimum 8 caractères)
        if (password.length() < 8) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/register.jsp?error=invalid_password");
            return;
        }

        if (authService.emailExists(email)) {
            String encodedEmail = URLEncoder.encode(email, StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/register.jsp?error=email_exists&email=" + encodedEmail);
            return;
        }

        Patient patient = authService.registerPatient(firstName, lastName, email, phone, password);

        HttpSession session = req.getSession(true);
        session.setAttribute("user", patient);
        resp.sendRedirect(req.getContextPath() + "/patient");
    }

    private void registerMedecin(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        // Enlever la restriction de jeton d'invitation pour permettre l'inscription libre des médecins
        // (Ou vous pouvez ajouter un champ 'token' caché dans le formulaire si vous voulez garder la sécurité)

        // Récupérer les paramètres
        String firstName = value(req.getParameter("firstName"));
        String lastName = value(req.getParameter("lastName"));
        String email = value(req.getParameter("email"));
        String phone = value(req.getParameter("phone"));
        String password = value(req.getParameter("password"));
        String confirmPassword = value(req.getParameter("confirmPassword"));
        String specialite = value(req.getParameter("specialite"));
        String licenceNumber = value(req.getParameter("licenceNumber"));
        String experience = value(req.getParameter("experience"));
        Part diplome = req.getPart("diplome");

        // Validation des champs obligatoires
        if (firstName.isBlank() || lastName.isBlank() || email.isBlank() || phone.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/register-medecin.jsp?error=invalid_data");
            return;
        }

        if (specialite.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/register-medecin.jsp?error=missing_specialite");
            return;
        }

        if (password.isBlank() || confirmPassword.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/register-medecin.jsp?error=invalid_data");
            return;
        }

        // Validation du mot de passe
        if (!password.equals(confirmPassword)) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/register-medecin.jsp?error=password_mismatch");
            return;
        }

        if (password.length() < 8) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/register-medecin.jsp?error=password_too_short");
            return;
        }

        // Vérifier au moins une majuscule et un chiffre
        if (!password.matches(".*[A-Z].*") || !password.matches(".*[0-9].*")) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/register-medecin.jsp?error=password_weak");
            return;
        }

        // Vérifier si l'email existe déjà
        if (authService.emailExists(email)) {
            String encodedEmail = URLEncoder.encode(email, StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/register-medecin.jsp?error=email_exists&email=" + encodedEmail);
            return;
        }

        // Sauvegarder le diplôme si présent
        String diplomePath = null;
        if (diplome != null && diplome.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + sanitizeFileName(diplome.getSubmittedFileName());
            String uploadPath = getServletContext().getRealPath("/") + UPLOAD_DIR;

            // Créer le répertoire s'il n'existe pas
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            diplome.write(uploadPath + File.separator + fileName);
            diplomePath = UPLOAD_DIR + "/" + fileName;
        }

        // Créer le compte médecin
        Medecin medecin = authService.registerMedecin(
                firstName, lastName, email, phone, password,
                specialite, licenceNumber, experience, diplomePath
        );

        if (medecin == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/register-medecin.jsp?error=registration_failed");
            return;
        }

        // Si créé par admin, rediriger vers la liste des médecins
        HttpSession session = req.getSession(false);
        User currentUser = (User) (session != null ? session.getAttribute("user") : null);
        boolean isAdmin = currentUser != null && currentUser.getRole() == User.Role.ADMIN;
        
        if (isAdmin) {
            resp.sendRedirect(req.getContextPath() + "/admin/medecins?success=medecin_added");
        } else {
            // Connexion automatique
            session = req.getSession(true);
            session.setAttribute("user", medecin);
            resp.sendRedirect(req.getContextPath() + "/medecin?success=account_created");
        }
    }

    private void forgotPassword(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = value(req.getParameter("email"));

        if (!email.isBlank()) {
            // Envoyer un email de réinitialisation
            boolean emailSent = authService.sendPasswordResetEmail(email);
            if (emailSent) {
                String message = "Un lien de réinitialisation a été envoyé à votre adresse email.";
                String encoded = URLEncoder.encode(message, StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/jsp/auth/forgot-password.jsp?message=" + encoded);
                return;
            }
        }

        String message = email.isBlank()
                ? "Veuillez renseigner votre email."
                : "Si cet email existe, un lien de réinitialisation sera envoyé.";
        String encoded = URLEncoder.encode(message, StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/jsp/auth/forgot-password.jsp?message=" + encoded);
    }

    private String value(String value) {
        return value == null ? "" : value.trim();
    }

    private String sanitizeFileName(String fileName) {
        if (fileName == null) return "file";
        return fileName.replaceAll("[^a-zA-Z0-9.-]", "_");
    }
}
