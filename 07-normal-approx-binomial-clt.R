# 07-normal-approx-binomial-clt.R
# Companion to IE 1072 lecture notes, Part III (Central Limit Theorem).

# Each binomial draw with size = 100 and p = 0.55 is itself a sum of
# 100 i.i.d. Bernoulli(0.55) variables, so by the CLT its sampling
# distribution should look approximately normal. We generate many such
# binomial samples and check normality with a histogram and a QQ plot
# against the normal distribution.

# Number of binomial replicates to draw.
n_replicates <- 100

# Each binomial draw is itself the sum of binom_size = 100 i.i.d. Bernoullis.
binom_size <- 100
p          <- 0.55

binomial_samples <- rbinom(n = n_replicates, size = binom_size, prob = p)

# Histogram of the sampling distribution: should be roughly bell-shaped.
hist(binomial_samples)

# QQ plot against the standard normal. Points should fall on (or near)
# the line if the normal approximation is good.
qqnorm(binomial_samples)
qqline(binomial_samples)
