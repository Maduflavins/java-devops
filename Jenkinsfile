pipeline{
agent{ docker { image 'maven:3.3.3'}}
stages{

stage("checkout project"){
    steps {
        echo 'checkouting project'
        checkout scm

    }

}
stage("check env"){
    steps{
        echo 'checking environment'
        sh "mvn -v"
        sh "java -version"
    }
}
stage("test"){
echo 'running test'
sh "mvn test"

}
stage("deploy"){
    when{
        expression{
            BRANCH_NAME == "Master"
        }
    }
    step{
        echo 'deploying application'
        sh "mvn package"
    }
}
stage("report"){
    echo 'reporting...'
    step([$class: 'JunitResultArchiever', testResults: '**/target/surefire-reports/TEST-*.xml'])
}
stage("Artifact"){
    echo 'Artifact collecting...'
    step([$class: 'ArtifactArchiver', artifacts: '**/target/*.jar', fingerprint: true])

}
}
}
