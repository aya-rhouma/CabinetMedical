package com.jee.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;

@Entity
@Table(name = "devis_materiel")
public class DevisMateriel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "materiel_id", nullable = false)
    private Materiel materiel;

    @Column(name = "quantite_demandee", nullable = false)
    private Integer quantiteDemandee;

    @Column(name = "date_devis", nullable = false)
    private LocalDate dateDevis;

    /* ===== Constructeurs ===== */

    public DevisMateriel() {
        this.dateDevis = LocalDate.now();
    }

    public DevisMateriel(Materiel materiel, Integer quantiteDemandee) {
        this.materiel = materiel;
        this.quantiteDemandee = quantiteDemandee;
        this.dateDevis = LocalDate.now();
    }

    /* ===== Getters & Setters ===== */

    public Integer getId() {
        return id;
    }

    public Materiel getMateriel() {
        return materiel;
    }

    public void setMateriel(Materiel materiel) {
        this.materiel = materiel;
    }

    public Integer getQuantiteDemandee() {
        return quantiteDemandee;
    }

    public void setQuantiteDemandee(Integer quantiteDemandee) {
        if (quantiteDemandee <= 0) {
            throw new IllegalArgumentException("La quantité demandée doit être > 0");
        }
        this.quantiteDemandee = quantiteDemandee;
    }

    public LocalDate getDateDevis() {
        return dateDevis;
    }

    public void setDateDevis(LocalDate dateDevis) {
        this.dateDevis = dateDevis;
    }
}