version 1.0

task cellranger_count {
  input {
    #File transcriptome_tar = "gs://pici-genome-references-master/files-for-specific-methods/cellranger_rnaseq/GRCh38.p13.tar"
    File transcriptome_tar = "gs://pici-genome-references-master/files-for-specific-methods/cellranger_rnaseq/GRCh38.p13.egfr.tar"
    File fastq_tar
    String sample_id
    Boolean include_introns
  }

  command {
    
    String include_introns_str = ""
    if (include_introns) {
      include_introns_str = "--include-introns"
    }

    tar xvf ${transcriptome_tar}
    tar xvf ${fastq_tar} 2> tar_output.txt



    #cellranger count ${include_introns_str} \
    #  --transcriptome=GRCh38.p13 \
    #  --disable-ui \
    #  --no-bam \
    #  --id ${sample_id} \
    #  --fastqs ${fastq_dirs} \
    #  --localcores 32 \
    #  --localmem 120
  }

  output {
    File out = stdout()
    File err = stderr()
  }

  runtime {
   cpu: "32"
   memory: "128GB"
   disks: "local-disk 350 SSD"
   #docker: "gcr.io/pici-internal/cellranger:6.1.1"
  }
}

workflow cellranger_rnaseq {
  
  input {
    File ref_dir
    String sample_id

    Boolean bam_input
    File bam_file
  }
    
  if (bam_input) {
    call bam_to_fastq {
      input:
        bam_file = bam_file,
        os = bam_to_fastq_os,
        version = bam_to_fastq_version,
        nthreads = ncores
    }
  }

  #call cellranger_count {
  #  input:
  #    fastqs = bam_to_fastq.fastqs
  #}
}
