version 1.0

task bam_to_fastq_10x {

  input {
    String os
    String version 
    String sample_id
    File bam_file
    Int nthreads
  }

  command {
    export BASE_DIR=/usr/gitc
    mkdir fastq_out
    $BASE_DIR/bamtofastq_linux --nthreads=${nthreads} ${bam_file} fastq_out
    cd $BASE_DIR/fastq_out
    tar cvf $BASE_DIR/${sample_id}_fastq.tar .
  }

  output {
    File fastq_tar = "${sample_id}_fastq.tar"
    File out = stdout()
  }

  runtime {
   cpu: "${nthreads}"
  }
}

workflow bam_to_fastq {
  
  input {
    String os = "macos"
    String version = "v1.3.5"

    String sample_id
    
    Int nthreads = 30
    File bam_file
  }
    
  call bam_to_fastq_10x {
    input:
      bam_file = bam_file,
      os = os,
      version = version,
      nthreads = nthreads,
      sample_id = sample_id
  }

  output {
    File fastq_tar = bam_to_fastq_10x.fastq_tar
    File out = bam_to_fastq_10x.out
  }
}
