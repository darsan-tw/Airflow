#!/bin/bash

# Directory containing JAR files
JARS_DIR="/home/airflow/.local/lib/python3.8/site-packages/pyspark/jars"

JARS=$(find "$JARS_DIR" -name '*.jar' | paste -sd ',' -)

# Set PYSPARK_SUBMIT_ARGS to include all JARs
echo "Setting PYSPARK_SUBMIT_ARGS to include all JARs in $JARS_DIR"
export PYSPARK_SUBMIT_ARGS="--jars $JARS pyspark-shell"
