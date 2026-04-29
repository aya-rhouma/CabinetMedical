package com.jee.ejb.stateless;

import com.jee.ejb.interfaces.MedecinServiceLocal;
import com.jee.entity.CertificatMedical;
import com.jee.entity.DossierMedical;
import com.jee.entity.Medecin;
import com.jee.entity.Patient;
import com.jee.entity.Prescription;
import com.jee.entity.RendezVous;
import com.jee.entity.Secretaire;
import com.jee.rmi.server.NotificationServiceImpl;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

import java.time.LocalDate;
import java.util.List;
import java.util.Locale;

@Stateless
public class MedecinService implements MedecinServiceLocal {

    @PersistenceContext
    private EntityManager em;
    private final NotificationServiceImpl notificationService = NotificationServiceImpl.getInstance();

    @Override
    public Patient getPatientByMedecin(int medecinId, int patientId) {
        List<Patient> patients = em.createQuery(
                        "SELECT DISTINCT p FROM RendezVous r " +
                                "JOIN r.patient p " +
                                "WHERE r.medecin.id = :medecinId AND p.id = :patientId",
                        Patient.class
                )
                .setParameter("medecinId", medecinId)
                .setParameter("patientId", patientId)
                .setMaxResults(1)
                .getResultList();

        if (patients.isEmpty()) {
            throw new IllegalArgumentException("Patient introuvable pour ce médecin.");
        }
        return patients.get(0);
    }

    @Override
    public List<Patient> getPatientsByMedecin(int medecinId) {
        return em.createQuery(
                        "SELECT DISTINCT r.patient FROM RendezVous r WHERE r.medecin.id = :id",
                        Patient.class
                ).setParameter("id", medecinId)
                .getResultList();
    }

    @Override
    public List<RendezVous> getRendezVousByMedecin(int medecinId) {
        return em.createQuery(
                        "SELECT r FROM RendezVous r " +
                                "JOIN FETCH r.patient " +
                                "JOIN FETCH r.medecin " +
                                "WHERE r.medecin.id = :id ORDER BY r.dateRdv DESC, r.heureDebut DESC",
                        RendezVous.class
                ).setParameter("id", medecinId)
                .getResultList();
    }

    @Override
    public List<RendezVous> getRendezVousByPatient(int medecinId, int patientId) {
        return em.createQuery(
                        "SELECT r FROM RendezVous r " +
                                "JOIN FETCH r.patient " +
                                "JOIN FETCH r.medecin " +
                                "WHERE r.medecin.id = :medecinId AND r.patient.id = :patientId ORDER BY r.dateRdv DESC, r.heureDebut DESC",
                        RendezVous.class
                ).setParameter("medecinId", medecinId)
                .setParameter("patientId", patientId)
                .getResultList();
    }

    @Override
    public List<RendezVous> getRendezVousFiltres(int medecinId, Integer patientId, String filtre) {
        String filtreValue = filtre == null ? "all" : filtre.trim().toLowerCase(Locale.ROOT);
        StringBuilder jpql = new StringBuilder(
                "SELECT r FROM RendezVous r " +
                        "JOIN FETCH r.patient " +
                        "JOIN FETCH r.medecin " +
                        "WHERE r.medecin.id = :medecinId "
        );

        if (patientId != null) {
            jpql.append("AND r.patient.id = :patientId ");
        }

        if ("planifies".equals(filtreValue)) {
            jpql.append(
                    "AND r.statut <> 'ANNULE' " +
                            "AND (r.dateRdv > CURRENT_DATE OR (r.dateRdv = CURRENT_DATE AND r.heureFin >= CURRENT_TIME)) "
            );
        } else if ("termines".equals(filtreValue)) {
            jpql.append(
                    "AND (r.statut = 'TERMINE' OR r.dateRdv < CURRENT_DATE OR (r.dateRdv = CURRENT_DATE AND r.heureFin < CURRENT_TIME)) "
            );
        }

        jpql.append("ORDER BY r.dateRdv DESC, r.heureDebut DESC");

        TypedQuery<RendezVous> query = em.createQuery(jpql.toString(), RendezVous.class)
                .setParameter("medecinId", medecinId);
        if (patientId != null) {
            query.setParameter("patientId", patientId);
        }
        return query.getResultList();
    }

    @Override
    public DossierMedical getDossierMedical(int medecinId, int patientId) {
        List<DossierMedical> dossiers = em.createQuery(
                        "SELECT d FROM DossierMedical d WHERE d.patient.id = :patientId AND d.medecin.id = :medecinId ORDER BY d.id DESC",
                        DossierMedical.class
                ).setParameter("patientId", patientId)
                .setParameter("medecinId", medecinId)
                .setMaxResults(1)
                .getResultList();
        return dossiers.isEmpty() ? null : dossiers.get(0);
    }

