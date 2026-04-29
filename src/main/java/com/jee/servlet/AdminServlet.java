package com.jee.servlet;

import com.jee.ejb.interfaces.AdminServiceLocal;
import com.jee.entity.User;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    @EJB
    private AdminServiceLocal adminService;

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
                case "medecins"         -> forwardMedecins(req, resp);
                case "addMedecin"       -> addMedecin(req, resp);
                case "deleteMedecin"    -> deleteMedecin(req, resp);
                case "secretaires"      -> forwardSecretaires(req, resp);
                case "addSecretaire"    -> addSecretaire(req, resp);
                case "deleteSecretaire" -> deleteSecretaire(req, resp);
                case "materiels"        -> forwardMateriels(req, resp);
                case "addMateriel"      -> addMateriel(req, resp);
                case "updateMateriel"   -> updateMateriel(req, resp);
                case "deleteMateriel"   -> deleteMateriel(req, resp);
                default                 -> forwardDashboard(req, resp);
            }
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            forwardDashboard(req, resp);
        }
    }

    /* ===================== DASHBOARD ===================== */

    private void forwardDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("nbPatients",    adminService.countPatients());
        req.setAttribute("nbMedecins",    adminService.countMedecins());
        req.setAttribute("nbSecretaires", adminService.countSecretaires());
        req.setAttribute("nbRdv",         adminService.countRendezVous());
        req.setAttribute("lastLogin",     LocalDateTime.now());
        req.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(req, resp);
    }

    /* ===================== MEDECINS ===================== */

    private void forwardMedecins(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("medecins", adminService.getAllMedecins());
        req.getRequestDispatcher("/jsp/admin/medecins.jsp").forward(req, resp);
    }

    private void addMedecin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String nom        = req.getParameter("nom");
        String prenom     = req.getParameter("prenom");
        String email      = req.getParameter("email");
        String telephone  = req.getParameter("telephone");
        String password   = req.getParameter("password");
        String specialite = req.getParameter("specialite");
        String licence    = req.getParameter("licenceNumber");
        String experience = req.getParameter("experience");
        adminService.addMedecin(nom, prenom, email, telephone, password, specialite, licence, experience);
        resp.sendRedirect(req.getContextPath() + "/admin?action=medecins&success=added");
    }

    private void deleteMedecin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        adminService.deleteMedecin(id);
        resp.sendRedirect(req.getContextPath() + "/admin?action=medecins&success=deleted");
    }

    /* ===================== SECRETAIRES ===================== */

    private void forwardSecretaires(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("secretaires", adminService.getAllSecretaires());
        req.setAttribute("medecins",    adminService.getAllMedecins());
        req.getRequestDispatcher("/jsp/admin/secretaires.jsp").forward(req, resp);
    }

    private void addSecretaire(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String nom       = req.getParameter("nom");
        String prenom    = req.getParameter("prenom");
        String email     = req.getParameter("email");
        String telephone = req.getParameter("telephone");
        String password  = req.getParameter("password");
        String midStr    = req.getParameter("medecinId");
        Integer medecinId = (midStr != null && !midStr.isBlank()) ? Integer.parseInt(midStr) : null;
        adminService.addSecretaire(nom, prenom, email, telephone, password, medecinId);
        resp.sendRedirect(req.getContextPath() + "/admin?action=secretaires&success=added");
    }

    private void deleteSecretaire(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        adminService.deleteSecretaire(id);
        resp.sendRedirect(req.getContextPath() + "/admin?action=secretaires&success=deleted");
    }

    /* ===================== MATERIELS ===================== */

    private void forwardMateriels(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("materiels", adminService.getAllMateriels());
        req.getRequestDispatcher("/jsp/admin/materiels.jsp").forward(req, resp);
    }

    private void addMateriel(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String nom  = req.getParameter("nom");
        int qte     = Integer.parseInt(req.getParameter("quantite"));
        int seuil   = Integer.parseInt(req.getParameter("seuilAlerte"));
        adminService.addMateriel(nom, qte, seuil);
        resp.sendRedirect(req.getContextPath() + "/admin?action=materiels&success=added");
    }

    private void updateMateriel(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id    = Integer.parseInt(req.getParameter("id"));
        String nom = req.getParameter("nom");
        int qte   = Integer.parseInt(req.getParameter("quantite"));
        int seuil = Integer.parseInt(req.getParameter("seuilAlerte"));
        adminService.updateMateriel(id, nom, qte, seuil);
        resp.sendRedirect(req.getContextPath() + "/admin?action=materiels&success=updated");
    }

    private void deleteMateriel(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        adminService.deleteMateriel(id);
        resp.sendRedirect(req.getContextPath() + "/admin?action=materiels&success=deleted");
    }

    /* ===================== SECURITE ===================== */

    private boolean checkAccess(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp?role=admin");
            return false;
        }
        Object userObj = session.getAttribute("user");
        if (!(userObj instanceof User user) || user.getRole() != User.Role.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp?role=admin&error=access_denied");
            return false;
        }
        return true;
    }
}
