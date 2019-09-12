#source('http://bioconductor.org/biocLite.R')
#BiocInstaller::biocLite("TxDb.Mmusculus.UCSC.mm10.knownGene")
#BiocInstaller::biocLite("TxDb.Hsapiens.UCSC.hg38.knownGene")
#BiocInstaller::biocLite("EnsDb.Hsapiens.v75")
#BiocInstaller::biocLite("EnsDb.Mmusculus.v79")

library("ChIPseeker")
library('clusterProfiler')
library('ChIPpeakAnno')

organism="Human" ## Change this if you want Mouse -- organism="Mouse"

## If you need any other organism than Human or Mouse (or different versions -- create the necessary modules below.

if(organism == "Mouse")
{
  library("EnsDb.Mmusculus.v79")
  library("org.Mm.eg.db")
  library("TxDb.Mmusculus.UCSC.mm10.knownGene")
  txdb <- TxDb.Mmusculus.UCSC.mm10.knownGene
  orgDB <- org.Mm.eg.db
}

if(organism == "Human")
{
  library("EnsDb.Hsapiens.v75")
  library('org.Hs.eg.db')
  library("TxDb.Hsapiens.UCSC.hg38.knownGene")
  txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene
  orgDB <- org.Hs.eg.db
}

library(randomcoloR)
#files<- getSampleFiles()

promoter <- getPromoters(txdb, upstream = 5000, downstream = 5000)
flist <- list.files(".",pattern = "narrowPeak$")
colors <- distinctColorPalette(k = length(flist))

#flist1 <- '';
#for(i in 1:length(flist))
#{
#  flist1[i] <- unlist(strsplit(flist[i],"\\."))[1];
#}

for(i in 1:length(flist))
{
  x <- readPeakFile(flist[i],header=F)
  prefix <- unlist(strsplit(flist[i],"\\."))[1];
    tagMatrix <- getTagMatrix(x,windows = promoter)
    fout <- paste(prefix,"Summary.pdf",sep="")
    pdf(fout)
    #plotAvgProf(tagMatrix,xlim=c(-5000,5000),xlab = "TSS Region -5K to +5K", ylab="Read Count Freq.",conf = 0.95, resample = 1000)
    annotated_peaks <- annotatePeak(x,tssRegion = c(-3000,3000),TxDb = txdb, annoDb = orgDB)
    plotAnnoPie(annotated_peaks)
    upsetplot(annotated_peaks)
    dev.off()
}


#par(mfrow=c(1,length(flist)))
# for(i in 1:7)
# {
#   x <- readPeakFile(flist[i],header=F)
#  tagMatrix <- getTagMatrix(x,windows = promoter)
#   tagHeatmap(tagMatrix,xlim=c(-5000,5000),xlab="TSS",color = colors[i])
# }


annoGR <- toGRanges(txdb)
for(i in 1:length(flist))
{
  x <- readPeakFile(flist[i],header=F)
  x_anno <- annoPeaks(x,annoGR,bindingRegion = c(-5000,5000))
## xGeneID will contain gene annotations
  xGeneID = addGeneIDs(x_anno, orgDB, IDs2Add = c("symbol"),feature_id_type = "entrez_id", silence = TRUE)
  fn_out <- paste(flist[i],".annot.tbl",sep="")
  write.table(xGeneID,file=fn_out,sep="\t",quote=F)
}
## WRAP THE LOOP OVER THE NEXT SECTION FOR GO ANALYSIS
xGO <- '';
for(i in 1:length(flist))
{
  xGO <- clusterProfiler::enrichGO(xGeneID$feature,OrgDb = orgDB,ont = "MF", pAdjustMethod = "BH",qvalueCutoff = 0.1)
  fn_out <- paste(flist[i],".GO.MF.results",sep="")
  write.table(xGO,file=fn_out,sep="\t",quote=F)

  xGO <- clusterProfiler::enrichGO(xGeneID$feature,OrgDb = orgDB,ont = "BP", pAdjustMethod = "BH",qvalueCutoff = 0.1)
  fn_out <- paste(flist[i],".GO.BP.results",sep="")
  write.table(xGO,file=fn_out,sep="\t",quote=F)
}

for(i in 1:length(flist))
{
  prefix <- unlist(strsplit(flist[i],"\\."))[1];
  fn <- paste(prefix,".tagmatrix.pdf",sep="");
  pdf(fn,height=9,width=5);
  x <- readPeakFile(flist[i],header=F);
  tagMatrix <- getTagMatrix(x,windows = promoter);
  tagHeatmap(tagMatrix,xlim=c(-5000,5000),xlab="TSS",color = colors[i],title=flist[i])
  dev.off()
}

