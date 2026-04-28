package com.jee.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "medecin")
@PrimaryKeyJoinColumn(name = "id")
public class Medecin extends User {

    @Column(name = "specialite", nullable = false, length = 100)
    private String specialite;

    public Medecin() {
        setRole(Role.MEDECIN);
    }

    public String getSpecialite() {
        return specialite;
    }

    public void setSpecialite(String specialite) {
        this.specialite = specialite;
    }

}
