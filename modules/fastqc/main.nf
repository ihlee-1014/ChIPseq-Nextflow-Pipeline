#!/usr/bin/env nextflow

process FASTQC {

    label 'process_low'
    container 'ghcr.io/bf528/fastqc:latest'
    publishDir params.outdir, mode: "copy"

    input:
    tuple val(sample), path(name)

    output:
    tuple val(name), path('*.zip'), emit: zip
    tuple val(name), path('*.html'), emit: html

    script:
    """
    fastqc $name -t $task.cpus
    """

    stub:
    """
    touch stub_${sample_id}_fastqc.zip
    touch stub_${sample_id}_fastqc.html
    """

}