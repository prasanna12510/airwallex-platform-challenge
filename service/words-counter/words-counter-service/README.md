# Deploying a words-counter API using Flask server on Kubernetes

This repo contains code that
1) Deploys a Flask API to count number of occurences of html page

## Prerequisites
1. Have `Docker` and the `Kubernetes CLI` (`kubectl`) installed together with `EKS`

## Getting started
setup REPOSITORY_ACCESS_USER and REPOSITORY_ACCESS_TOKEN in github secrets

1. git workflow will build image based on the commit_id on push/changes in service directory
2. Deploy `Flask API` in deploy folder: `skaffold deploy -t <version:latest>`
