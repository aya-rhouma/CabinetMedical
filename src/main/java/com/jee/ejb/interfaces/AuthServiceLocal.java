package com.jee.ejb.interfaces;

import com.jee.entity.Patient;
import com.jee.entity.Medecin;
import com.jee.entity.Secretaire;
import com.jee.entity.User;
import jakarta.ejb.Local;

@Local
public interface AuthServiceLocal {

    User authenticate(String email, User.Role role, String password);

    boolean emailExists(String email);

    Patient registerPatient(String firstName, String lastName, String email, String phone, String password);

    Medecin registerMedecin(String firstName, String lastName, String email, String phone, String password,
                            String specialite, String licenceNumber, String experience, String diplomePath);

    Secretaire registerSecretaire(String firstName, String lastName, String email, String phone, String password,
                                  int medecinId);

    boolean sendPasswordResetEmail(String email);
}
