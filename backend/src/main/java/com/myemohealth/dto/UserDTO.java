package com.myemohealth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.UUID;

/**
 * User response DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDTO {

    private Long id;
    private UUID uuid;
    private String email;
    private String firstName;
    private String lastName;
    private String role;
    private Boolean enabled;
    private Boolean emailVerified;
}
