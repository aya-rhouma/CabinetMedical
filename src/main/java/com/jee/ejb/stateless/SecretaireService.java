package com.jee.ejb.stateless;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import com.jee.ejb.interfaces.SecretaireServiceLocal;
import com.jee.entity.DevisMateriel;
import com.jee.entity.Materiel;
import com.jee.entity.Patient;
import com.jee.entity.RendezVous;
import com.jee.entity.Secretaire;
import com.jee.rmi.server.NotificationServiceImpl;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

@Stateless
public class SecretaireService implements SecretaireServiceLocal {

    @PersistenceContext
    private EntityManager em;

    private final NotificationServiceImpl notificationService =
            NotificationServiceImpl.getInstance();

    /* ===================== STATS ===================== */

    @Override
    public long countPatients() {
        return em.createQuery("SELECT COUNT(p) FROM Patient p", Long.class).getSingleResult();
    }

    @Override
    public long countMedecins() {
        return em.createQuery("SELECT COUNT(m) FROM Medecin m", Long.class).getSingleResult();
    }

    @Override
    public long countRendezVous() {
        return em.createQuery("SELECT COUNT(r) FROM RendezVous r", Long.class).getSingleResult();
    }

    @Override
    public long countRendezVousDuJour() {
        return em.createQuery(
                "SELECT COUNT(r) FROM RendezVous r WHERE r.dateRdv = CURRENT_DATE AND r.statut <> 'ANNULE'",
                Long.class
        ).getSingleResult();
    }

    @Override
    public Secretaire getSecretaireById(int secretaireId) {
        List<Secretaire> result = em.createQuery(
                "SELECT s FROM Secretaire s LEFT JOIN FETCH s.medecin WHERE s.id = :id",
                Secretaire.class
        ).setParameter("id", secretaireId)
         .setMaxResults(1)
         .getResultList();
        return result.isEmpty() ? null : result.get(0);
    }

    /* ===================== PATIENTS ===================== */

    @Override
    public List<Patient> getAllPatients() {
        return em.createQuery(
                "SELECT p FROM Patient p ORDER BY p.nom, p.prenom",
                Patient.class
        ).getResultList();
    }

    @Override
    public Patient getPatientById(int patientId) {
        Patient p = em.find(Patient.class, patientId);
        if (p == null) {
            throw new IllegalArgumentException("Patient introuvable.");
        }
        return p;
    }

    /* ===================== RENDEZ-VOUS ===================== */

    @Override
    public List<RendezVous> getAllRendezVous() {
        return em.createQuery(
                "SELECT r FROM RendezVous r JOIN FETCH r.patient JOIN FETCH r.medecin " +
                "ORDER BY r.dateRdv DESC, r.heureDebut DESC",
                RendezVous.class
        ).getResultList();
    }

    @Override
    public List<RendezVous> getRendezVousDuJour() {
        return em.createQuery(
                "SELECT r FROM RendezVous r JOIN FETCH r.patient JOIN FETCH r.medecin " +
                "WHERE r.dateRdv = CURRENT_DATE AND r.statut <> 'ANNULE' " +
                "ORDER BY r.heureDebut ASC",
                RendezVous.class
        ).getResultList();
    }

    @Override
    public List<RendezVous> getRendezVousPasses() {
        return em.createQuery(
                "SELECT r FROM RendezVous r JOIN FETCH r.patient JOIN FETCH r.medecin " +
                "WHERE r.dateRdv < CURRENT_DATE OR r.statut = 'EFFECTUE' " +
                "ORDER BY r.dateRdv DESC, r.heureDebut DESC",
                RendezVous.class
        ).getResultList();
    }

    @Override
    public List<RendezVous> getRendezVousByStatut(String statut) {
        if (statut == null || statut.isBlank()) {
            return getAllRendezVous();
        }
        return em.createQuery(
                "SELECT r FROM RendezVous r JOIN FETCH r.patient JOIN FETCH r.medecin " +
                "WHERE r.statut = :statut ORDER BY r.dateRdv DESC, r.heureDebut DESC",
                RendezVous.class
        ).setParameter("statut", statut.toUpperCase()).getResultList();
    }

    @Override
    public List<RendezVous> getRendezVousByDate(LocalDate date) {
        if (date == null) {
            return getAllRendezVous();
        }
        return em.createQuery(
                "SELECT r FROM RendezVous r JOIN FETCH r.patient JOIN FETCH r.medecin " +
                "WHERE r.dateRdv = :date ORDER BY r.heureDebut ASC",
                RendezVous.class
        ).setParameter("date", date).getResultList();
    }

