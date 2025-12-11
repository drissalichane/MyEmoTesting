package com.myemohealth.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Individual test attempts by patients
 */
@Entity
@Table(name = "test_instance")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TestInstance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, updatable = false)
    private UUID uuid;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private User patient;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "qcm_id", nullable = false)
    private QcmTemplate qcmTemplate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "phase_id", nullable = false)
    private Phase phase;

    @Column(name = "scheduled_at")
    private LocalDateTime scheduledAt;

    @Column(name = "started_at")
    private LocalDateTime startedAt;

    @Column(name = "finished_at")
    private LocalDateTime finishedAt;

    @Column(precision = 5, scale = 2)
    private BigDecimal score;

    @Column(name = "max_score", precision = 5, scale = 2)
    @Builder.Default
    private BigDecimal maxScore = BigDecimal.valueOf(10.0);

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    @Builder.Default
    private TestStatus status = TestStatus.SCHEDULED;

    @Column(name = "attempt_number")
    @Builder.Default
    private Integer attemptNumber = 1;

    @Column(name = "time_spent_seconds")
    private Integer timeSpentSeconds;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        if (uuid == null) {
            uuid = UUID.randomUUID();
        }
        createdAt = LocalDateTime.now();
    }

    /**
     * Check if test is passed (score >= 7.5)
     */
    public boolean isPassed() {
        return score != null && score.compareTo(BigDecimal.valueOf(7.5)) >= 0;
    }

    /**
     * Check if test is completed
     */
    public boolean isCompleted() {
        return status == TestStatus.COMPLETED || status == TestStatus.PASSED || status == TestStatus.FAILED;
    }

    public enum TestStatus {
        SCHEDULED,
        IN_PROGRESS,
        COMPLETED,
        ABANDONED,
        FAILED,
        PASSED
    }
}
