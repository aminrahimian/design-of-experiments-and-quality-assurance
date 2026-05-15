# 18-attribute-charts.R
# Companion to IE 1072 lecture notes, Part IX (Attributes Control Charts).
#
# Three attribute control charts on simulated data, each in a fixed-n
# and a variable-n variant where applicable:
#   - p chart: fraction nonconforming, binomial counts;
#   - u chart: defects per unit, Poisson counts on a fixed or variable
#     opportunity size;
#   - c chart: total defect counts, Poisson, fixed opportunity size.

library(qicharts2)

set.seed(123)

# ---- (1) p chart, fixed sample size ------------------------------------

bin_data_p_fixed <- data.frame(
  trial            = 1:30,
  Num_Items_in_Set = rep(75, 30)
)
true_p <- 0.4
bin_data_p_fixed$Num_Defective <- rbinom(n    = nrow(bin_data_p_fixed),
                                         size = bin_data_p_fixed$Num_Items_in_Set,
                                         prob = true_p)

p_fixed <- qic(
  y     = Num_Defective,
  n     = Num_Items_in_Set,
  x     = trial,
  data  = bin_data_p_fixed,
  chart = "p",
  title = "p chart (fixed n, binomial data)",
  xlab  = "Trial",
  ylab  = "Proportion defective"
)
p_fixed

# ---- (2) p chart, variable sample size (stepped limits) ---------------

bin_data_p_var <- data.frame(
  trial            = 1:30,
  Num_Items_in_Set = floor(runif(n = 30, min = 50, max = 100))
)
true_p <- 0.4
bin_data_p_var$Num_Defective <- rbinom(n    = nrow(bin_data_p_var),
                                       size = bin_data_p_var$Num_Items_in_Set,
                                       prob = true_p)

p_var <- qic(
  y     = Num_Defective,
  n     = Num_Items_in_Set,
  x     = trial,
  data  = bin_data_p_var,
  chart = "p",
  title = "p chart (variable n, binomial data)",
  xlab  = "Trial",
  ylab  = "Proportion defective"
)
p_var

# ---- (3) u chart, fixed opportunity size -------------------------------

u_data_fixed <- data.frame(
  trial               = 1:30,
  Num_of_Blemishes    = rpois(30, lambda = 20),
  Num_Units_Inspected = rep(60, 30)
)

u_fixed <- qic(
  y     = Num_of_Blemishes,
  n     = Num_Units_Inspected,
  x     = trial,
  data  = u_data_fixed,
  chart = "u",
  title = "u chart (fixed n)",
  xlab  = "Trial",
  ylab  = "Defects per unit"
)
u_fixed

# ---- (4) u chart, variable opportunity size ----------------------------

u_data_var <- data.frame(
  trial               = 1:30,
  Num_of_Blemishes    = rpois(30, lambda = 20),
  Num_Units_Inspected = floor(runif(n = 30, min = 50, max = 100))
)

u_var <- qic(
  y     = Num_of_Blemishes,
  n     = Num_Units_Inspected,
  x     = trial,
  data  = u_data_var,
  chart = "u",
  title = "u chart (variable n)",
  xlab  = "Trial",
  ylab  = "Defects per unit"
)
u_var

# ---- (5) c chart -------------------------------------------------------

product_defect_counts <- data.frame(
  product_id = 1:30,
  Counts     = rpois(n = 30, lambda = 25)
)

c_chart <- qic(
  y     = Counts,
  x     = product_id,
  data  = product_defect_counts,
  chart = "c",
  title = "c chart for defect counts",
  xlab  = "Product ID",
  ylab  = "Counts"
)
c_chart
