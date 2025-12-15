package com.myemohealth.service;

import com.myemohealth.entity.ChatMessage;
import com.myemohealth.repository.ChatMessageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatMessageRepository chatMessageRepository;
    private final SimpMessagingTemplate messagingTemplate;

    public ChatMessage saveAndSend(ChatMessage message) {
        // Save to DB
        ChatMessage saved = chatMessageRepository.save(message);

        // Push to recipient via WebSocket
        // Destination: /user/{recipientId}/queue/messages
        messagingTemplate.convertAndSendToUser(
                String.valueOf(saved.getRecipientId()),
                "/queue/messages",
                saved);

        return saved;
    }

    public List<ChatMessage> getConversation(Long userId1, Long userId2) {
        return chatMessageRepository
                .findBySenderIdAndRecipientIdOrSenderIdAndRecipientIdOrderByTimestampAsc(
                        userId1, userId2, userId2, userId1);
    }
}
