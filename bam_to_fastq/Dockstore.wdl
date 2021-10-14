version 1.0

task bam_to_fastq_10x {

  input {
    String os
    String version 
    File bam_file
    Int nthreads
  }

  command {
    echo "Hello"
    curl https://github.com/10XGenomics/bamtofastq/releases/download/${version}/bamtofastq_${os}
    echo "Post curl"
    echo `pwd`
    bamtofastq_${os} --nthreads=${nthreads} ${bam_file} ./fastq
  }

  output {
    Array[File] fastq_dirs = glob("./fastq/*")      
  }

  runtime {
   cpu: "${nthreads}"
  }
}

workflow bam_to_fastq {
  
  input {
    String os = "macos"
    String version = "v1.3.5"
    
    Int nthreads = 30

    File bam_file
  }
    
  call bam_to_fastq_10x {
    input:
      bam_file = bam_file,
      os = os,
      version = version,
      nthreads = nthreads
  }

  output {
    Array[File] fastq_dirs = bam_to_fastq_10x.fastq_dirs
  }
}
