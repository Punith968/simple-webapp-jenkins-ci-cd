# Complete Deployment Guide — simple-webapp-jenkins-ci-cd

## Current Status
✅ All project files created  
✅ Git repository initialized  
🔄 Jenkinsfile moved to project root (waiting for push to complete)  
⏳ Jenkins pipeline needs to be triggered after push completes

---

## Quick Command Reference

### Git Commands (via WSL from PowerShell)
```powershell
# Check status
wsl bash -c "cd /mnt/c/Users/punit/OneDrive/Desktop/DEVOPS/simple-webapp-jenkins-ci-cd && git status"

# Add and commit
wsl bash -c "cd /mnt/c/Users/punit/OneDrive/Desktop/DEVOPS/simple-webapp-jenkins-ci-cd && git add . && git commit -m 'Your message'"

# Push to GitHub
wsl bash -c "cd /mnt/c/Users/punit/OneDrive/Desktop/DEVOPS/simple-webapp-jenkins-ci-cd && git push origin main"
```

### Alternative: Start WSL bash session
```powershell
wsl
cd /mnt/c/Users/punit/OneDrive/Desktop/DEVOPS/simple-webapp-jenkins-ci-cd
git status
git push origin main
```

---

## Step-by-Step Deployment

### 1. Complete Git Push (DO THIS NOW)

In your terminal where it's asking for credentials:
1. Enter your GitHub username: `Punith968`
2. For password, use a **Personal Access Token** (not your password):
   - Create token: https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Scopes: Check `repo` (full control)
   - Copy the token and paste it when prompted

### 2. Verify Files on GitHub

Open: https://github.com/Punith968/simple-webapp-jenkins-ci-cd

Confirm these files are present:
- ✅ Jenkinsfile (in root)
- ✅ index.html
- ✅ styles.css
- ✅ script.js
- ✅ Dockerfile
- ✅ docker-compose.yml
- ✅ deploy.sh
- ✅ validate.sh
- ✅ README.md
- ✅ report.md
- ✅ .gitignore

### 3. Configure Jenkins Pipeline Job

#### A. Access Jenkins
- URL: http://localhost:8080 (or your Jenkins server)
- Login with your credentials

