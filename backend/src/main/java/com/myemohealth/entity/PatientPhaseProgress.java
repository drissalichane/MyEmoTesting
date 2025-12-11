package com.myemohealth.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

/**
 * Tracks patient progress through the 5 phases
 */
@Entity
@Table(name = "patient_phase_progress")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PatientPhaseProgress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private User patient;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "phase_id", nullable = false)
    private Phase phase;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    @Builder.Default
    private ProgressStatus status = ProgressStatus.NOT_STARTED;

    @Column(name = "started_at")
    private LocalDateTime startedAt;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @Column(name = "tests_completed")
    @Builder.Default
    private Integer testsCompleted = 0;

    @Column(name = "tests_passed")
    @Builder.Default
    private Integer testsPassed = 0;

    /**
     * Check if phase is completed (3 tests passed)
     */
    public boolean isPhaseCompleted() {
        return testsPassed != null && testsPassed >= 3;
    }

    /**
     * Increment test counters
     */
    public void recordTestCompletion(boolean passed) {
        this.testsCompleted++;
        if (passed) {
            this.testsPassed++;
        }

        // Check if phase is now completed
        if (isPhaseCompleted() && status != ProgressStatus.COMPLETED) {
            this.status = ProgressStatus.COMPLETED;
            this.completedAt = LocalDateTime.now();
        }
    }

    public enum ProgressStatus {
        NOT_STARTED,
        IN_PROGRESS,
        COMPLETED,
        FAILED
    }
}
