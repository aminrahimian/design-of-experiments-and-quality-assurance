# 13-2k-factorial-basic.R
# Companion to IE 1072 lecture notes, Part VII (The 2^3 Design,
# General 2^k Design).
#
# Build a 2^3 factorial design with expand.grid on the coded levels
# {-1, +1}, replicate the design twice, fit a linear model with main
# effects only and again with the full set of two- and three-factor
# interactions, and read off the ANOVA decomposition. Close with a
# surface-response contour plot and a prediction at a new design point.

library(pid)

# ---- Build the design and the response ---------------------------------

# Coded factor levels.
A <- B <- C <- c(-1, 1)

# Step 1: the un-replicated 2^3 design + a placeholder response.
data <- expand.grid(FactorA = A, FactorB = B, FactorC = C)
head(data)
response <- c(rep(1, 8))
data$r <- response
head(data)

# Step 2: replicate the design twice (16 runs total) and supply a
# response that varies across runs.
A <- B <- C <- c(-1, 1)
base <- expand.grid(A = A, B = B, C = C)
data <- rbind(base, base)
response <- c(rep(1:4, 4))
data$r <- response

# (Casting the factors keeps lm/aov happy in some downstream pipelines.)
base$A <- as.factor(base$A)
base$B <- as.factor(base$B)
base$C <- as.factor(base$C)

# ---- Fit linear models with increasing interaction depth ---------------

# Main effects only.
model <- lm(r ~ ., data = data)
res.aov <- aov(model)
summary(res.aov)

# All interactions up to three-factor (equivalent to A*B*C).
model <- lm(r ~ .^3, data = data)
res.aov <- aov(model)
summary(res.aov)

# Explicit A*B*C specification.
model <- lm(r ~ A * B * C, data = data)
res.aov <- aov(model)
summary(res.aov)

# ---- Surface response and prediction at a new design point -------------

contourPlot(model, "A", "B",
            xlim = c(-1.5, 1.5), ylim = c(-1.5, 1.5), N = 50)

new.df <- data.frame(A = 2, B = 1, C = 0)
predict(model, new.df)
