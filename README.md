# IE 1072: Design of Experiments and Quality Assurance

Lecture notes and supporting materials for IE 1072 at the University of Pittsburgh, taught by [Prof. Amin Rahimian](https://aminrahimian.github.io/).

## Contents

- **[`IE1072_unified_notes.pdf`](IE1072_unified_notes.pdf)**: the unified course notes. Covers probability foundations, sampling and estimation, limit theorems, confidence intervals, hypothesis testing, ANOVA, 2ᵏ factorial and 2ᵏ⁻ᵖ fractional designs, lot-by-lot acceptance sampling, and Shewhart control charts. 58 Practice problems with inline R code snippets.

- **[`data/`](data/)**: Excel datasets referenced by Practice problems.
  - `Cap Torque Data.xlsx` (Practices 6, 18)
  - `Shipping.xlsx` (Practices 7, 19)
  - `Soft Drink Experiment.xlsx` (Practice 25)

- **[`references/`](references/)**: lookup tables and procedure summaries.
  - `AcceptanceSamplingControlChartsTables.pdf`: required for Practices 31-35, 44, and 46. Contains MIL-STD-105E master tables (pp. 1-4), MIL-STD-414 master tables (pp. 5-6), and Appendix VI control chart constants $A_3, B_3, B_4, c_4$ etc. (p. 7).
  - `Military Standard 105E.pdf`, `Military Standard 414.pdf`: slide-deck procedure summaries. Optional supplementary material for Practices 30-35.

- **[`R_files/`](R_files/)**: standalone R companion scripts referenced inline throughout the notes (numbered `00`-`18`, one per topic). Each Practice that ships with an R companion links to the corresponding script here.

## Requirements

R is assumed throughout the notes both for distribution calculations (`pnorm`, `pt`, `pf`, `pchisq`, ...) and for the data-analysis problems. Install the packages used in the inline R snippets:

```r
install.packages(c(
  "dplyr", "ggplot2", "tidyr", "readxl", "lubridate",
  "pastecs", "aplpack", "benford.analysis",
  "pid", "AcceptanceSampling", "AQLSchemes", "qicharts2"
))
```

Open R with the repository root as the working directory so the relative paths in the notes (`data/...`, `references/...`) resolve correctly.

## Practice 4 (Benford's Law) external data

Practice 4 asks you to test Benford's Law on a public dataset of your own choice. Suggested sources from the original assignment:

- NYT COVID-19 case data: <https://github.com/nytimes/covid-19-data>
- 2020 US county election results: <https://github.com/tonmcg/US_County_Level_Election_Results_08-20>

Any count-style dataset that spans several orders of magnitude works.

## License

See [`LICENSE`](LICENSE).