    @Override
    public List<RendezVous> getRendezVousByStatutAndDate(String statut, LocalDate date) {
        boolean hasStatut = statut != null && !statut.isBlank();
        boolean hasDate = date != null;

        if (!hasStatut && !hasDate) return getAllRendezVous();
        if (hasStatut && !hasDate) return getRendezVousByStatut(statut);
        if (!hasStatut) return getRendezVousByDate(date);

        String statutValue = statut == null ? "" : statut.toUpperCase();

        return em.createQuery(
                "SELECT r FROM RendezVous r JOIN FETCH r.patient JOIN FETCH r.medecin " +
                "WHERE r.statut = :statut AND r.dateRdv = :date " +
                "ORDER BY r.heureDebut ASC",
                RendezVous.class
        ).setParameter("statut", statutValue)
         .setParameter("date", date)
         .getResultList();
    }

    @Override
    public RendezVous changerStatutRendezVous(int rdvId, String statut) {
        RendezVous rdv = em.find(RendezVous.class, rdvId);
        if (rdv == null) {
            throw new IllegalArgumentException("Rendez-vous introuvable.");
        }
        rdv.setStatut(statut.toUpperCase());

        // Notifier le patient
        String message = switch (statut.toUpperCase()) {
            case "CONFIRME"  -> "Votre rendez-vous du " + rdv.getDateRdv() + " a été confirmé.";
            case "ANNULE"    -> "Votre rendez-vous du " + rdv.getDateRdv() + " a été annulé par la secrétaire.";
            case "EFFECTUE"  -> "Votre rendez-vous du " + rdv.getDateRdv() + " est marqué comme effectué.";
            default          -> "Statut de votre rendez-vous mis à jour : " + statut;
        };
        notificationService.notifyPatient(rdv.getPatient().getId(), message);

        return rdv;
    }

    @Override
    public RendezVous modifierHoraireRendezVous(int rdvId, LocalDate date, LocalTime heureDebut, LocalTime heureFin) {
        if (date == null || heureDebut == null || heureFin == null) {
            throw new IllegalArgumentException("Date et horaires obligatoires.");
        }
        if (!heureDebut.isBefore(heureFin)) {
            throw new IllegalArgumentException("Heure de début doit être avant heure de fin.");
        }

        RendezVous rdv = em.find(RendezVous.class, rdvId);
        if (rdv == null) {
            throw new IllegalArgumentException("Rendez-vous introuvable.");
        }

        long conflits = em.createQuery(
                "SELECT COUNT(r) FROM RendezVous r " +
                "WHERE r.medecin.id = :medecinId AND r.dateRdv = :date " +
                "AND r.id <> :rdvId AND r.statut <> 'ANNULE' " +
                "AND r.heureDebut < :heureFin AND r.heureFin > :heureDebut",
                Long.class
        ).setParameter("medecinId", rdv.getMedecin().getId())
         .setParameter("date", date)
         .setParameter("rdvId", rdvId)
         .setParameter("heureDebut", heureDebut)
         .setParameter("heureFin", heureFin)
         .getSingleResult();

        if (conflits > 0) {
            throw new IllegalArgumentException("Créneau non disponible pour ce médecin.");
        }

        rdv.setDateRdv(date);
        rdv.setHeureDebut(heureDebut);
        rdv.setHeureFin(heureFin);
        rdv.setStatut("PLANIFIE");

        notificationService.notifyPatient(
                rdv.getPatient().getId(),
                "Votre rendez-vous a été déplacé au " + date +
                " (" + heureDebut + " - " + heureFin + ")."
        );

        return rdv;
    }

    @Override
    public RendezVous marquerPaiement(int rdvId, boolean paye) {
        RendezVous rdv = em.find(RendezVous.class, rdvId);
        if (rdv == null) {
            throw new IllegalArgumentException("Rendez-vous introuvable.");
        }
        rdv.setPaye(paye);
        return rdv;
    }

    /* ===================== MATERIELS ===================== */

    @Override
    public List<Materiel> getAllMateriels() {
        return em.createQuery(
                "SELECT m FROM Materiel m ORDER BY m.nom",
                Materiel.class
        ).getResultList();
    }

    @Override
    public List<Materiel> getMaterielsEnAlerte() {
        return em.createQuery(
                "SELECT m FROM Materiel m WHERE m.quantite <= m.seuilAlerte ORDER BY m.nom",
                Materiel.class
        ).getResultList();
    }

    @Override
    public DevisMateriel genererDevis(int materielId, int quantiteDemandee) {
        Materiel materiel = em.find(Materiel.class, materielId);
        if (materiel == null) {
            throw new IllegalArgumentException("Matériel introuvable.");
        }
        if (quantiteDemandee <= 0) {
            throw new IllegalArgumentException("La quantité demandée doit être > 0.");
        }
        DevisMateriel devis = new DevisMateriel(materiel, quantiteDemandee);
        em.persist(devis);
        return devis;
    }

    @Override
    public List<DevisMateriel> getDevisRecents() {
        return em.createQuery(
                "SELECT d FROM DevisMateriel d JOIN FETCH d.materiel ORDER BY d.dateDevis DESC, d.id DESC",
                DevisMateriel.class
        ).setMaxResults(50).getResultList();
    }
}
