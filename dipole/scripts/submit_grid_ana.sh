#!/bin/bash

# This script submit analysis jobs using jobsub_submit command to the Fermilab grid cluster system.

RUN_NUM=2
NSUBRUNS=100
# Set the base directory
APP_DIR="/exp/dune/app/users/wyjang"
BASE_DIR="$APP_DIR/dune/mirage/dipole"
ROOT_DATA_DIR="/exp/dune/data/users/wyjang/dune/mirage/dipole/run${RUN_NUM}"
ANALYZER_SCRIPT_FILE="$APP_DIR/share/dune/mirage/dipole/analyzer/mirage_plot.C"

jobsub_submit -N $NSUBRUNS \
    --memory=1000MB \
    --disk=100MB \
    --expected-lifetime=1h \
    --group=dune \
    --resource-provides=usage_model=OPPORTUNISTIC,DEDICATED \
    -f dropbox://$ANALYZER_SCRIPT_FILE \
    file://$APP_DIR/share/dune/mirage/dipole/scripts/agent_ana.sh \
    $RUN_NUM $(basename $ANALYZER_SCRIPT_FILE)
