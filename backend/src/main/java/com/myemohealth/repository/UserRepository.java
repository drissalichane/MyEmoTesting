package com.myemohealth.repository;

import com.myemohealth.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Spring Data JPA Repository for User entity
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    /**
     * Find user by UUID
     */
    Optional<User> findByUuid(UUID uuid);

    /**
     * Find user by email with role eagerly loaded
     */
    @Query("SELECT u FROM User u LEFT JOIN FETCH u.role WHERE u.email = :email")
    Optional<User> findByEmail(@Param("email") String email);

    /**
     * Check if email exists
     */
    boolean existsByEmail(String email);

    /**
     * Find all users with role eagerly loaded
     */
    @Query("SELECT u FROM User u LEFT JOIN FETCH u.role ORDER BY u.createdAt DESC")
    List<User> findAllWithRole();

    /**
     * Find users by role name
     */
    @Query("SELECT u FROM User u JOIN u.role r WHERE r.name = :roleName ORDER BY u.lastName, u.firstName")
    List<User> findByRoleName(@Param("roleName") String roleName);

    /**
     * Find all patients
     */
    default List<User> findPatients() {
        return findByRoleName("PATIENT");
    }

    /**
     * Find all doctors
     */
    default List<User> findDoctors() {
        return findByRoleName("DOCTOR");
    }

    /**
     * Update last login timestamp
     */
    @Modifying
    @Query("UPDATE User u SET u.lastLogin = :loginTime WHERE u.id = :userId")
    void updateLastLogin(@Param("userId") Long userId, @Param("loginTime") LocalDateTime loginTime);
}
