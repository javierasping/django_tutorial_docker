pipeline {
    environment {
        IMAGEN = "javierasping/django_tutorial_ic"
        LOGIN = 'USER_DOCKERHUB'
    }
    agent any
    stages {
        stage("Bajar_imagen") {
            agent {
                docker {
                    image "python:3"
                    args '-u root:root'
                }
            }
            stages {
                stage('Clonar_repo') {
                    steps {
                        git branch:'main',url:'https://github.com/javierasping/django_tutorial_docker.git'
                    }
                }
                stage('Instalar_requeriments') {
                    steps {
                        sh 'pip install -r django_tutorial/requirements.txt'
                    }
                }
                stage('Test')
                {
                    steps {
                        sh 'cd django_tutorial && python manage.py test --settings=django_tutorial.desarollo'
                    }
                }

            }
        }
        stage("Generar_imagen") {
            agent any
            stages {
                stage('Construir_imagen') {
                    steps {
                        script {
                            newApp = docker.build "$IMAGEN:${env.BUILD_NUMBER}"
                        }
                    }
                }
                stage('Subir_imagen') {
                    steps {
                        script {
                            docker.withRegistry( '', LOGIN ) {
                                newApp.push()
                            }
                        }
                    }
                }
                stage('Borrar_imagen') {
                    steps {
                        sh "docker rmi $IMAGEN:${env.BUILD_NUMBER}"
                    }
                }
            }
        }
        stage('SSH') {
            steps {
                sshagent(credentials: ['CLAVE_SSH']) {
                    sh 'ssh -o StrictHostKeyChecking=no javiercruces@atlas.javiercd.es wget https://github.com/javierasping/django_tutorial_docker/blob/main/docker-compose.yaml -O docker-compose.yaml'
                    sh 'ssh -o StrictHostKeyChecking=no javiercruces@atlas.javiercd.es docker-compose up -d --force-recreate'
                }
            }
        }
    }
    post {
        always {
            mail to: 'javierasping@gmail.com',
            subject: "Pipeline IC: ${currentBuild.fullDisplayName}",
            body: "${env.BUILD_URL} has result ${currentBuild.result}"
        }
    }
}

