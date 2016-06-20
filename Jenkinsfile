node {
    stage 'Checkout'
    checkout scm

    sh 'git rev-parse --short HEAD > GIT_COMMIT'
    short_commit = readFile('GIT_COMMIT')
    sh 'rm GIT_COMMIT'

    stage 'Build'
    withMaven {
        sh 'mvn clean compile'
    }

    stage 'Unit Tests'
    withMaven {
        sh 'mvn test'
    }
    step([$class: 'JUnitResultArchiver', testResults: 'target/surefire-reports/*.xml'])

    stage 'Integration Tests'
    withMaven {
        sh 'mvn verify'
    }
    step([$class: 'JUnitResultArchiver', testResults: 'target/failsafe-reports/*.xml'])

    dir('target') {
        archive "${pom.getArtifactId()}.${pom.getPackaging()}"
    }

    stash name: 'binary', includes: "target/${pom.getArtifactId()}.${pom.getPackaging()}"
    // dir('src/main/docker') {
    //     stash name: 'dockerfile', includes: 'Dockerfile'
    // }
}

// node('docker') {
//     unstash 'dockerfile'
//     unstash 'binary'
//
//     stage 'Building Docker Img'
//     image = docker.build("alecharp/simpleapp:${short_commit}")
//
//     container = image.run('-P')
//     sh "docker port ${container.id} 8080 > DOCKER_IP"
//     ip = readFile('DOCKER_IP').trim()
//     sh 'rm DOCKER_IP'
// }

// stage 'Container validation'
// try {
//     input message: "http://${ip}. Is it ok?", ok: 'Publish it'
// } finally {
//     node('docker') { container.stop() }
// }
//
// node('docker') {
//     stage 'Publishing Docker Img'
//     // requirement: local docker registry available on port 5000
//     docker.withRegistry('http://localhost:5000', '') {
//         image.push('latest')
//     }
// }

// Custom step
def withMaven(def body) {
    // def javaHome = tool name: 'oracle-8u77', type: 'hudson.model.JDK'
    def mavenHome = tool name: 'maven-3.3.9', type: 'hudson.tasks.Maven$MavenInstallation'

    withEnv(["PATH+MAVEN=${mavenHome}/bin"]) {
        body.call()
    }
}
