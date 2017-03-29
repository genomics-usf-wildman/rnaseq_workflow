#!/bin/bash


set -e

base_dir=$(dirname $0)

link_if_ne() {
    if ! [ -e $1 ]; then
        ln -s $base_dir/$2 $1;
    fi;
}

copy_if_ne() {
    if ! [ -e $1 ]; then
        cp $base_dir/$2 $1;
    fi;
    
}

### link necessary files
link_if_ne Makefile gse_project.mk;
link_if_ne common_makefile.mk ../common_makefile
link_if_ne srx_makefile.mk srx_makefile.mk
link_if_ne srx_utils.R srx_utils.R

### 
copy_if_ne project.mk ../project.mk
copy_if_ne gse_families.mk gse_families.mk
