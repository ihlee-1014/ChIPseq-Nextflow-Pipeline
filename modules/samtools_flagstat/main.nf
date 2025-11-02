#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {
    label 'process_single'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample), path(bam)

    output:
    tuple val(sample), path("*.txt"), emit: txt

    script:
    """
    samtools flagstat $bam > ${sample}_flagstat.txt
    """

    stub:
    """
    touch ${sample}_flagstat.txt
    """
}