# EpiILMCT: Continuous Time Distance-Based and Network-Based Individual Level Models for Epidemics
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/EpiILMCT)](https://cran.r-project.org/package=EpiILMCT)
[![Downloads](https://cranlogs.r-pkg.org/badges/EpiILMCT)](https://cran.r-project.org/package=EpiILMCT)
[![Licence](https://img.shields.io/badge/licence-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)
[![Rdoc](http://www.rdocumentation.org/badges/version/EpiILMCT)](http://www.rdocumentation.org/packages/EpiILMCT)

The R package *EpiILMCT* provides tools for simulating from continuous-time individual level models of disease transmission, and carrying out infectious disease data analyses with the same models. The epidemic models considered are distance-based and contact network-based models within Susceptible-Infectious-Removed (SIR) or Susceptible-Infectious-Notified-Removed (SINR) compartmental frameworks.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
Give examples
```

### Installing
You can install the **stable** version from
[CRAN](https://cran.r-project.org/package=EpiILMCT).

```s
install.packages('EpiILMCT', dependencies = TRUE)
```

You can install the **development** version from
[Github](https://github.com/walee2001d/EpiILMCT-package)

```s
# install.packages("devtools")
devtools::install_github("walee2001d/EpiILMCT-package")
```

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
control.strtegy <- function(object, inf.time, par.sus, par.ker, delt, cov.sus = NULL, radius = 1){
	
	if (class(object) == "datagen") {
		if (object$kerneltype == "network") {
			ker.mat <- object$network
			n       <- length(object$network[,1])
			des.ker <- NULL
		} else if (object$kerneltype == "distance") {
			ker.mat <- as.matrix(object$location)
			n       <- length(object$location[,1])
			des.ker <- "powerlaw"
		} else if (object$kerneltype == "both") {
			ker.mat <- list(as.matrix(object$location), object$network)		
			n       <- length(object$location[,1])
			des.ker <- "powerlaw"
		}
	}
	
	tss <- object$epidat
	
	cov1 <- cov.sus
	
	dis <- as.matrix(dist(object$location))

	for (i in 2:length(inf.time)) {
		
		mn <- sum(tss[,4] <= inf.time[i-1])
		
		initial1<-matrix(tss[1:mn,], ncol = 4, nrow = mn)
		
		tss1 <- datagen(type = object$type, kerneltype = object$kerneltype, kernelmatrix = ker.mat, 
		distancekernel = des.ker, initialepi = initial1, tmax = inf.time[i], 
		suspar = par.sus, transpar = NULL, kernel.par = par.ker, delta = delt,
		transcov = NULL, suscov = cov1)
	
		tss <- tss1$epidat
		newlyinfected <- tss[which(tss[,4] > inf.time[i-1] & tss[,4] <= inf.time[i]), 1]
		num.infected  <- sum(tss[,2] != Inf)
		uninfected <- tss[(num.infected+1):n,1]

# All individuals in the surrounded circle of a radius (radius) of the newly infected are removed:
		for (j in 1:length(newlyinfected)) {
			mk <- as.integer(which(dis[newlyinfected[j], uninfected] < radius))
			if (length(mk) > 0) {
				cov1[uninfected[mk],] = 0
			}
		}

	
	}

list(tss1,cov1)

}

library(future.apply)
library(EpiILMCT)
data(tswv)

epi<-tswv$tswvsir

rr<-seq(1, 10)
inf.time <- seq(2,7,by=0.5)
par.sus <- 0.01
par.ker <- 1.3
delt <- c(9, 3)
sus.cov <- matrix(rep(1, 520), ncol = 1)

summary.results <- list(NULL)

for(i in 1:length(rr)) {

	mb <- seq(1,32)
	posterior.pred<-function(x){
	
		epi.cont<-control.strtegy(object = epi, inf.time, par.sus, par.ker, delt, cov.sus = sus.cov, radius = rr[i])
		numb.infected    <- sum(epi.cont[[1]]$epidat[,2]!=Inf)
		length.infection <- max(epi.cont[[1]]$epidat[1:numb.infected,2])-min(epi.cont[[1]]$epidat[1:numb.infected,4])
		max.infection    <- max(epi.cont[[1]]$epidat[1:numb.infected,4])
		ratio            <- apply(epi.cont[[2]], 2, sum)/520
		
		result <- c(numb.infected, length.infection, max.infection, ratio)

	}
	
	plan(multiprocess, workers = 4) ## Parallelize using 
	datmcmc <- future_lapply(mb,FUN= posterior.pred, future.seed = TRUE)
	summary.results[[i]] <-sapply(datmcmc, unlist, simplify=TRUE)

}


mu <- matrix(0, ncol = 4, nrow = 10)
for(j in 1:10){
mu[j,] <- apply(summary.results[[j]], 1, mean)
}

par(mfrow = c(2,2))
plot(rr, mu[,1], type="o", ylab = "Number of infected", xlab = "radius")
plot(rr, mu[,2], type="o", ylab = "Length of epidemic", xlab = "radius")
plot(rr, mu[,3], type="o", ylab = "Maximum infection times", xlab = "radius")
plot(rr, mu[,4], type="o", ylab = "Ratio", xlab = "radius")
```

## Deployment


## Built With

* [R](https://cran.r-project.org) - The Comprehensive R Archive Network

## Contributing


## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Waleed Almutiry** - *Maintainer*
* **Rob Deardon** - *Maintainer*

## License

This project is licensed under the GNU General Public License,  version 3 - see the (http://www.r-project.org/Licenses/GPL-3) file for details.

## Acknowledgments
