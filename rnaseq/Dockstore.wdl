version 1.0

task cellranger_count {

  input {
    String base_dir = "/usr/gitc"
    String transcriptome_name
    File transcriptome_tar
    File fastq_tar
    String sample_id
    String extra_args
    Int local_cores
    Int local_mem
  }

  command {
    tar xvf ${transcriptome_tar}
    tar xvf ${fastq_tar} &> tar_output.txt

    ls -alh
    echo "tar_output="
    cat tar_output.txt

    python <<CODE
    import os
    def write_fastq_dirs(tar_output_file, output_file):
      with open(tar_output_file, 'r') as f:
        lines = f.readlines()
      print('lines=')
      print(lines)
      fpaths = [line.strip() for line in lines if len(line.strip()) > 0]
      print('fpaths=')
      print(fpaths)
      fastq_ext = ['fastq', 'fa', 'fq', 'fasta']
      root_dirs = dict()
      for p in fpaths:
        print('p=',p)
        ext_list = [p.endswith(ext) or p.endswith(ext + '.gz') for ext in fastq_ext]
        if any(ext_list):
          root_dir = p.split('/')[0]
          root_dirs[root_dir] = True
      
      with open(output_file, 'w') as f:
        f.write(','.join(root_dirs.keys()))

    if os.path.exists('tar_output.txt'):
      write_fastq_dirs('tar_output.txt', 'fastq_dirs.txt')  
    CODE

    ls -alh
    echo "fastq_dirs="
    cat fastq_dirs.txt

    export FASTQ_DIRS=`cat fastq_dirs.txt`

    ${base_dir}/cellranger/cellranger count ${extra_args} \
      --transcriptome=${transcriptome_name} \
      --disable-ui \
      --no-bam \
      --id ${sample_id} \
      --fastqs $FASTQ_DIRS \
      --localcores ${local_cores} \
      --localmem ${local_mem}

    tar cvzf ${sample_id}_cellranger_output.tgz ${sample_id}
  }

  output {
    File cellranger_output = "${sample_id}_cellranger_output.tgz"
    File out = stdout()
    File err = stderr()
  }

  runtime {
   cpu: "${local_cores}"
   memory: "${local_mem}GB"
   disks: "local-disk 350 SSD"
   docker: "gcr.io/pici-internal/cellranger:6.1.1"
  }
}

workflow cellranger_rnaseq {
  
  input {
    String transcriptome_name = "GRCh38.p13.egfr"
    File transcriptome_tar = "gs://pici-genome-references-master/files-for-specific-methods/cellranger_rnaseq/${transcriptome_name}.tar"
    String extra_args = " "
    Int local_cores = 1
    Int local_mem = 1

    File fastq_tar
    String sample_id
  }

  call cellranger_count {
    input:
      transcriptome_name = transcriptome_name,
      transcriptome_tar = transcriptome_tar,
      fastq_tar = fastq_tar,
      sample_id = sample_id,
      extra_args = extra_args,
      sample_id = sample_id,
      local_cores = local_cores,
      local_mem = local_mem
  }

  output {
    File cellranger_output = cellranger_count.cellranger_output
    File out = cellranger_count.out
    File err = cellranger_count.err
  }
}
