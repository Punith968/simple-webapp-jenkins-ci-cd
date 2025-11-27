# simple-webapp-jenkins-ci-cd

[![Pipeline Status](https://img.shields.io/badge/Pipeline-SUCCESS-brightgreen)]()
[![Build](https://img.shields.io/badge/Build-%2310-blue)]()
[![Deployment](https://img.shields.io/badge/Deployment-COMPLETE-success)]()
[![Docker](https://img.shields.io/badge/Docker-Running-blue)]()

CI/CD Pipeline for a Simple Web App using Jenkins — case study and demo repository.

This repo provides a minimal static web app and all necessary pipeline and container files to demonstrate a **complete, production-ready** Jenkins CI/CD flow.

**Status**: ✅ All 4 pipeline stages successful | ✅ Application deployed and running | ✅ 100% functional

> Looking for a single, step-by-step build and implementation doc? See `IMPLEMENTATION-GUIDE.md` for the full technology stack, folder structure, key code listings, local run commands (Windows PowerShell and WSL/Linux/macOS), Jenkins setup, and troubleshooting.

## 📁 Contents

**Application Files:**
- `index.html` — Landing page with CSS and JS
- `styles.css` — Modern, responsive styling
- `script.js` — Button interactivity (triggers alert)

**CI/CD Pipeline:**
- `Jenkinsfile` — Declarative Jenkins pipeline (4 stages: checkout, build, test, deploy)
- `validate.sh` — Validates presence of required files
- `deploy.sh` — Deployment script (alternative method)

**Containerization:**
- `Dockerfile` — Nginx-based image for serving static site
- `docker-compose.yml` — Multi-container setup (Jenkins + webapp)
- `setup-jenkins-docker.sh` — Docker permissions configuration

**Documentation:**
- `README.md` — Project overview (this file)
- `report.md` — Case study and workflow description
- `CASE-STUDY-SUMMARY.md` — **Complete project results and metrics** ⭐
- `DEPLOYMENT-GUIDE.md` — Step-by-step deployment instructions
- `DEPLOYMENT-COMPLETION.md` — Final deployment status

**Other:**
- `.gitignore` — Git ignore rules for common artifacts

Quick start (local demo)
1. Build and run the static webapp using Docker:

```bash
# from project root
docker build -t simple-webapp:local .
docker run -d --rm -p 8081:80 simple-webapp:local
```

Then open http://localhost:8081 in a browser and click the "Show Alert" button.

Run with docker-compose (includes Jenkins):

```bash
# from project root
docker-compose up --build
```

Jenkins will be available at http://localhost:8080 (initial admin password in docker logs or in jenkins_home volume).

Using the Jenkins pipeline
- Configure a pipeline job in Jenkins and point to this repository.
- Ensure `validate.sh` and `deploy.sh` are executable on the agent (or pipeline performs chmod +x).
- Set environment variables in the Jenkins job if needed:
  - `REPO_URL` — optional, to clone a remote repo instead of using workspace contents.
  - `DEPLOY_METHOD` — `copy` (default) or `docker` (build & run Docker image).

Notes
- `deploy.sh` expects `sudo` and typical Linux web server paths (`/var/www/html`). Adjust for your environment (e.g., Windows, or different web server path).
- The `docker-compose.yml` maps the webapp to port 8081 to avoid conflict with Jenkins on 8080.

## 🎯 Project Results

**Pipeline Success Rate**: 100% (4/4 stages)  
**Latest Build**: #10 (SUCCESS)  
**Deployment Method**: Docker containerization  
**Application URL**: http://localhost:8090  
**Container Status**: Running (simple-webapp-demo)

For detailed results, metrics, and lessons learned, see: **[CASE-STUDY-SUMMARY.md](CASE-STUDY-SUMMARY.md)** 📊

---

## 🚀 Future Enhancements

- Add automated end-to-end tests with Puppeteer or Playwright to validate the UI
- Add a Jenkins declarative step to publish artifacts or push Docker images to a registry
- Implement blue-green or canary deployment strategies
- Add webhook triggers for automatic builds on git push
- Set up monitoring and alerting (Slack/email notifications)

---

## 📄 License

This repository is provided as an educational demo for CI/CD workflows.

---

## 👨‍💻 Author

**Punith C**  
**Date**: November 13, 2025  
**GitHub**: https://github.com/Punith968/simple-webapp-jenkins-ci-cd

---

**✅ Project Status**: COMPLETE - PRODUCTION READY 🎉
