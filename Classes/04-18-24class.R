#
# Some R Commands for class on 4/18/24
# See also the folder fpp3_slides in CNotes for
# Sections 3.1 and 3.2
#
aus_retail
food <- aus_retail |>
filter(Industry == "Food retailing") |>
summarise(Turnover = sum(Turnover))
food |> autoplot(Turnover) +
labs(y = "Turnover ($AUD)")
food |>
features(Turnover, features = guerrero)
food |>
autoplot(box_cox(Turnover, 0.0895)) +
labs(y = "Box-Cox transformed turnover")
us_retail_employment
us_employment
aus_retail
food <- aus_retail |>
filter(Industry == "Food retailing") |>
summarise(Turnover = sum(Turnover))
food |> autoplot(Turnover) +
labs(y = "Turnover ($AUD)")
food |>
features(Turnover, features = guerrero)
food |>
autoplot(box_cox(Turnover, 0.0895))
food |> autoplot(box_cox(Turnover, 0.0))
us_employment
source("setup.R")
us_retail_employment <- us_employment |>
filter(year(Month) >= 1990, Title == "Retail Trade") |>
select(-Series_ID)
savehistory("~/stat223/RWork/RIntro/04-18-24class.R")
