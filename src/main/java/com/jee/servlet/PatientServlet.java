package com.jee.servlet;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

import com.jee.ejb.interfaces.PatientServiceLocal;
import com.jee.entity.CertificatMedical;
import com.jee.entity.Medecin;
import com.jee.rmi.remote.CallbackClient;
import com.jee.rmi.server.NotificationServiceImpl;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/patient")
public class PatientServlet extends HttpServlet {

    @EJB
    private PatientServiceLocal patientService;

    private final NotificationServiceImpl notificationService =
            NotificationServiceImpl.getInstance();

    private static final Map<String, SessionNotificationBridge> SESSION_CALLBACKS =
            new ConcurrentHashMap<>();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handle(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handle(req, resp);
    }

    private void handle(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer patientId = resolvePatientId(req.getSession(false));
        if (patientId == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp");
            return;
        }

        ensureCallbackRegistered(req.getSession(false), patientId);

        String action = Optional.ofNullable(req.getParameter("action"))
                .filter(a -> !a.isBlank())
                .orElse("dashboard");

        try {
            switch (action) {
                case "reserverRdv" -> reserverRdv(req, resp, patientId);
                case "annulerRdv" -> annulerRdv(req, resp, patientId);
                case "modifierRdv" -> modifierRdv(req, resp, patientId);
                case "demanderCertificat" -> demanderCertificat(req, resp, patientId);
                case "notifications" -> envoyerNotifications(req, resp, patientId);
                case "calendar" -> exporterCalendar(req, resp, patientId);
                case "reservationForm" -> forward(req, resp, patientId, "/jsp/rendezvous/form.jsp");
                case "mesRdv" -> forward(req, resp, patientId, "/jsp/rendezvous/list.jsp");
                case "demandeCertificat" -> forward(req, resp, patientId, "/jsp/patient/certificats-demande.jsp");
                default -> forward(req, resp, patientId, "/jsp/patient/dashboard.jsp");
            }
        } catch (RuntimeException e) {
            req.setAttribute("error", e.getMessage());
            forward(req, resp, patientId, "/jsp/patient/dashboard.jsp");
        }
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp,
                         int patientId, String jsp)
            throws ServletException, IOException {

        prepareData(req, patientId, jsp);
        req.getRequestDispatcher(jsp).forward(req, resp);
    }

    /**
     * ✅ POINT CLÉ : chargement des médecins
     */
    private void prepareData(HttpServletRequest req, int patientId, String jsp) {
        if ("/jsp/rendezvous/form.jsp".equals(jsp) || "/jsp/patient/certificats-demande.jsp".equals(jsp)) {
            String specialite = req.getParameter("specialite");
            String dateParam = req.getParameter("dateRdv");
            String hDebut = req.getParameter("heureDebut");
            String hFin = req.getParameter("heureFin");

            List<Medecin> medecins;

            if (notBlank(dateParam) && notBlank(hDebut) && notBlank(hFin)) {
                medecins = patientService.getMedecinsDisponibles(
                        specialite,
                        LocalDate.parse(dateParam),
                        LocalTime.parse(hDebut),
                        LocalTime.parse(hFin)
                );
            } else if (notBlank(specialite)) {
                medecins = patientService.getMedecinsBySpecialite(specialite);
            } else {
                medecins = patientService.getAllMedecins();
            }

            req.setAttribute("medecinsDisponibles", medecins);
            req.setAttribute("specialite", specialite == null ? "" : specialite);
        }

        req.setAttribute("rdvPlanifies",
                patientService.getRendezVousPlanifies(patientId));
        req.setAttribute("rdvPasses",
                patientService.getRendezVousPasses(patientId));

        List<CertificatMedical> certs =
                patientService.getDemandesCertificats(patientId);

        req.setAttribute("demandesCertificats", certs);
        req.setAttribute("certificatsPatient", certs);

        req.setAttribute("notifications",
                collectNotifications(req.getSession(false), patientId));
    }

    /* =================== ACTIONS =================== */

    private void reserverRdv(HttpServletRequest req, HttpServletResponse resp, int patientId)
            throws IOException {

        patientService.reserverRendezVous(
                patientId,
                Integer.parseInt(req.getParameter("medecinId")),
                LocalDate.parse(req.getParameter("dateRdv")),
                LocalTime.parse(req.getParameter("heureDebut")),
                LocalTime.parse(req.getParameter("heureFin"))
        );

        resp.sendRedirect(req.getContextPath() + "/patient");
    }

