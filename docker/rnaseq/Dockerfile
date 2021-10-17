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
    --output ${BASE_DIR}/bamtofastq_linux
RUN chmod +x ${BASE_DIR}/bamtofastq_linux

# Grab cellranger: https://support.10xgenomics.com/single-cell-gene-expression/software/downloads/latest
RUN curl -o ${BASE_DIR}/cellranger-6.1.1.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-6.1.1.tar.gz?Expires=1634525346&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci02LjEuMS50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2MzQ1MjUzNDZ9fX1dfQ__&Signature=QJIT~8pNAbs4IJJpoL1CfK~XJOxmjKbc40d~XlVKUa30A9cVORiQ3TRiaUNsdMwi1T4WRpy7FwNYGjmioUdZEQWfY9hOM9Cd71J1OI7pMUAS8AIShDXJKoUAncaEeGxod64~FhhzNyjioD1etoCs3SMmZczBulzbYMwADB9ykKhCltU6KVMqkr35GMP2UfPv-Qp2NKytKP0MhvVLNSyIFoBp75irABT4dbM~AQRtW4yJ-GRGuF99KC8BPjgIYpd7kvWcIca53Y1ZBY1ancOQeiL1Unefr5pJxvQGM4fB~yJ~25XI2voj8boGg2lQ5YOWfD5XbLQF05Y~YeEz9B~STQ__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
RUN tar xvzf ${BASE_DIR}/cellranger-${CELLRANGER_VERSION}.tar.gz -C ${BASE_DIR}
RUN ln -s ${BASE_DIR}/cellranger-${CELLRANGER_VERSION} ${BASE_DIR}/cellranger

CMD /bin/bash
