package com.myemohealth.repository;

import com.myemohealth.entity.QcmTemplate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Spring Data JPA Repository for QcmTemplate entity
 */
@Repository
public interface QcmTemplateRepository extends JpaRepository<QcmTemplate, Long> {

    /**
     * Find QCM template by UUID
     */
    Optional<QcmTemplate> findByUuid(UUID uuid);

    @Query("SELECT q FROM QcmTemplate q LEFT JOIN FETCH q.creator")
    List<QcmTemplate> findAll();

    /**
     * Find all active QCM templates
     */
    @Query("SELECT q FROM QcmTemplate q LEFT JOIN FETCH q.creator WHERE q.isActive = true ORDER BY q.title")
    List<QcmTemplate> findActive();

    /**
     * Find QCM templates by category
     */
    @Query("SELECT q FROM QcmTemplate q LEFT JOIN FETCH q.creator WHERE q.category = :category AND q.isActive = true ORDER BY q.title")
    List<QcmTemplate> findByCategory(@Param("category") String category);

    /**
     * Find QCM templates by creator
     */
    @Query("SELECT q FROM QcmTemplate q LEFT JOIN FETCH q.creator WHERE q.creator.id = :creatorId ORDER BY q.createdAt DESC")
    List<QcmTemplate> findByCreatorId(@Param("creatorId") Long creatorId);
}
