# 01-binomial-pmf-cdf.R
# Companion to IE 1072 lecture notes, Part I (Important Distributions).
# PMF, CDF, quantile and random-sample functions for the binomial
# distribution, plus a sanity check that the empirical median and mean of
# simulated samples line up with their theoretical counterparts.

library(ggplot2)
library(dplyr)

# Support: integers 0..10
x <- seq(0, 10)

# Ten evenly spaced quantile levels between 0 and 1, used below.
quants <- seq(from = 0, to = 1, length = 10)

# ---- PMF of Binomial(10, 0.25) -----------------------------------------

pmf <- dbinom(x, size = 10, prob = 0.25)
pmf_framed <- data.frame(x, pmf)

ggplot(pmf_framed, aes(x = x, y = pmf))                        # empty canvas
ggplot(pmf_framed, aes(x = x, y = pmf)) + geom_point()
ggplot(pmf_framed, aes(x = x, y = pmf)) + geom_point() + geom_line()

# ---- CDF of the same Binomial -------------------------------------------

cdf <- pbinom(x, size = 10, prob = 0.25)
cdf_framed <- data.frame(x, cdf)
ggplot(cdf_framed, aes(x = x, y = cdf)) + geom_point() + geom_line()

# ---- Quantile function and theoretical median ---------------------------

qbinom(quants, size = 10, prob = 0.25)
theory_median_point <- qbinom(0.5, size = 10, prob = 0.25)
theory_median_point

# ---- Empirical check via random samples ---------------------------------

random_samples <- rbinom(n = 100, size = 10, prob = 0.25)
hist(random_samples)

empirical_median_point <- median(random_samples)
empirical_mean         <- mean(random_samples)
empirical_median_point
empirical_mean
