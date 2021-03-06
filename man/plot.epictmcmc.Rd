\name{plot.epictmcmc}
\alias{plot.epictmcmc}
\title{ Plot the output of \code{epictmcmc} object}
\description{
  \code{plot.epictmcmc} is an S3 method that plots the output of an S3 object of class \code{epictmcmc}. 
}
\usage{
\method{plot}{epictmcmc}(x, epi = NULL, plottype = NULL, start = NULL, end = NULL, 
thin = NULL, ...)
}
\arguments{
  \item{x}{an S3 object of class \code{epictmcmc} (i.e. the output of the \code{epictmcmc} function).}
  \item{epi}{epidemic data of class \code{datagen}.}
  \item{plottype}{determines which of three options to plot the output of the \code{epictmcmc} function are used: ``parameter'' produces trace plots for each of the model parameters, and ``inf.times'' (``rem.times'') produces plots of the average posterior and 95\% CI of the unobserved infection (removal) times when \code{datatype} set to ``known removal'' (``unknown removal'').}
  \item{start, end, thin}{options for creating \code{\link{mcmc}} object.}
  \item{...}{additional arguments that are passed to the generic \code{plot} function.}
}
\value{
  The argument \code{plottype} is used to specify the kind of plot produced. Trace and density plots of the posterior distribution of the model parameters can be obtained by setting \code{plottype} = ``parameter''. Additionally, in the case of unobserved infection (removal) times, a plot of the average posterior and 95\% percentile intervals of the inferred infection (removal) times are produced by setting \code{plottype} = ``inf.times'' (``rem.times'').
}
\seealso{
  \code{\link{epictmcmc}}, \code{\link{print.epictmcmc}}, \code{\link{summary.epictmcmc}}, \code{\link{mcmc}}, \code{\link{plot.mcmc}}.
}
\keyword{plot}