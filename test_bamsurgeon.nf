"""
Runs BAMSurgeons built in test scripts

Usage: nextflow run test_bamsurgeon.nf -profile docker_conf

"""

process test_snv {
    /* 
     *  tests contain relative paths so must be in test directory
     */
    container "erikwaskiewicz/bamsurgeon:latest"

    script:
        """
        export PICARDJAR=\$(find /opt/conda -name picard.jar)
        cd /var/app/bamsurgeon/test

        bash test_snv.sh \$PICARDJAR
        """
}
