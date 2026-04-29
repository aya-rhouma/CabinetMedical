package com.jee.servlet;

import com.jee.ejb.interfaces.SecretaireServiceLocal;
import com.jee.entity.*;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/secretaire")
public class SecretaireServlet extends HttpServlet {

    @EJB
    private SecretaireServiceLocal secretaireService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleRequest(req, resp);
    }

    private void handleRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAccess(req, resp)) return;

        String action = req.getParameter("action");
        if (action == null || action.isBlank()) action = "dashboard";

        try {
            switch (action) {
                case "patients"        -> forwardPatients(req, resp);
                case "fichePatient"    -> forwardFichePatient(req, resp);
                case "rdv"             -> forwardRdv(req, resp);
                case "changerStatut"   -> changerStatut(req, resp);
                case "modifierHoraire" -> modifierHoraire(req, resp);
                case "marquerPaiement" -> marquerPaiement(req, resp);
                case "materiels"       -> forwardMateriels(req, resp);
                case "genererDevis"    -> genererDevis(req, resp);
                default                -> forwardDashboard(req, resp);
            }
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            forwardDashboard(req, resp);
        }
    }

    /* ===================== DASHBOARD ===================== */

    private void forwardDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("nbPatients",    secretaireService.countPatients());
        req.setAttribute("nbMedecins",    secretaireService.countMedecins());
        req.setAttribute("nbRdv",         secretaireService.countRendezVous());
        req.setAttribute("nbRdvDuJour",   secretaireService.countRendezVousDuJour());
        req.setAttribute("rdvDuJour",     secretaireService.getRendezVousDuJour());
        req.setAttribute("alertes",       secretaireService.getMaterielsEnAlerte());
        req.setAttribute("lastLogin",     LocalDateTime.now());
        req.getRequestDispatcher("/jsp/secretaire/dashboard.jsp").forward(req, resp);
    }

    /* ===================== PATIENTS ===================== */

    private void forwardPatients(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("patients", secretaireService.getAllPatients());
        req.getRequestDispatcher("/jsp/secretaire/patients.jsp").forward(req, resp);
    }

    private void forwardFichePatient(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int patientId = Integer.parseInt(req.getParameter("patientId"));
        Patient patient = secretaireService.getPatientById(patientId);
        List<RendezVous> rdvs = secretaireService.getRendezVousByStatutAndDate(null, null)
                .stream()
                .filter(r -> r.getPatient().getId() == patientId)
                .toList();
        req.setAttribute("patient", patient);
        req.setAttribute("rdvsPatient", rdvs);
        req.getRequestDispatcher("/jsp/secretaire/fiche-patient.jsp").forward(req, resp);
    }

    /* ===================== RENDEZ-VOUS ===================== */

    private void forwardRdv(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String statut = req.getParameter("statut");
        String dateParam = req.getParameter("dateRdv");
        LocalDate date = (dateParam != null && !dateParam.isBlank()) ? LocalDate.parse(dateParam) : null;

        List<RendezVous> rdvs = secretaireService.getRendezVousByStatutAndDate(statut, date);

        req.setAttribute("rdvs",           rdvs);
        req.setAttribute("selectedStatut", statut == null ? "" : statut);
        req.setAttribute("selectedDate",   dateParam == null ? "" : dateParam);
        req.getRequestDispatcher("/jsp/secretaire/rdv.jsp").forward(req, resp);
    }

    private void changerStatut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int rdvId = Integer.parseInt(req.getParameter("rdvId"));
        String statut = req.getParameter("statut");
        secretaireService.changerStatutRendezVous(rdvId, statut);
        resp.sendRedirect(req.getContextPath() + "/secretaire?action=rdv");
    }

    private void modifierHoraire(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int rdvId = Integer.parseInt(req.getParameter("rdvId"));
        LocalDate date = LocalDate.parse(req.getParameter("dateRdv"));
        LocalTime heureDebut = LocalTime.parse(req.getParameter("heureDebut"));
        LocalTime heureFin = LocalTime.parse(req.getParameter("heureFin"));
        secretaireService.modifierHoraireRendezVous(rdvId, date, heureDebut, heureFin);
        resp.sendRedirect(req.getContextPath() + "/secretaire?action=rdv");
    }

    private void marquerPaiement(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int rdvId = Integer.parseInt(req.getParameter("rdvId"));
        boolean paye = "true".equals(req.getParameter("paye"));
        secretaireService.marquerPaiement(rdvId, paye);
        resp.sendRedirect(req.getContextPath() + "/secretaire?action=rdv");
    }

    /* ===================== MATERIELS ===================== */

    private void forwardMateriels(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("materiels", secretaireService.getAllMateriels());
        req.setAttribute("alertes",   secretaireService.getMaterielsEnAlerte());
        req.setAttribute("devis",     secretaireService.getDevisRecents());
        req.getRequestDispatcher("/jsp/secretaire/materiels.jsp").forward(req, resp);
    }

    private void genererDevis(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int materielId = Integer.parseInt(req.getParameter("materielId"));
        int quantite = Integer.parseInt(req.getParameter("quantite"));
        secretaireService.genererDevis(materielId, quantite);
        resp.sendRedirect(req.getContextPath() + "/secretaire?action=materiels&success=devis_cree");
    }

    /* ===================== SECURITE ===================== */

    private boolean checkAccess(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp");
            return false;
        }
        Object userObj = session.getAttribute("user");
        if (!(userObj instanceof User user) ||
            (user.getRole() != User.Role.SECRETAIRE && user.getRole() != User.Role.ADMIN)) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp?error=access_denied");
            return false;
        }
        return true;
    }
}
