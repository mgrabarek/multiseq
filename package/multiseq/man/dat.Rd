% Generated by roxygen2 (4.0.2): do not edit by hand
\docType{data}
\name{dat}
\alias{dat}
\title{A list containing counts, covariates and metadata from a ChIP-Seq experiment
with a pattern of differential Transcription Factor Binding.}
\format{A list with elements: \code{x} a 4 by 2^14 matrix of counts (4 is the
number of samples and 2^14 is the number of adjacent bases where reads have been
counted),\code{read.depth} a 4-dimensional vector specifiying the total number
of counts per sample, \code{g} a 4-dimensional vector specifying a
binary covariate for each sample, \code{region} a string specifiying the region
reads were mapped to, \code{assembly} a string specifying the genome that reads
were mapped to, \code{samples} containing metadata about the samples.}
\description{
This dataset consists of count data from a HudsonAlpha Institute (HaibTf)
ChIP-Seq experiment on Gm12878 and H1hesc cell lines with factor Yy1 that is part of
the ENCODE project. Mapped reads were downloaded from http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeHaibTfbs/,
peaks were downloaded from http://ebi.edu.au/ftp/software/software/ensembl/encode/integration_data_jan2011/byFreeze/june2012/peaks/spp/optimal/.
Read counts in region chr1:11740409-11756792 were extracted from the bam files
with function \code{\link{get.counts}}.
}
\keyword{datasets}

