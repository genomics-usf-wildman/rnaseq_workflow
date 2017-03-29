#!/usr/bin/make -f

REFERENCE_DIR?=../ref_seqs/
COMMON_MAKEFILE?=../common_makefile.mk

-include ../project.mk

include srx_info.mk

ifeq ($(NREADS),1)
FASTQ_FILES:=$(patsubst %,%.fastq.gz,$(SRRS))
TOPHAT_FASTQ_ARGUMENT:=$(shell echo $(FASTQ_FILES)|sed 's/  */,/g')
else
FASTQ_FILES:=$(patsubst %,%_1.fastq.gz,$(SRRS))  $(patsubst %,%_2.fastq.gz,$(SRRS))
TOPHAT_FASTQ_ARGUMENT:=$(shell echo $(patsubst %,%_1.fastq.gz,$(SRRS))|sed 's/  */,/g') $(shell echo $(patsubst %,%_2.fastq.gz,$(SRRS))|sed 's/  */,/g')
endif

SRR_FILES=$(patsubst %,%.sra,$(SRRS))

get_srr: $(FASTQ_FILES)

make_fastq: $(FASTQ_FILES)

ifeq ($(NREADS),1)
$(FASTQ_FILES): %.fastq.gz: srx_info.mk
else
%_1.fastq.gz %_2.fastq.gz: srx_info.mk
endif
	$(MODULE) load sratoolkit/2.3.5-2; \
	fastq-dump -B --split-3 --gzip $*;


include $(COMMON_MAKEFILE)
