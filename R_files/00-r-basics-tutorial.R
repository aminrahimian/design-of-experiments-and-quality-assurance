# 00-r-basics-tutorial.R
# Companion to IE 1072 lecture notes.
# Basic R/dplyr/ggplot2 walkthrough using the Iris data: how to read data
# in, index columns, manipulate frames with dplyr verbs and the pipe, write
# loops and functions, and produce histograms and scatter plots.

# ---- Install (run once) and load packages -------------------------------

# install.packages("readxl")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("tidyr")

library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)

# ---- Read data from an Excel workbook -----------------------------------

# Adjust the working directory to point at the folder that holds Iris.xls.
getwd()
# setwd("path/to/your/folder")

data <- read_excel("Iris.xls")   # could be .xlsx
str(data)
head(data)
dim(data)[1]

# ---- Direct column access and Boolean masks -----------------------------

data$Petal_width
data$Petal_length[2]
data$Petal_length[2:4]

# Boolean mask: keep entries where the predicate is TRUE.
data$Petal_length >= 2
data$Petal_length[data$Petal_length >= 2]

# ---- dplyr verbs and the pipe (%>%) -------------------------------------

# filter: keep rows matching a condition
data %>% filter(Petal_width >= 0.4)

# select: keep/drop columns (the ! flips selection)
data %>% select(!Petal_width)

# mutate: create a new column
data %>% mutate(ratio = Petal_width / Petal_length)

# Same thing the base-R way
data$new_col <- rep(1, 150)

# Drop rows with NAs
data %>% drop_na()
data <- data %>% drop_na()

# summarise reduces a column to a scalar (or several)
data %>% summarise(mean = mean(Petal_width, na.rm = TRUE),
                   sd   = sd(Petal_length, na.rm = TRUE))

# Pipe several steps together
data %>%
  mutate(ratio = Petal_width / Petal_length) %>%
  summarise(mean = mean(ratio, na.rm = TRUE))

# ---- Indexing parts of a data frame -------------------------------------

data[1, "Sepal_width"]
data[1, ]
data[, "Sepal_width"]

vector <- c(1, 2, 4)
data[vector, ]

# Useful helpers for building sequences
rep(1, 3)
rep("a", 4)
rep(1:4, 3)
seq(1, 5, by = 0.5)

# ---- For loops and user-defined functions -------------------------------

for (i in 1:dim(data)[1]) {
  if (data$Petal_width[i] >= 2) {
    print(data$Petal_length[i])
  }
}

fahrenheit_to_celsius <- function(temp_F) {
  temp_C <- (temp_F - 32) * 5 / 9
  return(temp_C)
}
fahrenheit_to_celsius(80)

# ---- Histograms and scatter plots with ggplot2 --------------------------

ggplot(data, aes(x = Petal_width)) +
  geom_histogram(binwidth = 0.5)

ggplot(data, aes(x = Petal_width)) +
  geom_histogram(binwidth = 0.1, alpha = 0.5)

# Turn the species name into a factor so we can colour by it
class(data$Species_name)
data$Species_name <- as.factor(data$Species_name)
levels(data$Species_name)

ggplot(data, aes(x = Petal_width)) +
  geom_histogram(binwidth = 0.1, alpha = 0.5, aes(color = Species_name))

ggplot(data, aes(x = Petal_width)) +
  geom_histogram(binwidth = 0.1, alpha = 0.5) +
  facet_grid(. ~ Species_name)

ggplot(data, aes(Petal_width, Petal_length)) +
  geom_point(aes(color = Species_name))

# ---- A first taste of inference ----------------------------------------

# A two-sample t-test on two columns of the data frame.
t.test(data$Petal_width, data$Petal_length, conf.level = 0.95)

# Normal-distribution "tables" by function call: CDF and quantile.
pnorm(2, mean = mean(data$Petal_length), sd = sd(data$Petal_length),
      lower.tail = TRUE)
qnorm(0.95, mean = mean(data$Petal_length), sd = sd(data$Petal_length),
      lower.tail = TRUE)
