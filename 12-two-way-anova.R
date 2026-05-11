# 12-two-way-anova.R
# Companion to IE 1072 lecture notes, Part VI (Two-Way ANOVA).

# Two-factor analysis-of-variance examples with interaction:
#   (a) a 3 (type) x 2 (method) adhesion-force experiment, replicated
#       three times, illustrating expand.grid + cbind to build the design,
#       per-factor summaries, an interaction-style boxplot, and the full
#       two-way ANOVA with interaction term;
#   (b) the built-in ToothGrowth data (3 doses x 2 supplement types).

library(dplyr)
library(ggplot2)

# ---- (a) Adhesion force: type x method experiment ----------------------

A <- c(1, 2, 3)             # 3 levels of "type"
B <- c("dip", "spray")      # 2 levels of "method"

exp_data <- expand.grid(type = A, method = B)
df       <- rbind(exp_data, exp_data, exp_data)   # 3 replicates each

adhesion_force <- c(4, 5.6, 3.8, 5.4, 5.8, 5.5,
                    4.5, 4.9, 3.7, 4.9, 6.1, 5.0,
                    4.3, 5.4, 4.0, 5.6, 6.3, 5.0)

my_data <- cbind(df, adhesion_force)
head(my_data)
sample_n(my_data, 10)

# Label "type" levels for readability.
levels(my_data$method)
levels(my_data$type)

my_data$type <- factor(my_data$type,
                       levels = c(1, 2, 3),
                       labels = c("T1", "T2", "T3"))
levels(my_data$type)

# Marginal summaries by each factor.
group_by(my_data, method) %>%
  summarise(
    count = n(),
    mean  = mean(adhesion_force),
    sd    = sd(adhesion_force),
    min   = min(adhesion_force),
    max   = max(adhesion_force),
    Q1    = quantile(adhesion_force, probs = c(.25)),
    Q3    = quantile(adhesion_force, probs = c(.75))
  )

group_by(my_data, type) %>%
  summarise(
    count = n(),
    mean  = mean(adhesion_force),
    sd    = sd(adhesion_force),
    min   = min(adhesion_force),
    max   = max(adhesion_force),
    Q1    = quantile(adhesion_force, probs = c(.25)),
    Q3    = quantile(adhesion_force, probs = c(.75))
  )

# Interaction-style boxplot with means joined by method.
ggplot(my_data, aes(x = type, y = adhesion_force, fill = method)) +
  geom_boxplot() +
  stat_summary(fun = mean, geom = "line", aes(group = method))

# Two-way ANOVA with interaction.
result_aov <- aov(adhesion_force ~ method + type + method:type, data = my_data)
summary(result_aov)
plot(result_aov)

# ---- (b) ToothGrowth: dose x supp ---------------------------------------

my_data <- ToothGrowth
head(my_data)

# Re-label dose levels for readability.
my_data$dose <- factor(ToothGrowth$dose,
                       levels = c(0.5, 1, 2),
                       labels = c("D0.5", "D1", "D2"))
levels(my_data$dose)
levels(my_data$supp)
head(my_data)
sample_n(my_data, 10)

my_data$dose <- ordered(my_data$dose, levels = c("D0.5", "D1", "D2"))

group_by(my_data, dose) %>%
  summarise(
    count = n(),
    mean  = mean(len),
    sd    = sd(len),
    min   = min(len),
    max   = max(len),
    Q1    = quantile(len, probs = c(.25)),
    Q3    = quantile(len, probs = c(.75))
  )

group_by(my_data, supp) %>%
  summarise(
    count = n(),
    mean  = mean(len),
    sd    = sd(len),
    min   = min(len),
    max   = max(len),
    Q1    = quantile(len, probs = c(.25)),
    Q3    = quantile(len, probs = c(.75))
  )

ggplot(my_data, aes(x = dose, y = len, fill = supp)) +
  geom_boxplot() +
  stat_summary(fun = mean, geom = "line", aes(group = supp))

result_aov <- aov(len ~ dose + supp + dose:supp, data = my_data)
summary(result_aov)
plot(result_aov)
