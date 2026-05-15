# 09-t-tests-and-ci.R
# Companion to IE 1072 lecture notes, Part IV (Confidence Intervals) and
# Part V (Two-Sample Tests).
#
# Three worked t-tests illustrating different decision questions:
#   (a) one-sample t CI for the mean torque on a single machine,
#   (b) two-sample t-test comparing Machine 1 and Machine 2 torques,
#   (c) one-sample t-test on the log-difference of Democratic vs
#       Republican county vote totals (a paired-data style application).

library(dplyr)
library(readxl)
library(ggplot2)

# ---- (a) Single-sample t CI: mean torque per machine -------------------

data <- read_excel("Homework 1_Cap Torque Data.xlsx", sheet = "Sheet1")

M1 <- data %>% filter(Machine == 1)
t.test(M1$Torque, conf.level = 0.95)
t.test(M1$Torque, conf.level = 0.99)

M2 <- data %>% filter(Machine == 2)
t.test(M2$Torque, conf.level = 0.95)
t.test(M2$Torque, conf.level = 0.99)

# ---- (b) Two-sample t-test: Machine 1 vs Machine 2 ---------------------
# H0: equal means. A small p-value rejects H0.

t.test(M1$Torque, M2$Torque, conf.level = 0.95)

# ---- (c) t-test on log-difference of county vote totals ----------------
# Take the log of Democratic and Republican vote totals county by county
# and t-test the within-county difference of those logs.

votes <- read.csv("2020_US_County_Level_Presidential_Results.csv")

votes <- votes %>%
  mutate(log_votes_gop = log(votes_gop),
         log_votes_dem = log(votes_dem)) %>%
  mutate(diff_log_votes = log_votes_dem - log_votes_gop)

head(votes)
hist(votes$log_votes_gop)
hist(votes$log_votes_dem)

# Nationwide test, default 95% CI.
t.test(votes$log_votes_dem)
t.test(votes$diff_log_votes)

# Restricting to Pennsylvania counties (FIPS 42000--43000).
t.test((votes %>% filter(42000 < county_fips)
              %>% filter(county_fips < 43000))$diff_log_votes)

t.test((votes %>% filter(42000 < county_fips)
              %>% filter(county_fips < 43000))$diff_log_votes,
       conf.level = 0.99)