    private void annulerRdv(HttpServletRequest req, HttpServletResponse resp, int patientId)
            throws IOException {

        patientService.annulerRendezVous(
                patientId,
                Integer.parseInt(req.getParameter("rdvId"))
        );
        resp.sendRedirect(req.getContextPath() + "/patient");
    }

    private void modifierRdv(HttpServletRequest req, HttpServletResponse resp, int patientId)
            throws IOException {

        patientService.modifierHoraireRendezVous(
                patientId,
                Integer.parseInt(req.getParameter("rdvId")),
                LocalDate.parse(req.getParameter("dateRdv")),
                LocalTime.parse(req.getParameter("heureDebut")),
                LocalTime.parse(req.getParameter("heureFin"))
        );
        resp.sendRedirect(req.getContextPath() + "/patient");
    }

    private void demanderCertificat(HttpServletRequest req,
                                    HttpServletResponse resp, int patientId)
            throws IOException {

        patientService.demanderCertificat(
                patientId,
                Integer.parseInt(req.getParameter("medecinId")),
                req.getParameter("motif")
        );
        resp.sendRedirect(req.getContextPath() + "/patient");
    }

    /* =================== NOTIFICATIONS =================== */

    private void envoyerNotifications(HttpServletRequest req,
                                      HttpServletResponse resp, int patientId)
            throws IOException {

        resp.setContentType("application/json;charset=UTF-8");
        List<String> n = collectNotifications(req.getSession(false), patientId);

        String json = "{\"notifications\":[" +
                String.join(",", n.stream()
                        .map(s -> "\"" + escapeJson(s) + "\"").toList()) +
                "]}";

        resp.getWriter().write(json);
    }

    private List<String> collectNotifications(HttpSession session, int patientId) {

        LinkedHashSet<String> all = new LinkedHashSet<>();

        if (session != null) {
            Object bridge = session.getAttribute("patientCallbackBridge");
            if (bridge instanceof SessionNotificationBridge b) {
                all.addAll(b.drain());
            }
        }

        all.addAll(patientService.consumeNotifications(patientId));
        return new ArrayList<>(all);
    }

    /* =================== UTILS =================== */

    private Integer resolvePatientId(HttpSession session) {
        if (session == null) return null;
        Object user = session.getAttribute("user");
        if (user == null) return null;
        try {
            Object id = user.getClass().getMethod("getId").invoke(user);
            return id instanceof Number n ? n.intValue() : null;
        } catch (ReflectiveOperationException e) {
            return null;
        }
    }

    private boolean notBlank(String v) {
        return v != null && !v.isBlank();
    }

    private String escapeJson(String s) {
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"");
    }

    private void exporterCalendar(HttpServletRequest req,
                                  HttpServletResponse resp, int patientId)
            throws IOException {

        int rdvId = Integer.parseInt(req.getParameter("rdvId"));
        patientService.getRendezVousById(patientId, rdvId);

        resp.setContentType("text/calendar;charset=UTF-8");
        resp.setHeader("Content-Disposition",
                "attachment; filename=\"rdv-" + rdvId + ".ics\"");

        resp.getOutputStream().write("BEGIN:VCALENDAR\r\nEND:VCALENDAR"
                .getBytes(StandardCharsets.UTF_8));
    }

    private void ensureCallbackRegistered(HttpSession session, int patientId) {
        if (session == null) return;

        String key = session.getId() + ":" + patientId;
        if (SESSION_CALLBACKS.containsKey(key)) return;

        SessionNotificationBridge bridge = new SessionNotificationBridge();
        SESSION_CALLBACKS.put(key, bridge);
        notificationService.registerClient(patientId, bridge);

        session.setAttribute("patientCallbackBridge", bridge);
    }

    private static class SessionNotificationBridge implements CallbackClient {
        private final List<String> buf = new CopyOnWriteArrayList<>();

        @Override
        public void onNotification(String message) {
            buf.add(message);
        }

        List<String> drain() {
            List<String> out = new ArrayList<>(buf);
            buf.clear();
            return out;
        }
    }
}
