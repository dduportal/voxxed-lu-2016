#!/bin/sh

set -e
set -u
set -x

JENKINS_SLAVE_JAR="${JENKINS_HOME}/slave.jar"
JENKINS_CLI_JAR="${JENKINS_HOME}/jenkins-cli.jar"
JENKINS_CLI_BASE_CMD="java -jar ${JENKINS_CLI_JAR} -s ${JENKINS_URL}"
NODE_XML_DEF="/slave-definition.xml"

# Download the Jenkins utils JARs for CLI and slave
curl -L -o "${JENKINS_SLAVE_JAR}" "${JENKINS_URL}/jnlpJars/slave.jar"
curl -L -o "${JENKINS_CLI_JAR}" "${JENKINS_URL}/jnlpJars/jenkins-cli.jar"

# Create node within Jenkins if not defined, with labels and name replaced
${JENKINS_CLI_BASE_CMD} get-node ${NODE_NAME} >/dev/null ||
  cat "${NODE_XML_DEF}" | sed "s/NODE_NAME/$NODE_NAME/g" |
    sed "s/NODE_LABELS/$NODE_LABELS/g" |
      ${JENKINS_CLI_BASE_CMD} create-node ${NODE_NAME}

# Start the agent
java -jar "${JENKINS_SLAVE_JAR}" -jnlpUrl "${JENKINS_URL}/computer/${NODE_NAME}/slave-agent.jnlp"
