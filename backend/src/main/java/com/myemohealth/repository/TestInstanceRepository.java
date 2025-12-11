package com.myemohealth.repository;

import com.myemohealth.entity.TestInstance;
import com.myemohealth.entity.TestInstance.TestStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Spring Data JPA Repository for TestInstance entity
 */
@Repository
public interface TestInstanceRepository extends JpaRepository<TestInstance, Long> {

    /**
     * Find test instance by UUID
     */
    Optional<TestInstance> findByUuid(UUID uuid);

    /**
     * Find all test instances for a patient
     */
    @Query("SELECT t FROM TestInstance t WHERE t.patient.id = :patientId ORDER BY t.createdAt DESC")
    List<TestInstance> findByPatientId(@Param("patientId") Long patientId);

    /**
     * Find test instances by patient and phase
     */
    @Query("SELECT t FROM TestInstance t WHERE t.patient.id = :patientId AND t.phase.id = :phaseId ORDER BY t.createdAt DESC")
    List<TestInstance> findByPatientIdAndPhaseId(@Param("patientId") Long patientId, @Param("phaseId") Integer phaseId);

    /**
     * Find test instances by status
     */
    @Query("SELECT t FROM TestInstance t WHERE t.status = :status ORDER BY t.scheduledAt")
    List<TestInstance> findByStatus(@Param("status") TestStatus status);

    /**
     * Find scheduled tests for a patient
     */
    @Query("SELECT t FROM TestInstance t WHERE t.patient.id = :patientId AND t.status = 'SCHEDULED' ORDER BY t.scheduledAt")
    List<TestInstance> findScheduledTests(@Param("patientId") Long patientId);

    /**
     * Count tests by patient and phase
     */
    @Query("SELECT COUNT(t) FROM TestInstance t WHERE t.patient.id = :patientId AND t.phase.id = :phaseId")
    long countByPatientIdAndPhaseId(@Param("patientId") Long patientId, @Param("phaseId") Integer phaseId);

    /**
     * Count passed tests by patient and phase
     */
    @Query("SELECT COUNT(t) FROM TestInstance t WHERE t.patient.id = :patientId AND t.phase.id = :phaseId AND t.status = 'PASSED'")
    long countPassedTestsByPatientIdAndPhaseId(@Param("patientId") Long patientId, @Param("phaseId") Integer phaseId);
}
