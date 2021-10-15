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
    export BASE_DIR=`pwd`
    echo "BASE_DIR=$BASE_DIR"
    curl -L https://github.com/10XGenomics/bamtofastq/releases/download/${version}/bamtofastq_${os} --output $BASE_DIR/bamtofastq
    chmod +x $BASE_DIR/bamtofastq
    $BASE_DIR/bamtofastq --nthreads=${nthreads} ${bam_file} $BASE_DIR/fastq
    cd $BASE_DIR/fastq
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
