package com.jee.rmi.remote;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import com.jee.entity.CertificatMedical;
import com.jee.entity.Medecin;
import com.jee.entity.RendezVous;

public interface PatientServiceRemote extends Remote {

    RendezVous reserverRendezVous(int patientId, int medecinId,
                                  LocalDate date, LocalTime hDebut, LocalTime hFin) throws RemoteException;

    RendezVous annulerRendezVous(int patientId, int rdvId) throws RemoteException;

    RendezVous modifierHoraireRendezVous(int patientId, int rdvId,
                                         LocalDate date, LocalTime hDebut, LocalTime hFin) throws RemoteException;

    RendezVous getRendezVousById(int patientId, int rdvId) throws RemoteException;

    List<RendezVous> getRendezVousPlanifies(int patientId) throws RemoteException;

    List<RendezVous> getRendezVousPasses(int patientId) throws RemoteException;

    List<Medecin> getAllMedecins() throws RemoteException;

    List<Medecin> getMedecinsBySpecialite(String specialite) throws RemoteException;

    List<Medecin> getMedecinsDisponibles(String specialite,
                                         LocalDate date,
                                         LocalTime hDebut,
                                         LocalTime hFin) throws RemoteException;

    List<String> getAllSpecialites() throws RemoteException;

    CertificatMedical demanderCertificat(int patientId, int medecinId, String motif) throws RemoteException;

    List<CertificatMedical> getDemandesCertificats(int patientId) throws RemoteException;

    List<String> consumeNotifications(int patientId) throws RemoteException;
}