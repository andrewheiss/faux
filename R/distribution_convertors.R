#' Convert normal to uniform
#'
#' Convert a uniform distribution to a normal (gaussian) distribution with specified mu and sd
#' 
#' @param x the uniformly distributed vector
#' @param mu the mean of the normal distribution to return
#' @param sd the SD of the normal distribution to return
#' @param min the minimum possible value of x (calculated from x if not given)
#' @param max the maximum possible value of x (calculated from x if not given)
#'
#' @return a vector with a gaussian distribution
#' @export
#'
#' @examples
#' 
#' x <- runif(10000)
#' y <- unif2norm(x)
#' g <- ggplot2::ggplot() + ggplot2::geom_point(ggplot2::aes(x, y))
#' ggExtra::ggMarginal(g, type = "histogram")
#' 
unif2norm <- function(x, mu = 0, sd = 1, min = NULL, max = NULL) {
  # tol prevents min and max values returning as -Inf and Inf
  tol <- 1/length(x)
  if (is.null(min)) min <- min(x) - tol
  if (is.null(max)) max <- max(x) + tol
  p <- stats::punif(x, min, max)
  stats::qnorm(p, mu, sd)
}

#' Convert normal to poisson
#'
#' @param x the normally distributed vector
#' @param lambda the mean of the distribution to return
#' @param mu the mean of x (calculated from x if not given)
#' @param sd the SD of x (calculated from x if not given)
#'
#' @return a vector with a poisson distribution
#' @export
#'
#' @examples
#' 
#' x <- rnorm(10000)
#' y <- norm2pois(x, 2)
#' g <- ggplot2::ggplot() + ggplot2::geom_point(ggplot2::aes(x, y))
#' ggExtra::ggMarginal(g, type = "histogram")
#' 
norm2pois <- function(x, lambda, mu = mean(x), sd = stats::sd(x)) {
  p <- stats::pnorm(x, mu, sd)
  stats::qpois(p, lambda)
}


#' Convert normal to beta
#'
#' @param x the normally distributed vector
#' @param shape1,shape2 non-negative parameters of the distribution to return
#' @param mu the mean of x (calculated from x if not given)
#' @param sd the SD of x (calculated from x if not given)
#'
#' @return a vector with a beta distribution
#' @export
#'
#' @examples
#' 
#' x <- rnorm(10000)
#' y <- norm2beta(x, 1, 3)
#' g <- ggplot2::ggplot() + ggplot2::geom_point(ggplot2::aes(x, y))
#' ggExtra::ggMarginal(g, type = "histogram")
#' 
norm2beta <- function(x, shape1, shape2, mu = mean(x), sd = stats::sd(x), ...) {
  p <- stats::pnorm(x, mu, sd)
  stats::qbeta(p, shape1, shape2, ...)
}


#' Convert normal to binomial
#'
#' @param x the normally distributed vector
#' @param size number of trials (0 or more)
#' @param prob the probability of success on each trial (0 to 1)
#' @param mu the mean of x (calculated from x if not given)
#' @param sd the SD of x (calculated from x if not given)
#'
#' @return a vector with a binomial distribution
#' @export
#'
#' @examples
#' 
#' x <- rnorm(10000)
#' y <- norm2binom(x)
#' g <- ggplot2::ggplot() + ggplot2::geom_point(ggplot2::aes(x, y))
#' ggExtra::ggMarginal(g, type = "histogram")
#' 
norm2binom <- function(x, size = 1, prob = 0.5, mu = mean(x), sd = stats::sd(x)) {
  p <- stats::pnorm(x, mu, sd)
  stats::qbinom(p, size, prob)
}


