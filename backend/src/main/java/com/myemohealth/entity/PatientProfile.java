package com.myemohealth.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Extended profile information for patients
 */
@Entity
@Table(name = "patient_profile")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PatientProfile {

    @Id
    @Column(name = "user_id")
    private Long userId;

    @OneToOne(fetch = FetchType.LAZY)
    @MapsId
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "date_naissance")
    private LocalDate dateNaissance;

    @Column(length = 10)
    private String sexe;

    @Column(name = "medical_notes", columnDefinition = "TEXT")
    private String medicalNotes;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "doctor_id")
    private User doctor;

    @Column(name = "admission_date")
    private LocalDate admissionDate;

    @Column(name = "discharge_date")
    private LocalDate dischargeDate;

    @Column(name = "current_phase")
    @Builder.Default
    private Integer currentPhase = 1;

    @Column(name = "consent_voice_recording")
    @Builder.Default
    private Boolean consentVoiceRecording = false;

    @Column(name = "consent_data_sharing")
    @Builder.Default
    private Boolean consentDataSharing = false;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    /**
     * Calculate patient age
     */
    public Integer getAge() {
        if (dateNaissance == null) {
            return null;
        }
        return LocalDate.now().getYear() - dateNaissance.getYear();
    }

    /**
     * Check if patient has consented to voice recording
     */
    public boolean hasVoiceConsent() {
        return Boolean.TRUE.equals(consentVoiceRecording);
    }
}
