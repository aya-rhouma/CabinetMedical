package com.jee.ejb.stateless;

import com.jee.ejb.interfaces.AuthServiceLocal;
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
        patient.setEmail(email);
        patient.setTelephone(phone);
        patient.setMotDePasse(password);
        patient.setDateNaissance(LocalDate.now());
        patient.setAdresse("");
        em.persist(patient);
        return patient;
    }
}
