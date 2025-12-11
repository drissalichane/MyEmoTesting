package com.myemohealth.security;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.security.Principal;

/**
 * Custom Principal to hold user information from JWT
 */
@Data
@AllArgsConstructor
public class UserPrincipal implements Principal {
    private Long userId;
    private String email;
    private String role;

    @Override
    public String getName() {
        return email;
    }
}
