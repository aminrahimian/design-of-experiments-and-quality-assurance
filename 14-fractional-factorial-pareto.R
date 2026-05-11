# 14-fractional-factorial-pareto.R
# Companion to IE 1072 lecture notes, Part VII (The 2^{5-1} Design,
# Pareto Plots for Effect Screening).

# Two pieces:
#   (a) the Leaf Spring 2^{5-1} experiment: read the data, fit a linear
#       model up to two-factor interactions, and identify the dominant
#       effects with a Pareto plot;
#   (b) construct the design matrix from scratch: enumerate the full
#       2^5 design, build the sign table for every interaction column,
#       then select the half-fraction defined by the generator
#       I = ABCDE.

library(pid)
library(readxl)
library(dplyr)

# ---- (a) Leaf Spring: fit and screen effects ---------------------------
# 3 replicates of 1/2 fraction of a 2^5 design. Adjust the path.

my_data <- read_excel("rfiles/Leaf Spring Height.xlsx", sheet = "Sheet1")
head(my_data)

# Tidy up column names supplied by readxl.
my_data <- my_data %>%
  rename(A   = A...3,
         B   = B...4,
         C   = C...5,
         D   = D...6,
         E   = E...7,
         obs = FreeHeight) %>%
  select(A, B, C, D, E, obs)
head(my_data)

# Sign columns for the five factors.
factors <- my_data %>% select(A, B, C, D, E)
factors

# How many runs at each (A,B,C,D,E) combination?
factors %>%
  group_by(A, B, C, D, E) %>%
  summarise(count = n())

# Fit through two-factor interactions and look at the ANOVA.
model <- lm(obs ~ (A + B + C + D + E)^2, data = my_data)
res.aov <- aov(model)
summary(res.aov)

# The full three-factor model would be aliased here:
# the design only has resolution V, so three-way interactions cannot be
# separated from two-way interactions.
# model <- lm(obs ~ (A + B + C + D + E)^3, data = my_data)
# summary(aov(model))

# Pareto plot ranking the absolute effects.
dev.off()
paretoPlot(model)

# ---- (b) Build the 2^{5-1} design matrix from scratch ------------------

levels <- -c(-1, 1)
levels

full_fractorial <- expand.grid(A = levels, B = levels, C = levels,
                               D = levels, E = levels) %>%
  arrange(A, B, C, D, E)

sign_table <- full_fractorial

# How many terms exist at each interaction order:
choose(5, 1)   # main effects
choose(5, 2)   # two-factor interactions
choose(5, 3)   # three-factor interactions
choose(5, 4)   # four-factor interactions
choose(5, 5)   # five-factor interaction

# Build every interaction column.
sign_table <- sign_table %>%
  mutate(AB = A * B) %>% mutate(AC = A * C) %>%
  mutate(AD = A * D) %>% mutate(AE = A * E) %>%
  mutate(BC = B * C) %>% mutate(BD = B * D) %>% mutate(BE = B * E) %>%
  mutate(CD = C * D) %>% mutate(CE = C * E) %>%
  mutate(DE = D * E) %>%
  mutate(ABC = A * B * C) %>% mutate(ABD = A * B * D) %>%
  mutate(ABE = A * B * E) %>% mutate(ACD = A * C * D) %>%
  mutate(ACE = A * C * E) %>% mutate(ADE = A * D * E) %>%
  mutate(BCD = B * C * D) %>% mutate(BCE = B * C * E) %>%
  mutate(BDE = B * D * E) %>%
  mutate(CDE = C * D * E) %>%
  mutate(ABCD = A * B * C * D) %>% mutate(ABCE = A * B * C * E) %>%
  mutate(ABDE = A * B * D * E) %>% mutate(ACDE = A * C * D * E) %>%
  mutate(BCDE = B * C * D * E) %>%
  mutate(ABCDE = A * B * C * D * E)

sign_table

# Pick the half-fraction defined by the generator I = ABCDE.
fractional_factorial_signs <- sign_table %>% filter(ABCDE == 1)

fractional_factorial_design_matrix <- fractional_factorial_signs %>%
  select(A, B, C, D, E) %>%
  arrange(A, B, C, D, E)

fractional_factorial_design_matrix
