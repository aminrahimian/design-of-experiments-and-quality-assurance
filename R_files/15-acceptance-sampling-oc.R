# 15-acceptance-sampling-oc.R
# Companion to IE 1072 lecture notes, Part VIII (Single-Sampling Plan
# for Attributes, The Operating-Characteristic Curve).
#
# For three (n, c) attribute single-sampling plans, compute and overlay
# the operating-characteristic curve P_a(p) -- the probability of
# accepting a lot as a function of its true defective fraction p.

library(AcceptanceSampling)

# Range of true defective fractions to evaluate.
proportion_defective <- seq(from = 0, to = 0.08, length = 50)

# Three single-sampling plans of growing sample size and tighter c.
n50c1  <- OC2c(n = 50,  c = 1, pd = proportion_defective)
n100c2 <- OC2c(n = 100, c = 2, pd = proportion_defective)
n200c4 <- OC2c(n = 200, c = 4, pd = proportion_defective)

# Base R plot of the first OC curve, then overlay the other two.
plot(n50c1, type = "l")
lines(proportion_defective, n100c2@paccept, col = "red")
lines(proportion_defective, n200c4@paccept, col = "green")

legend("topright",
       legend = c("n = 50, c = 1", "n = 100, c = 2", "n = 200, c = 4"),
       col    = c("black", "red", "green"),
       lty    = 1)
title("Single Sampling Plans")
