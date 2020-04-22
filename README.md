# bamsurgeon-nextflow

A nextflow wrapper around the BAMSurgeon program: https://github.com/adamewing/bamsurgeon

[![Travis CI Build Status](https://travis-ci.com/erikwaskiewicz/bamsurgeon-nextflow.svg?token=6Kdapt3JHU3GMffhB2Mx&branch=master)](https://travis-ci.com/erikwaskiewicz/bamsurgeon-nextflow)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/erikwaskiewicz/bamsurgeon)

> **NOTE:**  
> This is a work in progress, it currently only works with the BAMSurgeon test data as the input reference FASTA 
> file, I've been having trouble getting the Docker image to work with a reference FASTA passed in through a volume, 
> see Issue #1 for details. Any help would be greatly appreciated :) 

## Introduction

BAMSurgeon is a tool to add variants to a pre-exisiting BAM file. BAMSurgeon can add single nucleotide variants (SNVs), copy number variants (CNVs) and structural variants (SVs) at a range of allele frequencies. This is useful for creating validation sets for clinical pipelines, particularly for somatic pipelines as there are few 'gold standard' references currently available.

BAMSurgeon has many dependencies, this pipeline uses Nextflow and Docker to make installing and using BAMSurgeon easier. It currently adds SNVs only but can be easily expanded to also include CNVs and SVs in the future.

This was written as part of my MSc Clinical Science (Clinical Bioinformatics) project at the University of Manchester.

BAMSurgeon documentation: https://github.com/adamewing/bamsurgeon/blob/master/doc/Manual.pdf

## Requirements

- Requires Conda and Docker to be installed
- Make Nextflow Conda environment: `conda env create -f conda_env/environment.yml`
- Pull Docker image from Dockerhub, either:
  - Latest version: `docker pull erikwaskiewicz/bamsurgeon:latest` 
  - Specific version: `docker pull erikwaskiewicz/bamsurgeon:v0.1`

## Running

```
nextflow bamsurgeon.nf \
    -profile docker_conf \
    --snv_file </path/to/BED/file/with/SNVs/to/add> \
    --bam_file </path/to/BAM/file/to/add/SNVs/to> \
    --ref_file </path/to/FASTA/reference/file/that/matches/input/BAM/reference>
```

See BAMSurgeon docs for details on the input formats.

## Tests

**BAMSurgeon test suite:** This runs the tests that come packaged with BAMSurgeon. See BAMSurgeon docs for details.

`nextflow test_bamsurgeon.nf -profile docker_conf`

**bamsurgeon-nextflow pipeline with test data:** This runs the pipeline using the data packaged with BAMSurgeon as an input.

`nextflow bamsurgeon.nf -profile test,docker_conf`

**Continuous integration:** Both of the above tests are run as part of a continuous integration script on Travis CI. This is run for every commit to GitHub. Dockercloud also checks that the image builds successfully for each commit. The badges at the top of this README show the build statuses.
