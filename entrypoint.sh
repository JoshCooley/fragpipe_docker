#!/usr/bin/env bash

default_options=()

headless_options=(
  --headless
  --config-ionquant "/opt/fragpipe/tools/IonQuant-${IONQUANT_VERSION}/IonQuant-${IONQUANT_VERSION}.jar"
  --config-msfragger "/opt/fragpipe/tools/MSFragger-${MSFRAGGER_VERSION}/MSFragger-${MSFRAGGER_VERSION}.jar"
  --manifest "$MANIFEST_FILE"
  --workflow "$WORKFLOW_FILE"
)

options=("${default_options[@]}")

if [[ -v HEADLESS ]]; then
  options+=("${headless_options[@]}")
fi

exec /opt/fragpipe/bin/fragpipe \
  "${options[@]}"
