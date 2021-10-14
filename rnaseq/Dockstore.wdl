version 1.0

task bam_to_fastq {

  input {
    String os
    String version 
    File bam_file
    Int nthreads
  }

  command {
    wget https://github.com/10XGenomics/bamtofastq/releases/download/${version}/bamtofastq_${os}
    bamtofastq_${os} --nthreads=${nthreads} ${bam_file} ./fastq
  }

  output {
    Array[File] fastq_dirs = glob("./fastq/*")      
  }

  runtime {
   cpu: "${nthreads}"
  }

}

task cellranger_count {
  input {
    File ref_dir
    String sample_id
    Array[File] fastq_dirs
    Int nthreads
    Int mem_gb
    Int ncores
  }

  command {
    
    cellranger count \
      --transcriptome=${ref_dir} \
      --include-introns \
      --disable-ui \
      --no-bam \
      --id ${sample_id} \
      --fastqs ${fastq_dirs} \
      --localcores ${ncores} \
      --localmem ${mem_gb}

  }

  output {
    File response = stdout()
  }

  runtime {
   docker: 'quay.io/cumulus/cellranger:6.1.1'
  }
}

workflow cellranger_rnaseq {
  
  input {
    String? bam_to_fastq_os = "macos"
    String? bam_to_fastq_version = "v1.3.5"
    
    Int? ncores = 30
    Int? mem_gb = 120

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
