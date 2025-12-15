package com.myemohealth.repository;

import com.myemohealth.entity.VoiceSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface VoiceSessionRepository extends JpaRepository<VoiceSession, Long> {
    List<VoiceSession> findByPatientIdOrderByTimestampDesc(Long patientId);
}
