package com.myemohealth.controller;

import com.myemohealth.entity.TestInstance;
import com.myemohealth.service.TestService;
import jakarta.validation.Valid;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * REST controller for test/QCM endpoints
 */
@RestController
@RequestMapping("/api/tests")
@RequiredArgsConstructor
public class TestController {

    private final TestService testService;

    /**
     * GET /api/tests/patient/{patientId}
     * Get all tests for a patient
     */
    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<TestInstance>> getPatientTests(@PathVariable Long patientId) {
        List<TestInstance> tests = testService.getPatientTests(patientId);
        return ResponseEntity.ok(tests);
    }

    /**
     * GET /api/tests/patient/{patientId}/phase/{phaseId}
     * Get tests for a patient in a specific phase
     */
    @GetMapping("/patient/{patientId}/phase/{phaseId}")
    public ResponseEntity<List<TestInstance>> getPatientTestsByPhase(
            @PathVariable Long patientId,
            @PathVariable Integer phaseId) {

        List<TestInstance> tests = testService.getPatientTestsByPhase(patientId, phaseId);
        return ResponseEntity.ok(tests);
    }

    /**
     * GET /api/tests/{id}
     * Get test by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<TestInstance> getTestById(@PathVariable Long id) {
        TestInstance test = testService.findById(id)
                .orElseThrow(() -> new RuntimeException("Test not found"));
        return ResponseEntity.ok(test);
    }

    /**
     * GET /api/tests/uuid/{uuid}
     * Get test by UUID
     */
    @GetMapping("/uuid/{uuid}")
    public ResponseEntity<TestInstance> getTestByUuid(@PathVariable UUID uuid) {
        TestInstance test = testService.findByUuid(uuid)
                .orElseThrow(() -> new RuntimeException("Test not found"));
        return ResponseEntity.ok(test);
    }

    /**
     * POST /api/tests/start
     * Start a new test
     */
    @PostMapping("/start")
    public ResponseEntity<TestInstance> startTest(@Valid @RequestBody StartTestRequest request) {
        try {
            TestInstance test = testService.startTest(
                    request.getPatientId(),
                    request.getQcmId(),
                    request.getPhaseId()
            );
            return ResponseEntity.status(HttpStatus.CREATED).body(test);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    /**
     * POST /api/tests/{id}/submit
     * Submit test answers
     */
    @PostMapping("/{id}/submit")
    public ResponseEntity<TestInstance> submitTest(
            @PathVariable Long id,
            @Valid @RequestBody SubmitTestRequest request) {

        try {
            TestInstance test = testService.submitAnswers(id, request.getAnswers());
            return ResponseEntity.ok(test);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    /**
     * GET /api/tests/{id}/result
     * Get test result
     */
    @GetMapping("/{id}/result")
    public ResponseEntity<TestInstance> getTestResult(@PathVariable Long id) {
        TestInstance test = testService.getTestResult(id);
        return ResponseEntity.ok(test);
    }

    // DTOs
    @Data
    public static class StartTestRequest {
        private Long patientId;
        private Long qcmId;
        private Integer phaseId;
    }

    @Data
    public static class SubmitTestRequest {
        private List<com.myemohealth.entity.Answer> answers;
    }
}
