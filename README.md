# IE 1072 — Design of Experiments and Quality Assurance

Companion R scripts for the lecture notes of IE 1072 at the University of
Pittsburgh, taught by [Prof. Amin Rahimian](https://aminrahimian.github.io/).
Each script corresponds to a topic in the notes. The numeric prefix in the
filename reflects the order in which the topic first appears.

## What's here

- `00`–`07`: probability foundations, sampling and estimation, limit theorems.
- `08`–`12`: confidence intervals, hypothesis testing, one- and two-way ANOVA.
- `13`–`14`: 2ᵏ factorial and 2ᵏ⁻ᵖ fractional factorial designs.
- `15`–`16`: lot-by-lot acceptance sampling and MIL-STD-105E.
- `17`–`18`: Shewhart variables and attributes control charts.

## Dependencies

​```r
install.packages(c(
  "dplyr", "ggplot2", "tidyr", "readxl", "lubridate",
  "pastecs", "aplpack", "benford.analysis",
  "pid", "AcceptanceSampling", "AQLSchemes", "qicharts2"
))
​```

## License

See [`LICENSE`](LICENSE).
