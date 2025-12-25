pipeline {
    agent any

    tools {
        maven 'maven'
        nodejs 'node'
    }

    environment {
        SCANNER_HOME = tool 'SonarQube-Server'
    }

    stages {
        stage('Clone') {
            steps {
                echo 'Cloning repository...'
                git branch: 'main', url: 'https://github.com/drissalichane/MyEmoTesting'
            }
        }

        stage('Parallel Analysis') {
            parallel {
                stage('Backend Flow') {
                    stages {
                        stage('Backend Build') {
                            steps {
                                dir('backend') {
                                    echo 'Building Backend...'
                                    bat 'mvn clean package -DskipTests'
                                }
                            }
                        }
                        stage('Backend Analysis') {
                            steps {
                                dir('backend') {
                                    echo 'Running SonarQube on Backend...'
                                    withSonarQubeEnv('SonarQube-Backend') {
                                        bat 'mvn sonar:sonar -Dsonar.projectKey=backend -Dsonar.projectName=backend'
                                    }
                                }
                            }
                        }
                    }
                }

                stage('Frontend Flow') {
                    stages {
                        stage('Frontend Install') {
                            steps {
                                dir('frontend-web') {
                                    echo 'Installing Frontend Dependencies...'
                                    bat 'npm install'
                                }
                            }
                        }
                        stage('Frontend Build') {
                            steps {
                                dir('frontend-web') {
                                    echo 'Building Frontend...'
                                    bat 'npm run build'
                                }
                            }
                        }
                        stage('Frontend Analysis') {
                            steps {
                                dir('frontend-web') {
                                    echo 'Running SonarQube on Frontend...'
                                    withSonarQubeEnv('SonarQube-Frontweb') {
                                        bat "${SCANNER_HOME}\\bin\\sonar-scanner -Dsonar.projectKey=frontweb -Dsonar.projectName=frontweb -Dsonar.sources=src -Dsonar.exclusions=**/node_modules/**"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        stage('E2E Tests') {
            steps {
                dir('e2e-tests') {
                    echo 'Running Selenium E2E Tests with Environment Setup...'
                    // Requires PowerShell on the agent
                    bat 'powershell -ExecutionPolicy Bypass -File run_ci_e2e.ps1'
                }
            }
        }
    }
}
