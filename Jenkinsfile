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


node {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */
        echo 'cloning repository'

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("maduflavins/devops")
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * This runs only a single dummy test inside the image. */

        app.inside {
            sh 'npm test'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
         echo 'Pushing repo'
         sh "./deploy.sh"
//         docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
//             app.push("${env.BUILD_NUMBER}")
//             app.push("latest")
//         }
    }
}



