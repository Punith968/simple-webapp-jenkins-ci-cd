# Implementation & Build Guide

This guide consolidates the full implementation, technologies used, code listings, and step-by-step build/run instructions for the entire project.

Status: Production-ready demo — Jenkins CI/CD green, Dockerized deployment works locally.


## 1) Project Overview

A minimal static site (HTML/CSS/JS) is served with nginx in Docker. A Jenkins Declarative Pipeline validates required files, runs simple tests, builds a Docker image, and deploys a container. You can run locally or via Jenkins.


## 2) Technology Stack

- Frontend: HTML5, CSS3, vanilla JavaScript
- Web server: nginx:alpine (serves static files)
- CI/CD: Jenkins (Declarative Pipeline: Checkout → Build → Test → Deploy)
- Containers: Docker; optional docker-compose for Jenkins + app
- OS/Environment: Windows + PowerShell, WSL2/Ubuntu, or Linux/macOS


## 3) Folder Structure

```
simple-webapp-jenkins-ci-cd/
├─ index.html                 # Landing page
├─ styles.css                 # Styling
├─ script.js                  # Interactivity
├─ Dockerfile                 # nginx-based container
├─ docker-compose.yml         # Jenkins + webapp (optional)
├─ Jenkinsfile                # CI/CD pipeline
├─ validate.sh                # Build/test validation
├─ deploy.sh                  # Copy-based deploy (optional)
├─ setup-jenkins-docker.sh    # Add Jenkins user to docker group
├─ README.md                  # High-level overview
├─ IMPLEMENTATION-GUIDE.md    # This document
├─ CASE-STUDY-SUMMARY.md      # Results summary
├─ DEPLOYMENT-GUIDE.md        # Step-by-step deployment
└─ ... other docs & artifacts
```


## 4) Key Code Listings

index.html

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Simple WebApp — Jenkins CI/CD Demo</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <main class="container">
    <header>
      <h1>Simple WebApp — Jenkins CI/CD Demo</h1>
      <p class="lead">A tiny static landing page used to demonstrate a Jenkins CI/CD pipeline.</p>
    </header>

    <section class="content">
      <p>This demo includes a button that triggers a JavaScript alert to show interactivity.</p>
      <button id="demoBtn" class="btn">Show Alert</button>
    </section>

    <footer>
      <small>© Simple WebApp CI/CD Demo</small>
    </footer>
  </main>

  <script src="script.js"></script>
