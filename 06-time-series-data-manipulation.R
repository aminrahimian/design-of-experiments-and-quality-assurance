# 06-time-series-data-manipulation.R
# Companion to IE 1072 lecture notes; Week 3 R module (data manipulation).

# Generate a one-year time series of daily hospital admissions, then
# practise the standard dplyr/ggplot2 idioms used throughout the course:
# date conversion, mutate with conditionals, scale_x_date plotting,
# filtering by date, selecting columns, and joining filter + select.

library(tidyverse)
library(lubridate)
library(ggplot2)

# Reproducible synthetic timestamps for one calendar year.
set.seed(123)
start_date <- as.Date("2023-01-01")
end_date   <- as.Date("2023-12-31")
dates      <- seq(start_date, end_date, by = "days")

# Random clock times for each day in 24-hour format.
times <- sprintf("%02d:%02d:%02d",
                 sample(0:23, 365, replace = TRUE),
                 sample(0:59, 365, replace = TRUE),
                 sample(0:59, 365, replace = TRUE))
timestamps <- paste(dates, times)

# Normally-distributed daily admission counts (mean = 50, SD = 10).
hospital_admissions <- rnorm(365, mean = 50, sd = 10)

timestamp_data <- data.frame(
  date      = dates,
  Time      = times,
  Timestamp = timestamps,
  cases     = hospital_admissions
)

# ---- mutate + ifelse to derive a categorical column --------------------

timestamp_data <- timestamp_data %>%
  mutate(busy_status = ifelse(cases > 50, "high", "low"))
head(timestamp_data)

# ---- scale_x_date for date-axis line plots -----------------------------

p1 <- timestamp_data %>%
  ggplot(aes(x = date, y = cases)) +
  geom_line() +
  scale_x_date() +
  ylab("US daily hospital admissions")
p1

# diff() applied via mutate to compute day-over-day changes
timestamp_data <- timestamp_data %>%
  mutate(new_cases = c(lag = 1, diff(cases)))
head(timestamp_data)

# ---- filter on a date range ---------------------------------------------

july_august_admissions <- timestamp_data %>%
  filter(date >= as.Date("2023-07-01") & date <= as.Date("2023-08-31"))
head(july_august_admissions)

# ---- filter + select combined -------------------------------------------

hightime_admissions <- timestamp_data %>%
  filter(busy_status == "high") %>%
  select(c("date", "cases"))
head(hightime_admissions)

p2 <- hightime_admissions %>%
  ggplot(aes(x = date, y = cases)) +
  geom_line() +
  scale_x_date() +
  ylab("Peak hospital admission times")
p2
