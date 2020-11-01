node{
    stage('Git CheckOut'){
        git 'https://github.com/Maduflavins/java-devops.git'

    }
    stage("Build Artifact"){
        def MAVEN_HOME = tool name: 'maven', type: 'maven'
        def MAVEN_CMD = "${MAVEN_HOME}/bin/mvn"
        sh "${MAVEN_CMD} clean package"

    }
    stage("Docker Build"){
        sh "docker build -t maduflavins/pivotaldevops ."
    }
    stage("Docker Push"){
        withVault(configuration: [timeout: 60, vaultCredentialId: 'vault-token', vaultUrl: 'http://67.205.152.207:8200'], vaultSecrets: [[path: 'docker/dockerhub', secretValues: [[envVar: 'username', vaultKey: 'USERNAME'], [envVar: 'password', vaultKey: 'PASSWORD']]]]){

            sh "docker login -u $USERNAME -p $PASSWORD"

        }
        sh 'docker push maduflavins/pivotaldevops'
    }
    stage("Rebuild Docker"){
        sh "docker build -t pivotaldevops ."
    }
    stage("Deploy Heroku"){

        withVault(configuration: [timeout: 60, vaultCredentialId: 'vault-token', vaultUrl: 'http://67.205.152.207:8200'], vaultSecrets: [[path: 'heroku/herokulogin', secretValues: [[vaultKey: 'HEROKU_USERNAME'], [vaultKey: 'HEROKU_TOKEN']]]]) {
            sh "docker login --username $HEROKU_USERNAME --password $HEROKU_TOKEN registry.heroku.com"
    }
     sh "docker ps"
     sh "docker container ls"
     sh "docker tag pivotaldevops:latest registry.heroku.com/pivotaldevops/web"
     sh "docker push registry.heroku.com/pivotaldevops/web"
     sh '''
        imageId=$(docker inspect registry.heroku.com/pivotaldevops/web --format={{.Id}})
        payload='{"updates":[{"type":"web","docker_image":"'"$imageId"'"}]}'
        curl -n -X PATCH https://api.heroku.com/apps/pivotaldevops/formation \
        -d "$payload" \
        -H "Content-Type: application/json" \
        -H "Accept: application/vnd.heroku+json; version=3.docker-releases" \
        -H "Authorization: Bearer $GIT_USERNAME"
        '''


    }

}
