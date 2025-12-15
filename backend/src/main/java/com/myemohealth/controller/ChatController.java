package com.myemohealth.controller;

import com.myemohealth.entity.ChatMessage;
import com.myemohealth.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/api/chat")
public class ChatController {

    private final ChatService chatService;
    private final com.myemohealth.repository.UserRepository userRepository;

    // WebSocket Endpoint: /app/chat
    @MessageMapping("/chat")
    public void processMessage(@Payload ChatMessage message) {
        message.setTimestamp(LocalDateTime.now());
        chatService.saveAndSend(message);
    }

    // REST Endpoint: Get History
    @GetMapping("/history/{userId1}/{userId2}")
    public ResponseEntity<?> getChatHistory(
            @PathVariable Long userId1,
            @PathVariable Long userId2) {

        // Security check: Current user must be one of the participants
        org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder
                .getContext().getAuthentication();

        String currentEmail = auth.getName();

        // Allow participants and admins to view conversations
        java.util.Optional<com.myemohealth.entity.User> currentUserOpt = userRepository.findByEmail(currentEmail);
        boolean isParticipant = currentUserOpt
                .map(u -> u.getId().equals(userId1) || u.getId().equals(userId2))
                .orElse(false);

        boolean isAdmin = currentUserOpt
                .map(u -> u.getRole() != null && "ADMIN".equals(u.getRole().getName()))
                .orElse(false);

        if (!isParticipant && !isAdmin) {
            return ResponseEntity.status(403).build();
        }

        return ResponseEntity.ok(chatService.getConversation(userId1, userId2));
    }
}
