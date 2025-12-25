pipeline {
    agent any

    tools {
        maven 'maven'
        jdk 'jdk17'
        nodejs 'node20' // Ensure a NodeJS tool named 'node20' is configured in Jenkins
    }

    environment {
        SCANNER_HOME = tool 'SonarQube-Server'
    }

    stages {
        stage('Clone') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }

        // --- BACKEND: SPRING BOOT ---
        stage('Backend - Build & Test') {
            steps {
                dir('backend') {
                    echo 'Building Backend...'
                    // Skipping tests for speed as requested, remove -DskipTests to run them
                    bat 'mvn clean package -DskipTests' 
                }
            }
        }

        stage('Backend - SonarQube Analysis') {
            steps {
                dir('backend') {
                    echo 'Running SonarQube Analysis on Backend...'
                    withSonarQubeEnv('SonarQube-Local') {
                        // Maven Sonar Plugin
                        bat 'mvn sonar:sonar -Dsonar.projectKey=myemohealth-backend -Dsonar.projectName="MyEmoHealth Backend"'
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
                    withSonarQubeEnv('SonarQube-Local') {
                        // Generic Sonar Scanner for JS/TS
                        // Sources: src/app
                        bat "${SCANNER_HOME}\\bin\\sonar-scanner -Dsonar.projectKey=myemohealth-frontend -Dsonar.projectName=\"MyEmoHealth Frontend\" -Dsonar.sources=src -Dsonar.exclusions=**/node_modules/**"
                    }
                }
            }
        }

        /* 
        // --- DEPLOYMENT (SKIPPED FOR NOW) ---
        stage('Build Docker Images') {
            parallel {
                stage('Build Backend Image') {
                    steps {
                        dir('backend') {
                            bat 'docker build -t myemohealth/backend:latest .'
                        }
                    }
                }
                stage('Build Frontend Image') {
                    steps {
                        dir('frontend-web') {
                            bat 'docker build -t myemohealth/frontend:latest .'
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                dir('deploy') {
                    bat 'docker-compose up -d'
                }
            }
        }
        */
    }
}
