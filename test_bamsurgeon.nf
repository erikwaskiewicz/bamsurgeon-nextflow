"""
Runs BAMSurgeons built in test scripts

Usage: nextflow run test_bamsurgeon.nf -profile docker_conf

The tests contain relative paths so must cd into test directory in each process

"""

process test_picard_installation {
    /* 
     *  Checks that Picard is installed correctly by looking for the 
     *  picard.jar file in /opt/conda/share
     */
    container "erikwaskiewicz/bamsurgeon:latest"
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
     *  
     */
    container "erikwaskiewicz/bamsurgeon:latest"
    script:
        """
        export PICARDJAR=\$(find /opt/conda -name picard.jar)

        cd /var/app/bamsurgeon/test
        bash test_snv.sh \$PICARDJAR
        """
}


process test_snv_alt {
    /* 
     *  
     */
    container "erikwaskiewicz/bamsurgeon:latest"
    script:
        """
        cd /var/app/bamsurgeon/test
        bash test_snv_alt.sh 5 1 /var/app/bamsurgeon/test_data/Homo_sapiens_chr22_assembly19.fasta
        """
}


//process test_snv_avoid {
    /* 
     *  
     *
    container "erikwaskiewicz/bamsurgeon:latest"
    script:
        """
        cd /var/app/bamsurgeon/test
        bash test_snv_avoid.sh 5 1 /var/app/bamsurgeon/test_data/Homo_sapiens_chr22_assembly19.fasta
        """
} */


//process test_snv_bowtie2 {
    /* 
     *  
     *
    container "erikwaskiewicz/bamsurgeon:latest"
    script:
        """
        export PICARDJAR=\$(find /opt/conda -name picard.jar)

        cd /var/app/bamsurgeon/test
        bash test_snv_bowtie2.sh 5 1 \
            /var/app/bamsurgeon/test_data/Homo_sapiens_chr22_assembly19.fasta \
            \$PICARDJAR \

        """
} */


//process test_snv_environ {
    /* 
     *  
     *
    container "erikwaskiewicz/bamsurgeon:latest"
    script:
        """
        export PICARDJAR=\$(find /opt/conda -name picard.jar)

        cd /var/app/bamsurgeon/test
        bash test_snv_avoid.sh \$PICARDJAR
        """
} */


//process test_snv_gsnap {
    /* 
     *  
     *
    container "erikwaskiewicz/bamsurgeon:latest"
    script:
        """
        export PICARDJAR=\$(find /opt/conda -name picard.jar)

        cd /var/app/bamsurgeon/test
        bash test_snv_gnap.sh 5 1 \
            /var/app/bamsurgeon/test_data/Homo_sapiens_chr22_assembly19.fasta \
            \$PICARDJAR \

        """
} */


//process test_snv_haplo {
    /* 
     *  
     *
    container "erikwaskiewicz/bamsurgeon:latest"
    script:
        """
        cd /var/app/bamsurgeon/test
        bash test_snv_haplo.sh 5 1 /var/app/bamsurgeon/test_data/Homo_sapiens_chr22_assembly19.fasta
        """
} */


//process test_snv_maxdepth {
    /* 
     *  
     *
    container "erikwaskiewicz/bamsurgeon:latest"
    script:
        """
        export PICARDJAR=\$(find /opt/conda -name picard.jar)

        cd /var/app/bamsurgeon/test
        bash test_snv_maxdepth.sh 5 1 \
            /var/app/bamsurgeon/test_data/Homo_sapiens_chr22_assembly19.fasta \
            \$PICARDJAR
        """
} */


process test_snv_minmutreads {
    /* 
     *  
     */
    container "erikwaskiewicz/bamsurgeon:latest"
    script:
        """
        cd /var/app/bamsurgeon/test
        bash test_snv_minmutreads.sh 5 1 /var/app/bamsurgeon/test_data/Homo_sapiens_chr22_assembly19.fasta
        """
}


//process test_snv_novoalign {
    /* 
     *  
     *
    container "erikwaskiewicz/bamsurgeon:latest"
    script:
        """
        export PICARDJAR=\$(find /opt/conda -name picard.jar)

        cd /var/app/bamsurgeon/test
        bash test_snv_novoalign.sh 5 1 \
            /var/app/bamsurgeon/test_data/Homo_sapiens_chr22_assembly19.fasta \
            \$PICARDJAR \

        """
} */


process test_snv_ont {
    /* 
     *  
     */
    container "erikwaskiewicz/bamsurgeon:latest"
    script:
        """
        export PICARDJAR=\$(find /opt/conda -name picard.jar)
        cd /var/app/bamsurgeon/test

        bash test_snv_ont.sh \$PICARDJAR
        """
}


process test_snv_skipmerge {
    /* 
     *  
     */
    container "erikwaskiewicz/bamsurgeon:latest"
    script:
        """
        cd /var/app/bamsurgeon/test
        bash test_snv_skipmerge.sh 5 1 /var/app/bamsurgeon/test_data/Homo_sapiens_chr22_assembly19.fasta
        """
}


//process test_snv_tmap {
    /* 
     *  
     *
    container "erikwaskiewicz/bamsurgeon:latest"
    script:
        """
        export PICARDJAR=\$(find /opt/conda -name picard.jar)

        cd /var/app/bamsurgeon/test
        bash test_snv_tmap.sh 5 1 \
        \
        \$PICARDJAR
        """
} */
