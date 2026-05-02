package com.jee.rmi.remote;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import com.jee.entity.DevisMateriel;
import com.jee.entity.Materiel;
import com.jee.entity.Patient;
import com.jee.entity.RendezVous;
import com.jee.entity.Secretaire;

public interface SecretaireServiceRemote extends Remote {

    long countPatients() throws RemoteException;

    long countMedecins() throws RemoteException;

    long countRendezVous() throws RemoteException;

    long countRendezVousDuJour() throws RemoteException;

    Secretaire getSecretaireById(int secretaireId) throws RemoteException;

    List<Patient> getAllPatients() throws RemoteException;

    Patient getPatientById(int patientId) throws RemoteException;

    List<RendezVous> getAllRendezVous() throws RemoteException;

    List<RendezVous> getRendezVousDuJour() throws RemoteException;

    List<RendezVous> getRendezVousPasses() throws RemoteException;

    List<RendezVous> getRendezVousByStatut(String statut) throws RemoteException;

    List<RendezVous> getRendezVousByDate(LocalDate date) throws RemoteException;

    List<RendezVous> getRendezVousByStatutAndDate(String statut, LocalDate date) throws RemoteException;

    RendezVous changerStatutRendezVous(int rdvId, String statut) throws RemoteException;

    RendezVous modifierHoraireRendezVous(int rdvId, LocalDate date, LocalTime heureDebut, LocalTime heureFin) throws RemoteException;

    RendezVous marquerPaiement(int rdvId, boolean paye) throws RemoteException;

    List<Materiel> getAllMateriels() throws RemoteException;

    List<Materiel> getMaterielsEnAlerte() throws RemoteException;

    DevisMateriel genererDevis(int materielId, int quantiteDemandee) throws RemoteException;

    List<DevisMateriel> getDevisRecents() throws RemoteException;
}