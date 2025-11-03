#!/usr/bin/env nextflow

process MULTIBWSUMMARY {
    label 'process_low'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir "${params.outdir}/multibwsummary", mode: "copy"

    input:
    path(bw)

    output:
    path("bw_all.npz")

    script:
    """
    multiBigwigSummary bins -b $bw -o bw_all.npz
    """

    stub:
    """
    touch bw_all.npz
    """
}