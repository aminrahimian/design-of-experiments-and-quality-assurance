# 05-benford-leading-digits.R
# Companion to IE 1072 lecture notes, Part II (Benford's Leading Digit Law).

# Extract the leading digit from real data sets (COVID-19 daily-case
# counts at three administrative levels, and 2020 US county-level
# presidential vote totals) and compare the observed first-digit
# frequencies to the Benford law P(d) = log10(1 + 1/d).

library(dplyr)
library(ggplot2)
library(benford.analysis)

# ---- COVID-19 daily cases: US, Pennsylvania, Allegheny County ----------

# Adjust paths to your local copies of the NYT data.
us_daily <- read.csv("us_new2024.csv")
us_daily <- us_daily %>% mutate(date = as.Date(date),
                                new_cases = c(1, diff(cases)))

# Leading digit of cumulative cases and of daily new cases.
us_bnfrd_cases     <- extract.digits(us_daily$cases,     number.of.digits = 1)
us_bnfrd_new_cases <- extract.digits(us_daily$new_cases, number.of.digits = 1)
hist(us_bnfrd_cases$data.digits)
hist(us_bnfrd_new_cases$data.digits)

# State-level: Pennsylvania (FIPS = 42).
states_daily <- read.csv("us-states.csv")
pa_daily <- states_daily %>% filter(fips == 42) %>%
  mutate(date = as.Date(date), new_cases = c(0, diff(cases)))

pa_cases_bnfrd     <- extract.digits(pa_daily$cases,     number.of.digits = 1)
pa_new_cases_bnfrd <- extract.digits(pa_daily$new_cases, number.of.digits = 1)
hist(pa_cases_bnfrd$data.digits)
hist(pa_new_cases_bnfrd$data.digits)

# County-level: Allegheny (FIPS = 42003).
counties_daily <- read.csv("us-counties.csv")
alle_daily <- counties_daily %>% filter(fips == 42003) %>%
  mutate(date = as.Date(date), new_cases = c(0, diff(cases)))

alle_cases_bnfrd <- extract.digits(alle_daily$cases, number.of.digits = 1)
hist(alle_cases_bnfrd$data.digits)

# ---- 2020 US county-level presidential vote totals ---------------------

votes <- read.csv("2020_US_County_Level_Presidential_Results.csv")

# Raw histograms (long tails; a log x-axis makes them readable).
hist(votes$votes_dem)
ggplot(votes, aes(x = votes_dem)) +
  geom_histogram(bins = 100) + scale_x_log10()
ggplot(votes, aes(x = votes_gop)) +
  geom_histogram(bins = 100) + scale_x_log10()

# Leading digit of Democratic and Republican vote totals.
votes_dem_bnfrd <- extract.digits(votes$votes_dem, number.of.digits = 1)
hist(votes_dem_bnfrd$data.digits)

votes_gop_bnfrd <- extract.digits(votes$votes_gop, number.of.digits = 1)
hist(votes_gop_bnfrd$data.digits)

# Restrict to Pennsylvania counties (FIPS in the 42000s).
pa_votes <- votes %>% filter(42000 < county_fips) %>% filter(county_fips < 43000)
hist(pa_votes$votes_dem)
hist(pa_votes$votes_gop)

pa_votes_dem_bnfrd <- extract.digits(pa_votes$votes_dem, number.of.digits = 1)
pa_votes_gop_bnfrd <- extract.digits(pa_votes$votes_gop, number.of.digits = 1)
hist(pa_votes_dem_bnfrd$data.digits)
hist(pa_votes_gop_bnfrd$data.digits)

# ---- Observed vs Benford-predicted first-digit frequencies -------------

# Observed relative frequencies of digit i in the Democratic vote totals.
n <- dim(votes_dem_bnfrd)[1]
for (i in 1:9) {
  print(sum(votes_dem_bnfrd$data.digits == i) / n)
}

# Theoretical Benford probabilities: P(d) = log10(1 + 1/d).
for (i in 1:9) {
  print(log10(1 + 1 / i))
}
