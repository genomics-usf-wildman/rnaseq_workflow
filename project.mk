# -*- mode: make -*-

# This file contains information about all of the variables that can
# be set for this workflow

# Files should not have spaces in them; make doesn't deal particularly
# well with spaces.

# If you change an option, don't forget to uncomment (remove the
# leading #) the line that youv'e changed. Commented lines indicate
# the defaults

# Required options

# Number of reads per fragment; 2 is paired-end, 1 is unpaired. This
# actually defaults to 1, but you probably don't really want that.
NREADS=2 

# List of FASTQ files; must be named _1 _2 for paired-end,
# unrestricted for unpaired
FASTQ_FILES=file1_1.fastq.gz file1_2.fastq.gz file2_1.fastq.gz file2_2.fastq.gz

# Everything else below is optional

## The species that this data is
# SPECIES=homo_sapiens
## The species to align it to; usually the same as $(SPECIES)
# ALIGNMENT_SPECIES=$(SPECIES)

## GTF and FASTA from Ensembl
# GTF=$(REFERENCE_DIR)Homo_sapiens.GRCh38.$(ENSEMBL_RELEASE).gtf
# FASTA=$(REFERENCE_DIR)Homo_sapiens.GRCh38.dna.toplevel.fa

## if you were using mouse, this would be
# SPECIES=mus_musculus
# GTF=$(REFERENCE_DIR)Mus_musculus.GRCm38.$(ENSEMBL_RELEASE).gtf
# FASTA=$(REFERENCE_DIR)Mus_musculus.GRCm38.dna.toplevel.fa

### in some cases (more recent mouse genomes) cufflinks cannot handle
### certain features in the GTF file, and you may need to fix the GTF
### file. Use the following rule (for mice) to clean that up. See
### https://github.com/cole-trapnell-lab/cufflinks/issues/77 for the
### issue which brought this up. (Hopefully fixed in cufflinks
### versions newer than 2.2.1
# CUFFLINKS_GTF=$(REFERENCE_DIR)Mus_musculus.GRCm38.$(ENSEMBL_RELEASE)_fixed.gtf
# $(CUFFLINKS_GTF): $(GTF)
# 	grep -v '\tSelenocysteine\t' $^ > $@

## The ensembl release to use
# ENSEMBL_RELEASE=84

## Whether to strip out patches or not; probably only useful for Homo
## Sapiens
# STRIP_PATCHES=1
# STRIP_PATCHES_SCRIPT=./rnaseq_workflow/strip_patches.pl

# Options for cufflinks; --max-bundle-frags avoids HIDATA errors
# CUFFLINKS_OPTIONS=--max-bundle-frags=400000000
