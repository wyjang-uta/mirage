#!/bin/bash

# parse arguments from jobsub
MAG_FIELD=$1
RUN_NUM=$2
NSUBRUNS=$3

BASE_DATA_DIR="/pnfs/dune/scratch/users/wyjang/dune_mixedpol/dipole"
SEED=$((RUN_NUM * 1000 + PROCESS))
OUTPUT_FILE="result_${RUN_NUM}_${SEED}_${MAG_FIELD}.root"

source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
source /cvmfs/larsoft.opensciencegrid.org/spack-packages/setup-env.sh
spack load expat@2.5.0
spack load geant4@10.6.1
spack load ifdhc@2.8.0
export G4DIR=$(spack location -i geant4@10.6.1)
export Geant4_DIR=$G4DIR/lib64/Geant4-10.6.1
export CMAKE_PREFIX_PATH=$G4DIR:$(spack location -i expat@2.5.0):$CMAKE_PREFIX_PATH
source $G4DIR/bin/geant4.sh

cd ${CONDOR_DIR_INPUT}
chmod +x ./dipole_defocus
./dipole_defocus ./run1.mac $MAG_FIELD $SEED $HOME/$OUTPUT_FILE

if [ -f "$HOME/$OUTPUT_FILE" ]; then
    echo "Transferring $OUTPUT_FILE to $BASE_DATA_DIR..."
    ifdh cp $HOME/$OUTPUT_FILE ${BASE_DATA_DIR}/${OUTPUT_FILE}
else
    echo "Error: Output file $HOME/$OUTPUT_FILE not found!"
    exit 1
fi