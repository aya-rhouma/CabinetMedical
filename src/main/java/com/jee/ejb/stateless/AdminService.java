package com.jee.ejb.stateless;

import com.jee.ejb.interfaces.AdminServiceLocal;
import com.jee.entity.*;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;

@Stateless
public class AdminService implements AdminServiceLocal {

    @PersistenceContext
    private EntityManager em;

    /* ===================== STATS ===================== */

    @Override
    public long countPatients() {
        return em.createQuery("SELECT COUNT(p) FROM Patient p", Long.class).getSingleResult();
    }

    @Override
    public long countMedecins() {
        return em.createQuery("SELECT COUNT(m) FROM Medecin m", Long.class).getSingleResult();
    }

    @Override
    public long countSecretaires() {
        return em.createQuery("SELECT COUNT(s) FROM Secretaire s", Long.class).getSingleResult();
    }

    @Override
    public long countRendezVous() {
        return em.createQuery("SELECT COUNT(r) FROM RendezVous r", Long.class).getSingleResult();
    }

    /* ===================== MEDECINS ===================== */

    @Override
    public List<Medecin> getAllMedecins() {
        return em.createQuery("SELECT m FROM Medecin m ORDER BY m.nom, m.prenom", Medecin.class).getResultList();
    }

    @Override
    public Medecin addMedecin(String nom, String prenom, String email, String telephone,
                               String password, String specialite, String licenceNumber, String experience) {
        if (emailExists(email)) {
            throw new IllegalArgumentException("Cet email est déjà utilisé.");
        }
        Medecin m = new Medecin();
        m.setNom(nom);
        m.setPrenom(prenom);
        m.setEmail(email.toLowerCase());
        m.setTelephone(telephone);
        m.setMotDePasse(password);
        m.setSpecialite(specialite);
        m.setLicenceNumber(licenceNumber);
        m.setExperience(experience);
        em.persist(m);
        return m;
    }

    @Override
    public void deleteMedecin(int medecinId) {
        Medecin m = em.find(Medecin.class, medecinId);
        if (m == null) throw new IllegalArgumentException("Médecin introuvable.");
        em.remove(m);
    }

    /* ===================== SECRETAIRES ===================== */

    @Override
    public List<Secretaire> getAllSecretaires() {
        return em.createQuery("SELECT s FROM Secretaire s ORDER BY s.nom, s.prenom", Secretaire.class).getResultList();
    }

    @Override
    public Secretaire addSecretaire(String nom, String prenom, String email, String telephone,
                                     String password, Integer medecinId) {
        if (emailExists(email)) {
            throw new IllegalArgumentException("Cet email est déjà utilisé.");
        }
        Secretaire s = new Secretaire();
        s.setNom(nom);
        s.setPrenom(prenom);
        s.setEmail(email.toLowerCase());
        s.setTelephone(telephone);
        s.setMotDePasse(password);
        if (medecinId != null) {
            Medecin medecin = em.find(Medecin.class, medecinId);
            s.setMedecin(medecin);
        }
        em.persist(s);
        return s;
    }

    @Override
    public void deleteSecretaire(int secretaireId) {
        Secretaire s = em.find(Secretaire.class, secretaireId);
        if (s == null) throw new IllegalArgumentException("Secrétaire introuvable.");
        em.remove(s);
    }

    /* ===================== MATERIELS ===================== */

    @Override
    public List<Materiel> getAllMateriels() {
        return em.createQuery("SELECT m FROM Materiel m ORDER BY m.nom", Materiel.class).getResultList();
    }

    @Override
    public Materiel addMateriel(String nom, int quantite, int seuilAlerte) {
        Materiel m = new Materiel(nom, quantite, seuilAlerte);
        em.persist(m);
        return m;
    }

    @Override
    public Materiel updateMateriel(int id, String nom, int quantite, int seuilAlerte) {
        Materiel m = em.find(Materiel.class, id);
        if (m == null) throw new IllegalArgumentException("Matériel introuvable.");
        m.setNom(nom);
        m.setQuantite(quantite);
        m.setSeuilAlerte(seuilAlerte);
        return m;
    }

    @Override
    public void deleteMateriel(int id) {
        Materiel m = em.find(Materiel.class, id);
        if (m == null) throw new IllegalArgumentException("Matériel introuvable.");
        em.remove(m);
    }

    /* ===================== PATIENTS ===================== */

    @Override
    public List<Patient> getAllPatients() {
        return em.createQuery("SELECT p FROM Patient p ORDER BY p.nom, p.prenom", Patient.class).getResultList();
    }

    /* ===================== HELPER ===================== */

    private boolean emailExists(String email) {
        Long count = em.createQuery("SELECT COUNT(u) FROM User u WHERE LOWER(u.email) = :email", Long.class)
                .setParameter("email", email.toLowerCase())
                .getSingleResult();
        return count > 0;
    }
}
