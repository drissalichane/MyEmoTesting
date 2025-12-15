package com.myemohealth.repository;

import com.myemohealth.entity.PatientProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PatientProfileRepository extends JpaRepository<PatientProfile, Long> {

    @Query("SELECT p FROM PatientProfile p LEFT JOIN FETCH p.user LEFT JOIN FETCH p.doctor")
    List<PatientProfile> findAll();

    @Query("SELECT p FROM PatientProfile p LEFT JOIN FETCH p.user LEFT JOIN FETCH p.doctor WHERE p.doctor.id = :doctorId")
    List<PatientProfile> findByDoctorId(@Param("doctorId") Long doctorId);
}
