package com.jee.servlet;

import java.io.IOException;
import java.util.List;

import com.jee.ejb.interfaces.AuthServiceLocal;
import com.jee.ejb.interfaces.MedecinServiceLocal;
import com.jee.entity.CertificatMedical;
import com.jee.entity.DossierMedical;
import com.jee.entity.Patient;
import com.jee.entity.Prescription;
import com.jee.entity.RendezVous;
import com.jee.entity.Secretaire;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/medecin")
public class MedecinServlet extends HttpServlet {

    @EJB
    private MedecinServiceLocal medecinService;
    @EJB
    private AuthServiceLocal authService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handleRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handleRequest(req, resp);
    }

    private void handleRequest(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Integer medecinId = resolveMedecinId(req.getSession(false));
        if (medecinId == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null || action.isBlank()) {
            action = "dashboard";
        }

        try {
            switch (action) {
                case "patients" -> forwardPatients(req, resp, medecinId);
                case "dossiers" -> forwardDossiers(req, resp, medecinId);
                case "rdv" -> forwardRdv(req, resp, medecinId);
                case "dossier" -> forwardDossier(req, resp, medecinId);
                case "addPrescription" -> addPrescription(req, resp, medecinId);
                case "saveDossier" -> saveDossier(req, resp, medecinId);
                case "certificats" -> forwardCertificats(req, resp, medecinId);
                case "genererCertificat" -> genererCertificat(req, resp, medecinId);
                case "secretaires" -> forwardSecretaires(req, resp, medecinId);
                case "createSecretaire" -> createSecretaire(req, resp, medecinId);
                case "deleteSecretaire" -> deleteSecretaire(req, resp, medecinId);
                default -> forwardDashboard(req, resp, medecinId);
            }
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            if (isSecretaireAction(action)) {
                forwardSecretaires(req, resp, medecinId);
            } else {
                forwardDashboard(req, resp, medecinId);
            }
        }
    }

    private void forwardDashboard(HttpServletRequest req, HttpServletResponse resp, int medecinId)
            throws ServletException, IOException {
        List<Patient> patients = medecinService.getPatientsByMedecin(medecinId);
        List<RendezVous> rdvs = medecinService.getRendezVousByMedecin(medecinId);
        List<CertificatMedical> certificats = medecinService.getDemandesCertificats(medecinId);

        req.setAttribute("nbPatients", patients.size());
        req.setAttribute("nbRdv", rdvs.size());
        req.setAttribute("nbCertificats", certificats.size());
        req.setAttribute("secretaires", medecinService.getSecretairesByMedecin(medecinId));
        req.setAttribute("lastLogin", java.time.LocalDateTime.now());
        req.getRequestDispatcher("/jsp/medecin/dashboard.jsp").forward(req, resp);
    }

    private void createSecretaire(HttpServletRequest req, HttpServletResponse resp, int medecinId)
            throws ServletException, IOException {
        String prenom = value(req.getParameter("prenom"));
        String nom = value(req.getParameter("nom"));
        String email = value(req.getParameter("email"));
        String telephone = value(req.getParameter("telephone"));
        String password = value(req.getParameter("password"));
        String confirmPassword = value(req.getParameter("confirmPassword"));

        if (prenom.isBlank() || nom.isBlank() || email.isBlank() || password.isBlank() || confirmPassword.isBlank()) {
            throw new IllegalArgumentException("Tous les champs obligatoires doivent etre renseignes.");
        }
        if (!password.equals(confirmPassword)) {
            throw new IllegalArgumentException("Les mots de passe ne correspondent pas.");
        }
        if (password.length() < 8) {
            throw new IllegalArgumentException("Le mot de passe doit contenir au moins 8 caracteres.");
        }
        if (authService.emailExists(email)) {
            throw new IllegalArgumentException("Cet email existe deja.");
        }

        authService.registerSecretaire(prenom, nom, email, telephone, password, medecinId);
        req.setAttribute("message", "Compte secretaire cree avec succes.");
        forwardSecretaires(req, resp, medecinId);
    }



    private void deleteSecretaire(HttpServletRequest req, HttpServletResponse resp, int medecinId)
            throws ServletException, IOException {
        String secretaireIdParam = req.getParameter("id");
        if (secretaireIdParam == null || secretaireIdParam.isBlank()) {
            throw new IllegalArgumentException("Identifiant secretaire manquant.");
        }
        medecinService.deleteSecretaire(medecinId, Integer.parseInt(secretaireIdParam));
        req.setAttribute("message", "Compte secretaire supprime.");
        forwardSecretaires(req, resp, medecinId);
    }

    private void forwardSecretaires(HttpServletRequest req, HttpServletResponse resp, int medecinId)
            throws ServletException, IOException {
        req.setAttribute("secretaires", medecinService.getSecretairesByMedecin(medecinId));
        req.getRequestDispatcher("/jsp/medecin/gererSecretaire.jsp").forward(req, resp);
    }

    private void forwardPatients(HttpServletRequest req, HttpServletResponse resp, int medecinId)
            throws ServletException, IOException {
        req.setAttribute("patients", medecinService.getPatientsByMedecin(medecinId));
        req.getRequestDispatcher("/jsp/medecin/patients.jsp").forward(req, resp);
    }

    private void forwardDossiers(HttpServletRequest req, HttpServletResponse resp, int medecinId)
            throws ServletException, IOException {
        req.setAttribute("patients", medecinService.getPatientsByMedecin(medecinId));
        req.getRequestDispatcher("/jsp/medecin/dossier.jsp").forward(req, resp);
    }

    private void forwardRdv(HttpServletRequest req, HttpServletResponse resp, int medecinId)
            throws ServletException, IOException {
        String patientIdParam = req.getParameter("patientId");
        String filtre = req.getParameter("filtre");
        Integer patientId = null;
        if (patientIdParam != null && !patientIdParam.isBlank()) {
            patientId = Integer.parseInt(patientIdParam);
        }
        if (filtre == null || filtre.isBlank()) {
            filtre = "all";
        }

        req.setAttribute("rdvs", medecinService.getRendezVousFiltres(medecinId, patientId, filtre));
        req.setAttribute("patients", medecinService.getPatientsByMedecin(medecinId));
        req.setAttribute("selectedPatientId", patientId);
        req.setAttribute("selectedFiltre", filtre);
        req.getRequestDispatcher("/jsp/medecin/rdv.jsp").forward(req, resp);
    }

    private void forwardDossier(HttpServletRequest req, HttpServletResponse resp, int medecinId)
            throws ServletException, IOException {
        String patientIdParam = req.getParameter("patientId");
        if (patientIdParam == null || patientIdParam.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/medecin?action=dossiers");
            return;
        }

        int patientId = Integer.parseInt(patientIdParam);
        Patient patient = medecinService.getPatientByMedecin(medecinId, patientId);
        DossierMedical dossier = medecinService.getDossierMedical(medecinId, patientId);
        List<Prescription> prescriptions = medecinService.getPrescriptionsByPatient(medecinId, patientId);

        req.setAttribute("patientId", patientId);
        req.setAttribute("patient", patient);
        req.setAttribute("dossier", dossier);
        req.setAttribute("prescriptions", prescriptions);
        req.setAttribute("templateOrdonnance", defaultPrescriptionTemplate());
        req.getRequestDispatcher("/jsp/medecin/dossier.jsp").forward(req, resp);
    }

    private void saveDossier(HttpServletRequest req, HttpServletResponse resp, int medecinId)
            throws IOException {
        int patientId = Integer.parseInt(req.getParameter("patientId"));
        String diagnostic = req.getParameter("diagnostic");
        String notes = req.getParameter("notes");
        medecinService.sauvegarderDossier(medecinId, patientId, diagnostic, notes);
        resp.sendRedirect(req.getContextPath() + "/medecin?action=dossier&patientId=" + patientId);
    }

    private void addPrescription(HttpServletRequest req, HttpServletResponse resp, int medecinId)
            throws IOException {
        int patientId = Integer.parseInt(req.getParameter("patientId"));
        String contenu = req.getParameter("contenu");
        if (contenu == null || contenu.isBlank()) {
            throw new IllegalArgumentException("Le contenu de la prescription est obligatoire.");
        }
        medecinService.ajouterPrescription(medecinId, patientId, contenu);
        resp.sendRedirect(req.getContextPath() + "/medecin?action=dossier&patientId=" + patientId);
    }

    private void forwardCertificats(HttpServletRequest req, HttpServletResponse resp, int medecinId)
            throws ServletException, IOException {
        String patientIdParam = req.getParameter("patientId");
        Integer patientId = null;
        List<CertificatMedical> certificats;
        if (patientIdParam != null && !patientIdParam.isBlank()) {
            patientId = Integer.parseInt(patientIdParam);
            certificats = medecinService.getDemandesCertificatsByPatient(medecinId, patientId);
        } else {
            certificats = medecinService.getDemandesCertificats(medecinId);
        }

        req.setAttribute("certificats", certificats);
        req.setAttribute("patients", medecinService.getPatientsByMedecin(medecinId));
        req.setAttribute("selectedPatientId", patientId);
        req.setAttribute("templateCertificat", defaultCertificatTemplate());
        req.getRequestDispatcher("/jsp/medecin/certificats.jsp").forward(req, resp);
    }

    private void genererCertificat(HttpServletRequest req, HttpServletResponse resp, int medecinId)
            throws IOException {
        int certificatId = Integer.parseInt(req.getParameter("certificatId"));
        String template = req.getParameter("contenuTemplate");
        int nbJours = parseIntOrDefault(req.getParameter("nbJours"), 1);
        medecinService.genererCertificat(medecinId, certificatId, template, nbJours);
        resp.sendRedirect(req.getContextPath() + "/medecin?action=certificats");
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        if (value == null || value.isBlank()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String defaultPrescriptionTemplate() {
        return """
                ORDONNANCE MEDICALE
                Date: {{DATE}}
                Patient: {{PATIENT}}
                Medecin: {{MEDECIN}}
                
                - Medicament 1:
                  Posologie:
                  Duree:
                
                - Medicament 2:
                  Posologie:
                  Duree:
                
                Conseils:
                """;
    }

    private String defaultCertificatTemplate() {
        return """
                 Je soussigné(e), Dr. {{MEDECIN}},
                 certifie avoir examiné ce jour le/la patient(e) {{PATIENT}}.
                 Son état de santé justifie un repos médical de {{NB_JOURS}} jour(s).
                 Fait le {{DATE}}.
                 """;
    }

    private Integer resolveMedecinId(HttpSession session) {
        if (session == null) {
            return null;
        }

        Object user = session.getAttribute("user");
        if (user == null) {
            return null;
        }

        try {
            Object id = user.getClass().getMethod("getId").invoke(user);
            if (id instanceof Number number) {
                return number.intValue();
            }
        } catch (ReflectiveOperationException ignored) {
            // Session user object does not expose getId().
        }

        return null;
    }

    private String value(String input) {
        return input == null ? "" : input.trim();
    }

    private boolean isSecretaireAction(String action) {
        return "secretaires".equals(action)
                || "createSecretaire".equals(action)
                || "deleteSecretaire".equals(action);
    }
}
