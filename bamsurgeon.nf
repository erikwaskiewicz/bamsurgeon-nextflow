"""
bamsurgeon-nextflow - A Nextflow wrapper around the BAMSurgeon program
Author: Erik Waskiewicz
"""

help_message = """
===============================================================================

bamsurgeon.nf  -  v${params.version}

===============================================================================

Usage: nextflow bamsurgeon.nf -profile [docker_conf / singularity_conf]

Required parameters:
  --bam_file            Path to BAM file to be mutated
  --fasta_ref           Path to FASTA reference file matching input BAM

At least one of these must be inputted:
  --snv_file            Path to a BED file of SNVs to introduced
  --indel_file          Path to a BED file of INDELs to introduced
  --sv_file             Path to a BED file of SVs to introduced

Optional parameters:
  --outdir              Path where the results to be saved [Default: './results']
  --bam_index           Path to .BAI file for input BAM

See https://github.com/erikwaskiewicz/bamsurgeon-nextflow for full details

===============================================================================
"""

// show help message above when --help flag is used
params.help = false
if ( params.help ) { log.info help_message; exit 0 }


/*-------------------------------------------------------------------*
 *  Config
 *-------------------------------------------------------------------*/

// Initialise variables
params.snv_file   = false
params.indel_file = false
params.sv_file    = false
params.bam_file   = false
params.bam_index  = false
params.ref_file   = false

// make sure bam and fasta ref are inputted
if ( !params.bam_file ) { log.error "ERROR\tNo BAM file inputted"; exit 1 }
if ( !params.ref_file ) { log.error "ERROR\tNo reference FASTA file inputted"; exit 1 }

// make sure at least one variant file has been inputted
if ( !( params.snv_file || params.indel_file || params.sv_file ) ) {
    log.error "ERROR\tNo target variants inputted"; exit 1
}

// get file objects
bam_file  = file(params.bam_file)
snv_file  = file(params.snv_file)
ref_fasta = file(params.ref_file)

// Create a summary for the logfile
def summary = [:]
summary["Pipeline version"] = "$params.version"
summary["Command"]          = "$workflow.commandLine"
summary["Input BAM file"]   = "${ params.bam_file }"
summary["Ref file"]         = "${ params.ref_file }"
summary["Input BAM index"]  = "${ params.bam_index ? params.bam_index : 'No BAM index supplied' }"
summary["SNV file"]         = "${ params.snv_file ? params.snv_file : 'No SNVs supplied' }"
summary["INDEL file"]       = "${ params.indel_file ? params.indel_file : 'No INDELs supplied' }"
summary["SV file"]          = "${ params.sv_file ? params.sv_file : 'No SVs supplied' }"

// print info to log and/or console
log.info """
===============================================================================
Inputs:\n${summary.collect  { k,v -> "  ${k.padRight(18)}: $v" }.join("\n")}
===============================================================================
"""


/*-------------------------------------------------------------------*
 *  Pipeline
 *-------------------------------------------------------------------*/

// check if bam index exists
if ( params.bam_index ) { bai_file = file("$params.bam_index", checkIfExists: true) } 
else { 
    process build_reference_bam_index {
        /*
         *  If no BAM index (.bai) file is supplied, make one
         */
        publishDir "$params.outdir", mode: "copy"
        input:
            file(bam) from bam_file
        output:
            file("${bam.name + '.bai'}") into bai_file
        when:
            !params.bam_index
        script:
        """
        picard BuildBamIndex \
            I=$bam \
            O=${bam.name + '.bai'}
        """
    }
}


process make_snvs {
    /* 
     *  Add the SNVs in the supplied SNV file to the reference BAM file
     */
    container "erikwaskiewicz/bamsurgeon:latest"
    publishDir "$params.outdir", mode: "copy"
    input:
        file(var) from snv_file
        file(bam) from bam_file
        file(bai) from bai_file
        //file(ref_file) from ref_fasta       These are currently hard coded below
        //file(ref_index) from ref_index      it cant find the .fai file when passed in 
    output:
        file("${bam.name.replace('.bam', '_mut.bam')}") into bam_out
    script:
    """
    export PICARDJAR=\$(find /opt/conda -name picard.jar)
    addsnv.py \
        --varfile $var \
        --bamfile $bam \
        --reference /var/app/bamsurgeon/test_data/Homo_sapiens_chr22_assembly19.fasta \
        --outbam ${bam.name.replace('.bam', '_mut.bam')} \
        --picardjar \$PICARDJAR \
        --aligner mem
    """
}


process build_processed_bam_index {
    /*
     *  Make a BAM index for the BAM with SNVs added to it
     */
    publishDir "$params.outdir", mode: "copy"
    input:
        file(bam) from bam_out
    output:
        file("${bam.name + '.bai'}") into bam_index_out
    script:
    """
    picard BuildBamIndex \
        I=$bam \
        O=${bam.name + '.bai'}
    """
}
