# Rerunning RNAseq on GEO files

This directory contains some additional files to make rerunning our
standard RNAseq pipeline on existing GEO datasets with data in SRAdb
fairly easy.

# Directions for use

To your existing git repository, run:

`git submodule add https://github.com/uiuc-cgm/rnaseq_workflow.git`

to add a submodule, then in your directory which you want the SRX
fastq files, run:

`../rnaseq_workflow/geo_analysis/set_up_workflow.sh`

Edit `gse_families.mk` to list the GSE identifiers that you would like
to analyze.

Edit the project.mk which you just created to match your project
settings. See the main README.md for details.

