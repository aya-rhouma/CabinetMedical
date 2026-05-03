package com.jee.ejb.stateless;

import java.time.LocalDate;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import com.jee.entity.RendezVous;
import com.jee.rmi.server.NotificationServiceImpl;

import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

@Singleton
@Startup
public class RendezVousReminderScheduler {

    @PersistenceContext
    private EntityManager em;

    private final NotificationServiceImpl notificationService =
            NotificationServiceImpl.getInstance();

    private final Set<String> sentReminderKeys = ConcurrentHashMap.newKeySet();

    @Schedule(hour = "*", minute = "0", second = "0", persistent = false)
    public void sendDayBeforeReminders() {
        LocalDate tomorrow = LocalDate.now().plusDays(1);

        List<RendezVous> rendezVousList = em.createQuery(
                        "SELECT r FROM RendezVous r JOIN FETCH r.patient JOIN FETCH r.medecin " +
                                "WHERE r.dateRdv = :targetDate " +
                                "AND UPPER(COALESCE(r.statut, 'PLANIFIE')) NOT IN ('ANNULE', 'EFFECTUE', 'TERMINE')",
                        RendezVous.class
                )
                .setParameter("targetDate", tomorrow)
                .getResultList();

        for (RendezVous rendezVous : rendezVousList) {
            Integer rdvId = rendezVous.getId();
            if (rdvId == null || rendezVous.getPatient() == null || rendezVous.getPatient().getId() <= 0) {
                continue;
            }

            String reminderKey = tomorrow + ":" + rdvId;
            if (!sentReminderKeys.add(reminderKey)) {
                continue;
            }

            notificationService.notifyPatient(
                    rendezVous.getPatient().getId(),
                    "Rappel: il reste 1 jour avant votre rendez-vous du " + rendezVous.getDateRdv() +
                            " de " + rendezVous.getHeureDebut() + " à " + rendezVous.getHeureFin() + "."
            );
        }

        cleanupOldKeys();
    }

    private void cleanupOldKeys() {
        String todayPrefix = LocalDate.now().toString() + ":";
        sentReminderKeys.removeIf(key -> key.compareTo(todayPrefix) < 0);
    }
}
