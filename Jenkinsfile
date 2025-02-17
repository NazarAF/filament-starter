pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'laravel-filament-starter'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_TAG = "latest"
        MYSQL_CONTAINER = 'laravel-mysql'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/NazarAF/filament-starter.git'
            }
        }

        stage('Run MySQL Container') {
            steps {
                script {
                    sh """
                    docker run -d --name ${MYSQL_CONTAINER} -e MYSQL_DATABASE=laravel -e MYSQL_USER=user -e MYSQL_PASSWORD= -e MYSQL_ROOT_PASSWORD= -p 3306:3306 mysql:8
                    """
                }
            }
        }

        stage('Run Laravel Container') {
            steps {
                script {
                    sh """
                    docker run -d -p 8000:8000 --name laravel-container --link ${MYSQL_CONTAINER}:mysql ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} bash -c "php artisan serve --host=0.0.0.0 --port=8000"
                    """
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
                    sh 'docker stop laravel-container ${MYSQL_CONTAINER}'
                    sh 'docker rm laravel-container ${MYSQL_CONTAINER}'
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
