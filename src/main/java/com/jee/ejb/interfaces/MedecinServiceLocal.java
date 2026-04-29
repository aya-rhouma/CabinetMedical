package com.jee.ejb.interfaces;

import com.jee.entity.*;
import jakarta.ejb.Local;

import java.util.List;

@Local
public interface MedecinServiceLocal {

    List<Patient> getPatientsByMedecin(int medecinId);

    Patient getPatientByMedecin(int medecinId, int patientId);

    List<RendezVous> getRendezVousByMedecin(int medecinId);

    List<RendezVous> getRendezVousByPatient(int medecinId, int patientId);

    List<RendezVous> getRendezVousFiltres(int medecinId, Integer patientId, String filtre);

    DossierMedical getDossierMedical(int medecinId, int patientId);

    DossierMedical sauvegarderDossier(int medecinId, int patientId, String diagnostic, String notes);

    Prescription ajouterPrescription(int medecinId, int patientId, String contenu);

    List<Prescription> getPrescriptionsByPatient(int medecinId, int patientId);

    CertificatMedical genererCertificat(int medecinId, int certificatId, String contenuTemplate, int nbJours);

    List<CertificatMedical> getDemandesCertificats(int medecinId);

    List<CertificatMedical> getDemandesCertificatsByPatient(int medecinId, int patientId);
}
