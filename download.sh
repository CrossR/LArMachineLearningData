#!/bin/bash

function download() {
  wget --no-check-certificate --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$1' -O- | sed -En 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$1" -O $2 && rm -rf /tmp/cookies.txt
}

function curl_download() {
  curl -L "https://drive.usercontent.google.com/download?id=$1&confirm=xxx" -o $2
}

# Google Drive links have the form https://drive.google.com/file/d/FILEID/view?usp=sharing
# You want the FILEID
# Note: For some reason the above function doesn't work for the files, so you need to set the two &id=FILEID instances in the link

# Parse the command line arguments
# If a path is given, use that, otherwise default to $MY_TEST_AREA
# ./download.sh <experiment> <path>
EXPERIMENT=$1
PANDORA_DIR="$MY_TEST_AREA"
STARTING_DIR=$(pwd)
EXPERIMENTS=("dune" "dunend" "uboone" "sbnd")

# If no experiment is given, or -h is given, print the help message
if [ "$#" -eq 0 ]; then
  echo "Usage: ./download.sh <experiment> <path>"
  echo "Available experiments: ${EXPERIMENTS[*]}"
  echo "If no path is given, the default is \$MY_TEST_AREA"
  exit 1
fi

# If a path is given, use that, otherwise default to $MY_TEST_AREA
if [ "$#" -eq 2 ]; then
  PANDORA_DIR=$2
fi

# Now check that the Pandora directory actually exists
if [ ! -d "$PANDORA_DIR" ]; then
  echo "The Pandora directory does not exist"
  echo "Either set \$MY_TEST_AREA or provide a path"
  exit 1
fi

# Finally, check the experiment given is valid
if [[ ! " ${EXPERIMENTS[@]} " =~ " ${EXPERIMENT} " ]]; then
  echo "Invalid experiment: ${EXPERIMENT}"
  echo "Available experiments: ${EXPERIMENTS[*]}"
  exit 1
fi

if [ ! -d "$PANDORA_DIR/LArMachineLearningData/" ]; then
  echo "LArMachineLearningData does not exist in $PANDORA_DIR, not downloading the files"
  exit 1
fi

### PandoraMVAData
mkdir -p "$PANDORA_DIR/LArMachineLearningData/PandoraMVAData"
cd "$PANDORA_DIR/LArMachineLearningData/PandoraMVAData" || exit

# MicroBooNE
if [[ "${EXPERIMENT}" == "uboone" ]]; then
  curl_download "1b3m9Glj1Qjx5tnSdvqLIBNFBWpH8NrvX" "PandoraSvm_v03_11_00.xml"
fi

# DUNE
if [[ "${EXPERIMENT}" == "dune" ]]; then
  curl_download "1i5mi545-NQU15raIyYOwbWY8VQuCv8Ox" "PandoraBdt_BeamParticleId_ProtoDUNESP_v03_26_00.xml"
  curl_download "1eeiScUaLjEoACxCyb73JwGnuMsJ1Y4Iq" "PandoraBdt_PfoCharacterisation_ProtoDUNESP_v03_26_00.xml"
  curl_download "12cl3gpijkcpIIZZGeThtH2e4Vzvf6Xqu" "PandoraBdt_Vertexing_ProtoDUNESP_v03_26_00.xml"

  curl_download "19eRtRnbqinLo_90hKMD9wjaHmpXU1m6j" "PandoraBdt_PfoCharacterisation_DUNEFD_HD_v04_06_00.xml"
  curl_download "1RSKy9hGO6BMVQL6NJMcHIk0mAP3MnqOS" "PandoraBdt_PfoCharacterisation_DUNEFD_VD_v04_06_00.xml"
  curl_download "17XqHdu53btjfnRF4-mHgv5mpE1HoDpDT" "PandoraBdt_Vertexing_DUNEFD_v03_27_00.xml"
fi

### PandoraMVAs
mkdir -p "$PANDORA_DIR/LArMachineLearningData/PandoraMVAs"
cd "$PANDORA_DIR/LArMachineLearningData/PandoraMVAs" || exit

# SBND
if [[ "${EXPERIMENT}" == "sbnd" ]]; then
  curl_download "1lGn-_BCK9TpEdVZUElAAxFJ9ynazcCY7" "PandoraBdt_v09_32_00_SBND.xml"
fi

### PandoraNetworkData
mkdir -p "$PANDORA_DIR/LArMachineLearningData/PandoraNetworkData"
cd "$PANDORA_DIR/LArMachineLearningData/PandoraNetworkData" || exit

