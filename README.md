# Voxxed Luxembourg 2016: Jenkins 2.0 et Pipeline-as-code: Que se passe-t-il ?

This repository contains the pipeline demo of my Voxxed 2016 talk.

Slides are here: http://fr.slideshare.net/legrimpeur/voxxed-luxembourd-2016-jenkins-20-et-pipeline-as-code

## Why ?

Goal is to demonstrate a complete Pipeline-as-code concept with Jenkins 2.x,
for a Java web-application, with Docker output.

## What ?

The techs are:
* Jenkins 2.0 of course
* Docker and Docker-Compose for starting the infrastructure and trying the
final artefact
* Gogs for storing local version of the git repository
* JFrog's Artifactory for offline dependency resolution (Gods of Demo !)
* A local Docker registry for delivering the final artefact
* Maven 3 + OpenJDK 8 for building and running the application
* DropWizard Framework for the application's backend
* AngularJS for the application's frontend

## How ?

* Start a Docker machin with 2 CPUs and 4 Gb of RAM
* Install Docker-compose where oyu have the git cloned repository.
* From the root of repository:
```bash
docker-compose up -d
```
* Take a coffee (time for offlining)
* Then:
  - Gogs: http://<Docker IP>:3000
  - Jenkins: http://<Docker IP>:8080
  - Artifactory: http://<Docker IP>:8081
* Inside Jenkins, create a new "MultiBranch" pipeline job, add the Gogs repository and "Let it Go©"
