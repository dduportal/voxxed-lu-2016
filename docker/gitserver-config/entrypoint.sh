#!/bin/sh
#
# This script will auto-configure a "blank" app stack for the demo

set -e
set -u
set -x

GITSERVER_ADDR=gitserver
GITSERVER_PORT=3000
GITSERVER_URL="http://${GITSERVER_ADDR}:${GITSERVER_PORT}"
GITSERVER_API_URL="${GITSERVER_URL}/api/v1"
FIRST_USER=jenkins
LOCAL_DATA_MOUNTPOINT=/current_data
REPO_NAME=demoapp
REPO_GIT_URL="git@${GITSERVER_ADDR}:${FIRST_USER}/${REPO_NAME}.git"
SSH_KEY_PATTERN=/current_data/sshkeys/demo_insecure_key

### First we wait a bit to avoid race concurency
sleep 2

echo "== Configuring Git Server"

# We create the first user
curl -X POST \
  -F "user_name=${FIRST_USER}" \
  -F "email=${FIRST_USER}@localhost.com" \
  -F "password=${FIRST_USER}" \
  -F "retype=${FIRST_USER}" \
  ${GITSERVER_URL}/user/sign_up

# Create initial repository
curl -X POST \
  -F "uid=1" \
  -F "name=${REPO_NAME}" \
  -u "jenkins:jenkins" \
  ${GITSERVER_API_URL}/user/repos

# Load SSH keys to avoid password laters
curl -X POST \
  -F "title=insecure_demo_key" \
  -F "key=$(cat ${SSH_KEY_PATTERN}.pub)" \
  -u "jenkins:jenkins" \
  ${GITSERVER_API_URL}/admin/users/${FIRST_USER}/keys

# Copying the SSH Config to avoid annoyances
mkdir -p /root/.ssh
cat <<EOF >/root/.ssh/config
Host ${GITSERVER_ADDR}
    HostName ${GITSERVER_ADDR}
    User git
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    IdentityFile ${SSH_KEY_PATTERN}
EOF

# Load our local repository inside the newly created one
git clone --bare ${LOCAL_DATA_MOUNTPOINT} /tmp/${REPO_NAME}
( cd /tmp/${REPO_NAME} \
    && git push --mirror "${REPO_GIT_URL}"
)

echo "== Configuration done."
exit 0
