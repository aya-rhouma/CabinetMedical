package com.jee.ejb.interfaces;

import com.jee.entity.*;

import jakarta.ejb.Local;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Local
public interface PatientServiceLocal {

    /* === RDV === */
    RendezVous reserverRendezVous(int patientId, int medecinId,
                                  LocalDate date, LocalTime hDebut, LocalTime hFin);

    RendezVous annulerRendezVous(int patientId, int rdvId);

    RendezVous modifierHoraireRendezVous(int patientId, int rdvId,
                                         LocalDate date, LocalTime hDebut, LocalTime hFin);

    RendezVous getRendezVousById(int patientId, int rdvId);

    List<RendezVous> getRendezVousPlanifies(int patientId);

    List<RendezVous> getRendezVousPasses(int patientId);

    /* === MEDECINS === */
    List<Medecin> getAllMedecins();                 // ✅ IMPORTANT
    List<Medecin> getMedecinsBySpecialite(String specialite);
    List<Medecin> getMedecinsDisponibles(String specialite,
                                         LocalDate date,
                                         LocalTime hDebut,
                                         LocalTime hFin);
    public List<String> getAllSpecialites();
    /* === CERTIFICATS === */
    CertificatMedical demanderCertificat(int patientId, int medecinId, String motif);
    List<CertificatMedical> getDemandesCertificats(int patientId);

    /* === NOTIFICATIONS === */
    List<String> consumeNotifications(int patientId);
}
