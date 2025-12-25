pipeline {
    agent any

    tools {
        maven 'maven'
        // JDK is assumed to be available on the agent
        nodejs 'node' 
    }

    environment {
        // This tool name "sonar-scanner" MUST be configured in Global Tool Configuration
        SCANNER_HOME = tool 'SonarQube-Server'
    }

    stages {
        stage('Clone') {
            steps {
                echo 'Cloning repository...'
                // Explicit URL as requested
                git branch: 'main', url: 'https://github.com/drissalichane/MyEmoTesting'
            }
        }

        // --- BACKEND: SPRING BOOT ---
        stage('Backend - Build & Test') {
            steps {
                dir('backend') {
                    echo 'Building Backend...'
                    bat 'mvn clean package -DskipTests' 
                }
            }
        }

        stage('Backend - SonarQube Analysis') {
            steps {
                dir('backend') {
                    echo 'Running SonarQube Analysis on Backend...'
                    // 'SonarQube-Backend' matches the Server Name in Configure System
                    withSonarQubeEnv('SonarQube-Backend') {
                        // Use sonar:sonar goal. The plugin is now defined in pom.xml.
                        bat 'mvn sonar:sonar -Dsonar.projectKey=backend -Dsonar.projectName=backend'
                    }
                }
            }
        }
        
        // --- FRONTEND: ANGULAR ---
        stage('Frontend - Install Dependencies') {
            steps {
                dir('frontend-web') {
                    echo 'Installing Angular Dependencies...'
                    bat 'npm install'
                }
            }
        }
        
        stage('Frontend - Build') {
            steps {
                dir('frontend-web') {
                    echo 'Building Angular App...'
                    bat 'npm run build'
                }
            }
        }

        stage('Frontend - SonarQube Analysis') {
            steps {
                dir('frontend-web') {
                    echo 'Running SonarQube Analysis on Frontend...'
                    // 'SonarQube-Frontweb' matches the Server Name in Configure System
                    withSonarQubeEnv('SonarQube-Frontweb') {
                        // Use the scanner tool configured in environment variable
                        bat "${SCANNER_HOME}\\bin\\sonar-scanner -Dsonar.projectKey=frontweb -Dsonar.projectName=frontweb -Dsonar.sources=src -Dsonar.exclusions=**/node_modules/**"
                    }
                }
            }
        }
    }
}
