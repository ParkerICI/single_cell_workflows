FROM gcr.io/pici-internal/genomics:2.0.4

# Solves apt update error: https://unix.stackexchange.com/questions/508724/failed-to-fetch-jessie-backports-repository
RUN rm -fr /etc/apt/sources.list.d/jessie*
RUN apt-get update

# Install curl
RUN apt-get install -y curl

ENV BASE_DIR="/usr/gitc"
ENV BAM_TO_FASTQ_VERSION="v1.3.5"
ENV CELLRANGER_VERSION="6.1.1"

# Grab a version of 10x_bam_to_fastq
RUN curl -L https://github.com/10XGenomics/bamtofastq/releases/download/${BAM_TO_FASTQ_VERSION}/bamtofastq_linux \
    --output ${BASE_DIR}/bamtofastq
RUN chmod +x ${BASE_DIR}/bamtofastq

# Grab cellranger: https://support.10xgenomics.com/single-cell-gene-expression/software/downloads/latest
# Note: curl link needs to be refreshed before building
RUN curl -o cellranger-${CELLRANGER_VERSION}.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-6.1.1.tar.gz?Expires=1634625589&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci02LjEuMS50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2MzQ2MjU1ODl9fX1dfQ__&Signature=lb33W5I5lWkRhIsWd5zN4r3HsZbkv45iemNEqwyOlXvH9TQMF~luhFmHbD8jgoprOivsbImLxW24oK9Oms2Yk-p5yzCVCY4Mhj4HIitZ9AMuGKsoRHuXKgC8Sx82OQPY0ereExNtWNx~oGRypAmzdIyI4CEl8AbT3Mtah6TZsN63Jrgnp4S0Kzp~ekCdG8ubzz4xX7MDJOMo5gwJj-AXVdzMD6noLFNzqehfHHXulg35eGOb~99pRXfsOaT5vUX68-KVv9jDgeDI08~4onSV3ThHqIXvhqyl1Og7W4R6A-ffn5acQ-UsyeJU63Bk5BCk5ou340kO~vRTXuwx3tdQNA__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
RUN tar xvzf ${BASE_DIR}/cellranger-${CELLRANGER_VERSION}.tar.gz -C ${BASE_DIR}
RUN ln -s ${BASE_DIR}/cellranger-${CELLRANGER_VERSION} ${BASE_DIR}/cellranger
RUN rm cellranger-${CELLRANGER_VERSION}.tar.gz

CMD /bin/bash
