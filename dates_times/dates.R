# Dates without time

as.Date("2021-4-5, Thursday",   format = "%Y-%m-%d, %A")
as.Date("2021-apr-5, Thursday", format = "%Y-%b-%d, %A")
as.Date("2021-Apr-5, Thursday", format = "%Y-%b-%d, %A")
as.Date("01/02/21",             format = "%d/%m/%y")

days <- c(
    as.Date("2021-01-02")
  , as.Date("2021-02-28")
  , as.Date("2021-12-31"))

days
format(days, format = "%d/%b/%y")
format(days, format = "%a %A")
format(days, format = "%a, %d-%b-%Y")
format(days, format = "%B-%Y")
format(days, format = "%c")   # "%a %b %e %H:%M:%S %Y"
format(days, format = "%D")   # %m/%d/%y
format(days, format = "%F")   # %Y-%m-%d
format(days, format = "%V")   # %Y-%m-%d
format(days, format = "Week %V")   # %Y-%m-%d
format(days, format = "Day %j of the year")   # 001-366
format(days, format = "%a (day of the week: %u)")   # 001-366
