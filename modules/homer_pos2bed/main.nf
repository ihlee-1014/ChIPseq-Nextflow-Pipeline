#!/usr/bin/env nextflow

process POS2BED {
    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir "${params.outdir}/pos2bed", mode: "copy"

    input:
    tuple val(sample), path(peaks)

    output:
    tuple val(sample), path("*bed"), emit: bed

    script:
    """
    pos2bed.pl $peaks > ${sample}_peaks.bed
    """

    stub:
    """
    touch ${sample}_peaks.bed
    """
}


