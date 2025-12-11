package com.myemohealth.service;

import com.myemohealth.entity.*;
import com.myemohealth.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

/**
 * Service for test execution and scoring
 */
@Service
@Transactional
@RequiredArgsConstructor
public class TestService {

    private final TestInstanceRepository testInstanceRepository;
    private final UserRepository userRepository;
    private final QcmTemplateRepository qcmTemplateRepository;
    private final PhaseRepository phaseRepository;
    private final QcmQuestionRepository qcmQuestionRepository;
    private final AnswerRepository answerRepository;

    private static final BigDecimal PASSING_SCORE = BigDecimal.valueOf(7.5);
    private static final BigDecimal MAX_SCORE = BigDecimal.valueOf(10.0);

    /**
     * Start a new test
     */
    public TestInstance startTest(Long patientId, Long qcmId, Integer phaseId) {
        User patient = userRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found"));
        QcmTemplate qcm = qcmTemplateRepository.findById(qcmId)
                .orElseThrow(() -> new RuntimeException("QCM not found"));
        Phase phase = phaseRepository.findById(phaseId)
                .orElseThrow(() -> new RuntimeException("Phase not found"));

        TestInstance test = TestInstance.builder()
                .patient(patient)
                .qcmTemplate(qcm)
                .phase(phase)
                .status(TestInstance.TestStatus.IN_PROGRESS)
                .startedAt(LocalDateTime.now())
                .maxScore(MAX_SCORE)
                .attemptNumber(1)
                .build();

        return testInstanceRepository.save(test);
    }

    /**
     * Submit answers and calculate score
     */
    public TestInstance submitAnswers(Long testId, List<Answer> answers) {
        TestInstance test = testInstanceRepository.findById(testId)
                .orElseThrow(() -> new RuntimeException("Test not found"));

        if (test.getStatus() != TestInstance.TestStatus.IN_PROGRESS) {
            throw new RuntimeException("Test is not in progress");
        }

        // Get all questions for this QCM
        List<QcmQuestion> questions = qcmQuestionRepository
                .findByQcmTemplateIdOrderByPosition(test.getQcmTemplate().getId());

        // Calculate score
        BigDecimal totalPoints = BigDecimal.ZERO;
        BigDecimal maxPossiblePoints = BigDecimal.ZERO;

        for (Answer answer : answers) {
            // Set test instance reference
            answer.setTestInstance(test);

            // Find corresponding question
            QcmQuestion question = questions.stream()
                    .filter(q -> q.getId().equals(answer.getQuestion().getId()))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("Question not found"));

            // Calculate points for this answer
            BigDecimal pointsEarned = calculateAnswerPoints(answer, question);
            answer.setPointsEarned(pointsEarned);

            // Persist answer
            answerRepository.save(answer);

            totalPoints = totalPoints.add(pointsEarned);
            maxPossiblePoints = maxPossiblePoints.add(question.getWeight().multiply(MAX_SCORE));
        }

        // Calculate final score (out of 10)
        BigDecimal score = BigDecimal.ZERO;
        if (maxPossiblePoints.compareTo(BigDecimal.ZERO) > 0) {
            score = totalPoints.divide(maxPossiblePoints, 4, RoundingMode.HALF_UP)
                    .multiply(MAX_SCORE)
                    .setScale(2, RoundingMode.HALF_UP);
        }

        // Update test instance
        test.setScore(score);
        test.setFinishedAt(LocalDateTime.now());
        test.setStatus(
                score.compareTo(PASSING_SCORE) >= 0 ? TestInstance.TestStatus.PASSED : TestInstance.TestStatus.FAILED);

        // Calculate time spent
        if (test.getStartedAt() != null) {
            long seconds = java.time.Duration.between(test.getStartedAt(), test.getFinishedAt()).getSeconds();
            test.setTimeSpentSeconds((int) seconds);
        }

