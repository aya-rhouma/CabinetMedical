package com.jee.rmi.remote;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

import com.jee.entity.Materiel;
import com.jee.entity.Medecin;
import com.jee.entity.Patient;
import com.jee.entity.Secretaire;

public interface AdminServiceRemote extends Remote {

    long countPatients() throws RemoteException;

    long countMedecins() throws RemoteException;

    long countSecretaires() throws RemoteException;

    long countRendezVous() throws RemoteException;

    List<Medecin> getAllMedecins() throws RemoteException;

    Medecin addMedecin(String nom, String prenom, String email, String telephone,
                       String password, String specialite, String licenceNumber, String experience) throws RemoteException;

    void deleteMedecin(int medecinId) throws RemoteException;

    List<Secretaire> getAllSecretaires() throws RemoteException;

    Secretaire addSecretaire(String nom, String prenom, String email, String telephone,
                             String password, Integer medecinId) throws RemoteException;

    void deleteSecretaire(int secretaireId) throws RemoteException;

    List<Materiel> getAllMateriels() throws RemoteException;

    Materiel addMateriel(String nom, int quantite, int seuilAlerte) throws RemoteException;

    Materiel updateMateriel(int id, String nom, int quantite, int seuilAlerte) throws RemoteException;

    void deleteMateriel(int id) throws RemoteException;

    List<Patient> getAllPatients() throws RemoteException;
}