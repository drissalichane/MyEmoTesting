package com.myemohealth.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VoiceSession {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long patientId;

    @Column(columnDefinition = "TEXT")
    private String userTranscript;

    @Column(columnDefinition = "TEXT")
    private String aiResponse;

    // POSITIVE, NEUTRAL, NEGATIVE, ANXIOUS, DEPRESSIVE
    private String sentimentDetected;

    // 0-100, where > 70 triggers doctor alert
    private int riskScore;

    private LocalDateTime timestamp;

    @PrePersist
    protected void onCreate() {
        timestamp = LocalDateTime.now();
    }
}
