package com.jee.ejb.interfaces;

import com.jee.entity.Patient;
import com.jee.entity.User;
import jakarta.ejb.Local;

@Local
public interface AuthServiceLocal {

    User authenticate(String email, User.Role role, String password);

    boolean emailExists(String email);

    Patient registerPatient(String firstName, String lastName, String email, String phone, String password);
}
