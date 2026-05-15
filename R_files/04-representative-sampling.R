# 04-representative-sampling.R
# Companion to IE 1072 lecture notes, Part II (Within/Between Variance
# and Representative Sampling).
#
# Two samples are drawn from the same two-component normal mixture: the
# first by i.i.d. random sampling (each draw flips a Bernoulli(p_1) to
# pick the component), and the second by representative sampling (the
# proportions p_1 and 1 - p_1 are imposed deterministically by index).
# Both target the same population mean; the representative scheme has
# smaller variance because the between-component allocation is fixed.

# ---- Shared mixture parameters ------------------------------------------

n    <- 100        # sample size
p_1  <- 0.6        # mixture weight on component 1
p_2  <- 1 - p_1
mu_1 <- 1;   sd1 <- 1
mu_2 <- 20;  sd2 <- 1

# ---- Random sampling ----------------------------------------------------
# Each i flips a Bernoulli(p_1) to decide which component to draw from.

random_sampling <- numeric(n)
for (i in 1:n) {
  if (runif(1) < p_1) {
    random_sampling[i] <- rnorm(1, mean = mu_1, sd = sd1)
  } else {
    random_sampling[i] <- rnorm(1, mean = mu_2, sd = sd2)
  }
}
hist(random_sampling, breaks = 30,
     main = "Random sampling from a normal mixture", xlab = "Value")
var(random_sampling)

# ---- Representative sampling --------------------------------------------
# The first n*p_1 indices are forced into component 1, the rest into
# component 2. The between-component split is now deterministic.

represenatative_sampling <- numeric(n)
for (i in 1:n) {
  if (i <= n * p_1) {        # 600 out of 1000 if n = 1000, or 60 if n = 100
    represenatative_sampling[i] <- rnorm(1, mean = mu_1, sd = sd1)
  } else {
    represenatative_sampling[i] <- rnorm(1, mean = mu_2, sd = sd2)
  }
}
hist(represenatative_sampling, breaks = 30,
     main = "Representative sampling from a normal mixture", xlab = "Value")
var(represenatative_sampling)

# The two sample variances should differ in a stable way across reruns:
# representative sampling removes the between-component variance term.
