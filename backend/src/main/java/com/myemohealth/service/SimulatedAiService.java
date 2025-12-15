package com.myemohealth.service;

import com.myemohealth.entity.VoiceSession;
import com.myemohealth.repository.VoiceSessionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class SimulatedAiService {

    private final VoiceSessionRepository voiceSessionRepository;

    // Simple keyword-based sentiment analysis simulation
    public VoiceSession analyzeAndSave(Long patientId, String userTranscript) {
        String transcriptLower = userTranscript.toLowerCase();

        String sentiment = "NEUTRAL";
        int riskScore = 10;
        String response = "I hear you. Tell me more about that.";

        if (transcriptLower.contains("sad") || transcriptLower.contains("cry")
                || transcriptLower.contains("hopeless")) {
            sentiment = "DEPRESSIVE";
            riskScore = 80;
            response = "I'm sorry you're feeling this way. It sounds very heavy. Remember your doctor is here to help.";
        } else if (transcriptLower.contains("anxious") || transcriptLower.contains("worry")
                || transcriptLower.contains("scared")) {
            sentiment = "ANXIOUS";
            riskScore = 60;
            response = "It seems like there's a lot on your mind. Let's take a deep breath together.";
        } else if (transcriptLower.contains("happy") || transcriptLower.contains("good")
                || transcriptLower.contains("great")) {
            sentiment = "POSITIVE";
            riskScore = 5;
            response = "That's wonderful to hear! What made you feel good about that?";
        }

        VoiceSession session = VoiceSession.builder()
                .patientId(patientId)
                .userTranscript(userTranscript)
                .aiResponse(response)
                .sentimentDetected(sentiment)
                .riskScore(riskScore)
                .build();

        // If risk > 70, in a real system we would send a Doctor Notification here

        return voiceSessionRepository.save(session);
    }
}
