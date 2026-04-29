package com.jee.ejb.stateless;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import com.jee.ejb.interfaces.PatientServiceLocal;
import com.jee.entity.CertificatMedical;
import com.jee.entity.Medecin;
import com.jee.entity.Patient;
import com.jee.entity.RendezVous;
import com.jee.rmi.server.NotificationServiceImpl;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

@Stateless
public class PatientService implements PatientServiceLocal {

    @PersistenceContext
    private EntityManager em;

    private final NotificationServiceImpl notificationService =
            NotificationServiceImpl.getInstance();

    /* ===================== RENDEZ-VOUS ===================== */

    @Override
    public List<RendezVous> getRendezVousPlanifies(int patientId) {
        return em.createQuery(
                        "SELECT r FROM RendezVous r JOIN FETCH r.medecin " +
                                "WHERE r.patient.id = :patientId " +
                                "AND r.statut <> 'ANNULE' " +
                                "AND (r.dateRdv > CURRENT_DATE " +
                                "OR (r.dateRdv = CURRENT_DATE AND r.heureFin >= CURRENT_TIME)) " +
                                "ORDER BY r.dateRdv ASC, r.heureDebut ASC",
                        RendezVous.class
                )
                .setParameter("patientId", patientId)
                .getResultList();
    }

    @Override
    public List<RendezVous> getRendezVousPasses(int patientId) {
        return em.createQuery(
                        "SELECT r FROM RendezVous r JOIN FETCH r.medecin " +
                                "WHERE r.patient.id = :patientId " +
                                "AND (r.statut = 'TERMINE' " +
                                "OR r.dateRdv < CURRENT_DATE " +
                                "OR (r.dateRdv = CURRENT_DATE AND r.heureFin < CURRENT_TIME)) " +
                                "ORDER BY r.dateRdv DESC, r.heureDebut DESC",
                        RendezVous.class
                )
                .setParameter("patientId", patientId)
                .getResultList();
    }

    @Override
    public RendezVous getRendezVousById(int patientId, int rendezVousId) {
        List<RendezVous> result = em.createQuery(
                        "SELECT r FROM RendezVous r JOIN FETCH r.medecin " +
                                "WHERE r.id = :id AND r.patient.id = :patientId",
                        RendezVous.class
                )
                .setParameter("id", rendezVousId)
                .setParameter("patientId", patientId)
                .setMaxResults(1)
                .getResultList();

        if (result.isEmpty()) {
            throw new IllegalArgumentException("Rendez-vous introuvable.");
        }
        return result.get(0);
    }

    @Override
    public RendezVous reserverRendezVous(int patientId, int medecinId,
                                         LocalDate date, LocalTime heureDebut, LocalTime heureFin) {

        assertHoraireValide(date, heureDebut, heureFin);

        long conflits = em.createQuery(
                        "SELECT COUNT(r) FROM RendezVous r " +
                                "WHERE r.medecin.id = :medecinId " +
                                "AND r.dateRdv = :date " +
                                "AND r.statut <> 'ANNULE' " +
                                "AND r.heureDebut < :heureFin " +
                                "AND r.heureFin > :heureDebut",
                        Long.class
                )
                .setParameter("medecinId", medecinId)
                .setParameter("date", date)
                .setParameter("heureDebut", heureDebut)
                .setParameter("heureFin", heureFin)
                .getSingleResult();

        if (conflits > 0) {
            throw new IllegalArgumentException("Créneau non disponible pour ce médecin.");
        }

        RendezVous rdv = new RendezVous();
        rdv.setPatient(em.getReference(Patient.class, patientId));
        rdv.setMedecin(em.getReference(Medecin.class, medecinId));
        rdv.setDateRdv(date);
        rdv.setHeureDebut(heureDebut);
        rdv.setHeureFin(heureFin);
        rdv.setStatut("PLANIFIE");

        em.persist(rdv);

        notificationService.notifyPatient(
                patientId,
                "Votre rendez-vous est planifié le " + date +
                        " de " + heureDebut + " à " + heureFin + "."
        );

        return rdv;
    }

    @Override
    public RendezVous annulerRendezVous(int patientId, int rendezVousId) {
        RendezVous rdv = em.createQuery(
                        "SELECT r FROM RendezVous r " +
                                "WHERE r.id = :id AND r.patient.id = :patientId",
                        RendezVous.class
                )
                .setParameter("id", rendezVousId)
                .setParameter("patientId", patientId)
                .getSingleResult();

        rdv.setStatut("ANNULE");

        notificationService.notifyPatient(
                patientId,
                "Votre rendez-vous #" + rendezVousId + " a été annulé."
        );

        return rdv;
    }

