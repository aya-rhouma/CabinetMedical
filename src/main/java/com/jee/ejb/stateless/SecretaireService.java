package com.jee.ejb.stateless;

import com.jee.ejb.interfaces.SecretaireServiceLocal;
import com.jee.entity.Medecin;
import com.jee.entity.Patient;
import com.jee.entity.RendezVous;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

@Stateless
public class SecretaireService implements SecretaireServiceLocal {

    @PersistenceContext
    private EntityManager em;

    @Override
    public long countPatients() {
        return em.createQuery("SELECT COUNT(p) FROM Patient p", Long.class).getSingleResult();
    }

    @Override
    public long countMedecins() {
        return em.createQuery("SELECT COUNT(m) FROM Medecin m", Long.class).getSingleResult();
    }

    @Override
    public long countRendezVous() {
        return em.createQuery("SELECT COUNT(r) FROM RendezVous r", Long.class).getSingleResult();
    }
}
