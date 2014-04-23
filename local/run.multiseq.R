#usage
#Rscript run.multiseq.R $samplesheet $chr":"$locus.start"-"$locus.end $multiseq.output.folder "test/multiseq" "chromosome.lengths.hg19.txt" "hg19.ensGene.gp.gz" 



#********************************************************************
#
#     Get arguments
#
#********************************************************************
args            <- commandArgs(TRUE)
samplesheet     <- args[1]
region          <- args[2]
dir.name        <- file.path(args[3])
hub.name        <- args[4]
chrom.file      <- file.path(args[5])
assembly        <- args[6]
annotation.file <- file.path(args([7]) 
#locus.start     <- as.numeric(args[2])+1

#PARAMETERS
#how many sd to plot when plotting effect size 
fra             <- 2  
do.plot         <- FALSE
do.smooth       <- FALSE
do.summary      <- TRUE
do.save         <- TRUE

                             
samples         <- read.table(samplesheet, stringsAsFactors=F, header=T)   
g               <- factor(samples$Tissue)
g               <- match(g, levels(g)) - 1  

split_region = unlist(strsplit(region, "\\:|\\-"))
chr=split_region[1]
locus.start=split_region[2]
locus.end=split_region[3]
locus.name <- paste(chr, locus.start, locus.end, sep=".")
dir.create(dir.name)
dir.name   <- file.path(dir.name, locus.name)
dir.create(dir.name)
                             
M <- get.counts(samples, region)

if (sum(M)<10){
    if (do.summary){
        write.table(t(c(chr, locus.start, locus.end, NA, NA)),
                    quote = FALSE,
                    col.names=FALSE,
                    row.names=FALSE,
                    file=file.path(dir.name,"summary.txt"))
    }
    stop("Total number of reads over all samples is <10. Stopping.")
}

print("Compute effect")
if (do.summary)
    ptm      <- proc.time()
res <- multiseq(M, g=g, minobs=1, lm.approx=FALSE, read.depth=samples$ReadDepth)
if (do.summary)
    my.time  <- proc.time() - ptm

res$chr=chr
res$locus.start=locus.start
res$locus.end=locus.end
res <- get.effect.intervals(res,fra)
    
if (do.save){
        #save results in a compressed file 
    write.effect.mean.variance.gz(res,dir.name)
    write.effect.intervals(res,dir.name,fra=2)
}

#plotting
if (do.plot){
    print("Plot Effect")
    # Extract gene model from genePred annotation file
    Transcripts <- get.Transcripts(annotation, chr, locus.start, locus.end)

    pdf(file=file.path(dir.name, "Effect.pdf"))
    layout(matrix(c(1,2), 2, 1, byrow = FALSE))
    #centipede <- read.table("/mnt/lustre/data/share/DNaseQTLs/CentipedeAndPwmVar/CentipedeOverlapMaxP99.UCSC
    #sites     <- centipede[centipede[,1] == chr & centipede[,2] < (locus.end+1) & centipede[,3] > locus.start, ]
    #offset    <- -0.25 #0.0025 
    #if (dim(sites)[1] > 0){for (k in 1:dim(sites)[1]){offset <-  -offset
    #text(x=(sites[k,2] + sites[k,3])/2, y=(ymax/2 -abs(offset) - offset), strsplit(as.character(sites[k,4]), split="=")[[1]][2])
    #rect(sites[k,2], 0, sites[k,3], ymax/2 + 1, col=rgb(0,0,1,0.3), border='NA')}}
    par(mar=c(0,3,2,1))
    plotResults(res)
    par(mar=c(4,3,0,1))
    plotTranscripts(Transcripts, locus.start, locus.end)
    dev.off()
}

#************************************************************
#
#    Apply cyclespin to each genotype class
#
#*************************************************************
if (do.smooth==TRUE){
    print("Smooth by group")
    res0 <- multiseq(M[g==0,], minobs=1, lm.approx=FALSE, read.depth=samples$ReadDepth[g==0])
    res1 <- multiseq(M[g==1,], minobs=1, lm.approx=FALSE, read.depth=samples$ReadDepth[g==1])
    
    if (do.plot==TRUE){
        print("Plot smoothed signals")
        pdf(file=file.path(dir.name,"Smoothing_by_group.pdf"))
        ymax <- max(c(as.vector(res0$est + fra*sqrt(res0$var)), as.vector(res1$est + fra*sqrt(res1$var))))
        ymin <- min(c(as.vector(res0$est - fra*sqrt(res0$var)), as.vector(res1$est - fra*sqrt(res1$var))))
        ylim <- c(ymin, ymax)
        layout(matrix(c(1,2,3,4), 4, 1, byrow = FALSE))
        par(mar=c(0,3,2,1))
        plotResults(res0, title=paste0("Smoothed ", samples$Tissue[g==0][1]), ylim=ylim, type="baseline")
        par(mar=c(0,3,2,1))
        plotResults(res1, title=paste0(samples$Tissue[g==1][1]), ylim=ylim, type="baseline")
        par(mar=c(0,3,2,1))
        plotTranscripts(Transcripts, locus.start, locus.end)
        dev.off()
    }
}

if (!is.null(hub.name)){
    multiseq.folder=file.path(args[3]) 
    multiseqToTrackHub(region, hub.name, multiseq.folder, chrom.file, assembly)
}