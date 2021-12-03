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

  Int local_mem_to_use = floor(0.9*local_mem)

  command {
    tar xvf "${transcriptome_tar}"
    tar xvf "${fastq_tar}" &> tar_output.txt

    ls -alh
    echo "tar_output="
    cat tar_output.txt

    python <<CODE
    import os
    def write_fastq_dirs(tar_output_file, output_file):
      with open(tar_output_file, 'r') as f:
        lines = f.readlines()
      fpaths = [line.strip() for line in lines if len(line.strip()) > 0]
      fastq_ext = ['fastq', 'fa', 'fq', 'fasta']
      root_dirs = dict()
      for p in fpaths:
        ext_list = [p.endswith(ext) or p.endswith(ext + '.gz') for ext in fastq_ext]
        if any(ext_list):
          file_parts = p.split('/')
          if len(file_parts) == 1:
            root_dir = '.'
          else:
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
      --id ${sample_id} \
      --fastqs "$FASTQ_DIRS" \
      --localcores ${local_cores} \
      --localmem ${local_mem_to_use}
  }

  output {
    File raw_counts = "${sample_id}/outs/raw_feature_bc_matrix.h5"
    File filtered_counts = "${sample_id}/outs/filtered_feature_bc_matrix.h5"
    File bam_aligned = "${sample_id}/outs/possorted_genome_bam.bam"
    File bam_aligned_index = "${sample_id}/outs/possorted_genome_bam.bam.bai"

    File metrics_summary = "${sample_id}/outs/metrics_summary.csv"
    File web_summary = "${sample_id}/outs/web_summary.html"

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
    String transcriptome_name = "GRCh38.p13"
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
    File raw_counts = cellranger_count.raw_counts
    File filtered_counts = cellranger_count.filtered_counts
    File bam_aligned = cellranger_count.bam_aligned
    File bam_aligned_index = cellranger_count.bam_aligned_index

    File metrics_summary = cellranger_count.metrics_summary
    File web_summary = cellranger_count.web_summary

    File out = cellranger_count.out
    File err = cellranger_count.err
  }
}
