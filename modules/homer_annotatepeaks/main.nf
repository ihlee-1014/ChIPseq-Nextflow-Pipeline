#!/usr/bin/env nextflow

process ANNOTATE {
    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir "${params.outdir}/annotatepeaks", mode: "copy"

    input:
    path(bed)
    path(genome)
    path(gtf)

    output:
    path("annotated_peaks.txt")

    script:
    """
    annotatePeaks.pl $bed $genome -gtf $gtf > annotated_peaks.txt
    """

    stub:
    """
    touch annotated_peaks.txt
    """
}



