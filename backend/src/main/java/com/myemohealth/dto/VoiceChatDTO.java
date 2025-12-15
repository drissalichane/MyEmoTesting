package com.myemohealth.dto;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Builder
public class VoiceChatDTO {
    private Long id;
    private LocalDateTime date;
    private String duration;
    private String sentiment;
    private String topic;
    private String audioUrl; // URL to fetch audio file
}
