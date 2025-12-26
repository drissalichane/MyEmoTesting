package com.myemohealth;

import com.myemohealth.entity.User;
import com.myemohealth.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@SpringBootTest
// Use the same profile as the application if needed, or default
public class DatabaseInterrogatorTest {

    @Autowired
    private UserRepository userRepository;

    @Test
    @Transactional // optional, but good for read-only
    public void printAllUsers() {
        System.out.println(
                "====================================================================================================");
        System.out.println("STARTING DATABASE INTERROGATION");
        System.out.println(
                "====================================================================================================");

        List<User> users = userRepository.findAll();

        if (users.isEmpty()) {
            System.out.println("No users found in the database.");
        } else {
            System.out.printf("%-5s | %-30s | %-15s | %-60s%n", "ID", "Email", "Role", "Password Hash");
            System.out.println(
                    "----------------------------------------------------------------------------------------------------");
            for (User user : users) {
                String roleName = (user.getRole() != null) ? user.getRole().getName() : "N/A";
                System.out.printf("%-5d | %-30s | %-15s | %-60s%n",
                        user.getId(),
                        user.getEmail(),
                        roleName,
                        user.getPasswordHash());
            }
        }

        System.out.println(
                "====================================================================================================");
        System.out.println("FINISHED DATABASE INTERROGATION");
        System.out.println(
                "====================================================================================================");
    }
}
