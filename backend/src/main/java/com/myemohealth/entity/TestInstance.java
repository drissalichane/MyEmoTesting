package com.myemohealth.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Individual test attempts by patients
 */
@Entity
@Table(name = "test_instance")
public class TestInstance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, updatable = false)
    private UUID uuid;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private PatientProfile patient;

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
    private BigDecimal maxScore = BigDecimal.valueOf(10.0);

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private TestStatus status = TestStatus.SCHEDULED;

    @Column(name = "attempt_number")
    private Integer attemptNumber = 1;

    @Column(name = "time_spent_seconds")
    private Integer timeSpentSeconds;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    public TestInstance() {
    }

    public TestInstance(Long id, UUID uuid, PatientProfile patient, QcmTemplate qcmTemplate, Phase phase,
            LocalDateTime scheduledAt, LocalDateTime startedAt, LocalDateTime finishedAt, BigDecimal score,
            BigDecimal maxScore, TestStatus status, Integer attemptNumber, Integer timeSpentSeconds,
            LocalDateTime createdAt) {
        this.id = id;
        this.uuid = uuid;
        this.patient = patient;
        this.qcmTemplate = qcmTemplate;
        this.phase = phase;
        this.scheduledAt = scheduledAt;
        this.startedAt = startedAt;
        this.finishedAt = finishedAt;
        this.score = score;
        this.maxScore = maxScore != null ? maxScore : BigDecimal.valueOf(10.0);
        this.status = status != null ? status : TestStatus.SCHEDULED;
        this.attemptNumber = attemptNumber != null ? attemptNumber : 1;
        this.timeSpentSeconds = timeSpentSeconds;
        this.createdAt = createdAt;
    }

    @PrePersist
    protected void onCreate() {
        if (uuid == null) {
            uuid = UUID.randomUUID();
        }
        createdAt = LocalDateTime.now();
    }

    public boolean isPassed() {
        return score != null && score.compareTo(BigDecimal.valueOf(7.5)) >= 0;
    }

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

    public static TestInstanceBuilder builder() {
        return new TestInstanceBuilder();
    }

    public static class TestInstanceBuilder {
        private Long id;
        private UUID uuid;
        private PatientProfile patient;
        private QcmTemplate qcmTemplate;
        private Phase phase;
        private LocalDateTime scheduledAt;
        private LocalDateTime startedAt;
        private LocalDateTime finishedAt;
        private BigDecimal score;
        private BigDecimal maxScore = BigDecimal.valueOf(10.0);
        private TestStatus status = TestStatus.SCHEDULED;
        private Integer attemptNumber = 1;
        private Integer timeSpentSeconds;
        private LocalDateTime createdAt;

        TestInstanceBuilder() {
        }

        public TestInstanceBuilder id(Long id) {
            this.id = id;
            return this;
        }

        public TestInstanceBuilder uuid(UUID uuid) {
            this.uuid = uuid;
            return this;
        }

        public TestInstanceBuilder patient(PatientProfile patient) {
            this.patient = patient;
            return this;
        }

        public TestInstanceBuilder qcmTemplate(QcmTemplate qcmTemplate) {
            this.qcmTemplate = qcmTemplate;
            return this;
        }

        public TestInstanceBuilder phase(Phase phase) {
            this.phase = phase;
            return this;
        }

        public TestInstanceBuilder scheduledAt(LocalDateTime scheduledAt) {
            this.scheduledAt = scheduledAt;
            return this;
        }

        public TestInstanceBuilder startedAt(LocalDateTime startedAt) {
            this.startedAt = startedAt;
            return this;
        }

        public TestInstanceBuilder finishedAt(LocalDateTime finishedAt) {
            this.finishedAt = finishedAt;
            return this;
        }

        public TestInstanceBuilder score(BigDecimal score) {
            this.score = score;
            return this;
        }

        public TestInstanceBuilder maxScore(BigDecimal maxScore) {
            this.maxScore = maxScore;
            return this;
        }

        public TestInstanceBuilder status(TestStatus status) {
            this.status = status;
            return this;
        }

        public TestInstanceBuilder attemptNumber(Integer attemptNumber) {
            this.attemptNumber = attemptNumber;
            return this;
        }

        public TestInstanceBuilder timeSpentSeconds(Integer timeSpentSeconds) {
            this.timeSpentSeconds = timeSpentSeconds;
            return this;
        }

        public TestInstanceBuilder createdAt(LocalDateTime createdAt) {
            this.createdAt = createdAt;
            return this;
        }

        public TestInstance build() {
            return new TestInstance(id, uuid, patient, qcmTemplate, phase, scheduledAt, startedAt, finishedAt, score,
                    maxScore, status, attemptNumber, timeSpentSeconds, createdAt);
        }
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public UUID getUuid() {
        return uuid;
    }

    public void setUuid(UUID uuid) {
        this.uuid = uuid;
    }

    public PatientProfile getPatient() {
        return patient;
    }

    public void setPatient(PatientProfile patient) {
        this.patient = patient;
    }

    public QcmTemplate getQcmTemplate() {
        return qcmTemplate;
    }

    public void setQcmTemplate(QcmTemplate qcmTemplate) {
        this.qcmTemplate = qcmTemplate;
    }

    public Phase getPhase() {
        return phase;
    }

    public void setPhase(Phase phase) {
        this.phase = phase;
    }

    public LocalDateTime getScheduledAt() {
        return scheduledAt;
    }

    public void setScheduledAt(LocalDateTime scheduledAt) {
        this.scheduledAt = scheduledAt;
    }

    public LocalDateTime getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(LocalDateTime startedAt) {
        this.startedAt = startedAt;
    }

    public LocalDateTime getFinishedAt() {
        return finishedAt;
    }

    public void setFinishedAt(LocalDateTime finishedAt) {
        this.finishedAt = finishedAt;
    }

    public BigDecimal getScore() {
        return score;
    }

    public void setScore(BigDecimal score) {
        this.score = score;
    }

    public BigDecimal getMaxScore() {
        return maxScore;
    }

    public void setMaxScore(BigDecimal maxScore) {
        this.maxScore = maxScore;
    }

    public TestStatus getStatus() {
        return status;
    }

    public void setStatus(TestStatus status) {
        this.status = status;
    }

    public Integer getAttemptNumber() {
        return attemptNumber;
    }

    public void setAttemptNumber(Integer attemptNumber) {
        this.attemptNumber = attemptNumber;
    }

    public Integer getTimeSpentSeconds() {
        return timeSpentSeconds;
    }

    public void setTimeSpentSeconds(Integer timeSpentSeconds) {
        this.timeSpentSeconds = timeSpentSeconds;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
