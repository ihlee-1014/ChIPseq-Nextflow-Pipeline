#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {
    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir "${params.outdir}/findmotifsgenome", mode: "copy"

    input:
    path(bed)
    path(genome)

    output:
    path("motifs")

    script:
    """
    findMotifsGenome.pl $bed $genome motifs -size 200
    """

    stub:
    """
    mkdir motifs
    """
}


