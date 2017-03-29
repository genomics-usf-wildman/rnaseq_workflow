#!/usr/bin/make -f

-include gse_families.mk
-include srx.mk

### module is how the biocluster loads specific versions; if we're not
### running there, we'll assume the correct version is installed and
### just echo what we're loading
ifdef MODULEPATH
MODULE=module
else
MODULE=echo
endif

R?=R
ROPTS?=--no-save --no-restore -q

GSE_FAMILES?=

gse_srx_info.txt: srx_utils.R
	$(MODULE) load R; \
	$(R) $(ROPTS) -f $< --args samples_from_entrez $(GSE_FAMILIES) $@

srx.mk: srx_utils.R gse_srx_info.txt
	$(MODULE) load R; \
	$(R) $(ROPTS) -f $< --args write_srx $(wordlist 2,$(words $^),$^) $@

make_srx_dirs: srx_utils.R gse_srx_info.txt
	$(MODULE) load R; \
	$(R) $(ROPTS) -f $< --args make_srx_dirs $(wordlist 2,$(words $^),$^)

submit_trimmed_fastqc: $(patsubst %,%-submit_trimmed_fastqc,$(SRX_FILES))

submit_alignment: $(patsubst %,%-submit_alignment,$(SRX_FILES))

submit_call: $(patsubst %,%-submit_call,$(SRX_FILES))

$(patsubst %,%-submit_trimmed_fastqc,$(SRX_FILES)): %-submit_trimmed_fastqc:
	+make -C $* submit_trimmed_fastqc

$(patsubst %,%-submit_alignment,$(SRX_FILES)): %-submit_alignment:
	+make -C $* submit_alignment

$(patsubst %,%-submit_call,$(SRX_FILES)): %-submit_call:
	+make -C $* submit_call

get_srr: $(patsubst %,%-get_srr,$(SRX_FILES))

$(patsubst %,%-get_srr,$(SRX_FILES)): %-get_srr: %
	+make -C $* get_srr

.PHONY: get_srr submit_trimmed_fastqc submit_alignment submit_call
