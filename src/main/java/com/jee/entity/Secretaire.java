package com.jee.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Table(name = "secretaire")
@PrimaryKeyJoinColumn(name = "id")
public class Secretaire extends User {

    @ManyToOne(fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.SET_NULL)
    @JoinColumn(name = "medecin_id")
    private Medecin medecin;

    public Secretaire() {
        setRole(Role.SECRETAIRE);
    }

    public Medecin getMedecin() {
        return medecin;
    }

    public void setMedecin(Medecin medecin) {
        this.medecin = medecin;
    }

}
