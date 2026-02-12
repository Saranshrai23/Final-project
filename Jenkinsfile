pipeline {
  agent any

  environment {
    AWS_REGION      = "ap-south-1"
    AWS_ACCOUNT_ID  = "659111892140"
    REPO_NAME       = "two-tier-app"
    ECR_URI         = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}"
    DEBIAN_FRONTEND = "noninteractive"
  }

  stages {

    stage('Checkout') {
      steps {
        deleteDir()
        git url: "https://github.com/Saranshrai23/Final-project.git", branch: "master"

        sh '''
          echo "Workspace: $(pwd)"
          ls -la
          find . -maxdepth 3 -name "Dockerfile*" -print
        '''
      }
    }

    stage('Run Ansible Playbook') {
      steps {
        sh '''
          if ! command -v ansible-playbook >/dev/null 2>&1; then
            echo "Installing Ansible..."
            sudo apt-get update -y
            sudo apt-get install -y ansible
          fi

          which ansible-playbook
          ansible-playbook --version

          cd ansible
          ansible-playbook -i inventory.ini playbook.yml -l local -b

          echo "Verify tools:"
          terraform version
          aws --version
          docker --version
        '''
      }
    }

    stage('Build Image') {
      steps {
        sh "docker build -t ${REPO_NAME}:latest ."
      }
    }

    stage('Create ECR Repo') {
      steps {
        sh "aws ecr create-repository --repository-name ${REPO_NAME} --region ${AWS_REGION} || true"
      }
    }

    stage('Login to ECR') {
      steps {
        sh """
          aws ecr get-login-password --region ${AWS_REGION} | \
          docker login --username AWS --password-stdin \
          ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
        """
      }
    }

    stage('Tag Image') {
      steps {
        sh "docker tag ${REPO_NAME}:latest ${ECR_URI}:latest"
      }
    }

    stage('Push Image') {
      steps {
        sh "docker push ${ECR_URI}:latest"
      }
    }

    stage('Build Infrastructure with Terraform') {
      steps {
        dir('final_eks_saransh_terraform/infra') {
          sh '''
            echo "Initializing Terraform..."
            terraform init -input=false

            echo "Planning Terraform..."
            terraform plan -input=false -out=tfplan

            echo "Applying Terraform..."
            terraform apply -input=false -auto-approve tfplan
          '''
        }
      }
    }

  }

  post {
    success {
      echo "✅ Pipeline completed successfully!"
    }
    failure {
      echo "❌ Pipeline failed!"
    }
  }
}
