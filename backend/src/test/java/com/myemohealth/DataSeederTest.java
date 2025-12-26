package com.myemohealth;

import com.myemohealth.entity.PatientProfile;
import com.myemohealth.entity.Role;
import com.myemohealth.entity.User;
import com.myemohealth.repository.DoctorProfileRepository;
import com.myemohealth.repository.PatientProfileRepository;
import com.myemohealth.repository.RoleRepository;
import com.myemohealth.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.annotation.Commit;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Optional;

@SpringBootTest
public class DataSeederTest {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PatientProfileRepository patientProfileRepository;

    @Autowired
    private DoctorProfileRepository doctorProfileRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Test
    @Transactional
    @Commit // Needed to persist changes after test finishes
    public void seedData() {
        System.out.println("================ SEEDING DATA START ================");

        // 1. Roles
        Role doctorRole = ensureRole("DOCTOR");
        Role patientRole = ensureRole("PATIENT");

        // 2. Doctor (doctor1@example.com / password)
        User doctor = ensureUser("doctor1@example.com", "password", "John", "Doe", doctorRole);
        ensureDoctorProfile(doctor);

        // 3. Patient (patient1@example.com / password)
        User patient = ensureUser("patient1@example.com", "password", "Alice", "Dupont", patientRole);
        PatientProfile patientProfile = ensurePatientProfile(patient);

        // 4. Assign Patient to Doctor
        if (patientProfile.getDoctor() == null || !patientProfile.getDoctor().getId().equals(doctor.getId())) {
            patientProfile.setDoctor(doctor);
            patientProfileRepository.save(patientProfile);
            System.out.println("✅ Assigned patient1 to doctor1");
        } else {
            System.out.println("ℹ️ patient1 already assigned to doctor1");
        }

        // 5. E2E Doctor (e2e_doctor@example.com / password123)
        User e2eDoctor = ensureUser("e2e_doctor@example.com", "password123", "E2E", "Tester", doctorRole);
        ensureDoctorProfile(e2eDoctor);

        System.out.println("================ SEEDING DATA COMPLETE ================");
    }

    private Role ensureRole(String name) {
        return roleRepository.findByName(name).orElseGet(() -> {
            Role role = Role.builder().name(name).description(name + " Role").build();
            System.out.println("✅ Created Role: " + name);
            return roleRepository.save(role);
        });
    }

    private User ensureUser(String email, String plainPassword, String firstName, String lastName, Role role) {
        Optional<User> existing = userRepository.findByEmail(email);
        if (existing.isPresent()) {
            User user = existing.get();
            // Reset password if needed (checking raw string vs encoded is tricky, we can
            // just overwrite)
            user.setPasswordHash(passwordEncoder.encode(plainPassword));
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setRole(role);
            System.out.println("✅ Updated User: " + email);
            return userRepository.save(user);
        } else {
            User user = User.builder()
                    .email(email)
                    .passwordHash(passwordEncoder.encode(plainPassword))
                    .firstName(firstName)
                    .lastName(lastName)
                    .role(role)
                    .enabled(true)
                    .emailVerified(true)
                    .build();
            System.out.println("✅ Created User: " + email);
            return userRepository.save(user);
        }
    }

    // We assume DoctorProfile entity exists similar to PatientProfile, based on
    // DoctorController code
    // If not, we might need to skip or simplistic check
    private void ensureDoctorProfile(User user) {
        if (!doctorProfileRepository.existsById(user.getId())) {
            // Assuming simple constructor or builder. If this fails build, I'll need to see
            // DoctorProfile
            com.myemohealth.entity.DoctorProfile profile = new com.myemohealth.entity.DoctorProfile();
            profile.setUser(user);
            profile.setSpecialty("General Psychiatry");
            doctorProfileRepository.save(profile);
            System.out.println("✅ Created Profile for Doctor: " + user.getEmail());
        }
    }

    private PatientProfile ensurePatientProfile(User user) {
        return patientProfileRepository.findById(user.getId()).orElseGet(() -> {
            PatientProfile profile = PatientProfile.builder()
                    .user(user)
                    .dateNaissance(LocalDate.of(1990, 1, 1))
                    .sexe("F")
                    .currentPhase(1)
                    .build();
            System.out.println("✅ Created Profile for Patient: " + user.getEmail());
            return patientProfileRepository.save(profile);
        });
    }
}
