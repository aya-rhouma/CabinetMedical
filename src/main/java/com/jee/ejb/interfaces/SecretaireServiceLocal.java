package com.jee.ejb.interfaces;

import com.jee.entity.*;
import jakarta.ejb.Local;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Local
public interface SecretaireServiceLocal {

    /* === STATS DASHBOARD === */
    long countPatients();
    long countMedecins();
    long countRendezVous();
    long countRendezVousDuJour();

    /* === PATIENTS === */
    List<Patient> getAllPatients();
    Patient getPatientById(int patientId);

    /* === RENDEZ-VOUS === */
    List<RendezVous> getAllRendezVous();
    List<RendezVous> getRendezVousDuJour();
    List<RendezVous> getRendezVousPasses();
    List<RendezVous> getRendezVousByStatut(String statut);
    List<RendezVous> getRendezVousByDate(LocalDate date);
    List<RendezVous> getRendezVousByStatutAndDate(String statut, LocalDate date);

    RendezVous changerStatutRendezVous(int rdvId, String statut);
    RendezVous modifierHoraireRendezVous(int rdvId, LocalDate date, LocalTime heureDebut, LocalTime heureFin);
    RendezVous marquerPaiement(int rdvId, boolean paye);

    /* === MATERIELS === */
    List<Materiel> getAllMateriels();
    List<Materiel> getMaterielsEnAlerte();
    DevisMateriel genererDevis(int materielId, int quantiteDemandee);
    List<DevisMateriel> getDevisRecents();
}