    @Override
    public DossierMedical sauvegarderDossier(int medecinId, int patientId, String diagnostic, String notes) {
        DossierMedical dossier = getDossierMedical(medecinId, patientId);
        if (dossier == null) {
            dossier = new DossierMedical();
            dossier.setPatient(em.getReference(Patient.class, patientId));
            dossier.setMedecin(em.getReference(Medecin.class, medecinId));
            em.persist(dossier);
        }
        dossier.setDiagnostic(diagnostic);
        dossier.setNotes(notes);
        return dossier;
    }

    @Override
    public Prescription ajouterPrescription(int medecinId, int patientId, String contenu) {
        Prescription prescription = new Prescription();
        prescription.setPatient(em.getReference(Patient.class, patientId));
        prescription.setMedecin(em.getReference(Medecin.class, medecinId));
        prescription.setContenu(contenu);
        prescription.setDatePrescription(LocalDate.now());
        em.persist(prescription);
        return prescription;
    }

    @Override
    public List<Prescription> getPrescriptionsByPatient(int medecinId, int patientId) {
        return em.createQuery(
                        "SELECT p FROM Prescription p WHERE p.patient.id = :patientId AND p.medecin.id = :medecinId ORDER BY p.datePrescription DESC, p.id DESC",
                        Prescription.class
                ).setParameter("patientId", patientId)
                .setParameter("medecinId", medecinId)
                .getResultList();
    }

    @Override
    public CertificatMedical genererCertificat(int medecinId, int certificatId, String contenuTemplate, int nbJours) {
        CertificatMedical certificat = em.createQuery(
                        "SELECT c FROM CertificatMedical c " +
                                "JOIN FETCH c.patient " +
                                "JOIN FETCH c.medecin " +
                                "WHERE c.id = :id AND c.medecin.id = :medecinId",
                        CertificatMedical.class
                ).setParameter("id", certificatId)
                .setParameter("medecinId", medecinId)
                .getSingleResult();
        certificat.setStatut("GENERE");
        if (contenuTemplate != null && !contenuTemplate.isBlank()) {
            String contenu = contenuTemplate
                    .replace("{{MEDECIN}}", certificat.getMedecin().getPrenom() + " " + certificat.getMedecin().getNom())
                    .replace("{{PATIENT}}", certificat.getPatient().getPrenom() + " " + certificat.getPatient().getNom())
                    .replace("{{NB_JOURS}}", String.valueOf(Math.max(nbJours, 1)))
                    .replace("{{DATE}}", LocalDate.now().toString());
            certificat.setMotif(contenu);
        }
        notificationService.notifyPatient(certificat.getPatient().getId(), "Votre certificat médical #" + certificatId + " a été généré.");
        return certificat;
    }

    @Override
    public List<CertificatMedical> getDemandesCertificats(int medecinId) {
        return em.createQuery(
                        "SELECT c FROM CertificatMedical c " +
                                "JOIN FETCH c.patient " +
                                "JOIN FETCH c.medecin " +
                                "WHERE c.medecin.id = :id AND c.statut = 'DEMANDE' ORDER BY c.id DESC",
                        CertificatMedical.class
                ).setParameter("id", medecinId)
                .getResultList();
    }

    @Override
    public List<CertificatMedical> getDemandesCertificatsByPatient(int medecinId, int patientId) {
        return em.createQuery(
                        "SELECT c FROM CertificatMedical c " +
                                "JOIN FETCH c.patient " +
                                "JOIN FETCH c.medecin " +
                                "WHERE c.medecin.id = :medecinId " +
                                "AND c.patient.id = :patientId " +
                                "AND c.statut = 'DEMANDE' " +
                                "ORDER BY c.id DESC",
                        CertificatMedical.class
                )
                .setParameter("medecinId", medecinId)
                .setParameter("patientId", patientId)
                .getResultList();
    }

    @Override
    public List<Secretaire> getSecretairesByMedecin(int medecinId) {
        return em.createQuery(
                        "SELECT s FROM Secretaire s WHERE s.medecin.id = :medecinId ORDER BY s.nom, s.prenom",
                        Secretaire.class
                )
                .setParameter("medecinId", medecinId)
                .getResultList();
    }

    @Override
    public void deleteSecretaire(int medecinId, int secretaireId) {
        List<Secretaire> secretaires = em.createQuery(
                        "SELECT s FROM Secretaire s WHERE s.id = :secretaireId AND s.medecin.id = :medecinId",
                        Secretaire.class
                )
                .setParameter("secretaireId", secretaireId)
                .setParameter("medecinId", medecinId)
                .setMaxResults(1)
                .getResultList();

        if (secretaires.isEmpty()) {
            throw new IllegalArgumentException("Secretaire introuvable pour ce medecin.");
        }

        em.remove(secretaires.get(0));
    }
}
