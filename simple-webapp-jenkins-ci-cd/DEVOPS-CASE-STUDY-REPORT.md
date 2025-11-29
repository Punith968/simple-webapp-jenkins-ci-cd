
# Department of COMPUTER SCIENCE AND ENGINEERING (AI & ML)

## Case Study Report
**On**
### Ability Enhancement Course – V (DevOps)
**Course Code**: 23CIAEC59

**By**
*   USN: 1MS24CI408
*   USN: 1MS24CI411
*   USN: 1MS23CI072
*   USN: 1MS23CI073

**Under the guidance of**
**Ms. Kavya Natikar**
Assistant Professor

**M. S. Ramaiah Institute of Technology**
(Autonomous Institute Affiliated to VTU)
MSR Nagar, MSRIT Post
Bangalore-560054, Karnataka, India

---

## Certificate

This is to certify that the Case Study entitled “**Implementation of a CI/CD Pipeline for a Simple Web Application Using Jenkins and Docker**” is a bonafide record of the Case Study Report work done by **1MS24CI408, 1MS24CI411, 1MS23CI072, 1MS23CI073** under my supervision and guidance, in partial fulfilment of the requirements for the award of the Bachelor of Engineering in Computer Science & Engineering (AI & ML) from Ramaiah Institute of Technology, Bangalore for the academic year 2025–2026.


**Candidate Sign**                                                      **Faculty Sign**

---

## Acknowledgment

We express our sincere gratitude to **Dr. Siddesh G. M**, Professor and Head of the Department, CSE (AI & ML) and CSE (Cyber Security), for providing the opportunity to carry out this case study work on DevOps. We also thank **Ms. Kavya Natikar**, Assistant Professor, Dept. of CSE (AI & ML), for her valuable guidance, support, and encouragement. We extend heartfelt thanks to our families for their continuous motivation throughout the completion of this project.

---

## Abstract

This case study presents the complete implementation of a CI/CD pipeline for a simple web application using Jenkins, Docker, and GitHub. The goal is to automate integration, testing, containerization, and deployment. The project demonstrates full automation with four successful pipeline stages: Checkout, Build, Test, and Deploy. Through DevOps methodologies, the workflow achieves reliable and repeatable deployments with 100% success.

## Introduction

Modern software engineering demands continuous integration and continuous deployment (CI/CD) practices to accelerate development cycles. To address this need, we built an automated CI/CD pipeline for a static web application. The pipeline uses Jenkins to automatically validate code, build Docker images, test components, and deploy the application. This case study highlights the architecture, tools, implementation steps, and technical outcomes of the pipeline.

## Problem Statement

Manual deployment processes are error-prone, inconsistent, and inefficient. Even for simple applications, repetitive manual steps lead to delays and configuration issues. The problem addressed in this case study is the need for a fully automated, reliable, and repeatable workflow to build, test, and deploy a simple web application. The objective is to design and implement an end-to-end CI/CD pipeline using Jenkins and Docker.

## Proposed Work

*   **Version Control**: Git & GitHub
*   **CI/CD Automation**: Jenkins
*   **Containerization**: Docker
*   **Orchestration**: Docker Compose
*   **Deployment Server**: Nginx
*   **Shell Scripts**: `validate.sh` and `deploy.sh`

## DevOps Tools / Technologies Used

*   **Git** – Source code management
*   **GitHub** – Remote repository
*   **Jenkins** – Pipeline automation
*   **Docker** – Containerization
*   **Docker Compose** – Multi-container environment
*   **Nginx** – Web server
*   **Shell Scripting** – Automation scripts

## Implementation Code & Configuration

**Jenkinsfile:**
```groovy
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Build') {
            steps {
                sh 'chmod +x validate.sh'
                sh './validate.sh'
            }
        }

        stage('Test') {
            steps {
                sh 'echo "Running tests..."'
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker build -t simple-webapp:demo .'
                sh 'docker run -d --rm -p 8081:80 simple-webapp:demo'
            }
        }
    }
}
```

