package com.jee.servlet;

import com.jee.ejb.interfaces.AuthServiceLocal;
import com.jee.entity.Patient;
import com.jee.entity.User;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Locale;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {

    @EJB
    private AuthServiceLocal authService;

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
            case "/forgot-password" -> forgotPassword(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void login(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = value(req.getParameter("email"));
        String password = value(req.getParameter("password"));
        String roleParam = value(req.getParameter("role")).toLowerCase(Locale.ROOT);
        String role = roleParam.isBlank() ? "patient" : roleParam;

        if (email.isBlank() || password.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp?role=" + role + "&error=required_fields");
            return;
        }

        User.Role userRole = switch (role) {
            case "patient" -> User.Role.PATIENT;
            case "medecin" -> User.Role.MEDECIN;
            case "secretaire" -> User.Role.SECRETAIRE;
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
        session.setAttribute("user", user);

        switch (user.getRole()) {
            case PATIENT -> resp.sendRedirect(req.getContextPath() + "/patient");
            case MEDECIN -> resp.sendRedirect(req.getContextPath() + "/medecin");
            case SECRETAIRE -> resp.sendRedirect(req.getContextPath() + "/secretaire");
            default -> resp.sendRedirect(req.getContextPath() + "/");
        }
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

    private void forgotPassword(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = value(req.getParameter("email"));
        String message = email.isBlank()
                ? "Veuillez renseigner votre email."
                : "Si cet email existe, un lien de réinitialisation sera envoyé.";
        String encoded = URLEncoder.encode(message, StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/jsp/auth/forgot-password.jsp?message=" + encoded);
    }

    private String value(String value) {
        return value == null ? "" : value.trim();
    }
}
