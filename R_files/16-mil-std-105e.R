# 16-mil-std-105e.R
# Companion to IE 1072 lecture notes, Part VIII (MIL-STD-105E).
#
# Read off the (n, c) single-sampling plan that MIL-STD-105E prescribes
# for Normal, Tightened, and Reduced inspection at a given lot size and
# AQL, then plot the resulting operating-characteristic curves so the
# three regimes can be compared visually.

library(AcceptanceSampling)
library(AQLSchemes)

# Same support as 15-acceptance-sampling-oc.R for an apples-to-apples plot.
proportion_defective <- seq(from = 0, to = 0.08, length = 50)

# AASingle() returns the (n, c) plan prescribed by MIL-STD-105E for the
# requested inspection level (Normal / Tightened / Reduced). The lot
# size and AQL are interactive in the package; defaults are used here.
plan_normal    <- AASingle("Normal")
plan_tightened <- AASingle("Tightened")
plan_reduced   <- AASingle("Reduced")

# OC curves for the three prescribed plans.
plan_normal_oc    <- OC2c(plan_normal$n,    plan_normal$c,    pd = proportion_defective)
plan_tightened_oc <- OC2c(plan_tightened$n, plan_tightened$c, pd = proportion_defective)
plan_reduced_oc   <- OC2c(plan_reduced$n,   plan_reduced$c,   pd = proportion_defective)

# Overlay the three curves.
plot(plan_normal_oc, type = "l")
lines(proportion_defective, plan_tightened_oc@paccept, col = "red")
lines(proportion_defective, plan_reduced_oc@paccept,   col = "green")

legend("topright",
       legend = c("Normal", "Tightened", "Reduced"),
       col    = c("black", "red", "green"),
       lty    = 1)
title("MIL-STD-105E")
