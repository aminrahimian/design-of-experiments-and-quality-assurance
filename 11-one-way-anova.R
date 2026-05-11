# 11-one-way-anova.R
# Companion to IE 1072 lecture notes, Part VI (One-Way ANOVA).

# Two illustrations of a single-factor analysis of variance:
#   (a) the built-in PlantGrowth data, with three treatment levels and a
#       per-group summary, a boxplot, and the aov() output;
#   (b) a synthetic three-fertilizer experiment (10 obs each) that you
#       can re-run to see how the F statistic behaves under known means
#       and variances.

library(dplyr)
library(ggplot2)

# ---- (a) PlantGrowth: one-way ANOVA ------------------------------------

my_data <- PlantGrowth
head(PlantGrowth)

# Pick a fixed level order before computing summaries.
my_data$group <- ordered(my_data$group, levels = c("ctrl", "trt1", "trt2"))
my_data$group <- as.factor(my_data$group)

# Per-group summary statistics.
group_by(my_data, group) %>%
  summarise(
    count = n(),
    mean  = mean(weight, na.rm = TRUE),
    sd    = sd(weight, na.rm = TRUE),
    min   = min(weight),
    max   = max(weight),
    Q1    = quantile(weight, probs = c(.25)),
    Q3    = quantile(weight, probs = c(.75))
  )

# Quick visual checks.
plot(my_data)
ggplot(my_data, aes(x = group, y = weight)) + geom_point()
ggplot(my_data, aes(x = group, y = weight, fill = group)) + geom_boxplot()

# Marginal sanity checks: per-group view of the response.
my_data %>% filter(group == "ctrl")
hist((my_data %>% filter(group == "trt2"))$weight)

# One-way ANOVA: is mean weight the same across ctrl/trt1/trt2?
result_aov <- aov(weight ~ group, data = my_data)
summary(result_aov)

# ---- (b) Synthetic three-fertilizer experiment -------------------------

set.seed(123)

plant_data <- data.frame(
  treatment = rep(c("FertilizerA", "FertilizerB", "FertilizerC"), each = 10),
  growth    = c(rnorm(10, mean = 20, sd = 2.0),
                rnorm(10, mean = 22, sd = 2.5),
                rnorm(10, mean = 24, sd = 2.0))
)
head(plant_data)

# Per-group summary statistics.
plant_data %>%
  group_by(treatment) %>%
  summarise(
    count = n(),
    mean  = mean(growth, na.rm = TRUE),
    sd    = sd(growth, na.rm = TRUE),
    min   = min(growth),
    max   = max(growth),
    Q1    = quantile(growth, probs = c(.25)),
    Q3    = quantile(growth, probs = c(.75))
  )

# Boxplot and one-way ANOVA on the synthetic data.
ggplot(plant_data, aes(x = treatment, y = growth, fill = treatment)) +
  geom_boxplot() +
  labs(title = "Effect of Different Fertilizers on Plant Growth",
       x = "Treatment", y = "Plant Growth")

anova_result <- aov(growth ~ treatment, data = plant_data)
summary(anova_result)
