package com.myemohealth.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

/**
 * Treatment phases (1-5) that patients progress through
 */
@Entity
@Table(name = "phase")
public class Phase {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true)
    private Integer number;

    @Column(nullable = false, length = 100)
    private String label;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "duration_days")
    private Integer durationDays;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    public Phase() {
    }

    public Phase(Integer id, Integer number, String label, String description, Integer durationDays,
            LocalDateTime createdAt) {
        this.id = id;
        this.number = number;
        this.label = label;
        this.description = description;
        this.durationDays = durationDays;
        this.createdAt = createdAt;
    }

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getNumber() {
        return number;
    }

    public void setNumber(Integer number) {
        this.number = number;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getDurationDays() {
        return durationDays;
    }

    public void setDurationDays(Integer durationDays) {
        this.durationDays = durationDays;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public static PhaseBuilder builder() {
        return new PhaseBuilder();
    }

    public static class PhaseBuilder {
        private Integer id;
        private Integer number;
        private String label;
        private String description;
        private Integer durationDays;
        private LocalDateTime createdAt;

        PhaseBuilder() {
        }

        public PhaseBuilder id(Integer id) {
            this.id = id;
            return this;
        }

        public PhaseBuilder number(Integer number) {
            this.number = number;
            return this;
        }

        public PhaseBuilder label(String label) {
            this.label = label;
            return this;
        }

        public PhaseBuilder description(String description) {
            this.description = description;
            return this;
        }

        public PhaseBuilder durationDays(Integer durationDays) {
            this.durationDays = durationDays;
            return this;
        }

        public PhaseBuilder createdAt(LocalDateTime createdAt) {
            this.createdAt = createdAt;
            return this;
        }

        public Phase build() {
            return new Phase(id, number, label, description, durationDays, createdAt);
        }
    }
}
