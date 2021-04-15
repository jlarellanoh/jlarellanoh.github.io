How to deal with Dates and Times in R
================
Juan Lorenzo Arellano
2021-04-16

-   [Introduction](#introduction)
    -   [How to parse a Character String into a
        Date](#how-to-parse-a-character-string-into-a-date)
        -   [Default date format](#default-date-format)
        -   [Customized date format](#customized-date-format)
        -   [Adding time and timezones](#adding-time-and-timezones)
    -   [How to convert Dates into
        Strings](#how-to-convert-dates-into-strings)
        -   [How to extract parts of
            Dates](#how-to-extract-parts-of-dates)
    -   [How to extract parts of Times](#how-to-extract-parts-of-times)

# Introduction

A common need that exists in every programming language is parsing
strings into dates and converting dates into string. This is
specifically important for data analysts because we get data from many
different sources and countries where the format changes, and we need to
read that data into a R as dates. For instance, 31st of January of 2021
can be seen as:

-   **01/31/21**: US format
-   **January the 31, 2021**: US format
-   **31/01/21**: typically European format
-   **31.01.21**: typically German format
-   **31-01-21**: typically English format
-   **31/JAN/21**: variation of English format
-   **31 January 2021**: variation of English format

Conversely, in many occasions we to extract specific parts of the date
like day of week, calendar week, month name, day name, etc. or produce a
long string containing date parts like “Today is Monday of week 23
(2021)” when creating reports or dashboards.

We are going to see how we can do this transformations in **base R** (we
will not cover [**lubridate**](https://lubridate.tidyverse.org/) nor the
new kid on the block: [**clock**](https://clock.r-lib.org/)

## How to parse a Character String into a Date

### Default date format

A date is data type or class that exists within R. When you need to
write a date into a report, document, csv, etc. you covert into a
string. Also, to enter a date into the R terminal you produce a string
that has to be converted into an R date type.

``` r
mydate_chr <- "2021-04-15"     # we create a date as string
class(mydate_chr)              # [1] "character"

mydate_date <- as.Date(mydate_chr)  # we convert it into a date with default format yyyy-mm-dd 
mydate_date                         # [1] "2021-04-15"

class(mydate_date)             # [1] "Date"
```

Ok, we’ve cast a string into a Date with default format, but what is the
default format?. As per the documentation `?as.Date`, if we do not
indicate any format then the parameter *tryFormats* comes into play,
whose default value is *c(“%Y-%m-%d”, “%Y/%m/%d”)*. Let’s test it!!

``` r
mydates <- c("2021/04/01", "2021/04/02", "2021-04-03", "2021.04.04")  # Format with slashes wins "/"
as.Date(mydates)           # [1] "2021-04-01" "2021-04-02" NA           NA 

mydates <- c("2021-04-01", "2021/04/02", "2021-04-03", "2021.04.04")  # Format with dashes wins "-"
as.Date(mydates)           # [1] "2021-04-01" NA           "2021-04-03" NA  
```

What’s happened here? `format` tries all the patterns in `tryFormats`
and we it finds one that works then it keeps using that one discarding
the others. So I’ve changed only the format of the first date and it
lead the behavior of `as.Date()`.

### Customized date format

What if the default format is not convinient for us. Then we use the
`format` argument of `as.Date()`

``` r
mydates <- c("01/01/2021", "02/02/2021")  # Changed to dd/mm/yyyy
as.Date(mydates, format = "%d/%m/%Y")     # Works: [1] "2021-01-01" "2021-02-02"

mydates <- c("01/JAN/21", "02/JAN/21")    # Format with slashes wins "/"
as.Date(mydates, format = "%d/%b/%y")     # Works: [1] "2021-01-01" "2021-01-02"

mydates <- c("Thu, 15 of April, 2021")          # Format with slashes wins "/"
as.Date(mydates, format = "%a, %d of %B, %Y")   # Works: [1] "2021-04-15"
```

There are plenty of *conversion specifications* that you can query on
the documention of `strptime()` or
[here](https://rdrr.io/r/base/strptime.html).

### Adding time and timezones

Dates are stored with the class `Data` while datatimes are stored with
POSIXct:

``` r
Sys.Date()          # [1] "2021-04-16"
class(Sys.Date())   # [1] "Date"

Sys.time()          # [1] "2021-04-16" 00:30:23 CEST
class(Sys.time())   # [1] "POSIXct" "POSIXt" 
```

The class `POSIXct` stores the number of seconds since 01/01/1970, so
its underlying datatype is numeric (it’s a simple signed number):

``` r
x <- Sys.time()    
class(x)          # [1] "POSIXct" "POSIXt"
typeof(x)         # [1] "double"
```

In order to parse a datetime string, we need the function `strptime()`:

``` r
strptime("2021-02-15 12:05:59"
         , format = "%Y-%m-%d %H:%M:%S")

strptime("2021-02-15 12:05:59"
         , format = "%Y-%m-%d %T")              # %T = %H:%M:%S

strptime("2021-02-15 12:05:59 PM"
         , format = "%Y-%m-%d %I:%M:%S %p")     # %p = AM/PM

strptime("2021-02-15 12:05:59 PM +0350"
         , format = "%Y-%m-%d %I:%M:%S %p %z")  # %z = timezone

strptime("2021-02-15 12:05:59 PM -0600"
         , format = "%Y-%m-%d %I:%M:%S %p %z")  # %z = timezone
```

## How to convert Dates into Strings

### How to extract parts of Dates

Here we can use the function `format()`. Let say, we want to know the
week number of my birthday, we can do:

``` r
juan_bd <- as.Date("1979/02/21")
format(juan_bd, format = "Week was %V")    # [1] "Week was 08"
```

We can also check other date elements, like:

``` r
format(juan_bd, format = "That day it was %A (%a)")        # [1] "That day it was Wednesday (Wed)"
format(juan_bd, format = "It was the day %u of the week")  # [1] "It was the day 3rd of the week 08"
format(juan_bd, format = "It was %Cth century")            # [1] "It was 19th century"
```

## How to extract parts of Times

If you’ve reached this point, it’s going to be a piece of cake for you:

``` r
juan_bd <- strptime("1979-02-21 06:01:21 PM +0600"
                    , format = "%Y-%m-%d %I:%M:%S %p %z")

format(juan_bd, format = "Hour: %H or %I %p")     # [1] "Hour: 13 or 01 PM" 
format(juan_bd, format = "Minute: %M")            # [1] "Minute: 01"
format(juan_bd, format = "Second: %S")            # [1] "Second: 21"
format(juan_bd, format = "Timezone: %z")          # [1] "Timezone: +0600"
```

And that’s all! I’ll be very happy to hear your comments, feedback,
corrections and requests. You can get in touch with me on:

-   Twitter: @jlarellanoh
-   Email:
