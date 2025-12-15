package com.myemohealth.controller;

import com.myemohealth.dto.UserDTO;
import com.myemohealth.entity.User;
import com.myemohealth.entity.VoiceSession;
import com.myemohealth.repository.UserRepository;
import com.myemohealth.repository.VoiceSessionRepository;
import com.myemohealth.security.UserPrincipal;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * REST controller for user management endpoints
 */
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserRepository userRepository;
    private final VoiceSessionRepository voiceSessionRepository;

    /**
     * GET /api/users/me
     * Get current authenticated user
     */
    @GetMapping("/me")
    public ResponseEntity<UserDTO> getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserPrincipal userPrincipal = (UserPrincipal) authentication.getPrincipal();
        String email = userPrincipal.getEmail();

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return ResponseEntity.ok(convertToDTO(user));
    }

    /**
     * GET /api/users/{id}
     * Get user by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return ResponseEntity.ok(convertToDTO(user));
    }

    /**
     * GET /api/users
     * Get all users (admin only - should add @PreAuthorize)
     */
    @GetMapping
    public ResponseEntity<List<UserDTO>> getAllUsers() {
        List<User> users = userRepository.findAllWithRole();
        List<UserDTO> userDTOs = users.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());

        return ResponseEntity.ok(userDTOs);
    }

    /**
     * GET /api/users/patients
     * Get all patients
     */
    @GetMapping("/patients")
    public ResponseEntity<List<UserDTO>> getPatients() {
        List<User> patients = userRepository.findPatients();
        List<UserDTO> patientDTOs = patients.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());

        return ResponseEntity.ok(patientDTOs);
    }

    /**
     * GET /api/users/doctors
     * Get all doctors
     */
    @GetMapping("/doctors")
    public ResponseEntity<List<UserDTO>> getDoctors() {
        List<User> doctors = userRepository.findDoctors();
        List<UserDTO> doctorDTOs = doctors.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());

        return ResponseEntity.ok(doctorDTOs);
    }

    /**
     * PUT /api/users/{id}
     * Update user
     */
    @PutMapping("/{id}")
    public ResponseEntity<UserDTO> updateUser(
            @PathVariable Long id,
            @Valid @RequestBody UserDTO userDTO) {

        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Update allowed fields
        if (userDTO.getFirstName() != null) {
            user.setFirstName(userDTO.getFirstName());
        }
        if (userDTO.getLastName() != null) {
            user.setLastName(userDTO.getLastName());
        }

        user = userRepository.save(user);

        return ResponseEntity.ok(convertToDTO(user));
    }

    /**
     * GET /api/users/{id}/analysis
     * Get AI analysis summary for a user
     */
    @GetMapping("/{id}/analysis")
    public ResponseEntity<Map<String, Object>> getUserAnalysis(@PathVariable Long id) {
        List<VoiceSession> sessions = voiceSessionRepository.findByPatientIdOrderByTimestampDesc(id);

        if (sessions.isEmpty()) {
            Map<String, Object> noData = new HashMap<>();
            noData.put("summary", "No voice analysis data available for this user.");
            noData.put("riskLevel", "Unknown");
            noData.put("recommendations", Collections.emptyList());
            return ResponseEntity.ok(noData);
        }

        // Calculate risk level based on recent sessions
        long depressiveSessions = sessions.stream()
                .limit(10) // Last 10 sessions
                .filter(s -> "DEPRESSIVE".equals(s.getSentimentDetected()))
                .count();

        String riskLevel;
        if (depressiveSessions >= 7) {
            riskLevel = "High";
        } else if (depressiveSessions >= 4) {
            riskLevel = "Moderate";
        } else {
            riskLevel = "Low";
        }

        // Generate summary
        Map<String, Long> sentimentCounts = sessions.stream()
                .limit(10)
                .collect(Collectors.groupingBy(
                        VoiceSession::getSentimentDetected,
                        Collectors.counting()));

        String summary = String.format(
                "Based on %d recent voice sessions: %s",
                Math.min(sessions.size(), 10),
                sentimentCounts.entrySet().stream()
                        .map(e -> e.getValue() + " " + e.getKey().toLowerCase())
                        .collect(Collectors.joining(", ")));

        // Generate recommendations
        List<String> recommendations = new ArrayList<>();
        if ("High".equals(riskLevel)) {
            recommendations.add("Schedule immediate follow-up consultation");
            recommendations.add("Consider medication review");
            recommendations.add("Increase monitoring frequency");
        } else if ("Moderate".equals(riskLevel)) {
            recommendations.add("Schedule follow-up in 1-2 weeks");
            recommendations.add("Monitor mood patterns closely");
        } else {
            recommendations.add("Continue regular check-ins");
            recommendations.add("Maintain current treatment plan");
        }

        Map<String, Object> analysis = new HashMap<>();
        analysis.put("summary", summary);
        analysis.put("riskLevel", riskLevel);
        analysis.put("recommendations", recommendations);

        return ResponseEntity.ok(analysis);
    }

    /**
     * GET /api/users/{id}/voice-chats
     * Get voice chat history for a user
     */
    @GetMapping("/{id}/voice-chats")
    public ResponseEntity<List<Map<String, Object>>> getUserVoiceChats(@PathVariable Long id) {
        List<VoiceSession> sessions = voiceSessionRepository.findByPatientIdOrderByTimestampDesc(id);

        if (sessions.isEmpty()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        List<Map<String, Object>> chats = sessions.stream()
                .map(session -> {
                    Map<String, Object> chat = new HashMap<>();
                    chat.put("id", session.getId());
                    chat.put("date", session.getTimestamp().format(dateFormatter));
                    chat.put("sentiment", session.getSentimentDetected());
                    chat.put("transcript", session.getUserTranscript());
                    chat.put("response", session.getAiResponse());
                    chat.put("riskScore", session.getRiskScore());
                    return chat;
                })
                .collect(Collectors.toList());

        return ResponseEntity.ok(chats);
    }

    /**
     * Helper method to convert User entity to DTO
     */
    private UserDTO convertToDTO(User user) {
        return UserDTO.builder()
                .id(user.getId())
                .uuid(user.getUuid())
                .email(user.getEmail())
                .firstName(user.getFirstName())
                .lastName(user.getLastName())
                .role(user.getRole() != null ? user.getRole().getName() : null)
                .enabled(user.getEnabled())
                .emailVerified(user.getEmailVerified())
                .build();
    }
}
