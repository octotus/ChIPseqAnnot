# ChIPseqAnnot
Set of scripts for annotating chIP-seq results

Set of R / Python scripts for annotating ChIP-seq (from MACS2) results.
The R script depends on the following libraries from Bioconductor:
  #BiocInstaller::biocLite("TxDb.Mmusculus.UCSC.mm10.knownGene")
  #BiocInstaller::biocLite("TxDb.Hsapiens.UCSC.hg38.knownGene")
  #BiocInstaller::biocLite("EnsDb.Hsapiens.v75")
  #BiocInstaller::biocLite("EnsDb.Mmusculus.v79")
  
Currently the script works for Human (hg38) and Mouse (mm10). Other genomes can be added to the script as needed.

The python script creates an Excel sheet out of All annotated Tables (result from R script). It imports glob and xlsxwriter (can be installed through pip).

All scripts have been tested on 
    RStudio v1.1.463 running R v3.5.2 on a Mac (OS X 10.14.6 -- Mojave).
    Python 3.7.1
