# RNAseq Nextflow Pipeline

The following README contains directions on how to run the ChIPSeq Nextflow pipeline.  

Our final project is based on [Barutcu et al. 2016](https://doi.org/10.1016/j.bbagrm.2016.08.003),
which is focused on how the RUNX1 transcription factor contributes to chromatin organization of breast cancer cells via ChIP-seq integrated with Hi-C and gene expression analysis. In this project, we reproduce the ChIP-seq analysis techniques of the reference publication, examine significant peaks, and compare results to the original publication.  

This repository consists of the following files:  

| File(s) | Path | Description |
| :------- | :------ | :------- |
| Nextflow Pipeline     | `main.nf` | Consists of a full Nextflow pipeline that processes the ChIP-seq data from Barutcu et al. 2016.    |
| Jupyter Notebook Report  | `project03_report.ipynb`   | Consists of a Jupyter Notebook report that runs analyses on our ChIP-seq data.   |
| Jupyter Notebook Report PDF | `project03_report.pdf` | Consists of our report in `.pdf` format. |
| Nextflow Modules | `modules/` | Consists of all Nextflow modules and their `main.nf` files used to run the pipeline. |
| Nextflow Configuration | `nextflow.config` | Consists of all parameters and settings used to run the Nextflow pipeline. |  
| Samplesheet | `full_samplesheet.csv` | Consists of sample names and paths to samples. Please change file paths if necessary.* |
| DAG of Pipeline | `project-3-pipeline.png` | Consists of a DAG visualization of the Nextflow pipeline. |

To run the Nextflow pipeline, please run the command:
```
nextflow run main.nf -profile singularity,local
```

*All sample data were downloaded from the original publication. Please download the .fastq files and edit the file paths in `full_samplesheet.csv` before running the pipeline.

Feel free to change any file paths if necessary.
