// pipeline{
// agent{ docker { image 'maven:3.3.3'}}
// stages{
//
// stage("checkout project"){
//     steps {
//         echo 'checkouting project'
//         checkout scm
//
//     }
//
// }
// stage("check env"){
//     steps{
//         echo 'checking environment'
//         sh "mvn -v"
//         sh "java -version"
//     }
// }
// stage("test"){
// echo 'running test'
// sh "mvn test"
//
// }
// stage("deploy"){
//     when{
//         expression{
//             BRANCH_NAME == "Master"
//         }
//     }
//     step{
//         echo 'deploying application'
//         sh "mvn package"
//     }
// }
// stage("report"){
//     echo 'reporting...'
//     step([$class: 'JunitResultArchiever', testResults: '**/target/surefire-reports/TEST-*.xml'])
// }
// stage("Artifact"){
//     echo 'Artifact collecting...'
//     step([$class: 'ArtifactArchiver', artifacts: '**/target/*.jar', fingerprint: true])
//
// }
// }
// }


// node {
//     def app
//
//     stage('Clone repository') {
//         /* Let's make sure we have the repository cloned to our workspace */
//         echo 'cloning repository'
//
//         checkout scm
//     }
//
//     stage('Build image') {
//         /* This builds the actual image; synonymous to
//          * docker build on the command line */
//
//         app = docker.build("maduflavins/devops")
//     }
//
//     stage('Test image') {
//         /* Ideally, we would run a test framework against our image.
//          * This runs only a single dummy test inside the image. */
//
//         app.inside {
//             sh 'mvn test'
//         }
//     }
//
//     stage('Push image') {
//         /* Finally, we'll push the image with two tags:
//          * First, the incremental build number from Jenkins
//          * Second, the 'latest' tag.
//          * Pushing multiple tags is cheap, as all the layers are reused. */
//          echo 'Pushing repo'
//          sh "./deploy.sh"
// //         docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
// //             app.push("${env.BUILD_NUMBER}")
// //             app.push("latest")
// //         }
//     }
// }
//
//


#!groovy

pipeline {

  agent any

  environment {
    git_commit_message = ''
    git_commit_diff = ''
    git_commit_author = ''
    git_commit_author_name = ''
    git_commit_author_email = ''
  }

  stages {

    // Build
    stage('Build') {
      agent {
        label 'node'
      }
      steps {
        deleteDir()
        checkout scm
      }
    }

    // Static Code Analysis
    stage('Static Code Analysis') {
      agent {
        label 'node'
      }
      steps {
        deleteDir()
        checkout scm
        sh "echo 'Run Static Code Analysis'"
      }
    }

    // Unit Tests
    stage('Unit Tests') {
      agent {
        label 'node'
      }
      steps {
        deleteDir()
        checkout scm
        sh "echo 'Run Unit Tests'"
        sh "mvn test"
      }
    }

    // Acceptance Tests
    stage('Acceptance Tests') {
      agent {
        label 'node'
      }
      steps {
        deleteDir()
        checkout scm
        sh "echo 'Running Acceptance Tests'"
      }
    }

  }
  post {
    success {
      sh "echo 'Send mail on success'"
      // mail to:"me@example.com", subject:"SUCCESS: ${currentBuild.fullDisplayName}", body: "Yay, we passed."
    }
    failure {
      sh "echo 'Send mail on failure'"
      // mail to:"me@example.com", subject:"FAILURE: ${currentBuild.fullDisplayName}", body: "Boo, we failed."
    }
  }
}

