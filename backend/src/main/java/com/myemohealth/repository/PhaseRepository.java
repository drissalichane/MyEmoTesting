package com.myemohealth.repository;

import com.myemohealth.entity.Phase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Spring Data JPA Repository for Phase entity
 */
@Repository
public interface PhaseRepository extends JpaRepository<Phase, Integer> {
}
