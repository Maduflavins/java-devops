node {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */
        echo 'building image'
        app = docker.build("maduflavins/javadevops")
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * This runs only a single dummy test inside the image. */

        app.inside {
           echo 'running test'
           sh 'mvn test'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
         echo 'deploying image'
        docker.withRegistry('https://registry.heroku.com', 'heroku-docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}