#' Convert normal to uniform
#' 
#' Convert a normal (gaussian) distribution to a uniform distribution with specified minimum and maximum
#'
#' @param x the normally distributed vector
#' @param min the minimum of the uniform distribution to return
#' @param max the maximum of the uniform distribution to return
#' @param mu the mean of x (calculated from x if not given)
#' @param sd the SD of x (calculated from x if not given)
#'
#' @return a vector with a uniform distribution
#' @export
#'
#' @examples
#' 
#' x <- rnorm(10000)
#' y <- norm2unif(x)
#' g <- ggplot2::ggplot() + ggplot2::geom_point(ggplot2::aes(x, y))
#' ggExtra::ggMarginal(g, type = "histogram")
#' 
norm2unif <- function(x, min = 0, max = 1, mu = mean(x), sd = stats::sd(x)) {
  p <- stats::pnorm(x, mu, sd)
  stats::qunif(p, min, max)
}

#' Convert normal to truncated normal
#' 
#' Convert a normal (gaussian) distribution to a truncated normal distribution with specified minimum and maximum
#'
#' @param x the normally distributed vector
#' @param min the minimum of the truncated distribution to return
#' @param max the maximum of the truncated distribution to return
#' @param mu the mean of the distribution to return (calculated from x if not given)
#' @param sd the SD of the distribution to return (calculated from x if not given)
#'
#' @return a vector with a uniform distribution
#' @export
#'
#' @examples
#' 
#' x <- rnorm(10000)
#' y <- norm2trunc(x, 1, 7, 3.5, 2)
#' g <- ggplot2::ggplot() + ggplot2::geom_point(ggplot2::aes(x, y))
#' ggExtra::ggMarginal(g, type = "histogram")
#' 
norm2trunc <- function(x, min = -Inf, max = Inf, mu = mean(x), sd = stats::sd(x)) {
  p <- stats::pnorm(x, mean(x), stats::sd(x))
  truncnorm::qtruncnorm(p, a = min, b = max, mean = mu, sd = sd)
}

#' Convert truncated normal to normal
#' 
#' Convert a truncated normal distribution to a normal (gaussian) distribution
#'
#' @param x the truncated normally distributed vector
#' @param min the minimum of the truncated distribution (calculated from x if not given)
#' @param max the maximum of the truncated distribution (calculated from x if not given)
#' @param mu the mean of the distribution to return (calculated from x if not given)
#' @param sd the SD of the distribution to return (calculated from x if not given)
#'
#' @return a vector with a uniform distribution
#' @export
#'
#' @examples
#' 
#' x <- truncnorm::rtruncnorm(10000, 1, 7, 3.5, 2)
#' y <- trunc2norm(x, 1, 7)
#' g <- ggplot2::ggplot() + ggplot2::geom_point(ggplot2::aes(x, y))
#' ggExtra::ggMarginal(g, type = "histogram")
#' 
trunc2norm <- function(x, min = min(x), max = max(x), 
                       mu = mean(x), sd = stats::sd(x)) {
  p <- truncnorm::ptruncnorm(x, a = min, b = max, mean = mu, sd = sd)
  stats::qnorm(p, mean = mu, sd = sd)
}

#' Convert normal to likert
#'
#' @param x the normally distributed vector
#' @param prob a vector of probabilities 
#' @param mu the mean of x (calculated from x if not given)
#' @param sd the SD of x (calculated from x if not given)
#'
#' @return a vector with a specified distribution
#' @export
#'
#' @examples
#' 
#' x <- rnorm(10000)
#' y <- norm2likert(x, c(.1, .2, .35, .2, .1, .05))
#' g <- ggplot2::ggplot() + ggplot2::geom_point(ggplot2::aes(x, y))
#' ggExtra::ggMarginal(g, type = "histogram")
#' 
#' y <- norm2likert(x, c(.4, .3, .2, .1))
#' g <- ggplot2::ggplot() + ggplot2::geom_point(ggplot2::aes(x, y))
#' ggExtra::ggMarginal(g, type = "histogram")
#' 
norm2likert <- function(x, prob, mu = mean(x), sd = stats::sd(x)) {
  cprob <- cumsum(prob)
  n <- length(cprob)
  if (abs(cprob[n] - 1) > .01) {
    # TODO: better checks for valid prob (check existing funcs)
    stop("argument \"prob\" must add up to 1")
  }
  p <- stats::pnorm(x, mu, sd)
  sapply(p, function(a) n + 1 - sum(a < cprob))
}

