#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {
    label 'process_single'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir "${params.outdir}/bedtools_intersect", mode: "copy"

    input:
    tuple val(rep1), path(bed1), val(rep2), path(bed2)

    output:
    path("repr_peaks.bed")

    script:
    """
    bedtools intersect -a $bed1 -b $bed2 -f 0.5 -r > repr_peaks.bed
    """

    stub:
    """
    touch repr_peaks.bed
    """
}