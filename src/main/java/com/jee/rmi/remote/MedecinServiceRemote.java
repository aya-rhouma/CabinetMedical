package com.jee.rmi.remote;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

import com.jee.entity.CertificatMedical;
import com.jee.entity.DossierMedical;
import com.jee.entity.Patient;
import com.jee.entity.Prescription;
import com.jee.entity.RendezVous;
import com.jee.entity.Secretaire;

public interface MedecinServiceRemote extends Remote {

    List<Patient> getPatientsByMedecin(int medecinId) throws RemoteException;

    Patient getPatientByMedecin(int medecinId, int patientId) throws RemoteException;

    List<RendezVous> getRendezVousByMedecin(int medecinId) throws RemoteException;

    List<RendezVous> getRendezVousByPatient(int medecinId, int patientId) throws RemoteException;

    List<RendezVous> getRendezVousFiltres(int medecinId, Integer patientId, String filtre) throws RemoteException;

    DossierMedical getDossierMedical(int medecinId, int patientId) throws RemoteException;

    DossierMedical sauvegarderDossier(int medecinId, int patientId, String diagnostic, String notes) throws RemoteException;

    Prescription ajouterPrescription(int medecinId, int patientId, String contenu) throws RemoteException;

    List<Prescription> getPrescriptionsByPatient(int medecinId, int patientId) throws RemoteException;

    CertificatMedical genererCertificat(int medecinId, int certificatId, String contenuTemplate, int nbJours) throws RemoteException;

    List<CertificatMedical> getDemandesCertificats(int medecinId) throws RemoteException;

    List<CertificatMedical> getDemandesCertificatsByPatient(int medecinId, int patientId) throws RemoteException;

    List<Secretaire> getSecretairesByMedecin(int medecinId) throws RemoteException;

    void deleteSecretaire(int medecinId, int secretaireId) throws RemoteException;
}