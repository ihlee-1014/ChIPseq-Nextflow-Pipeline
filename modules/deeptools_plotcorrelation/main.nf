#!/usr/bin/env nextflow

process PLOTCORRELATION {
    label 'process_low'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir "${params.outdir}/plotcorelation", mode: "copy"

    input:
    path(npz)
    val(corrtype)

    output:
    path("correlation_plot.png")

    script:
    """
    plotCorrelation -in $npz -c $corrtype -p heatmap -o correlation_plot.png
    """

    stub:
    """
    touch correlation_plot.png
    """
}