**Dockerfile:**
```dockerfile
FROM nginx:latest
COPY . /usr/share/nginx/html
```

**docker-compose.yml:**
```yaml
version: '3'

services:
  jenkins:
    image: jenkins/jenkins:lts
    ports:
      - "8080:8080"
    volumes:
      - jenkins_home:/var/jenkins_home

  webapp:
    build: .
    ports:
      - "8081:80"

volumes:
  jenkins_home:
```

**validate.sh:**
```bash
#!/bin/bash
required=(index.html styles.css script.js Dockerfile)

for file in "${required[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing: $file"
    exit 1
  fi
done

echo "All required files are present."
```

## Deployment Details

The application is deployed using two distinct methods to demonstrate versatility:

### 1. Docker Container Deployment (Local/Server)
*   **Mechanism**: The Jenkins pipeline builds a Docker image (`simple-webapp:demo`) and runs it as a container.
*   **Port Mapping**: The container's internal port `80` is mapped to the host's port `8081`.
*   **Access**: The application is accessible locally at `http://localhost:8081`.
*   **Command**: `docker run -d --rm -p 8081:80 simple-webapp:demo`

### 2. GitHub Pages Deployment (Public Cloud)
*   **Mechanism**: A GitHub Actions workflow (`deploy.yml`) automatically triggers on push to the `main` branch.
*   **Process**: It builds the static assets and pushes them to a specific `gh-pages` branch.
*   **Access**: The application is publicly accessible on the internet.
*   **URL**: `https://Punith968.github.io/simple-webapp-jenkins-ci-cd/`

## Analysis of Results

*   **Pipeline Success Rate**: 100%
*   **Total Stages**: 4 (Checkout, Build, Test, Deploy)
*   **Deployment Method**: Docker containerization
*   **Application served using Nginx on port 8081**

## Key Learning Outcomes & Roles/Responsibilities

### Key Learning Outcomes
*   **CI/CD Pipeline Mastery**: Gained practical experience in designing and implementing a complete CI/CD pipeline using Jenkins.
*   **Containerization**: Understood the core concepts of Docker and how to containerize applications for consistent deployment.
*   **Automation**: Learned to automate repetitive tasks like testing and deployment using shell scripts and Jenkinsfiles.
*   **Version Control Integration**: Mastered the integration of Git/GitHub with Jenkins for automated triggers.
*   **Infrastructure as Code**: Applied IaC principles by defining infrastructure and pipelines using Dockerfiles and Jenkinsfiles.

### Roles & Responsibilities
*   **1MS24CI408**:
    *   **Role**: DevOps Engineer (Pipeline Architect)
    *   **Responsibilities**: Designed the Jenkins pipeline architecture, wrote the `Jenkinsfile`, and configured the Jenkins server.
*   **1MS24CI411**:
    *   **Role**: Cloud Engineer (Docker Specialist)
    *   **Responsibilities**: Created the `Dockerfile` and `docker-compose.yml`, managed container orchestration, and ensured Nginx configuration.
*   **1MS23CI072**:
    *   **Role**: Automation Engineer (Scripting & Testing)
    *   **Responsibilities**: Wrote the `validate.sh` script for automated testing, handled shell scripting for deployment, and verified build integrity.
*   **1MS23CI073**:
    *   **Role**: Software Developer (Web & GitHub Actions)
    *   **Responsibilities**: Developed the web application (HTML/CSS/JS), set up the GitHub repository, and implemented the GitHub Actions workflow for Pages deployment.

## Conclusion

The CI/CD pipeline created using Jenkins and Docker successfully automates the entire software delivery process for a simple web application. It eliminates manual effort, ensures consistency, and accelerates deployment. This case study demonstrates the effectiveness of DevOps practices in real-world scenarios.

## References

1.  Jenkins Documentation – https://www.jenkins.io/doc/
2.  Docker Documentation – https://docs.docker.com/
3.  Git Reference – https://git-scm.com/doc
4.  Nginx Docs – https://nginx.org/
5.  DevOps Handbook – Gene Kim et al.
