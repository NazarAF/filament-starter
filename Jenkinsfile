pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'laravel-filament-starter'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/NazarAF/filament-starter.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                }
            }
        }

        stage('Run Laravel Container') {
            steps {
                script {
                    sh """
                    docker run -d -p 8000:8000 --name laravel-container ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} bash -c "php artisan serve --host=0.0.0.0 --port=8000"
                    """
                }
            }
        }

        stage('Run Migrations and Seed') {
            steps {
                script {
                    sh 'docker exec laravel-container php artisan migrate --force'
                    sh 'docker exec laravel-container php artisan db:seed --force'
                }
            }
        }

        stage('Test Application') {
            steps {
                script {
                    sh 'docker exec laravel-container php artisan test'
                }
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    echo "Deploying to production..."
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    sh 'docker stop laravel-container'
                    sh 'docker rm laravel-container'
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up docker containers"
            sh 'docker system prune -f'
        }

        success {
            echo "Pipeline succeeded!"
        }

        failure {
            echo "Pipeline failed!"
        }
    }
}
