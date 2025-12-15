export interface User {
    id: number;
    email: string;
    firstName: string;
    lastName: string;
    role: 'PATIENT' | 'DOCTOR' | 'ADMIN';
    createdAt?: string;
    updatedAt?: string;
}

export interface AuthResponse {
    accessToken: string;
    refreshToken: string;
    tokenType: string;
    expiresIn: number;
    userId: number;
    email: string;
    firstName: string;
    lastName: string;
    role: string;
}

export interface LoginRequest {
    email: string;
    password: string;
}

export interface RegisterRequest {
    email: string;
    password: string;
    firstName: string;
    lastName: string;
    role: string;
    dateNaissance?: string;
    sexe?: string;
    consentVoiceRecording?: boolean;
    consentDataSharing?: boolean;
}
