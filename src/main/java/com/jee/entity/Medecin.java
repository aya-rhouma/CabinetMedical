package com.jee.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "medecin")
@PrimaryKeyJoinColumn(name = "id")
public class Medecin extends User {

    @Column(name = "specialite", nullable = false, length = 100)
    private String specialite;

    @Column(name = "licence_number", length = 100)
    private String licenceNumber;

    @Column(name = "experience", length = 50)
    private String experience;


    public Medecin() {
        setRole(Role.MEDECIN);
    }

    public String getSpecialite() {
        return specialite;
    }

    public void setSpecialite(String specialite) {
        this.specialite = specialite;
    }

    public String getLicenceNumber() {
        return licenceNumber;
    }

    public void setLicenceNumber(String licenceNumber) {
        this.licenceNumber = licenceNumber;
    }

    public String getExperience() {
        return experience;
    }

    public void setExperience(String experience) {
        this.experience = experience;
    }
}
