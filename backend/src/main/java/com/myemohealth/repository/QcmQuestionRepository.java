package com.myemohealth.repository;

import com.myemohealth.entity.QcmQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Spring Data JPA Repository for QcmQuestion entity
 */
@Repository
public interface QcmQuestionRepository extends JpaRepository<QcmQuestion, Long> {

    /**
     * Find all questions for a QCM template, ordered by position
     */
    @Query("SELECT q FROM QcmQuestion q WHERE q.qcmTemplate.id = :qcmId ORDER BY q.position")
    List<QcmQuestion> findByQcmTemplateIdOrderByPosition(@Param("qcmId") Long qcmId);
}
