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
include {MULTIBWSUMMARY} from './modules/deeptools_multibwsummary'
include {PLOTCORRELATION} from './modules/deeptools_plotcorrelation'
include {TAGDIR} from './modules/homer_maketagdir'
include {FINDPEAKS} from './modules/homer_findpeaks'
include {POS2BED} from './modules/homer_pos2bed'
include {BEDTOOLS_INTERSECT} from './modules/bedtools_intersect'
include {BEDTOOLS_REMOVE} from './modules/bedtools_remove'
include {ANNOTATE} from './modules/homer_annotatepeaks'

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

    bigwigs_ch = BAMCOVERAGE.out
        .map { tuple -> tuple[1]}
        .collect()
        .map { files -> files.flatten()}

    //bigwigs_ch.view()

    // create matrix with bigwigs info
    MULTIBWSUMMARY(bigwigs_ch)

    // generate plot of distances between correlation coefficients
    PLOTCORRELATION(MULTIBWSUMMARY.out, params.corrtype)

    // make tag directory for each bam file
    TAGDIR(BOWTIE2_ALIGN.out)

    // make channels for IP and INPUT tagdirs (keyed by replicate no.)
    ip_ch = TAGDIR.out
        .filter { sample, tagdir -> sample.toString().contains('IP_') }
        .map { sample, tagdir ->
            def name = sample.toString()
            def match = (name =~ /IP_(rep\d+)/)
            def rep = match[0][1]
            tuple(rep, tagdir)
        }
        .filter { it != null }
    input_ch = TAGDIR.out
        .filter { sample, tagdir -> sample.toString().contains('INPUT_') }
        .map { sample, tagdir ->
            def name = sample.toString()
            def match = (name =~ /INPUT_(rep\d+)/)
            def rep = match[0][1]
            tuple(rep, tagdir)
        }
        .filter { it != null }

    // make channel that joins ip and input tagdirs
    paired_ch = ip_ch.join(input_ch)
        .map { rep, ip_tagdir, input_tagdir -> tuple(rep, ip_tagdir, input_tagdir) }

    // run findPeaks on each tag directory
    FINDPEAKS(paired_ch)
    
    // convert peak outputs to BED format
    POS2BED(FINDPEAKS.out)

    // collect bed files from POS2BED
    bedlist = POS2BED.out.collect()

    // pair POS2BED outputs for intersection
    bedlist.map { list ->
        def pairs = []
        for (int i = 0; i < list.size(); i += 2) {
            pairs << [list[i], list[i + 1]]
        }
        def rep1 = pairs.find { it[0] == "rep1" }
        def rep2 = pairs.find { it[0] == "rep2" }
        tuple(rep1[0], file(rep1[1]), rep2[0], file(rep2[1]))
    }
    .set { bedintersect_ch }

    //bedintersect_ch.view()

    // produce single set of reproducible peaks from POS2BED outputs
    BEDTOOLS_INTERSECT(bedintersect_ch)

    // filter ENCODE blacklist peaks
    BEDTOOLS_REMOVE(BEDTOOLS_INTERSECT.out, params.blacklist)

    // annotate peaks to their nearest genomic feature
    ANNOTATE(BEDTOOLS_REMOVE.out, params.genome, params.gtf)
}