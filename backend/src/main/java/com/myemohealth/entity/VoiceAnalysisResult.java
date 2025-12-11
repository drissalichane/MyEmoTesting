package com.myemohealth.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;

/**
 * AI-generated emotional analysis results from voice recordings
 */
@Entity
@Table(name = "voice_analysis_result")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VoiceAnalysisResult {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "voice_record_id", nullable = false, unique = true)
    private VoiceRecord voiceRecord;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "emotion_scores", columnDefinition = "jsonb")
    private Map<String, Object> emotionScores;

    @Column(name = "dominant_emotion", length = 50)
    private String dominantEmotion;

    @Column(precision = 5, scale = 2)
    private BigDecimal confidence;

    @Column(name = "sentiment_score", precision = 5, scale = 2)
    private BigDecimal sentimentScore;

    @Enumerated(EnumType.STRING)
    @Column(name = "stress_level", length = 20)
    private StressLevel stressLevel;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "analysis_metadata", columnDefinition = "jsonb")
    private Map<String, Object> analysisMetadata;

    @Column(name = "analyzer_version", length = 20)
    private String analyzerVersion;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    public enum StressLevel {
        LOW,
        MEDIUM,
        HIGH,
        VERY_HIGH
    }
}
