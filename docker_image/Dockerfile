# =====================================================================
#  erikwaskiewicz/bamsurgeon Dockerfile
#
# =====================================================================

# Use miniconda parent image - debian based
FROM continuumio/miniconda:4.7.10
LABEL maintainer="Erik Waskiewicz"

# Set the working directory & copy across current directory
# Set python so that it doesn't create .pyc files
WORKDIR /var/app
COPY . /var/app
ENV PYTHONDONTWRITEBYTECODE=true

# Install awk and ps for use with Nextflow reports
# remove apt cache after running to reduce image size
RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
        build-essential \
        gawk \
        git \
        procps \
 && rm -rf /var/lib/apt/lists/*

# Update conda, make the conda environment, clean unnecessary files afterwards
RUN conda install --yes --freeze-installed \
        python=2.7 \
        bioconda::bcftools \
        bioconda::bwa \
        bioconda::exonerate \
        bioconda::htslib \
        bioconda::picard \
        bioconda::pysam \
        bioconda::samtools \
        bioconda::velvet \
        conda-forge::numpy \
        conda-forge::scipy \
 && conda clean -afy \
 && find /opt/conda/ -follow -type f -name '*.a' -delete \
 && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
 && find /opt/conda/ -follow -type f -name '*.js.map' -delete

# Download and setup bamsurgeon - last Python2 commit
RUN git clone https://github.com/adamewing/bamsurgeon.git \
 && cd bamsurgeon \
 && git checkout 198986f4627509a163a42c7320c703edaac15d40 \
 && python setup.py install
