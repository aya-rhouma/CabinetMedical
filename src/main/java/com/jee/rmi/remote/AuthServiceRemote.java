package com.jee.rmi.remote;

import java.rmi.Remote;
import java.rmi.RemoteException;

import com.jee.entity.Medecin;
import com.jee.entity.Patient;
import com.jee.entity.Secretaire;
import com.jee.entity.User;

public interface AuthServiceRemote extends Remote {

    User authenticate(String email, User.Role role, String password) throws RemoteException;

    boolean emailExists(String email) throws RemoteException;

    Patient registerPatient(String firstName, String lastName, String email, String phone, String password) throws RemoteException;

    Medecin registerMedecin(String firstName, String lastName, String email, String phone, String password,
                            String specialite, String licenceNumber, String experience, String diplomePath) throws RemoteException;

    Secretaire registerSecretaire(String firstName, String lastName, String email, String phone, String password,
                                  int medecinId) throws RemoteException;

    boolean sendPasswordResetEmail(String email) throws RemoteException;
}