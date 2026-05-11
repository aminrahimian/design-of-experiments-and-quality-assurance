# 08-cap-torque-eda.R
# Companion to IE 1072 lecture notes; Week 4 EDA module / Part IV.

# Exploratory data analysis on the cap-torque measurements: overlaid
# histograms by machine, descriptive statistics overall and per machine,
# normal QQ plots overall and split by machine, and stem-and-leaf
# displays. The same data set is used downstream in 09-t-tests-and-ci.R.

library(ggplot2)
library(dplyr)
library(readxl)
library(pastecs)
library(aplpack)

# Read the data and make Machine a factor for grouping.
data <- read_excel("Homework 1_Cap Torque Data.xlsx", sheet = "Sheet1")
data$Machine <- as.factor(data$Machine)

# ---- Overlaid histograms, by Machine and overall -----------------------

options(repr.plot.width = 3, repr.plot.height = 2)
ggplot(data, aes(x = Torque, color = Machine)) +
  geom_histogram(binwidth = 1, fill = "gray", alpha = 0.5,
                 position = "identity")

ggplot(data, aes(x = Torque)) + geom_histogram(binwidth = 2)

# ---- Descriptive statistics (pastecs::stat.desc) -----------------------

overall_stats <- stat.desc(data$Torque, basic = FALSE)
print("Descriptive statistics overall:")
print(overall_stats)

Machine1 <- filter(data, Machine == "1")
Machine1_stats <- stat.desc(Machine1$Torque, basic = FALSE)
print("Descriptive statistics for Machine 1:")
Machine1_stats

Machine2 <- filter(data, Machine == "2")
Machine2_stats <- stat.desc(Machine2$Torque, basic = FALSE)
print("Descriptive statistics for Machine 2:")
Machine2_stats

# ---- Normal QQ plots ----------------------------------------------------

options(repr.plot.width = 3, repr.plot.height = 2)
p <- ggplot(data = data, aes(sample = Torque))
p + stat_qq(col = "blue") + stat_qq_line()

# Split QQ plot by machine.
q <- ggplot(data, aes(sample = Torque, colour = factor(Machine)))
q + stat_qq() + stat_qq_line()

# ---- Stem-and-leaf displays --------------------------------------------

stem(Machine1$Torque)
stem(Machine2$Torque)
