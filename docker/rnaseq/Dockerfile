FROM gcr.io/pici-internal/genomics:2.0.4

# Solves apt update error: https://unix.stackexchange.com/questions/508724/failed-to-fetch-jessie-backports-repository
RUN rm -fr /etc/apt/sources.list.d/jessie*
RUN apt-get update

# Install curl
RUN apt-get install -y curl

# Grab a version of 10x_bam_to_fastq
RUN curl -L https://github.com/10XGenomics/bamtofastq/releases/download/${version}/bamtofastq_linux \
    --output /usr/bin/bamtofastq_linux

# Grab cellranger: https://support.10xgenomics.com/single-cell-gene-expression/software/downloads/latest
RUN curl -o cellranger-6.1.1.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-6.1.1.tar.gz?Expires=1634462651&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci02LjEuMS50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2MzQ0NjI2NTF9fX1dfQ__&Signature=l0jGkXYGdLerMbHLgTjsuC8ceu0PHthGKu5dZ2votE1~euZ7gBy7JCTltUP6EYlz-NpceJxWUWU4ZUgXu6jEy1ftg9qUueXiPawSHztb6JqEht9CKRV--Ride~yKKXS848XqyoUmoZG0cxrmlS27P26D7jievYxX0ElhHj~tYrlN-v3W4i4g8cZXmDndKZp~omsP4pL1UrRRdLVKvJvh-hYU7nfZ--7qKaJlifjYdtHqv-exKfFn0kfDaw3AWWN8bC-6sOBjma15Ncn2DBhdLtncrMZB3DWxFM3-4MM2Z4KjoNFgX28vqTLjJbNgwywLmiu4XUbfyHZzPifWO9U5aw__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA" && \
    tar xvzf cellranger-6.1.1.tar.gz && \
    mv cellranger-6.1.1 /usr/local && \
    ln -s /usr/local/cellranger-6.1.1/cellranger /usr/bin

CMD /bin/bash
