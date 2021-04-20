How to deal with Dates and Times in R
================
Juan Lorenzo Arellano
2021-04-20

-   [Introduction](#introduction)
    -   [How to get current Date and
        Time](#how-to-get-current-date-and-time)
    -   [How to parse a Character String into a
        Date](#how-to-parse-a-character-string-into-a-date)
        -   [Default date format](#default-date-format)
        -   [Customized date format](#customized-date-format)
        -   [Adding time and timezones](#adding-time-and-timezones)
    -   [How to convert Dates into
        Strings](#how-to-convert-dates-into-strings)
        -   [Extracting parts of Dates](#extracting-parts-of-dates)
    -   [How to extract parts of Times](#how-to-extract-parts-of-times)

# Introduction

A common need that exists in most of the programming languages is
parsing strings into dates and converting dates into string. Mastering
this process is of vital importance for data analysts/data scientist
because we get data from many different sources and countries where
format changes, and for dates this is typically a headache. For
instance, “31st of January of 2021” can be written as:

-   **01/31/21**: US format
-   **January the 31, 2021**: US format
-   **31/01/21**: typically European format
-   **31.01.21**: typically German format
-   **31-01-21**: typically English format
-   **31/JAN/21**: variation of English format
-   **31 January 2021**: variation of English format

Conversely, in many occasions we to extract specific parts of the date
like day of week, calendar week, month name, day name, etc. or we
produce a long string containing date parts embedded with text like in
this example “today is Monday of week 23 (2021)”.

In this recipe we are going to learn how we can do this transformations
in **base R** (we will not cover
[**lubridate**](https://lubridate.tidyverse.org/) nor the new kid on the
block: [**clock**](https://clock.r-lib.org/)

## How to get current Date and Time

Base R comes with 2 main functions to report current data and time:

``` r
Sys.Date()          # [1] "2021-04-20"
Sys.time()          # [1] "2021-04-20 10:44:18 CEST"

class(Sys.Date())   # [1] "Date"
class(Sys.time())   # [1] "POSIXct" "POSIXt" 
```

Notice the inconsistency in the case: `Date()` starts with uppercase
while `time()` starts with lowercase.

`Sys.Date()` returns and object of the class `Date` with the current
date in the current time zone. `Sys.time()` returns and object of class
`POSIXct`. They can be formatted following below instructions. Both
classes store the number of seconds since 01/01/1970, so their
underlying data type is numeric (it’s a simple signed number). `POSIXct`
has more precision as it stores hours, minutes seconds and timezones:

``` r
t <- Sys.time()    
typeof(t)         # [1] "double"

d <- Sys.Date()    
typeof(d)         # [1] "double"
```

But, there is another data type or class for datetimes: `POSIXlt`. This
class creates a named list with all the date and time components like
day, minutes, seconds… etc. We’ll see this class a bit later.

## How to parse a Character String into a Date

### Default date format

A date is a data type or class that exists within R. When you need to
write a date into a report, document, csv, etc. you covert into a
string. Also, to enter a date into the R terminal you produce a string
that has to be converted into an R date type.

``` r
mydate_chr <- "2021-04-15"          # we create a date as string
class(mydate_chr)                   # [1] "character"

mydate_date <- as.Date(mydate_chr)  # we convert it into a date with default format yyyy-mm-dd 
class(mydate_date)                  # [1] "Date"
```

Ok, we’ve cast a string into a date with default format, but what is the
default format?. As per the documentation (`?as.Date()`), if we do not
indicate any format then the parameter `tryFormats` comes into play,
whose default value is `c("%Y-%m-%d", "%Y/%m/%d")`. Let’s test it!!

``` r
as.Date("2021/04/01")    # It works: [1] "2021-04-01"
as.Date("2021-04-01")    # It works: [1] "2021-04-01"
as.Date("2021.04.01")    # Error: character string is not in a standard unambiguous format
as.Date("2021 04 01")    # Error: character string is not in a standard unambiguous format
```

We’ve just seen how the two default formats work but not the other two,
as expected. We’ll try with a character vector as input with multiple
formats:

``` r
# First attempt
mydates <- c("2021/04/01", "2021/04/02", "2021-04-03", "2021.04.04")  # Format with slashes wins "/"
as.Date(mydates)           # [1] "2021-04-01" "2021-04-02" NA           NA 

# Second attempt
mydates <- c("2021-04-01", "2021/04/02", "2021-04-03", "2021.04.04")  # Format with dashes wins "-"
as.Date(mydates)           # [1] "2021-04-01" NA           "2021-04-03" NA  
```

What’s happened here? `format()` tries all the patterns in `tryFormats`
with the 1st element on the vector and when finds one that works then
uses it for the rest. Notice that in the second attempt I’ve only
changed the first date and it changed the behavior of `as.Date()`.

### Customized date format

What if the default format is not convenient for us. Then we use the
`format` argument of the function `as.Date()`

``` r
mydates <- c("01/01/2021", "02/02/2021")  # Changed to dd/mm/yyyy
as.Date(mydates, format = "%d/%m/%Y")     # Works: [1] "2021-01-01" "2021-02-02"

mydates <- c("01/JAN/21", "02/JAN/21")    # Format with slashes wins "/"
as.Date(mydates, format = "%d/%b/%y")     # Works: [1] "2021-01-01" "2021-01-02"

mydates <- c("Thu, 15 of April, 2021")          # Format with slashes wins "/"
as.Date(mydates, format = "%a, %d of %B, %Y")   # Works: [1] "2021-04-15"
```

There are plenty of *conversion specifications* that you can query on
the documentation of `strptime()` or
[here](https://rdrr.io/r/base/strptime.html).

### Adding time and timezones

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

As we said at the beginning, there is a class called `POSIXlt` that
stores a date and time in a name list. See below"

``` r
x <- strptime("2021-02-15 12:05:59"
              , format = "%Y-%m-%d %H:%M:%S")
class(x)     # [1] "POSIXlt" "POSIXt"
typeof(x)    # list
```

As we see, `strptime()` constructs a `POSIXlt` object. We can extract
its components individually:

``` r
x$sec     # 59
x$min     # 5
x$hour    # 12
x$mday    # 15
x$mon     # 1   (it goes from 0 to 11: do 1+x$mon)
x$year    # 121 (years from 1900: do 1900+x$year)
x$wday    # 1   (day of week 0-6 -Sun to Sat-)
x$yday    # 45  (day of year 0-364 -or 365 in a leap year-)
x$isdst   # 0   (daylight savings: 0 not in place)
x$zone    # CET (Central European Time)
x$gmtoff  # The offset in seconds from GMT. NA is unknown
```

A `POSIXlt` it’s a bit more complex class than a `POSIXct` but it stores
time in a human-like way.

## How to convert Dates into Strings

### Extracting parts of Dates

Here we can use the function `format()`. Let say, we want to know the
week number of Joe’s birthday, we can do:

``` r
Joe_bday <- as.Date("1975/03/28")
format(Joe_bday, format = "Week was %V")    # [1] "Week was 13"
```

We can also check other date elements, like:

``` r
format(Joe_bday, format = "That day it was %A (%a)")        # [1] "That day it was Friday (Fri)"
format(Joe_bday, format = "It was the day %u of the week")  # [1] "It was the day 3rd of the week 5"
format(Joe_bday, format = "It was %Cth century")            # [1] "It was 19th century (really ??)"
```

As can you see, %C doesn’t calculate the century correctly. It’s define
in the documentation as “Century (00–99): the integer part of the year
divided by 100.”. I warned you!

Additionally, there is a set of methods to assist on this matter,
namely:

``` r
weekdays(Joe_bday)                      # [1] "Friday"
weekdays(Joe_bday, abbreviate = T)      # [1] "Fri"

months(Joe_bday)                        # [1] "March"
months(Joe_bday, abbreviate = T)        # [1] "Mar"

quarters(Joe_bday)                      # [1] "Q1" 

julian(Joe_bday)                        # [1] "1970-01-01"  (number of days since 1970-01-01)
```

## How to extract parts of Times

If you’ve reached this point, it’s going to be a piece of cake for you:

``` r
Joe_bday <- strptime("1975-03-28 06:01:21 PM +0600"
                    , format = "%Y-%m-%d %I:%M:%S %p %z")

format(Joe_bday, format = "Hour: %H or %I %p")     # [1] "Hour: 13 or 01 PM" 
format(Joe_bday, format = "Minute: %M")            # [1] "Minute: 01"
format(Joe_bday, format = "Second: %S")            # [1] "Second: 21"
format(Joe_bday, format = "Timezone: %z")          # [1] "Timezone: +0600"
```

And that’s all! I’ve you read up to here, you’ll feel much comfortable
dealing with dates and times in R. We haven’t covert how to operate with
them (addition and subtraction of 2 dates). This will be another R
recipe.

I’d be very happy to hear from your. You can get in touch with me on:

-   Twitter: [@jlarellanoh](https://twitter.com/jlarellanoh)
-   Email: <r.data.science.101@gmail.com>
