// Jenkinsfile — Declarative pipeline for Simple WebApp CI/CD demo
pipeline {
  agent any

  // Environment variables (override in Jenkins configuration or pipeline parameters)
  environment {
    // Set REPO_URL in Jenkins credentials or pipeline environment if you want the pipeline to clone externally
    REPO_URL = ""
    DEPLOY_METHOD = "copy" // options: 'copy' or 'docker'
    IMAGE_NAME = "simple-webapp:latest"
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
          }
        }
      }
    }

    stage('Build') {
      steps {
        echo 'Validating folder structure and required files...'
        // validate.sh will exit non-zero if files are missing
        sh './validate.sh'
      }
    }

    stage('Test') {
      steps {
        echo 'Running simple tests (file existence) — validate.sh'
        sh './validate.sh'
      }
    }

    stage('Deploy') {
      steps {
        script {
          if (env.DEPLOY_METHOD == 'docker') {
            echo "Building Docker image ${env.IMAGE_NAME} and running container..."
            sh 'docker build -t ${IMAGE_NAME} .'
            sh 'docker rm -f simple-web || true'
            sh 'docker run -d --name simple-web -p 8080:80 ${IMAGE_NAME}'
          } else {
            echo 'Deploy method: copy — running deploy.sh (may require sudo)'
            sh 'chmod +x deploy.sh || true'
            sh './deploy.sh'
          }
        }
      }
    }
  }

  post {
    success {
      echo 'Pipeline completed successfully.'
      // Example: send email on success (requires email configured in Jenkins)
      // emailext subject: "Build Successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Good news!"
    }
    failure {
      echo 'Pipeline failed. Inspect logs and fix the issue.'
      // Optionally send failure notification
      // emailext subject: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Something went wrong."
    }
  }
}
