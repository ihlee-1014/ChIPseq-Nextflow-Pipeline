#!/usr/bin/bash nextflow

process MULTIQC {

    label 'process_low'
    container 'ghcr.io/bf528/multiqc:latest'
    publishDir params.outdir, mode: "copy"

    input:
    path("*")

    output:
    path("multiqc_report.html")

    script:
    """
    multiqc -f .
    """
    
    stub:
    """
    touch multiqc_report.html
    """
}