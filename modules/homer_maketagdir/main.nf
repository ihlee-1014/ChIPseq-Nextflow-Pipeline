#!/usr/bin/env nextflow

process TAGDIR {
    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir "${params.outdir}/tagdir", mode: "copy"

    input:
    tuple val(sample), path(bam)

    output:
    tuple val(sample), path("*_tags"), emit: tagdir

    script:
    """
    makeTagDirectory ${sample}_tags $bam
    """

    stub:
    """
    mkdir ${sample}_tags
    """
}


