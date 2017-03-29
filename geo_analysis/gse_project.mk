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
	$(MODULE) load R/3.2.0; \
	$(R) $(ROPTS) -f $< --args samples_from_entrez $(GSE_FAMILIES) $@

srx.mk: srx_utils.R gse_srx_info.txt
	$(MODULE) load R/3.2.0; \
	$(R) $(ROPTS) -f $< --args write_srx $(wordlist 2,$(words $^),$^) $@

make_srx_dirs: srx_utils.R gse_srx_info.txt
	$(MODULE) load R/3.2.0; \
	$(R) $(ROPTS) -f $< --args make_srx_dirs $(wordlist 2,$(words $^),$^)

get_srr: $(patsubst %,%-get_srr,$(SRX_FILES))

$(patsubst %,%-get_srr,$(SRX_FILES)): %-get_srr: %
	+make -C $* get_srr

.PHONY: get_srr
