package com.jee.entity;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "materiel")
public class Materiel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String nom;

    @Column(nullable = false)
    private Integer quantite;

    @Column(name = "seuil_alerte", nullable = false)
    private Integer seuilAlerte;

    /* ===== Constructeurs ===== */

    public Materiel() {
    }

    public Materiel(String nom, Integer quantite, Integer seuilAlerte) {
        this.nom = nom;
        this.quantite = quantite;
        this.seuilAlerte = seuilAlerte;
    }

    /* ===== Logique métier ===== */

    public boolean isEnAlerte() {
        return quantite != null && seuilAlerte != null && quantite <= seuilAlerte;
    }

    /* ===== Getters & Setters ===== */

    public Integer getId() {
        return id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public Integer getQuantite() {
        return quantite;
    }

    public void setQuantite(Integer quantite) {
        if (quantite < 0) {
            throw new IllegalArgumentException("La quantité ne peut pas être négative");
        }
        this.quantite = quantite;
    }

    public Integer getSeuilAlerte() {
        return seuilAlerte;
    }

    public void setSeuilAlerte(Integer seuilAlerte) {
        if (seuilAlerte < 0) {
            throw new IllegalArgumentException("Le seuil d'alerte ne peut pas être négatif");
        }
        this.seuilAlerte = seuilAlerte;
    }
}