How to add and subtruct Dates and Times in R
================
Juan Lorenzo Arellano
2021-04-20

-   [Introduction](#introduction)
    -   [Addition of an scalar to a
        date](#addition-of-an-scalar-to-a-date)

# Introduction

Following the R recipe [How to deal with Date and Time in
R](dates_times/How-to-deal-with-Dates-and-Times-in-R.md) where we
reviewed the base R capabilities to deal with dates and times, we
continue exploring how to add and subtract dates and times, also in base
R. I plan to cover [**lubridate**](https://lubridate.tidyverse.org/) and
[**clock**](https://clock.r-lib.org/) packages in the future.

## Addition of an scalar to a date

It’s very common that we need to calculate an end date for a process or
service knowing only the starting date and the duration. For this, we
need to add the number of **days** (scalar) to a date. Let’s take a
look:

``` r
start_point <- Sys.Date()
duration_days <- 365                # one year
start_point + duration_days         # [1] "2022-04-20"

duration_days <- 15                 # 15 days
start_point + duration_days         # [1] "2021-05-05"

duration_days <- 3 * 30             # 3 months (approx)
start_point + duration_days         # [1] "2021-07-19"

duration_days <- 16 * 7             # 16 weeks
start_point + duration_days         # [1] "2021-08-10"

class(start_point + duration_days)  # [1] "Date"
```

As you have seen above, adding a scalar to date produces another date
pointing at the future. If you want to add weeks, months, etc. you need
to convert it to days first. That’s a bit tricky because three months
aren’t exactly 90 days. The exact number depends on which months are
those. This has to be pre-computed separately, I’m afraid.
