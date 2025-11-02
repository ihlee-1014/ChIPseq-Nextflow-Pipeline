#!/usr/bin/env nextflow

process TRIM {
    label 'process_medium'
    container 'ghcr.io/bf528/trimmomatic:latest'
    publishDir "${params.outdir}/trimmed", mode: "copy"

    input:
    tuple val(sample), path(read)
    path(adapter_fa)

    output:
    tuple val(sample), path("${sample}_trimmed.fastq.gz"), emit: trimmed
    tuple val(sample), path("${sample}_trim.log"), emit: log

    script:
    """
    trimmomatic SE -threads ${task.cpus} \
        ${read} ${sample}_trimmed.fastq.gz \
        ILLUMINACLIP:${adapter_fa}:2:30:10 \
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 \
        2> ${sample}_trim.log
    """

    stub:
    """
    touch ${sample}_trimmed.fastq.gz
    touch ${sample}_trim.log
    """
}
