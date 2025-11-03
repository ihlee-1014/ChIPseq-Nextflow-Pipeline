#!/usr/bin/env nextflow

process SAMTOOLS_SORT {
    label 'process_single'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir "${params.outdir}/samtools_sort", mode: 'copy'

    input:
    tuple val(sample), path(bam)

    output:
    tuple val(sample), path("*.sorted.bam"), emit: sorted

    script:
    """
    samtools sort $bam > ${sample}.sorted.bam
    """

    stub:
    """
    touch ${sample}.stub.sorted.bam
    """
}