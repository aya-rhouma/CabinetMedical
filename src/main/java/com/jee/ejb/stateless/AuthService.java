package com.jee.ejb.stateless;

import com.jee.ejb.interfaces.AuthServiceLocal;
import com.jee.entity.Medecin;
import com.jee.entity.Patient;
import com.jee.entity.User;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.time.LocalDate;
import java.util.List;
import java.util.Locale;

@Stateless
public class AuthService implements AuthServiceLocal {

    @PersistenceContext
    private EntityManager em;

    @Override
    public User authenticate(String email, User.Role role, String password) {
        if (email == null || role == null || password == null) {
            return null;
        }

        List<User> users = em.createQuery(
                        "SELECT u FROM User u WHERE LOWER(u.email) = :email AND u.role = :role",
                        User.class
                )
                .setParameter("email", email.toLowerCase(Locale.ROOT))
                .setParameter("role", role)
                .setMaxResults(1)
                .getResultList();

        if (users.isEmpty()) {
            return null;
        }

        User user = users.get(0);
        return password.equals(user.getMotDePasse()) ? user : null;
    }

    @Override
    public boolean emailExists(String email) {
        if (email == null || email.isBlank()) {
            return false;
        }

        Long existing = em.createQuery(
                        "SELECT COUNT(u) FROM User u WHERE LOWER(u.email) = :email",
                        Long.class
                )
                .setParameter("email", email.toLowerCase(Locale.ROOT))
                .getSingleResult();
        return existing != null && existing > 0;
    }

    @Override
    public Patient registerPatient(String firstName, String lastName, String email, String phone, String password) {
        Patient patient = new Patient();
        patient.setPrenom(firstName);
        patient.setNom(lastName);
        patient.setEmail(email.toLowerCase(Locale.ROOT));
        patient.setTelephone(phone);
        patient.setMotDePasse(password);
        patient.setDateNaissance(LocalDate.now());
        patient.setAdresse("");
        patient.setCIN(generateUniqueCIN());
        em.persist(patient);
        return patient;
    }

    @Override
    public Medecin registerMedecin(String firstName, String lastName, String email, String phone, String password,
                                   String specialite, String licenceNumber, String experience, String diplomePath) {
        Medecin medecin = new Medecin();
        medecin.setPrenom(firstName);
        medecin.setNom(lastName);
        medecin.setEmail(email.toLowerCase(Locale.ROOT));
        medecin.setTelephone(phone);
        medecin.setMotDePasse(password);
        medecin.setSpecialite(specialite);
        medecin.setLicenceNumber(licenceNumber);
        medecin.setExperience(experience);
        medecin.setCIN(generateUniqueCIN());
        em.persist(medecin);
        return medecin;
    }

    @Override
    public boolean sendPasswordResetEmail(String email) {
        return emailExists(email);
    }

    private int generateUniqueCIN() {
        int cin;
        boolean exists;
        do {
            cin = 10000000 + (int)(Math.random() * 90000000);
            Long count = em.createQuery(
                    "SELECT COUNT(u) FROM User u WHERE u.cin = :cin",
                    Long.class
            )
            .setParameter("cin", cin)
            .getSingleResult();
            exists = count != null && count > 0;
        } while (exists);
        return cin;
    }
}