</body>
</html>
```

styles.css

```css
:root { --bg:#f6f8fa; --card:#fff; --accent:#007bff; --text:#222; }
*{ box-sizing:border-box } html,body{ height:100%; margin:0; font-family:Inter, system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', Arial; color:var(--text); background:var(--bg) }
.container{ max-width:680px; margin:6vh auto; background:#fff; padding:2rem; border-radius:10px; box-shadow:0 8px 30px rgba(16,24,40,.06); text-align:center }
+h1{ margin:0 0 .25rem; font-size:1.6rem } .lead{ margin:0 0 1rem; color:#444 } .content{ margin-top:1rem }
.btn{ display:inline-block; padding:.6rem 1.05rem; font-size:1rem; border-radius:8px; border:none; background:var(--accent); color:#fff; cursor:pointer } .btn:hover{ background:#0056d6 }
footer{ margin-top:1.6rem; color:#666; font-size:.875rem }
```

script.js

```javascript
document.addEventListener('DOMContentLoaded', function () {
  const btn = document.getElementById('demoBtn');
  if (!btn) return;
  btn.addEventListener('click', function () {
    alert('Hello from the Simple WebApp Jenkins CI/CD demo!');
  });
});
```

Dockerfile

```dockerfile
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY ./ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

docker-compose.yml

```yaml
version: '3.8'
services:
  jenkins:
    image: jenkins/jenkins:lts
    restart: unless-stopped
    ports: ["8080:8080", "50000:50000"]
    environment: ["JAVA_OPTS=-Djenkins.install.runSetupWizard=false"]
    volumes:
      - jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
  docker-dind:
    image: docker:dind
    privileged: true
    environment: ["DOCKER_TLS_CERTDIR="]
  webapp:
    build: .
    image: simple-webapp:local
    ports: ["8081:80"]
    restart: unless-stopped
volumes:
  jenkins_home:
```

Jenkinsfile

```groovy
pipeline {
  agent any
  environment {
    REPO_URL = ""
    DEPLOY_METHOD = "docker"
    IMAGE_NAME = "simple-webapp:latest"
    CONTAINER_NAME = "simple-webapp-demo"
    WEBAPP_PORT = "8090"
  }
  stages {
    stage('Checkout') {
      steps {
        script {
          if (env.REPO_URL?.trim()) {
            echo "Cloning from ${env.REPO_URL} (branch: main)..."
            sh 'git clone --branch main ${REPO_URL} repo || true'
            dir('repo') { sh 'ls -la' }
          } else {
            echo 'REPO_URL not set — using current workspace contents.'
            echo 'Changing to project directory: simple-webapp-jenkins-ci-cd'
            dir('simple-webapp-jenkins-ci-cd') {
              sh 'pwd && ls -la'
            }
          }
        }
      }
    }
    stage('Build') {
      steps {
        dir('simple-webapp-jenkins-ci-cd') {
          sh 'chmod +x validate.sh deploy.sh || true'
          sh './validate.sh'
        }
      }
    }
    stage('Test') {
      steps { dir('simple-webapp-jenkins-ci-cd') { sh './validate.sh' } }
    }
    stage('Deploy') {
      steps {
        dir('simple-webapp-jenkins-ci-cd') {
          script {
            if (env.DEPLOY_METHOD == 'docker') {
              sh "docker build -t ${env.IMAGE_NAME} ."
              sh "docker rm -f ${env.CONTAINER_NAME} || true"
              sh "docker run -d --name ${env.CONTAINER_NAME} -p ${env.WEBAPP_PORT}:80 ${env.IMAGE_NAME}"
              echo "Deployment complete! Access the webapp at: http://localhost:${env.WEBAPP_PORT}"
            } else {
              sh 'chmod +x deploy.sh || true'
              sh './deploy.sh'
            }
          }
        }
      }
    }
  }
  post {
    success {
      echo '================================================'
      echo 'Pipeline completed successfully! ✅'
      echo '================================================'
      script {
        if (env.DEPLOY_METHOD == 'docker') {
          echo "Webapp deployed and running at: http://localhost:${env.WEBAPP_PORT}"
          echo "Container name: ${env.CONTAINER_NAME}"
          sh "docker ps | grep ${env.CONTAINER_NAME} || echo 'Container not found'"
        }
      }
      echo '================================================'
    }
    failure { echo 'Pipeline failed. Inspect logs and fix the issue.' }
  }
}
```

validate.sh

```bash
#!/usr/bin/env bash
set -euo pipefail
REQUIRED=(index.html styles.css script.js)
MISSING=()
for f in "${REQUIRED[@]}"; do [ -f "$f" ] || MISSING+=("$f"); done
if [ ${#MISSING[@]} -ne 0 ]; then
  echo "Missing required files:" >&2
  for m in "${MISSING[@]}"; do echo " - $m" >&2; done
  exit 2
else
  echo "All required files present: ${REQUIRED[*]}"
fi
```

deploy.sh (optional copy-based deployment)

```bash
#!/usr/bin/env bash
set -euo pipefail
SITE_SRC_DIR="$(pwd)"; TARGET_DIR="/var/www/html"
if [ ! -f "$SITE_SRC_DIR/index.html" ] || [ ! -f "$SITE_SRC_DIR/styles.css" ] || [ ! -f "$SITE_SRC_DIR/script.js" ]; then echo "Required files missing"; exit 1; fi
sudo mkdir -p "$TARGET_DIR"; sudo cp -r "$SITE_SRC_DIR"/* "$TARGET_DIR/"
if id -u www-data >/dev/null 2>&1; then sudo chown -R www-data:www-data "$TARGET_DIR"; else sudo chown -R nobody:nogroup "$TARGET_DIR" || true; fi
```

setup-jenkins-docker.sh (agent Docker permissions)

```bash
#!/usr/bin/env bash
set -euo pipefail
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```


## 5) Build & Run Locally

Prerequisites
- Install Docker Desktop (Windows/macOS) or Docker Engine (Linux)
- Optional: WSL2 Ubuntu for Windows

PowerShell (Windows)

```powershell
# Clone and run
git clone https://github.com/Punith968/simple-webapp-jenkins-ci-cd.git
cd simple-webapp-jenkins-ci-cd
docker build -t simple-webapp:local .
docker run -d --rm -p 8081:80 --name simple-webapp-demo simple-webapp:local
# Open http://localhost:8081
```

Stop container

```powershell
docker rm -f simple-webapp-demo
```

WSL/Linux/macOS

```bash
git clone https://github.com/Punith968/simple-webapp-jenkins-ci-cd.git
cd simple-webapp-jenkins-ci-cd
docker build -t simple-webapp:local .
docker run -d --rm -p 8081:80 --name simple-webapp-demo simple-webapp:local
```


## 6) Jenkins CI/CD Setup

1) Create a Pipeline Job
- Pipeline script from SCM → Git URL points to this repository
- Script Path: `Jenkinsfile` (repo root)

2) Allow Docker for Jenkins user (on Jenkins host)

```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

3) Pipeline environment (optional)
- `DEPLOY_METHOD=docker`
- `WEBAPP_PORT=8090`

4) Run the Pipeline
- Checkout → Build (validate) → Test → Deploy (Docker)
- App URL after success: http://localhost:8090


## 7) Troubleshooting

- Docker permission denied in Jenkins: ensure `jenkins` in `docker` group and Jenkins restarted
- Port conflicts: change `WEBAPP_PORT` or local run port (e.g., 8081)
- Windows line endings: set LF for Jenkinsfile and `*.sh`; pipeline does `chmod +x`
- Slow image pulls: pre-pull `nginx:alpine` on agent (`docker pull nginx:alpine`)
