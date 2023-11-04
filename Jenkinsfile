pipeline {
    agent any

    stages {
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

        stage('SONARQUBE') {
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
                      <title>Erreur dans le pipeline</title>
                    </head>
                    <body>
                      <div class="container" style="width: 600px; margin: 0 auto;">
                        <h1 style="font-size: 24px; margin-top: 0;">Erreur dans le pipeline</h1>
                        <p style="margin-bottom: 10px;">
                          Une erreur s\'est produite dans le pipeline. Voici les informations sur l\'erreur :
                        </p>
                        <ul style="list-style-type: none; margin: 0; padding: 0;">
                          <li>
                            <strong style="font-weight: bold;">Erreur :</strong> {{ erreur }}
                          </li>
                          <li>
                            <strong style="font-weight: bold;">Source :</strong> {{ source }}
                          </li>
                          <li>
                            <strong style="font-weight: bold;">Date :</strong> {{ date }}
                          </li>
                        </ul>
                        <p style="margin-bottom: 10px;">
                          Pour plus d\'informations, veuillez consulter les logs du pipeline.
                        </p>
                      </div>
                    </body>
                    </html>''', recipientProviders: [contributor()], subject: 'Jenkins email sending test', to: 'bensidi.elhoudhaiffouddine@esprit.tn'
              }
        }
    }
}
