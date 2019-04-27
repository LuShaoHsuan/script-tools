#!/bin/sh
# remove file from gcs
gsutil rm [your blob name]

# push file to gcs
gsutil cp [local file path] [bucket name]

# pull file from gcs
gsutil cp [bucket name] [local file path]

# install python dependencies via command using requirements.txt
gcloud composer environments update [composer env name] --update-pypi-packages-from-file requirements.txt --location us-central1

# set default project
gcloud config set project my-project