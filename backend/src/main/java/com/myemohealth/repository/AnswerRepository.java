package com.myemohealth.repository;

import com.myemohealth.entity.Answer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Spring Data JPA Repository for Answer entity
 */
@Repository
public interface AnswerRepository extends JpaRepository<Answer, Long> {
}
