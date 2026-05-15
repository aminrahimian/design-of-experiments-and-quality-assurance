# 10-grouped-summaries-facets.R
# Companion to IE 1072 lecture notes; Week 4 EDA / Part IV.
#
# Demonstrates how to take a single data set with multiple subgroups
# (here, 2020 county-level vote totals broken down by state) and produce
# (i) per-group summary statistics with dplyr's group_by + summarise,
# (ii) state-level totals using filter inside sum(), and
# (iii) faceted histograms+density plots for visual comparison across
# the same subgroups. Also illustrated on the shipping data: per-center
# histograms, scatter, and grouped summaries.

library(dplyr)
library(ggplot2)
library(readxl)

# ---- (i) County vote totals: state-level sums --------------------------

votes <- read.csv("2020_US_County_Level_Presidential_Results.csv")

# Sum GOP/Dem (raw and log-transformed) over a county-FIPS range.
sum((votes %>% filter(42000 < county_fips)
            %>% filter(county_fips < 43000))$votes_gop)
sum((votes %>% filter(42000 < county_fips)
            %>% filter(county_fips < 43000))$votes_dem)
sum((votes %>% filter(42000 < county_fips)
            %>% filter(county_fips < 43000))$log_votes_gop)
sum((votes %>% filter(42000 < county_fips)
            %>% filter(county_fips < 43000))$log_votes_dem)

# ---- (ii) State-level grouped summary statistics -----------------------

grouped_votes <- votes %>%
  group_by(state_name) %>%
  summarise(
    count    = n(),
    mean_dem = mean(votes_gop),
    mean_gop = mean(votes_dem),
    sd_dem   = sd(votes_dem),
    sd_gop   = sd(votes_gop),
    Min_dem  = min(votes_dem),
    Max_gop  = max(votes_gop),
    Q1_dem   = quantile(votes_dem, probs = c(.25)),
    Q3_gop   = quantile(votes_gop, probs = c(.75))
  )
grouped_votes

# ---- (iii) Faceted histogram + density plot ----------------------------

plots <- ggplot(votes %>% filter(41000 < county_fips) %>%
                  filter(county_fips < 44000),
                aes(votes_dem)) +
  geom_histogram(aes(y = stat(density)), bins = 15) +
  geom_density() +
  facet_grid(. ~ state_name)
plots

# ---- (iv) Shipping data: faceted EDA + scatter + grouped summary -------

shipping_data <- read_excel("Shipping.xlsx")

# One density-overlaid histogram per shipping center.
p <- ggplot(shipping_data, aes(x = Days)) +
  geom_histogram(aes(y = stat(density)), bins = 15) +
  geom_density() +
  facet_grid(. ~ Center)
p

# Distance vs Days, colour by Center.
p <- ggplot(shipping_data, aes(Distance, Days, col = Center)) +
  geom_point()
p

# Per-center descriptive statistics.
shipping_data %>%
  group_by(Center) %>%
  summarise(
    count = n(),
    mean  = mean(Days, na.rm = TRUE),
    sd    = sd(Days, na.rm = TRUE),
    Min   = min(Days, na.rm = TRUE),
    Max   = max(Days, na.rm = TRUE),
    Q1    = quantile(Days, probs = 0.25, na.rm = TRUE),
    Q3    = quantile(Days, probs = 0.75, na.rm = TRUE)
  )
