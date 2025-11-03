#!/usr/bin/env nextflow

process BEDTOOLS_REMOVE {
    label 'process_single'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir "${params.outdir}/bedtools_remove", mode: "copy"

    input:
    path(bed)
    path(blacklist)

    output:
    path("repr_peaks_filtered.bed")

    script:
    """
    bedtools subtract -a $bed -b $blacklist > repr_peaks_filtered.bed
    """

    stub:
    """
    touch repr_peaks_filtered.bed
    """
}