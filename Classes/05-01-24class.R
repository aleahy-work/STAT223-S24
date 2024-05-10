#
#  5/1/24 R class work
#

#
# Section 5.11: Exercise 9
#

hh_budget
hh_budget |> distinct(Country)
hh_budget |> filter(Country == "Australia")
aus_budget <- hh_budget |> filter(Country == "Australia")
aus_budget
aus_budget |> arrange(Year)
aus_budget |> arrange(desc(Year))
aus_budget |> filter(Year <= 2012)
train_data <- aus_budget |> filter(Year <= 2012)

aus_fit <- train_data |>
  model(
    Mean = MEAN(Wealth),
    Naive = NAIVE(Wealth),
    Drift = RW(Wealth ~ drift())
  )

aus_fit

aus_fc <- aus_fit |>
  forecast(h = "4 years")

aus_fc |>
  autoplot(
    aus_budget,
    level = NULL
  ) +
  labs(
    y = "population",
    title = "Aus Wealth"
  ) +
  guides(colour = guide_legend(title = "Forecast"))

accuracy(aus_fc, aus_budget)

aus_fit2 <- train_data |>
  model(
    Drift = RW(Wealth ~ drift())
  )

aus_fit2 |> gg_tsresiduals()

#
# Exponential Smoothing: Algeria economy example
#

algeria_economy <- global_economy |>
  filter(Country == "Algeria")

fit <- algeria_economy |>
  model(
    ETS(Exports ~ error("A") + trend("N") + season("N"))
  )

report(fit)

fit |>
  forecast(h = 5) |>
  autoplot(algeria_economy) +
  labs(y = "% of GDP", title = "Exports: Algeria")

#
# Exponential Smoothing with Trend Example: Australian population
#

aus_economy <- global_economy |>
  filter(Code == "AUS") |>
  mutate(Pop = Population / 1e6)
fit <- aus_economy |>
  model(AAN = ETS(Pop ~ error("A") + trend("A") + season("N")))
report(fit)

components(fit) |> autoplot()

fit |>
  forecast(h = 10) |>
  autoplot(aus_economy, level = NULL) +
  labs(y = "Millions", title = "Population: Australia")


