package com.jee.ejb.interfaces;

import jakarta.ejb.Local;

@Local
public interface SecretaireServiceLocal {
    long countPatients();
    long countMedecins();
    long countRendezVous();
}
