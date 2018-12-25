#!/bin/sh

# show default project
default_project=`gcloud info | grep 'project' | tr -d '[]' | awk '/project:/ {print $2}'`

# switch project
echo "default_project: $default_project"

# show parameter mapping
echo "source project: $1"
echo "source dataset: $2"
echo "target project: $3"
echo "target dataset: $4"

# confirm source/target parameter
while true; do
    read -p "Please confirm source and target: (y/n) " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# set source and target dataset var
export SOURCE_DATASET="$1:$2"
export DEST_PREFIX="$3:$4."

# find dataset
bq ls | grep -w "$4" > /dev/null

# check if target dataset exists; if not, create it.
if [[ $? -eq 0 ]]; then
	echo "target dataset exists."
else
	echo "target dataset not exists."
	# create target dataset
	bq --location=US mk --dataset "$3:$4"
fi

# clone source dataset recursively to target dataset
echo "------------------------------------ cloning start ------------------------------------"
for f in `bq ls $SOURCE_DATASET | grep TABLE | awk '{print $1}'`
do
  export CLONE_CMD="bq --nosync cp $SOURCE_DATASET.$f $DEST_PREFIX$f"
  echo $CLONE_CMD
  echo `$CLONE_CMD`
done
echo "-------------------------------------- finished ---------------------------------------"
echo "Log file in $LOG_FILE_PATH"