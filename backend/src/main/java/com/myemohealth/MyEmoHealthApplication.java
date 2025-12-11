package com.myemohealth;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

/**
 * Spring Boot Application Entry Point
 * MyEmoHealth - Emotional Telemonitoring System
 */
@SpringBootApplication
@EnableJpaRepositories(basePackages = "com.myemohealth.repository")
public class MyEmoHealthApplication {

    public static void main(String[] args) {
        SpringApplication.run(MyEmoHealthApplication.class, args);
    }
}
