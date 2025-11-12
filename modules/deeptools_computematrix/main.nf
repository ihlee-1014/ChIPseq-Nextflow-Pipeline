#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir "${params.outdir}/computematrix", mode: 'copy'

    input:
    tuple val(sample), path(bw)
    path(bed)
    val(window)

    output:
    tuple val(sample), path("*.gz"), emit: matrix

    script:
    """
    computeMatrix scale-regions -S $bw -R $bed -b $window -a $window -o ${sample}_matrix.gz
    """

    stub:
    """
    touch ${sample}_matrix.gz
    """
}