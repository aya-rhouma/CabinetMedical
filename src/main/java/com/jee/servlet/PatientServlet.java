package com.jee.servlet;

import com.jee.ejb.interfaces.PatientServiceLocal;
import com.jee.entity.Medecin;
import com.jee.entity.RendezVous;
import com.jee.rmi.remote.CallbackClient;
import com.jee.rmi.server.NotificationServiceImpl;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

@WebServlet("/patient")
public class PatientServlet extends HttpServlet {

    @EJB
    private PatientServiceLocal patientService;
    private final NotificationServiceImpl notificationService = NotificationServiceImpl.getInstance();
    private static final Map<String, SessionNotificationBridge> SESSION_CALLBACKS = new ConcurrentHashMap<>();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleRequest(req, resp);
    }

    private void handleRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer patientId = resolvePatientId(req.getSession(false));
        if (patientId == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp");
            return;
        }
        ensureCallbackRegistered(req.getSession(false), patientId);

        String action = req.getParameter("action");
        if (action == null || action.isBlank()) {
            action = "dashboard";
        }

        try {
            switch (action) {
                case "reserverRdv" -> reserverRdv(req, resp, patientId);
                case "annulerRdv" -> annulerRdv(req, resp, patientId);
                case "modifierRdv" -> modifierRdv(req, resp, patientId);
                case "demanderCertificat" -> demanderCertificat(req, resp, patientId);
                case "notifications" -> notifications(req, resp, patientId);
                case "calendar" -> exportCalendar(req, resp, patientId);
                default -> forwardDashboard(req, resp, patientId);
            }
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            forwardDashboard(req, resp, patientId);
        }
    }

    private void forwardDashboard(HttpServletRequest req, HttpServletResponse resp, int patientId)
            throws ServletException, IOException {
        String specialite = req.getParameter("specialite");
        String dateParam = req.getParameter("dateRdv");
        String heureDebutParam = req.getParameter("heureDebut");
        String heureFinParam = req.getParameter("heureFin");

        List<Medecin> medecinsDisponibles;
        if (notBlank(dateParam) && notBlank(heureDebutParam) && notBlank(heureFinParam)) {
            medecinsDisponibles = patientService.getMedecinsDisponibles(
                    specialite,
                    LocalDate.parse(dateParam),
                    LocalTime.parse(heureDebutParam),
                    LocalTime.parse(heureFinParam)
            );
        } else {
            medecinsDisponibles = patientService.getMedecinsBySpecialite(specialite);
        }

        req.setAttribute("rdvPlanifies", patientService.getRendezVousPlanifies(patientId));
        req.setAttribute("rdvPasses", patientService.getRendezVousPasses(patientId));
        req.setAttribute("demandesCertificats", patientService.getDemandesCertificats(patientId));
        req.setAttribute("notifications", collectNotifications(req.getSession(false), patientId));
        req.setAttribute("medecinsDisponibles", medecinsDisponibles);
        req.setAttribute("specialite", specialite == null ? "" : specialite);
        req.getRequestDispatcher("/jsp/patient/dashboard.jsp").forward(req, resp);
    }

    private void reserverRdv(HttpServletRequest req, HttpServletResponse resp, int patientId) throws IOException {
        int medecinId = Integer.parseInt(req.getParameter("medecinId"));
        LocalDate date = LocalDate.parse(req.getParameter("dateRdv"));
        LocalTime heureDebut = LocalTime.parse(req.getParameter("heureDebut"));
        LocalTime heureFin = LocalTime.parse(req.getParameter("heureFin"));
        patientService.reserverRendezVous(patientId, medecinId, date, heureDebut, heureFin);
        resp.sendRedirect(req.getContextPath() + "/patient");
    }

    private void annulerRdv(HttpServletRequest req, HttpServletResponse resp, int patientId) throws IOException {
        int rdvId = Integer.parseInt(req.getParameter("rdvId"));
        patientService.annulerRendezVous(patientId, rdvId);
        resp.sendRedirect(req.getContextPath() + "/patient");
    }

    private void modifierRdv(HttpServletRequest req, HttpServletResponse resp, int patientId) throws IOException {
        int rdvId = Integer.parseInt(req.getParameter("rdvId"));
        LocalDate date = LocalDate.parse(req.getParameter("dateRdv"));
        LocalTime heureDebut = LocalTime.parse(req.getParameter("heureDebut"));
        LocalTime heureFin = LocalTime.parse(req.getParameter("heureFin"));
        patientService.modifierHoraireRendezVous(patientId, rdvId, date, heureDebut, heureFin);
        resp.sendRedirect(req.getContextPath() + "/patient");
    }

    private void demanderCertificat(HttpServletRequest req, HttpServletResponse resp, int patientId) throws IOException {
        int medecinId = Integer.parseInt(req.getParameter("medecinId"));
        String motif = req.getParameter("motif");
        patientService.demanderCertificat(patientId, medecinId, motif);
        resp.sendRedirect(req.getContextPath() + "/patient");
    }

    private void notifications(HttpServletRequest req, HttpServletResponse resp, int patientId) throws IOException {
        List<String> notifications = collectNotifications(req.getSession(false), patientId);
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write(toNotificationsJson(notifications));
    }

    private void exportCalendar(HttpServletRequest req, HttpServletResponse resp, int patientId) throws IOException {
        int rdvId = Integer.parseInt(req.getParameter("rdvId"));
        RendezVous rdv = patientService.getRendezVousById(patientId, rdvId);

        resp.setContentType("text/calendar;charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"rdv-" + rdvId + ".ics\"");
        resp.getOutputStream().write(buildIcs(rdv).getBytes(StandardCharsets.UTF_8));
    }

    private List<String> collectNotifications(HttpSession session, int patientId) {
        LinkedHashSet<String> merged = new LinkedHashSet<>();

        if (session != null) {
            Object bridgeObject = session.getAttribute("patientCallbackBridge");
            if (bridgeObject instanceof SessionNotificationBridge bridge) {
                merged.addAll(bridge.drain());
            }
        }

        merged.addAll(patientService.consumeNotifications(patientId));
        return new ArrayList<>(merged);
    }

    private void ensureCallbackRegistered(HttpSession session, int patientId) {
        if (session == null) {
            return;
        }

        String expectedKey = session.getId() + ":" + patientId;
        String currentKey = (String) session.getAttribute("patientCallbackKey");
        if (expectedKey.equals(currentKey) && session.getAttribute("patientCallbackBridge") instanceof SessionNotificationBridge) {
            return;
        }

        if (currentKey != null) {
            SessionNotificationBridge oldBridge = SESSION_CALLBACKS.remove(currentKey);
            Integer oldPatientId = (Integer) session.getAttribute("patientCallbackPatientId");
            if (oldBridge != null && oldPatientId != null) {
                notificationService.unregisterClient(oldPatientId, oldBridge);
            }
        }

        SessionNotificationBridge bridge = new SessionNotificationBridge();
        SESSION_CALLBACKS.put(expectedKey, bridge);
        notificationService.registerClient(patientId, bridge);

        session.setAttribute("patientCallbackBridge", bridge);
        session.setAttribute("patientCallbackKey", expectedKey);
        session.setAttribute("patientCallbackPatientId", patientId);
    }

    private String toNotificationsJson(List<String> notifications) {
        StringBuilder json = new StringBuilder();
        json.append("{\"notifications\":[");
        for (int i = 0; i < notifications.size(); i++) {
            if (i > 0) {
                json.append(',');
            }
            json.append('"').append(escapeJson(notifications.get(i))).append('"');
        }
        json.append("]}");
        return json.toString();
    }

    private String escapeJson(String value) {
        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }

    private String buildIcs(RendezVous rdv) {
        LocalDateTime start = LocalDateTime.of(rdv.getDateRdv(), rdv.getHeureDebut());
        LocalDateTime end = LocalDateTime.of(rdv.getDateRdv(), rdv.getHeureFin());
        String dtStampUtc = LocalDateTime.now(ZoneOffset.UTC).format(DateTimeFormatter.ofPattern("yyyyMMdd'T'HHmmss'Z'"));
        String dtStart = start.format(DateTimeFormatter.ofPattern("yyyyMMdd'T'HHmmss"));
        String dtEnd = end.format(DateTimeFormatter.ofPattern("yyyyMMdd'T'HHmmss"));
        String medecinNom = rdv.getMedecin().getPrenom() + " " + rdv.getMedecin().getNom();

        return "BEGIN:VCALENDAR\r\n" +
                "VERSION:2.0\r\n" +
                "PRODID:-//CabinetMedical//Patient Calendar//FR\r\n" +
                "CALSCALE:GREGORIAN\r\n" +
                "METHOD:PUBLISH\r\n" +
                "BEGIN:VEVENT\r\n" +
                "UID:rdv-" + rdv.getId() + "@cabinetmedical\r\n" +
                "DTSTAMP:" + dtStampUtc + "\r\n" +
                "DTSTART:" + dtStart + "\r\n" +
                "DTEND:" + dtEnd + "\r\n" +
                "SUMMARY:Consultation Dr " + escapeIcs(medecinNom) + "\r\n" +
                "DESCRIPTION:Rendez-vous medical avec Dr " + escapeIcs(medecinNom) + "\r\n" +
                "LOCATION:Cabinet Medical\r\n" +
                "STATUS:CONFIRMED\r\n" +
                "END:VEVENT\r\n" +
                "END:VCALENDAR\r\n";
    }

    private String escapeIcs(String value) {
        return value
                .replace("\\", "\\\\")
                .replace(",", "\\,")
                .replace(";", "\\;")
                .replace("\n", "\\n");
    }

    private Integer resolvePatientId(HttpSession session) {
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
            return null;
        }
        return null;
    }

    private boolean notBlank(String value) {
        return value != null && !value.isBlank();
    }

    private static class SessionNotificationBridge implements CallbackClient {
        private final List<String> notifications = new CopyOnWriteArrayList<>();

        @Override
        public void onNotification(String message) {
            notifications.add(message);
        }

        List<String> drain() {
            if (notifications.isEmpty()) {
                return List.of();
            }
            List<String> copy = new ArrayList<>(notifications);
            notifications.clear();
            return copy;
        }
    }
}
