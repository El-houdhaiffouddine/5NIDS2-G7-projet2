pipeline {

    agent any

    stages {

        stage('CHECK-GIT-SECRETS') {
            steps {
                echo '******** PHASE D\'ANALYSE DU REPOSITORY GIT A LA RECHERCHE DES IDENTIFIANTS ********'
                sh 'docker pull gesellix/trufflehog'
                sh 'docker run -t gesellix/trufflehog --json https://github.com/El-houdhaiffouddine/5NIDS2-G7-projet2.git > git-secret-result.txt'

            }
        }

        stage('GIT') {
            steps {
                echo '******** PHASE DE RECUPERATION DU CODE SUR GITHUB ********'
                sh 'git config --global credential.helper store'
                sh 'git clone https://github.com/El-houdhaiffouddine/5NIDS2-G7-projet2.git'
            }
        }

        stage('MAVEN BUILD') {
             steps {
                 echo '******** PHASE DE NETTOYAGE, DE COMPILATION ET DE PACKAGE AVEC L\'OUTIL MAVEN ********'
                 sh 'mvn clean package'
             }
        }

        stage('OWASP DEPENDANCY-CHECK') {
             steps {
                  echo '******** PHASE D\'ANALYSE DES COMPOSANTS DE L\'APPLICATION A LA RECHCERCHE DE VULNERABILITES ********'
                  dependencyCheck additionalArguments: '--format HTML', odcInstallation: 'dp-check'
             }

        }

        stage('SAST WITH SONARQUBE') {
              steps {
                  echo '******** PHASE DE SCAN DU CODE POUR RECHERCHER LES VULNERABILITES ET LES BUGS AVEC SONARQUBE ********'
                  sh 'mvn sonar:sonar -Dsonar.login=squ_7d0fea97567ebed576ed2e7fd0ee3ca24cab5ed1'
              }
        }

        stage('NEXUS') {
              steps {
                   echo '******** PHASE D\'ENVOIE DES ARTIFACTS DANS Sonatype Nexus Repository Manager ********'
                   sh 'mvn deploy'
              }
        }

        stage('DOCKER IMAGE') {
              steps {
                   echo '******** PHASE DE GENERATION DE NOTRE IMAGE DOCKER POUR LE DEPLOIEMENT DE NOTRE APPLICATION SPRING BOOT AVEC DOCKER ********'
                   sh 'docker build -t elhoudhaiffouddinebensidi-5nids2-g7-projet2:1.0.0 .'
              }
        }

        stage('DOCKER HUB') {
              steps {
                   echo '******** PHASE DE DEPOT DE NOTRE IMAGE DANS LE REPOSITORY PUBLIQUE DOCKER HUB ********'
                   sh 'docker login -u b2ben -p elhouD@#1998'
                   sh 'docker tag elhoudhaiffouddinebensidi-5nids2-g7-projet2:1.0.0 b2ben/elhoudhaiffouddinebensidi-5nids2-g7-projet2:1.0.0'
                   sh 'docker push b2ben/elhoudhaiffouddinebensidi-5nids2-g7-projet2:1.0.0'
              }
        }

        stage('DOCKER-COMPOSE') {
              steps {
                   echo '******** PHASE DE DEPLOIEMENT DE NOTRE SOLUTION SUR L\'ENVIRONNEMENT D\'EXECUTION AVEC DOCKER-COMPOSE ********'
                   sh 'docker volume create kaddemdatabase'
                   sh 'docker volume create kaddemdb'
                   sh 'docker-compose up -d'
              }
        }

        stage('DAST WITH OWASP ZAP') {
              steps {
                    echo '******** PHASE DE RECHERCHE DES VULNERABILITES DYNAMIQUEMENT AVEC OWASP ZAP ********'
                    sh 'docker pull owasp/zap2docker-stable'
                    sh 'docker run -t ghcr.io/zaproxy/zaproxy:stable zap-full-scan.py -t http://192.168.1.189:8084/kaddem > dast-report.txt'
              }
        }

        stage('GRAFANA') {
              steps {
                    //shell(command: 'nohup ./prometheus &', workingDirectory: '/opt/prometheus-2.48.0-rc.2.linux-amd64')
                    //shell(command: 'nohup ./grafana server &', workingDirectory: '/opt/grafana-10.2.0/bin')
                    sh '/opt/prometheus-2.48.0-rc.2.linux-amd64/prometheus --config.file=/opt/prometheus-2.48.0-rc.2.linux-amd64/prometheus.yml &'
                    sh '/opt/grafana-10.2.0/bin/grafana server --homepath=/opt/grafana-10.2.0 &'
              }
        }

        stage('MAIL') {
              steps {
                    emailext body: '''<!DOCTYPE html>
                    <html lang="fr">
                    <head>
                        <meta charset="UTF-8">
                        <title>Résultat du pipeline Jenkins</title>
                        <style>
                            body {
                                font-family: sans-serif;
                                font-size: 16px;
                                color: #333;
                                background-color: #fff;
                            }

                            h1 {
                                font-size: 24px;
                                margin-top: 0;
                            }

                            p {
                                margin-bottom: 10px;
                            }

                            img {
                                border: 2px solid #ff0000;
                                border-radius: 5px;
                            }
                            ul {
                                list-style-type: circle;
                                list-style-position: inside;
                                margin: 0;
                                padding: 0;
                            }

                            li {
                                margin-bottom: 10px;
                                font-family: sans-serif;
                                font-size: 16px;
                            }

                            .container {
                                width: 600px;
                                margin: 0 auto;
                            }

                            .header {
                                background-color: #000;
                                color: #fff;
                                padding: 20px;
                            }

                            .content {
                                padding: 20px;
                            }

                            .footer {
                                background-color: #f0f0f0;
                                padding: 20px;
                            }
                        </style>
                    </head>
                    <body>
                    <div class="container">
                        <header>
                            <img src="https://wiki.jenkins-ci.org/JENKINS/attachments/2916393/57409619.png" alt="Jenkins Logo">
                            <h1 style="font-size: 24px; margin-top: 0; color: blueviolet; ">$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS</h1>
                        </header>
                        <content>
                            <p>Voici les détails obtenus après l\'exécution du Pipeline Jenkins:</p>
                            <ul style="list-style-type: none; margin: 0; padding: 0;">
                                <li>
                                    Projet :<mark style="color: blue;">$JOB_NAME</mark>
                                </li>
                                <li>
                                    Source :<mark style="color: blue;">$BUILD_URL</mark>
                                </li>
                                <li>
                                    Résultat(s):<mark style="color: red;">$BUILD_LOG</mark>
                                </li>
                            </ul>
                        </content>
                        <footer>
                            <p>Copyright © 2023. BEN SIDI EL-HOUDHAIFFOUDDINE Cybersecurity Engineering Student.</p>
                        </footer>
                    </div>
                    </body>
                    </html>''', mimeType: 'text/html', subject: 'Objet: Résultat d\'exécution du Pipeline Jenkins pour le projet DevOps', to: 'bensidi.elhoudhaiffouddine@esprit.tn'
              }
        }
    }
}
