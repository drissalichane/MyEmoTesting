package com.myemohealth.repository;

import com.myemohealth.entity.ChatThread;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Spring Data JPA Repository for ChatThread entity
 */
@Repository
public interface ChatThreadRepository extends JpaRepository<ChatThread, Long> {

    /**
     * Find chat thread by UUID
     */
    Optional<ChatThread> findByUuid(UUID uuid);

    /**
     * Find chat thread by patient and doctor
     */
    @Query("SELECT t FROM ChatThread t WHERE t.patient.id = :patientId AND t.doctor.id = :doctorId")
    Optional<ChatThread> findByPatientIdAndDoctorId(@Param("patientId") Long patientId,
            @Param("doctorId") Long doctorId);

    /**
     * Find all chat threads for a patient
     */
    @Query("SELECT t FROM ChatThread t WHERE t.patient.id = :patientId ORDER BY t.lastMessageAt DESC NULLS LAST")
    List<ChatThread> findByPatientId(@Param("patientId") Long patientId);

    /**
     * Find all chat threads for a doctor
     */
    @Query("SELECT t FROM ChatThread t WHERE t.doctor.id = :doctorId ORDER BY t.lastMessageAt DESC NULLS LAST")
    List<ChatThread> findByDoctorId(@Param("doctorId") Long doctorId);

    /**
     * Find all active chat threads
     */
    @Query("SELECT t FROM ChatThread t WHERE t.status = 'ACTIVE' ORDER BY t.lastMessageAt DESC")
    List<ChatThread> findActiveThreads();
}
