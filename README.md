# bamsurgeon-nextflow

A nextflow wrapper around the BAMSurgeon program https://github.com/adamewing/bamsurgeon

## Requirements

- Install conda env
- Pull Docker image

## Running

```
nextflow bamsurgeon.nf \
    -profile docker_conf \

```

## Tests

BAMSurgeon test suite: 

`nextflow test_bansurgeon.nf -profile docker_conf`

bamsurgeon-nextflow pipeline with test data:

`nextflow bamsurgeon.nf -profile test,docker_conf`