
create_manuscript <- function(new_dir, manuscript) {
  md <- r'(---
title             : "The title"
shorttitle        : "Title"

author:
  - name          : "James Conigrave"
    affiliation   : "1"
    corresponding : yes    # Define only one corresponding author
    email         : "james.conigrave@gmail.com"

affiliation:
  - id            : "1"
    institution   : "University of Sydney"

bibliography      : "r-references.bib"

classoption       : "doc"
output            : papaja::apa6_pdf
---

```{r setup, include = FALSE}
library("papaja")
library("targets")
r_refs("r-references.bib")
```

```{r analysis-preferences}
# Seed for random number generation
set.seed(42)
knitr::opts_chunk$set(cache.extra = knitr::rand_seed)
```

# Methods
We report how we determined our sample size, all data exclusions (if any), all manipulations, and all measures in the study. <!-- 21-word solution (Simmons, Nelson & Simonsohn, 2012; retrieved from http://ssrn.com/abstract=2160588) -->

## Participants

## Material

## Procedure

## Data analysis
We used `r cite_r("r-references.bib")` for all our analyses.

# Results

```{r}
tar_load(clean_data)
```

There were `r nrow(clean_data)` observations.

# Discussion

\newpage

# References

::: {#refs custom-style="Bibliography"}
:::)'

  write(md, paste0(new_dir, "/", manuscript))

}
