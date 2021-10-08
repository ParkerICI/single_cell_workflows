version 0.1

task hello {
  input {
    String name
  }

  command {
    echo 'hello ${name}!'
  }
  output {
    File response = stdout()
  }
  runtime {
   docker: 'quay.io/cumulus/cellranger:6.1.1'
  }
}

workflow test {
  call hello
}
