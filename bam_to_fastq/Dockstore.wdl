version 1.0

task bam_to_fastq_10x {

  input {
    String base_dir = "/usr/gitc"
    String sample_id
    File bam_file
    Int nthreads
  }

  command {
    ${base_dir}/bamtofastq --nthreads=${nthreads} ${bam_file} fastq_out
    tar cvf - ${sample_id}_fastq.tar -C fastq_out . > ${sample_id}_fastq.tar
  }

  output {
    File fastq_tar = "${sample_id}_fastq.tar"
    File out = stdout()
    File err = stderr()
  }

  runtime {
   cpu: "${nthreads}"
   memory: "32GB"
   docker: "gcr.io/pici-internal/cellranger:6.1.1"
  }
}

workflow bam_to_fastq {
  
  input {
    String sample_id
    Int nthreads = 30
    File bam_file
  }
    
  call bam_to_fastq_10x {
    input:
      bam_file = bam_file,
      nthreads = nthreads,
      sample_id = sample_id
  }

  output {
    File fastq_tar = bam_to_fastq_10x.fastq_tar
    File out = bam_to_fastq_10x.out
    File err = bam_to_fastq_10x.err
  }
}
