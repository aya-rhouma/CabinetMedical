package com.jee.ejb.interfaces;

import com.jee.entity.*;
import jakarta.ejb.Local;

import java.util.List;

@Local
public interface AdminServiceLocal {

    /* === STATS === */
    long countPatients();
    long countMedecins();
    long countSecretaires();
    long countRendezVous();

    /* === MEDECINS === */
    List<Medecin> getAllMedecins();
    Medecin addMedecin(String nom, String prenom, String email, String telephone,
                       String password, String specialite, String licenceNumber, String experience);
    void deleteMedecin(int medecinId);

    /* === SECRETAIRES === */
    List<Secretaire> getAllSecretaires();
    Secretaire addSecretaire(String nom, String prenom, String email, String telephone,
                              String password, Integer medecinId);
    void deleteSecretaire(int secretaireId);

    /* === MATERIELS === */
    List<Materiel> getAllMateriels();
    Materiel addMateriel(String nom, int quantite, int seuilAlerte);
    Materiel updateMateriel(int id, String nom, int quantite, int seuilAlerte);
    void deleteMateriel(int id);

    /* === PATIENTS === */
    List<Patient> getAllPatients();
}
