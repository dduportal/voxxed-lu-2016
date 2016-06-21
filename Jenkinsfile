
node('maven3-jdk8') {
  stage 'Checkout'
  checkout scm

  sh 'git rev-parse --short HEAD > GIT_COMMIT'
  short_commit = readFile('GIT_COMMIT').trim()
  def pom = readMavenPom file:'pom.xml'
  sh 'rm GIT_COMMIT'

  stage 'Build'
  sh 'mvn clean compile'

  stage 'Unit Tests'
  sh 'mvn test'
  step([$class: 'JUnitResultArchiver', testResults: 'target/surefire-reports/*.xml'])

  stage 'Integration Tests'
  sh 'mvn verify'
  step([$class: 'JUnitResultArchiver', testResults: 'target/failsafe-reports/*.xml'])

  def artefactName = "${pom.getArtifactId()}.${pom.getPackaging()}"
  archive "target/${artefactName}"

  stash name: 'binary', includes: "target/${artefactName}"
  stash name: 'config', includes: "hello-world.yml"
  stash name: 'dockerfile', includes: "Dockerfile"

}

node('docker') {
  unstash 'dockerfile'
  unstash 'config'
  unstash 'binary'

  stage 'Building Docker Img'
  image = docker.build("voxxed2016lu/demoapp:${short_commit}")

  stage 'Launching Docker image for manual validation'
  container = image.run('-P')
  sh "docker port ${container.id} 8080 | cut -d':' -f2 > EXPOSED_PORT"
  exposed_port = readFile('EXPOSED_PORT').trim()
  sh 'rm EXPOSED_PORT'
}

try {
  input message: "http://localhost:${exposed_port}. Is it ok?", ok: 'Publish it'
} finally {
  node('docker') { container.stop() }
}

node('docker') {
  stage 'Publishing Docker Img'
  docker.withRegistry('http://localhost:5000', '') {
    image.push('latest')
  }
}
