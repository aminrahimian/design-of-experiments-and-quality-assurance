# 02-poisson-accidents.R
# Companion to IE 1072 lecture notes, Part I (Poisson Distribution).
# Fit a Poisson to industrial accident counts: per-person accident
# frequencies are recorded, the mean rate is estimated, and the
# Poisson-predicted counts are compared against the observed counts.

library(ggplot2)

# Observed data: for each possible accident count (0, 1, 2, ..., 9, 13, 18),
# how many people had exactly that many accidents.
num_accidents          <- c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 13, 18)
people_accident_counts <- c(42, 44, 30, 30, 25, 11, 12, 15, 8, 8, 19, 3)

# Total accidents and total people, used to estimate the rate parameter.
total_accident_count   <- sum(num_accidents * people_accident_counts)
total_people_count     <- sum(people_accident_counts)
avg_accidents_per_people <- total_accident_count / total_people_count

# Poisson PMF evaluated at each accident count, using the estimated rate.
poisson_probs <- dpois(num_accidents, lambda = avg_accidents_per_people)

# Quick base-R views.
plot(poisson_probs)
plot(total_accident_count * poisson_probs)
plot(people_accident_counts)
plot(total_accident_count * poisson_probs, people_accident_counts)

# Overlay observed counts vs Poisson-predicted counts on one ggplot.
df <- data.frame(
  x     = rep(num_accidents, 2),
  y     = c(people_accident_counts, total_accident_count * poisson_probs),
  group = rep(c("people accident counts", "poisson proportions"),
              each = length(num_accidents))
)

ggplot(df, aes(x = x, y = y, color = group, shape = group)) +
  geom_point(size = 3) +
  geom_line() +
  labs(title = "People accident counts and Poisson proportions on the same plot",
       x = "Number of accidents", y = "People count") +
  theme_minimal()
