package com.jee.entity;

import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "patient")
@PrimaryKeyJoinColumn(name = "id")
public class Patient extends User {

    @Column(name = "date_naissance", nullable = false)
    private LocalDate dateNaissance;

    @Lob
    @Column(name = "adresse")
    private String adresse;

    public Patient() {
        setRole(Role.PATIENT);
    }

    public LocalDate getDateNaissance() {
        return dateNaissance;
    }

    public void setDateNaissance(LocalDate dateNaissance) {
        this.dateNaissance = dateNaissance;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

}
