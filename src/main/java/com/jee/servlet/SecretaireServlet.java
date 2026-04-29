package com.jee.servlet;

import com.jee.ejb.interfaces.SecretaireServiceLocal;
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

@WebServlet("/secretaire")
public class SecretaireServlet extends HttpServlet {

    @EJB
    private SecretaireServiceLocal secretaireService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp");
            return;
        }

        Object userObj = session.getAttribute("user");
        if (!(userObj instanceof User user) || user.getRole() != User.Role.SECRETAIRE) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp?error=access_denied");
            return;
        }

        req.setAttribute("nbPatients", secretaireService.countPatients());
        req.setAttribute("nbMedecins", secretaireService.countMedecins());
        req.setAttribute("nbRdv", secretaireService.countRendezVous());
        req.setAttribute("lastLogin", LocalDateTime.now());

        req.getRequestDispatcher("/jsp/secretaire/dashboard.jsp").forward(req, resp);
    }
}
