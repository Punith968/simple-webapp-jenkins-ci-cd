# Project Report — simple-webapp-jenkins-ci-cd

**Status**: ✅ COMPLETE — ALL 4 STAGES SUCCESSFUL  
**Latest Build**: #10 (100% success)  
**Deployment**: Docker container on port 8090 (production-ready)

## Introduction

This project delivers a complete CI/CD pipeline for a simple static web application (HTML/CSS/JS) using Jenkins. The pipeline automates code checkout, validation, testing, and deployment. Deployment is performed via Docker, serving the site through an Nginx container. The solution is designed to be minimal, reproducible, and suitable as a teaching/demo artifact for modern DevOps workflows.

Key outcomes:
- Fully automated pipeline (Checkout → Build → Test → Deploy) with post-deploy verification
- Containerized deployment with clean lifecycle management
- Documentation, scripts, and configuration aligned for repeatable runs

## Technologies Used

- Frontend: HTML5, CSS3, JavaScript (ES6)
- Web server: Nginx (nginx:alpine base image)
- Containerization: Docker
- CI/CD: Jenkins (Declarative Pipeline)
- Version control: Git (GitHub)
- OS/Runtime: Windows host with WSL2 Ubuntu 24.04 (Jenkins agent), PowerShell for host commands

## Tools Used

- Jenkins 2.528.2 (Pipeline from SCM)
- Docker 28.2.2 (daemon + CLI)
- Git 2.43.0
- WSL2 (Ubuntu) and Windows PowerShell
- VS Code (editing), GitHub (remote repo)
- Optional: docker-compose (local Jenkins + webapp composition)

## Methodology / Implementation Steps

1. Project Scaffold
   - Created static site: `index.html`, `styles.css`, `script.js`
   - Added pipeline and container artifacts: `Jenkinsfile`, `Dockerfile`, `docker-compose.yml`
   - Wrote automation scripts: `validate.sh` (checks required files), `deploy.sh` (copy-based alternative)
   - Initialized Git and pushed to GitHub

2. Jenkins Pipeline Configuration (Pipeline from SCM)
   - Repository: `https://github.com/Punith968/simple-webapp-jenkins-ci-cd.git`
   - Branch: `main`
   - Script Path: `simple-webapp-jenkins-ci-cd/Jenkinsfile` (to handle nested structure)
   - Environment vars: `DEPLOY_METHOD=docker`, `CONTAINER_NAME=simple-webapp-demo`, `WEBAPP_PORT=8090`

3. Build and Test Stages (CI)
   - Ensure scripts are executable on Linux agents (`chmod +x validate.sh deploy.sh` safeguard)
   - Run `validate.sh` to assert presence of `index.html`, `styles.css`, `script.js`
   - Fast feedback via clear console logs and non-zero exit on missing files

4. Deploy Stage (CD)
   - Build Docker image from `Dockerfile` (Nginx serving app assets)
   - Stop and remove any previous container with the same name
   - Run container mapping host port 8090 → container port 80
   - Post actions verify container is running and print access URL

5. Platform and Permissions Hardening
   - Added Jenkins user to `docker` group and restarted service (no sudo needed)
   - Pre-pulled `nginx:alpine` to avoid first-build network delays
   - Used `dir()` wrappers in `Jenkinsfile` to work within nested repo path

6. Documentation and Evidence
   - Authored `CASE-STUDY-SUMMARY.md`, `DEPLOYMENT-GUIDE.md`, and `DEPLOYMENT-COMPLETION.md`
   - Recorded final build success and deployment verification steps

## Results

- Pipeline: 4/4 stages green (Checkout, Build, Test, Deploy)
- Build: #10 finished SUCCESS in ~15 seconds total
- Deployment: Docker image `simple-webapp:latest` (ID: e54b76dbdf5f)
- Runtime: Container `simple-webapp-demo` (ID: 1db05a33b511), port mapping `8090:80`
- Accessibility: App live at `http://localhost:8090` (and WSL IP as applicable)
- Functionality: JavaScript alert verified — “Hello from the Simple WebApp Jenkins CI/CD demo!”

For comprehensive metrics, challenges overcome, and lessons learned, see: **[CASE-STUDY-SUMMARY.md](CASE-STUDY-SUMMARY.md)**.

---

Prepared on: November 13, 2025  
Author: Punith C  
Repository: https://github.com/Punith968/simple-webapp-jenkins-ci-cd
