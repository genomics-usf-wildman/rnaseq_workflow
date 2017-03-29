library("XML")
library("data.table")
library("rentrez")
library("tools")

args <- commandArgs(trailingOnly=TRUE)

command <- args[1]

args <- args[-1]

##' Search and fetch things from entrez
##'
##' 
##' @title entrez.search.fetch
##' @param db Entrez database
##' @param term Term to search for
##' @param rettype Return type
##' @return character string of results
##' @author Don Armstrong <don@donarmstrong.com>
entrez.search.fetch <- function(db,term,rettype="native") {
    entrez_fetch(db=db,
                 entrez_search(db=db,term=term,retmax=2000)$id,
                 rettype=rettype)
}
##' Get GSM identifier from a GSE identifier
##'
##' Return character vector of GSM identifiers given a GSE identifier
##' @title get.entrez.samples
##' @param gse GSE identifer
##' @return character vector of GSM identifiers
##' @author Don Armstrong <don@donarmstrong.com>
get.entrez.samples <- function(gse) {
    en.res <-
        entrez.search.fetch(db="gds",
                            term=gse,
                            rettype="native")
    stringr::str_match_all(en.res,"Accession: (GSM\\d+)")[[1]][,2]
}
##' Get SRR/SRX details for a specific GSM
##'
##' Returns a data.table of sra, srx, and nreads details given a
##' specific GSM
##' @title get.entrez.sra.srx
##' @param gsm GSM identifer
##' @return data.table of sra, srx and nreads
##' @author Don Armstrong <don@donarmstrong.com>
get.entrez.sra.srx <- function(gsm) {
    en.res <-
        entrez.search.fetch(db="sra",
                            term=gsm,
                            rettype="native")
    srx.id <-
        as.character(XML::xmlToDataFrame(XML::getNodeSet(XML::xmlParse(en.res),
                                                         path="//EXPERIMENT/IDENTIFIERS/PRIMARY_ID")
                                         )[,"text"])
    srr.ids <-
        as.character(XML::xmlToDataFrame(XML::getNodeSet(XML::xmlParse(en.res),
                                                         path="//RUN_SET/RUN/IDENTIFIERS/PRIMARY_ID")
                                         )[,"text"])
    srr.nreads <-
        sapply(XML::getNodeSet(XML::xmlParse(en.res),
                               path="//RUN_SET/RUN/Statistics"),
               function(x){xmlAttrs(x)["nreads"]}
               )
    temp <- data.frame(GSM=gsm,SRX=srx.id,SRR=srr.ids,NREADS=srr.nreads)
    rownames(temp) <- srr.ids
    temp
}

if (command == "samples_from_entrez") {

    ## get samples from the GSE passed
    entrez.samples <- sapply(args[-length(args)],get.entrez.samples)
    ## get SRA/SRX details
    sra.srx <- rbindlist(lapply(entrez.samples,get.entrez.sra.srx))
    ## write those details to a file for later use
    fwrite(sra.srx,
           file=args[length(args)])
} else if (command == "write_srx") {
    sra.srx <- fread(args[1])
    mk.output <-
        paste0("SRX_FILES=",paste(collapse=" ",sra.srx[,unique(SRX)]),"\n")
    for(srx in sra.srx[,unique(SRX)]) {
        mk.output <- paste0(mk.output,
                            srx,"_SRR=",paste(collapse=" ",
                                              sra.srx[SRX==srx,SRR]),"\n")
    }
    cat(mk.output,
        file=args[length(args)])
} else if (command == "make_srx_dirs") {
    sra.srx <- fread(args[1])
    for (srx in sra.srx[,unique(SRX)]) {
        if (!dir.exists(srx)) {
            dir.create(srx)
        }
        wd <- getwd()
        setwd(srx)
        if (file.exists("Makefile"))
            file.remove("Makefile")
        file.symlink("../srx_makefile.mk","Makefile")
        srr.mk <- paste0("SRX=",srx,"\n",
                         "SRRS=",gsub(","," ",sra.srx[SRX==srx,SRR]),"\n",
                         "NREADS=",sra.srx[SRX==srx,NREADS],"\n"
                         )
        cat(srr.mk,file="srx_info.mk.new")
        if (!file.exists("srx_info.mk") ||
            !(md5sum("srx_info.mk")==md5sum("srx_info.mk.new"))) {
            file.rename("srx_info.mk.new","srx_info.mk")
        } else {
            file.remove("srx_info.mk.new")
        }
        setwd(wd)
    }
} else {
    stop(paste0("Unsupported command: ",command))
}
    