    @Override
    public RendezVous modifierHoraireRendezVous(int patientId, int rendezVousId,
                                                LocalDate date, LocalTime heureDebut, LocalTime heureFin) {

        assertHoraireValide(date, heureDebut, heureFin);

        RendezVous rdv = em.createQuery(
                        "SELECT r FROM RendezVous r " +
                                "WHERE r.id = :id AND r.patient.id = :patientId",
                        RendezVous.class
                )
                .setParameter("id", rendezVousId)
                .setParameter("patientId", patientId)
                .getSingleResult();

        long conflits = em.createQuery(
                        "SELECT COUNT(r) FROM RendezVous r " +
                                "WHERE r.medecin.id = :medecinId " +
                                "AND r.dateRdv = :date " +
                                "AND r.id <> :rdvId " +
                                "AND r.statut <> 'ANNULE' " +
                                "AND r.heureDebut < :heureFin " +
                                "AND r.heureFin > :heureDebut",
                        Long.class
                )
                .setParameter("medecinId", rdv.getMedecin().getId())
                .setParameter("date", date)
                .setParameter("rdvId", rendezVousId)
                .setParameter("heureDebut", heureDebut)
                .setParameter("heureFin", heureFin)
                .getSingleResult();

        if (conflits > 0) {
            throw new IllegalArgumentException("Le nouvel horaire n'est pas disponible.");
        }

        rdv.setDateRdv(date);
        rdv.setHeureDebut(heureDebut);
        rdv.setHeureFin(heureFin);
        rdv.setStatut("PLANIFIE");

        notificationService.notifyPatient(
                patientId,
                "Votre rendez-vous #" + rendezVousId +
                        " a été modifié : " + date +
                        " (" + heureDebut + " - " + heureFin + ")."
        );

        return rdv;
    }

    /* ===================== MEDECINS ===================== */

    /**
     * ✅ NOUVELLE MÉTHODE – affichage de TOUS les médecins (dashboard par défaut)
     */
    @Override
    public List<Medecin> getAllMedecins() {
        return em.createQuery(
                "SELECT m FROM Medecin m ORDER BY m.nom, m.prenom",
                Medecin.class
        ).getResultList();
    }

    public List<String> getAllSpecialites() {
        return em.createQuery(
                "SELECT DISTINCT m.specialite FROM Medecin m " +
                        "WHERE m.specialite IS NOT NULL AND m.specialite <> '' " +
                        "ORDER BY m.specialite",
                String.class
        ).getResultList();
    }


    @Override
    public List<Medecin> getMedecinsBySpecialite(String specialite) {
        String s = specialite == null ? "" : specialite.trim();

        if (s.isEmpty()) {
            return getAllMedecins();
        }

        return em.createQuery(
                        "SELECT m FROM Medecin m " +
                                "WHERE LOWER(m.specialite) LIKE :spec " +
                                "ORDER BY m.nom, m.prenom",
                        Medecin.class
                )
                .setParameter("spec", "%" + s.toLowerCase() + "%")
                .getResultList();
    }

    @Override
    public List<Medecin> getMedecinsDisponibles(String specialite,
                                                LocalDate date,
                                                LocalTime heureDebut,
                                                LocalTime heureFin) {

        assertHoraireValide(date, heureDebut, heureFin);

        String s = specialite == null ? "" : specialite.trim();

        return em.createQuery(
                        "SELECT m FROM Medecin m " +
                                "WHERE (:spec = '' OR LOWER(m.specialite) LIKE :likeSpec) " +
                                "AND m.id NOT IN (" +
                                "   SELECT r.medecin.id FROM RendezVous r " +
                                "   WHERE r.dateRdv = :date " +
                                "   AND r.statut <> 'ANNULE' " +
                                "   AND r.heureDebut < :heureFin " +
                                "   AND r.heureFin > :heureDebut" +
                                ") " +
                                "ORDER BY m.nom, m.prenom",
                        Medecin.class
                )
                .setParameter("spec", s)
                .setParameter("likeSpec", "%" + s.toLowerCase() + "%")
                .setParameter("date", date)
                .setParameter("heureDebut", heureDebut)
                .setParameter("heureFin", heureFin)
                .getResultList();
    }

    /* ===================== CERTIFICATS ===================== */

    @Override
    public CertificatMedical demanderCertificat(int patientId, int medecinId, String motif) {

        CertificatMedical certificat = new CertificatMedical();
        certificat.setPatient(em.getReference(Patient.class, patientId));
        certificat.setMedecin(em.getReference(Medecin.class, medecinId));
        certificat.setStatut("DEMANDE");
        certificat.setMotif(motif);

        em.persist(certificat);
        return certificat;
    }

    @Override
    public List<CertificatMedical> getDemandesCertificats(int patientId) {
        return em.createQuery(
                        "SELECT c FROM CertificatMedical c " +
                                "JOIN FETCH c.medecin " +
                                "WHERE c.patient.id = :patientId " +
                                "ORDER BY c.id DESC",
                        CertificatMedical.class
                )
                .setParameter("patientId", patientId)
                .getResultList();
    }

    /* ===================== NOTIFICATIONS ===================== */

    @Override
    public List<String> consumeNotifications(int patientId) {
        return notificationService.consumePendingNotifications(patientId);
    }

    /* ===================== VALIDATION ===================== */

    private void assertHoraireValide(LocalDate date,
                                     LocalTime heureDebut,
                                     LocalTime heureFin) {

        if (date == null || heureDebut == null || heureFin == null) {
            throw new IllegalArgumentException("Date et horaires obligatoires.");
        }
        if (!heureDebut.isBefore(heureFin)) {
            throw new IllegalArgumentException(
                    "Heure de début doit être avant heure de fin."
            );
        }
    }
}
