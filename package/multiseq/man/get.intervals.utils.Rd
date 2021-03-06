% Generated by roxygen2 (4.0.2): do not edit by hand
\name{get.intervals.utils}
\alias{get.intervals.utils}
\title{helper function to get.intervals}
\usage{
get.intervals.utils(mean, var, what, z.threshold, p.threshold, region)
}
\arguments{
\item{mean:}{an estimated vector of means.}

\item{var:}{an estimated vector of variances.}

\item{what:}{a string, it can be either "baseline" or "log_baseline" or "effect".}

\item{z.threshold:}{a multiplier of the standard deviation.}

\item{p.threshold:}{this argument is only used when \code{what=="baseline"} or \code{what=="log_baseline"} to specify a threshold for the detection of peaks: if \code{mean-z.threshold*sqrt(var)>p.threshold} then a peak is called.}

\item{region:}{a string specifying a genomic region: reference sequence name, start position, end position; defaults to NULL; if provided, the function will output the interval in genomic coordinates.}
}
\description{
Output interval is in \code{bed} format (\code{start} is 0-based, \code{end} is 1-based).
}
\keyword{internal}

