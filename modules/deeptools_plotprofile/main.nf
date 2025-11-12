#!/usr/bin/env nextflow

process PLOTPROFILE {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir "${params.outdir}/plotprofile", mode: 'copy'

    input:
    tuple val(sample), path(matrix)

    output:
    path("*.png"), emit: coverage

    script:
    """
    plotProfile -m $matrix -o ${sample}_signal_coverage.png
    """

    stub:
    """
    touch ${sample}_signal_coverage.png
    """
}