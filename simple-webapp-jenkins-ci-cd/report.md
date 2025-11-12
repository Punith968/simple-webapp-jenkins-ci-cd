# Case Study: CI/CD Pipeline for a Simple Web App using Jenkins

Overview
--------
This case study demonstrates a minimal end-to-end continuous integration and delivery pipeline for a static web application. The repository contains the source for a small landing page and all artifacts required to build, test, and deploy it using Jenkins.

Objectives
- Show a clear, reproducible pipeline for static web assets.
- Demonstrate validation steps to catch missing files early.
- Provide both direct file-copy deployment and containerized deployment options.

Workflow
--------
1. Checkout: The pipeline pulls source from the repository (main branch) or uses the workspace when `REPO_URL` is not provided.
2. Build: Run simple validation to ensure the repository contains the required files (`index.html`, `styles.css`, `script.js`). This prevents wasted work on incomplete check-ins.
3. Test: Re-run validation or more advanced checks (linting, unit tests, snapshot tests) if present.
4. Deploy: Two options supported:
   - Copy deployment: simple copy to `/var/www/html` and service restart (quick for VMs with SSH access).
   - Docker deployment: build a Docker image with nginx and run the container (portable & reproducible).
5. Post: Provide success/failure messaging and hooks for notifications.

Advantages
- Simplicity: small codebase that demonstrates major CI/CD concepts.
- Flexibility: supports both VM-based and containerized deploys.
- Reproducibility: Dockerfile ensures identical runtime for served static files.

Limitations & Next steps
- Security: `deploy.sh` uses `sudo` — production pipelines should use dedicated deployment agents or orchestrators.
- Tests: currently limited to file-existence checks. Add automated UI tests with Playwright/Puppeteer and integrate test reports in Jenkins.
- Registry: extend pipeline to push Docker images to a registry and use image tags based on build numbers.

Conclusion
This demo provides a compact, real-world starting place for teaching and building CI/CD pipelines with Jenkins. It balances minimalism (easy to grasp and run locally) with realistic options (file-copy deploy vs container deploy).
