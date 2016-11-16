RNAseq Workflow
---------------

Directions for Use
------------------

To your existing git repository, run:

`git submodule add https://github.com/uiuc-cgm/rnaseq_workflow.git`

to add a submodule, then in your directory which contains your fastq files, run:

    ln ../rnaseq_workflow/common_makefile Makefile -s
    cp ../rnaseq_workflow/project.mk project.mk

Now, edit the project.mk which you just created to match your project

Editing `project.mk`
===================

`project.mk` contains various options which you can set, and has
comments describing how the options operate.

The most important two options which need to be set are `NREADS` which
indicates whether a sample is using paired-end (2) or single-ended (1)
reads, and `FASTQ_FILES`, which gives the list of fastq files.

For paired end reads, the fastq files must end in `_1.fastq.gz` and
`_2.fastq.gz` so that the makefile knows which read pair belongs with
which sample. You can generate files with this naming scheme by using
`ln -s` to symlink the files obtained from the sequencing core in a
subdirectory (say `raw_data`) to the directory containing the
`Makefile` and `project.mk` files. For example, if you had files named
`2011250397_131_ATTACTCG-TCAGAGCC_L00M_R2_001.fastq.gz` in the rawdata
directory, then:

    for file in $(cd raw_data/; ls -1 *.fastq.gz); do
        ln -s raw_data/$file $(echo $file|sed 's_/_[ATCC-]_L00._R\([12]\)_001/\1/');
    done;


will create those symlinks. You may need to modify the sed line as appropriate.

Getting remote files
====================

