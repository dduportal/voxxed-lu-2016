#!/bin/sh

set -e
set -u
set -x

# This code serves only to list expected env variables
echo "== Using SHARED_M2_REPOSITORY=${SHARED_M2_REPOSITORY}"
echo "== Using ARTEFACT_SERVER_URL=${ARTEFACT_SERVER_URL}"

sleep 30

# Then, we configure the artefact server using default credentials
# TODO: add a healtch check against artefact repo. Risk is minimalist since mvn take some time :)
curl -u admin:password -X POST -H "Content-type:application/xml" \
  --data-binary @/artifactory.config.xml \
    "${ARTEFACT_SERVER_URL}/artifactory/api/system/configuration"

curl -u admin:password -X POST -H "Content-Type: application/json" \
  --data '{"action":"repository","repository":"local-cache","path":"'${SHARED_M2_REPOSITORY}'","excludeMetadata":false,"verbose":true}' \
    "${ARTEFACT_SERVER_URL}/artifactory/ui/artifactimport/repository"
