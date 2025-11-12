# simple-webapp-jenkins-ci-cd

CI/CD Pipeline for a Simple Web App using Jenkins — case study and demo repository.

This repo provides a minimal static web app and all necessary pipeline and container files to demonstrate a Jenkins CI/CD flow.

Contents
- `index.html` — Landing page with CSS and JS.
- `styles.css` — Basic styling.
- `script.js` — Button interactivity (triggers alert).
- `Jenkinsfile` — Declarative Jenkins pipeline (checkout, build, test, deploy, post).
- `Dockerfile` — Build an nginx image to serve the static site.
- `docker-compose.yml` — Local compose file that brings up Jenkins (and a simple webapp service). Useful for local testing.
- `deploy.sh` — Script to copy files to `/var/www/html` and restart web server.
- `validate.sh` — Validates presence of required files.
- `.gitignore` — Ignore common artifacts.
- `report.md` — Case study and workflow description.

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

Extending the demo
- Add automated end-to-end tests with Puppeteer or Playwright to validate the UI.
- Add a Jenkins declarative step to publish artifacts or push Docker images to a registry.

License
This repository is provided as an educational demo for CI/CD workflows.
