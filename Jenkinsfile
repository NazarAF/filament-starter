pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'laravel-filament-starter'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_TAG = 'latest'
        CONTAINER_NAME = 'laravel-filament'
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
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Run Laravel Container') {
            steps {
                script {
                    sh """
                    docker run -d -p 8083:8083 --name ${CONTAINER_NAME} \\
                    ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} \\
                    bash -c "php artisan serve --host=0.0.0.0 --port=8083"
                    """
                }
            }
        }

        stage('Run Migrations and Seed') {
            steps {
                script {
                    sh "docker exec ${CONTAINER_NAME} php artisan migrate:fresh --seed"
                }
            }
        }

        stage('Run Test') {
            steps {
                script {
                    sh "docker exec ${CONTAINER_NAME} php artisan test"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded!'
        }

        failure {
            echo 'Pipeline failed!'
            echo 'Cleaning up Docker containers'
            sh "docker stop ${CONTAINER_NAME} || true"
            sh "docker rm ${CONTAINER_NAME} || true"
            sh 'docker system prune -f'
        }
    }
}