        return testInstanceRepository.save(test);
    }

    /**
     * Calculate points earned for a single answer
     */
    private BigDecimal calculateAnswerPoints(Answer answer, QcmQuestion question) {
        switch (question.getQuestionType()) {
            case SINGLE_CHOICE:
                return calculateSingleChoicePoints(answer, question);
            case MULTIPLE_CHOICE:
                return calculateMultipleChoicePoints(answer, question);
            case SCALE:
                return calculateScalePoints(answer, question);
            case TEXT:
                // Text answers need manual grading, return 0 for now
                return BigDecimal.ZERO;
            default:
                return BigDecimal.ZERO;
        }
    }

    /**
     * Calculate points for single choice question
     */
    @SuppressWarnings("unchecked")
    private BigDecimal calculateSingleChoicePoints(Answer answer, QcmQuestion question) {
        Map<String, Object> options = question.getOptions();
        Map<String, Object> selectedOptions = answer.getSelectedOptions();

        if (selectedOptions == null || !selectedOptions.containsKey("value")) {
            return BigDecimal.ZERO;
        }

        String selectedValue = (String) selectedOptions.get("value");
        List<Map<String, Object>> optionsList = (List<Map<String, Object>>) options.get("options");

        for (Map<String, Object> option : optionsList) {
            if (selectedValue.equals(option.get("value"))) {
                Object pointsObj = option.get("points");
                BigDecimal points = pointsObj instanceof Number ? BigDecimal.valueOf(((Number) pointsObj).doubleValue())
                        : BigDecimal.ZERO;

                answer.setIsCorrect(points.compareTo(BigDecimal.valueOf(7)) >= 0);
                return points.multiply(question.getWeight());
            }
        }

        return BigDecimal.ZERO;
    }

    /**
     * Calculate points for multiple choice question
     */
    @SuppressWarnings("unchecked")
    private BigDecimal calculateMultipleChoicePoints(Answer answer, QcmQuestion question) {
        Map<String, Object> options = question.getOptions();
        Map<String, Object> selectedOptions = answer.getSelectedOptions();

        if (selectedOptions == null || !selectedOptions.containsKey("values")) {
            return BigDecimal.ZERO;
        }

        List<String> selectedValues = (List<String>) selectedOptions.get("values");
        List<Map<String, Object>> optionsList = (List<Map<String, Object>>) options.get("options");

        BigDecimal totalPoints = BigDecimal.ZERO;
        for (String value : selectedValues) {
            for (Map<String, Object> option : optionsList) {
                if (value.equals(option.get("value"))) {
                    Object pointsObj = option.get("points");
                    BigDecimal points = pointsObj instanceof Number
                            ? BigDecimal.valueOf(((Number) pointsObj).doubleValue())
                            : BigDecimal.ZERO;
                    totalPoints = totalPoints.add(points);
                }
            }
        }

        // Get max possible points
        Object maxPointsObj = options.get("maxPoints");
        BigDecimal maxPoints = maxPointsObj instanceof Number
                ? BigDecimal.valueOf(((Number) maxPointsObj).doubleValue())
                : MAX_SCORE;

        // Normalize to max points
        if (totalPoints.compareTo(maxPoints) > 0) {
            totalPoints = maxPoints;
        }

        answer.setIsCorrect(totalPoints.compareTo(BigDecimal.valueOf(7)) >= 0);
        return totalPoints.multiply(question.getWeight());
    }

    /**
     * Calculate points for scale question (1-10)
     */
    @SuppressWarnings("unchecked")
    private BigDecimal calculateScalePoints(Answer answer, QcmQuestion question) {
        if (answer.getValueNumeric() == null) {
            return BigDecimal.ZERO;
        }

        Map<String, Object> options = question.getOptions();
        Object minObj = options.get("min");
        Object maxObj = options.get("max");

        int min = minObj instanceof Number ? ((Number) minObj).intValue() : 1;
        int max = maxObj instanceof Number ? ((Number) maxObj).intValue() : 10;

        BigDecimal value = answer.getValueNumeric();

        // Normalize to 0-10 scale
        BigDecimal normalizedValue = value.subtract(BigDecimal.valueOf(min))
                .divide(BigDecimal.valueOf(max - min), 4, RoundingMode.HALF_UP)
                .multiply(MAX_SCORE);

        answer.setIsCorrect(normalizedValue.compareTo(BigDecimal.valueOf(5)) >= 0);
        return normalizedValue.multiply(question.getWeight());
    }

    /**
     * Get test results
     */
    public TestInstance getTestResult(Long testId) {
        return testInstanceRepository.findById(testId)
                .orElseThrow(() -> new RuntimeException("Test not found"));
    }

    /**
     * Get patient test history
     */
    public List<TestInstance> getPatientTests(Long patientId) {
        return testInstanceRepository.findByPatientId(patientId);
    }

    /**
     * Get patient tests for a specific phase
     */
    public List<TestInstance> getPatientTestsByPhase(Long patientId, Integer phaseId) {
        return testInstanceRepository.findByPatientIdAndPhaseId(patientId, phaseId);
    }

    // Basic CRUD methods
    public TestInstance save(TestInstance testInstance) {
        return testInstanceRepository.save(testInstance);
    }

    public Optional<TestInstance> findById(Long id) {
        return testInstanceRepository.findById(id);
    }

    public Optional<TestInstance> findByUuid(UUID uuid) {
        return testInstanceRepository.findByUuid(uuid);
    }

    public List<TestInstance> findByPatientId(Long patientId) {
        return testInstanceRepository.findByPatientId(patientId);
    }

    public List<TestInstance> findByPatientIdAndPhaseId(Long patientId, Integer phaseId) {
        return testInstanceRepository.findByPatientIdAndPhaseId(patientId, phaseId);
    }

    public List<TestInstance> findScheduledTests(Long patientId) {
        return testInstanceRepository.findScheduledTests(patientId);
    }

    public long countByPatientAndPhase(Long patientId, Integer phaseId) {
        return testInstanceRepository.countByPatientIdAndPhaseId(patientId, phaseId);
    }

    public long countPassedTestsByPatientAndPhase(Long patientId, Integer phaseId) {
        return testInstanceRepository.countPassedTestsByPatientIdAndPhaseId(patientId, phaseId);
    }

    public void delete(TestInstance testInstance) {
        testInstanceRepository.delete(testInstance);
    }
}
