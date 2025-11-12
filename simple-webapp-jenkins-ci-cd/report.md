# Project Report — simple-webapp-jenkins-ci-cd

Status: COMPLETE — All 4 stages successful (Build #10)

## 1) Introduction
- Simple static website (HTML/CSS/JS)
- Jenkins pipeline automates: Checkout → Build → Test → Deploy
- Deployment via Docker (Nginx) on port 8090

## 2) Technologies Used
- HTML5, CSS3, JavaScript
- Nginx (nginx:alpine)
- Docker
- Jenkins (Declarative Pipeline)
- Git/GitHub

## 3) Tools Used
- Jenkins 2.528.2
- Docker 28.2.2
- Git 2.43.0
- Windows + WSL2 (Ubuntu 24.04)
- VS Code

## 4) Methodology / Implementation Steps
1. Create app files: `index.html`, `styles.css`, `script.js`
2. Add pipeline/container files: `Jenkinsfile`, `Dockerfile`, `docker-compose.yml`
3. Push repo to GitHub; configure Jenkins (Pipeline from SCM)
4. CI: run `validate.sh` in Build and Test stages (checks required files)
5. CD: build image and run container `simple-webapp-demo` on port 8090
6. Verify: open http://localhost:8090 and confirm JS alert works

## 5) Results
- Pipeline: 4/4 stages PASS (Checkout, Build, Test, Deploy)
- Build: #10 — SUCCESS; total runtime ~15s
- Deployment: Docker image `simple-webapp:latest`; container `simple-webapp-demo`
- URL: http://localhost:8090 (accessible and working)
- Verification: “Hello from the Simple WebApp Jenkins CI/CD demo!” alert shown

For more details and screenshots/logs, see: CASE-STUDY-SUMMARY.md

— Prepared on Nov 13, 2025 — Author: Punith C