# DUNE
if [[ "${EXPERIMENT}" == "dune" ]]; then
  download "1kd2QqW2hivCTlKD2pgVCQifsgie8QwD9" "PandoraNet_Vertex_DUNEFD_HD_Accel_1_U_v04_06_00.pt"
  download "16_PRz7Flch9rKyv2b3z4pli4WyhUXKqO" "PandoraNet_Vertex_DUNEFD_HD_Accel_1_V_v04_06_00.pt"
  download "1-_hxLuNO3q59BTIiuiECI2Fq_MMLctEj" "PandoraNet_Vertex_DUNEFD_HD_Accel_1_W_v04_06_00.pt"
  download "1GSWeLcZZ1xBWB9qRFfWbUeqgBw4oJu7o" "PandoraNet_Vertex_DUNEFD_HD_Accel_2_U_v04_06_00.pt"
  download "1v4KpSSekvuhQAKV1S32u_yNCCaQQXWYK" "PandoraNet_Vertex_DUNEFD_HD_Accel_2_V_v04_06_00.pt"
  download "1UGIp1mcIADZujzCW7vxiryanWYF77wjm" "PandoraNet_Vertex_DUNEFD_HD_Accel_2_W_v04_06_00.pt"

  download "15y8Nn66mP8lVO9NP4jZTKNdTTEfJQSrA" "PandoraNet_Vertex_DUNEFD_VD_Accel_1_U_v04_06_00.pt"
  download "1PakLUma5gJ34hXEEvgSMfV0_kky4_IMB" "PandoraNet_Vertex_DUNEFD_VD_Accel_1_V_v04_06_00.pt"
  download "1s2DEXlgNkjTNWUyUXIJm5718OMuj3a4p" "PandoraNet_Vertex_DUNEFD_VD_Accel_1_W_v04_06_00.pt"
  download "1K2zGwPKfPNI0WyArR_RBO3by0rpUijr3" "PandoraNet_Vertex_DUNEFD_VD_Accel_2_U_v04_06_00.pt"
  download "1RTaWO_ilYdqTd-qpjGBAmOKuMobG0tIM" "PandoraNet_Vertex_DUNEFD_VD_Accel_2_V_v04_06_00.pt"
  download "1867oCU1ZxPLiRMQE5SlZDswzfhz8rgSM" "PandoraNet_Vertex_DUNEFD_VD_Accel_2_W_v04_06_00.pt"

  download "1BYX6Y0sirNzBw0qsj6Xsa-qOAdqn5PG7" "PandoraNet_Vertex_DUNEFD_HD_Atmos_1_U_v04_03_00.pt"
  download "1AWywC9LsCkuNo6lVo5VAWvlM2n-FWTnx" "PandoraNet_Vertex_DUNEFD_HD_Atmos_1_V_v04_03_00.pt"
  download "1CLV64endpentEDSoRFTu6obWoYL2Bx-a" "PandoraNet_Vertex_DUNEFD_HD_Atmos_1_W_v04_03_00.pt"
  download "1HYhF3xGcZXOVxXrjDnYgV_34-q5d58UC" "PandoraNet_Vertex_DUNEFD_HD_Atmos_2_U_v04_03_00.pt"
  download "1DDqVFhnRBPy6ZIehd9u1SwyiKaWC3hSF" "PandoraNet_Vertex_DUNEFD_HD_Atmos_2_V_v04_03_00.pt"
  download "1JLr5GfjSNt6vO81ZCv42UHH09hjvtFw7" "PandoraNet_Vertex_DUNEFD_HD_Atmos_2_W_v04_03_00.pt"
fi

# DUNE ND
if [[ "${EXPERIMENT}" == "dunend" ]]; then
  download "1rFR3zYxTgXNzqvdQQ7e7PM9d_dtDyMTj" "PandoraNet_Vertex_DUNEND_Accel_1_U_v04_06_00.pt"
  download "10mVZEUxstmUMALhK4ja9gDEtWXOd6SZ-" "PandoraNet_Vertex_DUNEND_Accel_1_V_v04_06_00.pt"
  download "1Sq4YHhhH9gOEIZipEu9lXgcjw8PlfGGi" "PandoraNet_Vertex_DUNEND_Accel_1_W_v04_06_00.pt"
  download "1i3AYNEM0liddEzZp1ST9QR5rcORElAXN" "PandoraNet_Vertex_DUNEND_Accel_2_U_v04_06_00.pt"
  download "1ZpmskwhfeorVSRQPhzRoDRkzZ5TmOPz1" "PandoraNet_Vertex_DUNEND_Accel_2_V_v04_06_00.pt"
  download "1pEQ7d2OLDMkx6-s0l0WRyC-F86i_N-mo" "PandoraNet_Vertex_DUNEND_Accel_2_W_v04_06_00.pt"
fi

cd "${STARTING_DIR}" || exit
