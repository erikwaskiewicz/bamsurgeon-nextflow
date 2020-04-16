"""
bamsurgeon-nextflow tests - Runs BAMSurgeon's built in test scripts
Author: Erik Waskiewicz

Usage: nextflow run test_bamsurgeon.nf -profile [ docker_conf / singularity_conf ]

NOTE: The tests contain relative paths so must cd into test directory in each 
process. Many processes require the path to the picard.jar file installed in 
/opt/conda, this is set in each process.
"""

process test_picard_installation {
    /* 
     *  Checks that Picard is installed correctly by looking for the 
     *  picard.jar file in /opt/conda/share
     */
    container "erikwaskiewicz/bamsurgeon:latest"
    output:
        val true into installed_correctly
    script:
    """
    export PICARDJAR=\$(find /opt/conda -name picard.jar)
    count=\$(echo \$PICARDJAR | wc -l)

    if [[ \$count -lt 1 ]]; then
        echo "Picard not installed"
        exit 1

    elif [[ \$count -gt 1 ]]; then
        echo "Multiple versions of Picard installed"
        exit 1

    else
        echo "Picard installed at \$PICARDJAR"
        exit 0
    fi
    """
}


/*-------------------------------------------------------------------*
 *  SNV tests
 *-------------------------------------------------------------------*/

process test_snv {
    /* 
     *  Tests that the add_snvs.py command works
     */
    container "erikwaskiewicz/bamsurgeon:latest"
    input:
        val flag from installed_correctly
    script:
    """
    export PICARDJAR=\$(find /opt/conda -name picard.jar)

    cd /var/app/bamsurgeon/test
    bash test_snv.sh \$PICARDJAR
    """
}


process test_snv_alt {
    /* 
     *  Tests that the add_snvs.py command works
     */
    container "erikwaskiewicz/bamsurgeon:latest"
    input:
        val flag from installed_correctly
    script:
    """
    cd /var/app/bamsurgeon/test
    bash test_snv_alt.sh 5 1 /var/app/bamsurgeon/test_data/Homo_sapiens_chr22_assembly19.fasta
    """
}


process test_snv_environ {
    /* 
     *  Tests that add_snvs.py works with the BAMSURGEON_PICARD_JAR env variable set
     */
    container "erikwaskiewicz/bamsurgeon:latest"
    input:
        val flag from installed_correctly
    script:
    """
    export PICARDJAR=\$(find /opt/conda -name picard.jar)

    cd /var/app/bamsurgeon/test
    bash test_snv_environ.sh \$PICARDJAR
    """
} 


process test_snv_minmutreads {
    /* 
     *  Tests that add_snvs.py works with the optional minmutreads input
     */
    container "erikwaskiewicz/bamsurgeon:latest"
    input:
        val flag from installed_correctly
    script:
    """
    cd /var/app/bamsurgeon/test
    bash test_snv_minmutreads.sh 5 1 /var/app/bamsurgeon/test_data/Homo_sapiens_chr22_assembly19.fasta
    """
}


process test_snv_ont {
    /* 
     *  Tests add_snvs.py with mimimap2
     */
    container "erikwaskiewicz/bamsurgeon:latest"
    input:
        val flag from installed_correctly
    script:
    """
    export PICARDJAR=\$(find /opt/conda -name picard.jar)
    cd /var/app/bamsurgeon/test

    bash test_snv_ont.sh \$PICARDJAR
    """
}


process test_snv_skipmerge {
    /* 
     *  Tests that add_snvs.py works with the optional skipmerge flag
     */
    container "erikwaskiewicz/bamsurgeon:latest"
    input:
        val flag from installed_correctly
    script:
    """
    cd /var/app/bamsurgeon/test
    bash test_snv_skipmerge.sh 5 1 /var/app/bamsurgeon/test_data/Homo_sapiens_chr22_assembly19.fasta
    """
}


/* 
These weren't run as they use a different variant caller and require a different index:
    - test_snv_bowtie2
    - test_snv_gsnap
    - test_snv_novoalign
    - test_snv_tmap

These weren't run as there are bugs in the code:
    - test_snv_avoid - typo in input bam - *_mut.bam, should be *_realign.bam
    - test_snv_haplo - input file test_data/random_snvs_haplopairs.txt doesnt exist

This wasn't run as it's expected to fail:
    - test_snv_maxdepth
*/
