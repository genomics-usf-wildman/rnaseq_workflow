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
