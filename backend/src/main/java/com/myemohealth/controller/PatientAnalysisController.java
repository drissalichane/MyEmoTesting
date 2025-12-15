package com.myemohealth.controller;

import com.myemohealth.dto.PatientAnalysisDTO;
import com.myemohealth.dto.VoiceChatDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@RestController
@RequestMapping("/api/patients")
@RequiredArgsConstructor
public class PatientAnalysisController {

    @GetMapping("/{id}/analysis")
    public ResponseEntity<PatientAnalysisDTO> getPatientAnalysis(@PathVariable Long id) {
        // TODO: Integrate with real AI Service
        // For now, return "real-looking" mock data based on ID to simulate
        // functionality

        return ResponseEntity.ok(PatientAnalysisDTO.builder()
                .summary(
                        "Patient exhibits signs of moderate anxiety with fluctuating mood patterns over the last 2 weeks. Sleep disturbances reported.")
                .riskLevel("Moderate")
                .recommendations(Arrays.asList(
                        "Schedule bi-weekly check-ins",
                        "Prescribe CBT exercises for sleep hygiene",
                        "Monitor stress triggers related to work"))
                .build());
    }

    @GetMapping("/{id}/voice-chats")
    public ResponseEntity<List<VoiceChatDTO>> getPatientVoiceChats(@PathVariable Long id) {
        // TODO: Fetch from database
        return ResponseEntity.ok(Arrays.asList(
                VoiceChatDTO.builder()
                        .id(101L)
                        .date(LocalDateTime.now().minusDays(2))
                        .duration("15:20")
                        .sentiment("Neutral")
                        .topic("Work Stress")
                        .audioUrl("/api/audio/101") // Placeholder
                        .build(),
                VoiceChatDTO.builder()
                        .id(102L)
                        .date(LocalDateTime.now().minusDays(5))
                        .duration("12:45")
                        .sentiment("Negative")
                        .topic("Insomnia & Fatigue")
                        .audioUrl("/api/audio/102")
                        .build()));
    }
}
