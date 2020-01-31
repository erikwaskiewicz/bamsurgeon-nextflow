"""


Usage: nextflow run generate-in-silico-data.nf

"""

help_message = """
===============================================================================

generate-in-silico-data.nf  -  v${params.version}

===============================================================================

Usage: nextflow generate-in-silico-data.nf -profile test

Required parameters:
  --bam_file            Absolute path to BAM file
  --fasta_ref           Absolute path to FASTA file

Optional parameters:
  --outdir              Path where the results to be saved [Default: './results']
"""

// show help message above when --help flag is used
params.help = false
if ( params.help ) { log.info help_message; exit 0 }


/*-------------------------------------------------------------------*
 *  Config
 *-------------------------------------------------------------------*/

params.snv_file = false
params.bam_file = false
params.ref_file = false

// make sure bam and fasta ref are inputted
if ( !params.bam_file ) { log.error "ERROR\tNo BAM file inputted"; exit 1 }
if ( !params.ref_file ) { log.error "ERROR\tNo reference FASTA file inputted"; exit 1 }

// make sure at least one file has been inputted
if ( !( params.snv_file || params.indel_file || params.sv_file ) ) {
    log.error "ERROR\tNo target variants inputted"; exit 1
}

// check if fasta indexes and dict exists
if ( params.bam_index ) { bai_file = file("$params.bam_index", checkIfExists: true) } 
else { params.bam_index = false }

// get file objects
bam_file  = file(params.bam_file)
snv_file  = file(params.snv_file)
ref_fasta = file(params.ref_file)
cnv_list  = file(params.cnv_list)

// Create a summary for the logfile
def summary = [:]
summary["Pipeline version"] = "$params.version"
summary["Command"]          = "$workflow.commandLine"
summary["Input BAM file"]   = "${ params.bam_file ? params.bam_file : 'No BAM file supplied' }"
summary["SNV file"]         = "${ params.snv_file ? params.snv_file : 'No SNVs supplied' }"
summary["Ref file"]         = "${ params.ref_file ? params.ref_file : 'No ref supplied' }"

// print info to log and/or console
log.info """
===============================================================================
Inputs:\n${summary.collect  { k,v -> "  ${k.padRight(18)}: $v" }.join("\n")}
===============================================================================
"""


/*-------------------------------------------------------------------*
 *  Pipeline
 *-------------------------------------------------------------------*/

if ( !params.bam_index ) {
    process build_reference_bam_index {
        /*
         *  If no BAM index (.bai) file is supplied, make one
         */
        publishDir "$baseDir/data/in_silico_data", mode: "copy"

        input:
            file(bam) from bam_file

        output:
            file("${bam.name + '.bai'}") into bai_file

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
        file(bam) from bam_file
        file(bai) from bai_file
        file(ref) from ref_fasta
        file(var) from snv_file
        file(cnv) from cnv_list

    output:
        file("${bam.name.replace('.bam', '_mut.bam')}") into bam_out

    script:
        """
        addsnv.py \
            --bamfile $bam \
            --reference /var/app/bamsurgeon/test_data/Homo_sapiens_chr22_assembly19.fasta \
            --varfile $var \
            --numsnvs 5 \
            --outbam ${bam.name.replace('.bam', '_mut.bam')} \
            --aligner mem \
            --picardjar /opt/conda/share/picard-2.21.7-0/picard.jar \
            --cnvfile /var/app/bamsurgeon/test_data/test_cnvlist.txt.gz #\
            #--seed 1234
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
