works_with_R("2.15.2",breakpointError="1.0")

## experiment: calculate the breakpoint error and show the curve that
## demonstrates what exponent we need to pick for the number of points.

sample.signal <- function(d){
  locations <- round(seq(1,length(mu),l=d))
  last <- as.integer(locations[length(locations)])
  this.signal <- signal[locations]
  result <- run.cghseg(this.signal, locations)
  result$bases.per.probe <- factor(round(last/d))
  result$mu <- mu[locations]
  result$locations <- locations
  result$signal <- this.signal
  result$cost <-
    sapply(result$breaks, breakpointError, mu.break.after, last)
  result$crit <- function(lambda,alpha){
    J <- result$J.est
    Kseq <- seq_along(J)
    lambda * Kseq * d^alpha + J
  }
  result$lambda <- 10^seq(-3,3,l=200)
  result$kstar <- function(lambda,a){
    which.min(result$crit(lambda,a))
  }
  result$lambda.error <- function(a){
    lseq <- result$lambda
    k <- sapply(lseq,result$kstar,a)
    result$cost[k]
  }
  result$lambda.star <- function(a){
    error <- result$lambda.error(a) 
    l <- which(error == min(error))
    chosen <- l[ceiling(length(l)/2)]
    result$lambda[chosen]
  }
  result
}
  
set.seed(1)
seg.size <- 10000
means <- c(-3,0,3,1,-1,2,4)/3
mu <- do.call(c,lapply(means,rep,seg.size))
mu.break.after <- which(diff(mu)!=0)
signal <- rnorm(length(mu),mu,1)

signals <- list()
signal.size <- c(700, 7000)
n.signals <- length(signal.size)
for(sig.i in 1:n.signals){
  cat(sprintf("simulating signal %4d / %4d\n",sig.i,n.signals))
  d <- signal.size[sig.i]
  signals[[sig.i]] <- sample.signal(d)
}

save(signals,file="signals.RData")