#### B. Create/Update Pipeline Job
1. Go to "simple-webapp-pipeline" (or create new if doesn't exist)
2. Click **Configure**
3. Under **Pipeline** section:
   - Definition: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository URL: `https://github.com/Punith968/simple-webapp-jenkins-ci-cd.git`
   - Credentials: Add GitHub credentials if repo is private
   - Branch Specifier: `*/main`
   - Script Path: `Jenkinsfile`
4. Click **Save**

#### C. Add GitHub Credentials (if needed)
1. Manage Jenkins → Credentials → System → Global credentials
2. Add Credentials:
   - Kind: Username with password
   - Username: Your GitHub username
   - Password: Personal Access Token (same one from step 1)
   - ID: `github-credentials`
3. Go back to pipeline config and select this credential

### 4. Run the Pipeline

1. Go to pipeline job page
2. Click **Build Now**
3. Click on the build number (e.g., #4)
4. Click **Console Output** to watch progress

Expected stages:
```
✓ Checkout   — Clone repo from GitHub
✓ Build      — Run validate.sh
✓ Test       — Verify files exist
✓ Deploy     — Copy files or build Docker image
✓ Post       — Success/failure notification
```

### 5. Troubleshooting Common Issues

#### Issue: "validate.sh: Permission denied"
**Solution**: Make scripts executable in git
```bash
cd /mnt/c/Users/punit/OneDrive/Desktop/DEVOPS/simple-webapp-jenkins-ci-cd
chmod +x validate.sh deploy.sh
git add validate.sh deploy.sh
git commit -m "Make scripts executable"
git push origin main
```

Or add to Jenkinsfile before running scripts:
```groovy
sh 'chmod +x validate.sh deploy.sh'
```

#### Issue: "docker: command not found" in Jenkins
**Solution**: Install Docker on Jenkins agent or use Jenkins with Docker support
- If using docker-compose.yml from this project, Jenkins needs Docker socket access
- Ensure Jenkins container has Docker CLI installed

#### Issue: "sudo: no tty present" when running deploy.sh
**Solution**: 
- Option 1: Configure Jenkins agent with passwordless sudo for specific commands
- Option 2: Use Docker deployment instead (set `DEPLOY_METHOD=docker`)
- Option 3: Use SSH to deploy to remote server

#### Issue: Branch not found
**Solution**: Check your default branch name
```bash
git branch
# If shows 'master', rename to 'main':
git branch -M main
git push -u origin main
```

---

## Deployment Methods

### Method 1: Docker Deployment (Recommended)

This builds a Docker image and runs it:

1. Set environment in Jenkins job or Jenkinsfile:
   ```groovy
   environment {
     DEPLOY_METHOD = "docker"
     IMAGE_NAME = "simple-webapp:latest"
   }
   ```

2. Ensure Jenkins has Docker access:
   - Jenkins container needs Docker CLI
   - Docker socket mounted: `/var/run/docker.sock:/var/run/docker.sock`

3. Build and run:
   ```bash
   docker build -t simple-webapp:latest .
   docker run -d --name simple-web -p 8080:80 simple-webapp:latest
   ```

4. Access: http://localhost:8080

### Method 2: Copy Deployment (Linux Server)

This copies files to `/var/www/html`:

1. Set environment:
   ```groovy
   environment {
     DEPLOY_METHOD = "copy"
   }
   ```

2. Requirements:
   - Jenkins agent must have:
     - Sudo access (or run as www-data user)
     - Access to target web server directory
   - Nginx or Apache installed on target

3. Deploy:
   ```bash
   sudo ./deploy.sh
   ```

4. Access: http://your-server/

### Method 3: SSH Remote Deployment

Deploy to a separate server via SSH:

1. Add SSH stage to Jenkinsfile:
   ```groovy
   stage('Deploy to Server') {
     steps {
       sshagent(['your-ssh-credentials-id']) {
         sh '''
           scp -r ./* user@server:/path/to/webapp/
           ssh user@server "cd /path/to/webapp && sudo ./deploy.sh"
         '''
       }
     }
   }
   ```

2. Add SSH credentials in Jenkins:
   - Manage Jenkins → Credentials → Add SSH key

---

## Local Testing (Without Jenkins)

### Test 1: Open in Browser
```powershell
Start-Process 'c:\Users\punit\OneDrive\Desktop\DEVOPS\simple-webapp-jenkins-ci-cd\index.html'
```

### Test 2: Validate Files
```bash
cd /mnt/c/Users/punit/OneDrive/Desktop/DEVOPS/simple-webapp-jenkins-ci-cd
chmod +x validate.sh
./validate.sh
```

Expected output: `All required files present: index.html styles.css script.js`

### Test 3: Docker Build & Run
```bash
cd /mnt/c/Users/punit/OneDrive/Desktop/DEVOPS/simple-webapp-jenkins-ci-cd
docker build -t simple-webapp:local .
docker run -d --name test-webapp -p 8081:80 simple-webapp:local
```

Open: http://localhost:8081

Stop:
```bash
docker rm -f test-webapp
```

### Test 4: Docker Compose (Jenkins + WebApp)
```bash
cd /mnt/c/Users/punit/OneDrive/Desktop/DEVOPS/simple-webapp-jenkins-ci-cd
docker-compose up --build
```

- Jenkins: http://localhost:8080
- WebApp: http://localhost:8081

Stop:
```bash
docker-compose down
```

---

## Next Steps After Successful Pipeline

1. **Add Automated Tests**
   - Create tests with Puppeteer or Playwright
   - Add test stage to Jenkinsfile
   - Generate test reports

2. **Improve Deployment**
   - Push Docker images to Docker Hub or private registry
   - Use Kubernetes for orchestration
   - Implement blue-green deployment

3. **Add Monitoring**
   - Jenkins build notifications (email, Slack)
   - Application monitoring (uptime checks)
   - Log aggregation

4. **Security Enhancements**
   - Use Jenkins credentials store for secrets
   - Scan Docker images for vulnerabilities
   - Implement least-privilege access

---

## Useful Links

- GitHub Repo: https://github.com/Punith968/simple-webapp-jenkins-ci-cd
- Jenkins Docs: https://www.jenkins.io/doc/
- Docker Hub: https://hub.docker.com/
- Create GitHub Token: https://github.com/settings/tokens

---

## Contact & Support

For issues or questions about this deployment:
1. Check Console Output in Jenkins for error details
2. Review this guide's troubleshooting section
3. Verify all files are present on GitHub
4. Ensure Docker/Jenkins have proper permissions

Good luck with your DevOps case study! 🚀
