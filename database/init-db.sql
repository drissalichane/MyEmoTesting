-- MyEmoHealth Database Initialization Script
-- PostgreSQL 13+

-- Create database (run this separately as superuser if needed)
-- CREATE DATABASE suiviemot;
-- \c suiviemot;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================
-- CORE USER MANAGEMENT
-- ============================================

CREATE TABLE role (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "user" (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role_id INTEGER NOT NULL REFERENCES role(id),
    enabled BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

CREATE TABLE patient_profile (
    user_id BIGINT PRIMARY KEY REFERENCES "user"(id) ON DELETE CASCADE,
    date_naissance DATE,
    sexe VARCHAR(10) CHECK (sexe IN ('M', 'F', 'OTHER')),
    medical_notes TEXT,
    doctor_id BIGINT REFERENCES "user"(id),
    admission_date DATE,
    discharge_date DATE,
    current_phase INTEGER DEFAULT 1 CHECK (current_phase BETWEEN 1 AND 5),
    consent_voice_recording BOOLEAN DEFAULT FALSE,
    consent_data_sharing BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE doctor_profile (
    user_id BIGINT PRIMARY KEY REFERENCES "user"(id) ON DELETE CASCADE,
    specialty VARCHAR(100),
    phone VARCHAR(20),
    license_number VARCHAR(50),
    availabilities JSONB,
    max_patients INTEGER DEFAULT 50,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- PHASE MANAGEMENT
-- ============================================

CREATE TABLE phase (
    id SERIAL PRIMARY KEY,
    number INTEGER UNIQUE NOT NULL CHECK (number BETWEEN 1 AND 5),
    label VARCHAR(100) NOT NULL,
    description TEXT,
    duration_days INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE patient_phase_progress (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    phase_id INTEGER NOT NULL REFERENCES phase(id),
    status VARCHAR(20) DEFAULT 'IN_PROGRESS' CHECK (status IN ('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'FAILED')),
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    tests_completed INTEGER DEFAULT 0,
    tests_passed INTEGER DEFAULT 0,
    UNIQUE(patient_id, phase_id)
);

-- ============================================
-- QCM SYSTEM
-- ============================================

CREATE TABLE qcm_template (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    creator_id BIGINT NOT NULL REFERENCES "user"(id),
    category VARCHAR(50),
    difficulty_level INTEGER CHECK (difficulty_level BETWEEN 1 AND 5),
    estimated_duration_minutes INTEGER,
    is_active BOOLEAN DEFAULT TRUE,
    version INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE qcm_question (
    id BIGSERIAL PRIMARY KEY,
    qcm_id BIGINT NOT NULL REFERENCES qcm_template(id) ON DELETE CASCADE,
    position INTEGER NOT NULL,
    question_text TEXT NOT NULL,
    question_type VARCHAR(20) NOT NULL CHECK (question_type IN ('SINGLE_CHOICE', 'MULTIPLE_CHOICE', 'SCALE', 'TEXT')),
    options JSONB,
    correct_answer JSONB,
    weight DECIMAL(5,2) DEFAULT 1.0,
    explanation TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(qcm_id, position)
);

CREATE TABLE test_instance (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
    patient_id BIGINT NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    qcm_id BIGINT NOT NULL REFERENCES qcm_template(id),
    phase_id INTEGER NOT NULL REFERENCES phase(id),
    scheduled_at TIMESTAMP,
    started_at TIMESTAMP,
    finished_at TIMESTAMP,
    score DECIMAL(5,2),
    max_score DECIMAL(5,2) DEFAULT 10.0,
    status VARCHAR(20) DEFAULT 'SCHEDULED' CHECK (status IN ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'ABANDONED', 'FAILED', 'PASSED')),
    attempt_number INTEGER DEFAULT 1,
    time_spent_seconds INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE answer (
    id BIGSERIAL PRIMARY KEY,
    test_instance_id BIGINT NOT NULL REFERENCES test_instance(id) ON DELETE CASCADE,
    question_id BIGINT NOT NULL REFERENCES qcm_question(id),
    selected_options JSONB,
    value_numeric DECIMAL(10,2),
    text_response TEXT,
    is_correct BOOLEAN,
    points_earned DECIMAL(5,2),
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(test_instance_id, question_id)
);

-- ============================================
-- COMMUNICATION SYSTEM
-- ============================================

CREATE TABLE chat_thread (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
    patient_id BIGINT NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    doctor_id BIGINT NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'ARCHIVED', 'CLOSED')),
    last_message_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(patient_id, doctor_id)
);

CREATE TABLE chat_message (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
    thread_id BIGINT NOT NULL REFERENCES chat_thread(id) ON DELETE CASCADE,
    sender_id BIGINT NOT NULL REFERENCES "user"(id),
    message_type VARCHAR(20) DEFAULT 'TEXT' CHECK (message_type IN ('TEXT', 'VOICE', 'IMAGE', 'FILE')),
    text_content TEXT,
    attachment_url VARCHAR(500),
    attachment_encrypted BOOLEAN DEFAULT FALSE,
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE call_log (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
    thread_id BIGINT REFERENCES chat_thread(id),
    initiator_id BIGINT NOT NULL REFERENCES "user"(id),
    receiver_id BIGINT NOT NULL REFERENCES "user"(id),
    call_type VARCHAR(20) NOT NULL CHECK (call_type IN ('AUDIO', 'VIDEO')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('INITIATED', 'RINGING', 'ANSWERED', 'ENDED', 'MISSED', 'REJECTED')),
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    duration_seconds INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- VOICE ANALYSIS SYSTEM
-- ============================================

CREATE TABLE voice_record (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
    patient_id BIGINT NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    test_instance_id BIGINT REFERENCES test_instance(id),
    file_path VARCHAR(500) NOT NULL,
    file_size_bytes BIGINT,
    duration_seconds INTEGER,
    is_encrypted BOOLEAN DEFAULT TRUE,
    encryption_key_id VARCHAR(100),
    mime_type VARCHAR(50),
    transcription TEXT,
    processing_status VARCHAR(20) DEFAULT 'PENDING' CHECK (processing_status IN ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP
);

CREATE TABLE voice_analysis_result (
    id BIGSERIAL PRIMARY KEY,
    voice_record_id BIGINT UNIQUE NOT NULL REFERENCES voice_record(id) ON DELETE CASCADE,
    emotion_scores JSONB,
    dominant_emotion VARCHAR(50),
    confidence DECIMAL(5,2),
    sentiment_score DECIMAL(5,2),
    stress_level VARCHAR(20) CHECK (stress_level IN ('LOW', 'MEDIUM', 'HIGH', 'VERY_HIGH')),
    analysis_metadata JSONB,
    analyzer_version VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- NOTIFICATIONS & ALERTS
-- ============================================

CREATE TABLE notification (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
    user_id BIGINT NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    notification_type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'NORMAL' CHECK (priority IN ('LOW', 'NORMAL', 'HIGH', 'URGENT')),
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP,
    action_url VARCHAR(500),
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP
);

-- ============================================
-- AUDIT & SECURITY
-- ============================================

CREATE TABLE audit_log (
    id BIGSERIAL PRIMARY KEY,
    entity_type VARCHAR(100) NOT NULL,
    entity_id BIGINT,
    action VARCHAR(50) NOT NULL,
    user_id BIGINT REFERENCES "user"(id),
    ip_address INET,
    user_agent TEXT,
    changes JSONB,
    status VARCHAR(20),
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE refresh_token (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    is_revoked BOOLEAN DEFAULT FALSE,
    revoked_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

-- User indexes
CREATE INDEX idx_user_email ON "user"(email);
CREATE INDEX idx_user_role ON "user"(role_id);
CREATE INDEX idx_user_uuid ON "user"(uuid);

-- Patient profile indexes
CREATE INDEX idx_patient_doctor ON patient_profile(doctor_id);
CREATE INDEX idx_patient_phase ON patient_profile(current_phase);

-- Test instance indexes
CREATE INDEX idx_test_patient ON test_instance(patient_id);
CREATE INDEX idx_test_qcm ON test_instance(qcm_id);
CREATE INDEX idx_test_phase ON test_instance(phase_id);
CREATE INDEX idx_test_status ON test_instance(status);
CREATE INDEX idx_test_scheduled ON test_instance(scheduled_at);

-- Chat indexes
CREATE INDEX idx_chat_thread_patient ON chat_thread(patient_id);
CREATE INDEX idx_chat_thread_doctor ON chat_thread(doctor_id);
CREATE INDEX idx_chat_message_thread ON chat_message(thread_id);
CREATE INDEX idx_chat_message_sender ON chat_message(sender_id);
CREATE INDEX idx_chat_message_created ON chat_message(created_at DESC);

-- Voice record indexes
CREATE INDEX idx_voice_patient ON voice_record(patient_id);
CREATE INDEX idx_voice_test ON voice_record(test_instance_id);
CREATE INDEX idx_voice_status ON voice_record(processing_status);

-- Notification indexes
CREATE INDEX idx_notification_user ON notification(user_id);
CREATE INDEX idx_notification_read ON notification(is_read);
CREATE INDEX idx_notification_created ON notification(created_at DESC);

-- Audit log indexes
CREATE INDEX idx_audit_entity ON audit_log(entity_type, entity_id);
CREATE INDEX idx_audit_user ON audit_log(user_id);
CREATE INDEX idx_audit_created ON audit_log(created_at DESC);

-- ============================================
-- TRIGGERS FOR UPDATED_AT
-- ============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_user_updated_at BEFORE UPDATE ON "user"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_patient_profile_updated_at BEFORE UPDATE ON patient_profile
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_doctor_profile_updated_at BEFORE UPDATE ON doctor_profile
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_qcm_template_updated_at BEFORE UPDATE ON qcm_template
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================

COMMENT ON TABLE "user" IS 'Core user table for all system users (patients, doctors, admins)';
COMMENT ON TABLE patient_profile IS 'Extended profile information for patients';
COMMENT ON TABLE doctor_profile IS 'Extended profile information for doctors';
COMMENT ON TABLE phase IS 'Treatment phases (1-5) that patients progress through';
COMMENT ON TABLE qcm_template IS 'QCM questionnaire templates created by doctors';
COMMENT ON TABLE test_instance IS 'Individual test attempts by patients';
COMMENT ON TABLE voice_record IS 'Encrypted voice recordings with metadata';
COMMENT ON TABLE voice_analysis_result IS 'AI-generated emotional analysis of voice recordings';
COMMENT ON TABLE audit_log IS 'Security audit trail for sensitive operations';

COMMENT ON COLUMN voice_record.is_encrypted IS 'Voice files must be encrypted at rest for GDPR compliance';
COMMENT ON COLUMN patient_profile.consent_voice_recording IS 'Explicit patient consent for voice recording and analysis';
COMMENT ON COLUMN test_instance.score IS 'Test score out of 10. Passing score is >= 7.5';
