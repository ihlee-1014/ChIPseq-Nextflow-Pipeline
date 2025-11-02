#!/usr/bin/env nextflow

process SAMTOOLS_IDX {
    label 'process_single'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample), path(bam)

    output:
    tuple val(sample), path(bam), path("*.bai"), emit: index    

    script:
    """
    samtools index $bam
    """

    stub:
    """
    touch ${sample}.stub.sorted.bam.bai
    """
}