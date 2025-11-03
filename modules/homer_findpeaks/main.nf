#!/usr/bin/env nextflow

process FINDPEAKS {
    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir "${params.outdir}/findpeaks", mode: "copy"

    input:
    tuple val(rep), path(ip), path(input)

    output:
    tuple val(rep), path("*txt"), emit: peaks

    script:
    """
    findPeaks $ip -i $input -style factor -o ${rep}_peaks.txt
    """

    stub:
    """
    touch ${rep}_peaks.txt
    """
}


