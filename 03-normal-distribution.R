# 03-normal-distribution.R
# Companion to IE 1072 lecture notes, Part I (Normal Distribution).

# Use the normal CDF to compute the probability that an observation
# falls inside a tolerance band [17, 19]. The mean and standard
# deviation are estimated from a sample (here, the Cap Torque data).

library(readxl)

# Read the cap-torque data (path adjusted to your environment).
data <- read_excel("Homework 1_Cap Torque Data.xlsx", sheet = "Sheet1")

# Probability that a normal random variable falls below 17 and below 19,
# under the fitted normal model. Their difference is the probability of
# landing in the tolerance band [17, 19].
low <- pnorm(17, mean = mean(data$Torque), sd = sd(data$Torque),
             lower.tail = TRUE)
up  <- pnorm(19, mean = mean(data$Torque), sd = sd(data$Torque),
             lower.tail = TRUE)

up - low   # P(17 < X <= 19) under the fitted N(mean, sd^2)
low        # P(X <= 17)
