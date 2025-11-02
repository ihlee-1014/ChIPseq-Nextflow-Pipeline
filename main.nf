// Include your modules here
include {FASTQC} from './modules/fastqc'
include {TRIM} from './modules/trimmomatic'
include {BOWTIE2_BUILD} from './modules/bowtie2_build'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS_FLAGSTAT} from './modules/samtools_flagstat'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {SAMTOOLS_IDX} from './modules/samtools_idx'
include {MULTIQC} from './modules/multiqc'
include {BAMCOVERAGE} from './modules/deeptools_bamcoverage'

workflow {
    //Here we construct the initial channels we need
    Channel.fromPath(params.subsampled_samplesheet)
    | splitCsv( header: true )
    | map{ row -> tuple(row.name, file(row.path)) }
    | set { read_ch }
    
    //read_ch.view()

    // initial quality control
    FASTQC(read_ch)
    TRIM(read_ch, params.adapter_fa)

    // build genome and align with bowtie2
    BOWTIE2_BUILD(params.genome)
    BOWTIE2_ALIGN(TRIM.out.trimmed, BOWTIE2_BUILD.out.index, BOWTIE2_BUILD.out.name)

    // sort and index alignments
    SAMTOOLS_SORT(BOWTIE2_ALIGN.out)
    SAMTOOLS_IDX(SAMTOOLS_SORT.out)

    // calculate alignment stats
    SAMTOOLS_FLAGSTAT(BOWTIE2_ALIGN.out.bam)

    // make channel collecting all qc outputs needed for MULTIQC
    multiqc_ch = FASTQC.out.zip
        .mix(TRIM.out.log, SAMTOOLS_FLAGSTAT.out.txt)
        .map { tuple -> tuple[1] } 
        .collect()
        .map { files -> files.flatten() }

    // call MULTIQC
    MULTIQC(multiqc_ch)

    // generate bigwig files
    BAMCOVERAGE(SAMTOOLS_IDX.out)

}