pipeline {

  agent any

  environment {
    RUN_UNIT_TESTS = 'false'
    DEPLOY_ARTIFACT = 'false'
    ARTIFACT_ID = readMavenPom().getArtifactId()
    ARTIFACT_VERSION = readMavenPom().getVersion()
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  stages {

    stage('Information') {
      steps {
        script {
          def commit = sh(returnStdout: true, script: 'git --no-pager show -s --format=\'%h\'  origin/' + env.BRANCH_NAME).trim()
          def author = sh(returnStdout: true, script: 'git --no-pager show -s --format=\'%an\' origin/' + env.BRANCH_NAME).trim()
          def authorEmail = sh(returnStdout: true, script: 'git --no-pager show -s --format=\'%ae\' origin/' + env.BRANCH_NAME).trim()
          def comment = sh(returnStdout: true, script: 'git --no-pager show -s --format=\'%B\' origin/' + env.BRANCH_NAME).trim()
          echo """
    Branch : ${env.BRANCH_NAME}
    Author : ${author}
    Email : ${authorEmail}
    Commit : ${commit}
    Comment : ${comment}
    ArtifactId : ${ARTIFACT_ID}
    Version : ${ARTIFACT_VERSION}
          """
        }
      }
    }

    stage('Build Package with Tests') {
      when {
        environment name: 'RUN_UNIT_TESTS', value: 'true'
      }
      agent {
        docker {
          image 'maven:3.5.4-jdk-8-alpine'
          args '-v $HOME/.m2:/root/.m2'
        }
      }
      steps {
        configFileProvider([configFile(fileId: 'maven-settings', variable: 'MAVEN_SETTINGS')]) {
          sh 'mvn -B -s ${MAVEN_SETTINGS} clean package'
        }
      }
    }
    stage('Build Package Skip Tests') {
      when {
        not { environment name: 'RUN_UNIT_TESTS', value: 'true' }
      }
      agent {
        docker {
          image 'maven:3.5.4-jdk-8-alpine'
          args '-v $HOME/.m2:/root/.m2'
        }
      }
      steps {
        configFileProvider([configFile(fileId: 'maven-settings', variable: 'MAVEN_SETTINGS')]) {
          sh 'mvn -B -s ${MAVEN_SETTINGS} clean package -DskipTests'
        }
      }
    }

    stage('Deploy Artifact') {
      when {
        environment name: 'DEPLOY_ARTIFACT', value: 'true'
      }
      agent {
        docker {
          image 'maven:3.5.4-jdk-8-alpine'
          args '-v $HOME/.m2:/root/.m2'
          reuseNode true
        }
      }
      steps {
        configFileProvider([configFile(fileId: 'maven-settings', variable: 'MAVEN_SETTINGS')]) {
          sh 'mvn -B -s ${MAVEN_SETTINGS} deploy -DskipTests'
        }
      }
    }

  }

  post {
    success {
      echo "Build ${env.JOB_NAME} #${env.BUILD_NUMBER} status : ${currentBuild.currentResult}.\n${env.BUILD_URL}"
      // TODO send slack
//        slackSend channel: '#jenkins',
//            color: 'good',
//            message: "Build ${env.JOB_NAME} ${env.BUILD_NUMBER} status : ${currentBuild.currentResult}.\n${env.BUILD_URL}",
//            attachments: "",
//            botUser: true
    }
    failure {
      // TODO send mail / slack
      echo "I have not failed. I've just found 10 000 ways that won't work. -Thomas Edison"
      echo "Failure is unimportant. It takes courage to make a fool of yourself. -Charlie Chaplin"
    }
  }

}
