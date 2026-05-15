# 17-xbar-s-charts.R
# Companion to IE 1072 lecture notes, Part IX (Variables Control Charts).
#
# Xbar and S charts built with qicharts2::qic, first on the Quality.xlsx
# data set (Days subgrouped by Date), then on a simulated process where
# the in-control mean is 5 and within-subgroup standard deviation is 1.

# install.packages("qicharts2")   # run once if needed
library(readxl)
library(dplyr)
library(qicharts2)

# ---- (a) Quality.xlsx: Days subgrouped by Date -------------------------

quality_df <- read_excel("Quality.xlsx", sheet = "Sheet1")
head(quality_df)

# Xbar chart: subgroup means.
xbar_days <- qic(
  y     = Days,
  x     = Date,
  data  = quality_df,
  chart = "xbar",
  title = "Xbar chart for Days",
  xlab  = "Date",
  ylab  = "Mean Days",
  decimals = 2
)

# S chart: within-subgroup standard deviation.
s_days <- qic(
  y     = Days,
  x     = Date,
  data  = quality_df,
  chart = "s",
  title = "S chart for Days",
  xlab  = "Date",
  ylab  = "Within-subgroup s (Days)",
  decimals = 2
)

xbar_days
s_days

# ---- (b) Simulated process data ----------------------------------------

set.seed(123)

Process <- data.frame(
  metric_value    = rnorm(100, 5, 1),
  subgroup_sample = rep(1:10, each = 10),
  Process_run_id  = 1:100
)

xbar_proc <- qic(
  y     = metric_value,
  x     = subgroup_sample,
  data  = Process,
  chart = "xbar",
  title = "Xbar chart (simulated process)",
  xlab  = "Subgroup",
  ylab  = "Mean"
)

s_proc <- qic(
  y     = metric_value,
  x     = subgroup_sample,
  data  = Process,
  chart = "s",
  title = "S chart (simulated process)",
  xlab  = "Subgroup",
  ylab  = "Standard deviation"
)

xbar_proc
s_proc
