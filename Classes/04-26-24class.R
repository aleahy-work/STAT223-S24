#
# Class 4/26/24 R Work
#

library(fpp3)

#
# Bootstrapping Example
#

google_stock <- gafa_stock |>
  filter(Symbol == "GOOG", year(Date) >= 2015) |>
  mutate(day = row_number()) |>
  update_tsibble(index = day, regular = TRUE)
# Filter the year of interest
google_2015 <- google_stock |> filter(year(Date) == 2015)

fit <- google_2015 |>
  model(NAIVE(Close))
sim <- fit |> generate(h = 30, times = 5, bootstrap = TRUE)
sim

google_2015 |>
  ggplot(aes(x = day)) +
  geom_line(aes(y = Close)) +
  geom_line(aes(y = .sim, colour = as.factor(.rep)),
            data = sim) +
  labs(title="Google daily closing stock price", y="$US" ) +
  guides(colour = "none")

fc <- fit |> forecast(h = 30, bootstrap = TRUE)
fc

autoplot(fc, google_2015) +
  labs(title="Google daily closing stock price", y="$US" )

#
# Train-Test Split Example
#

recent_production <- aus_production |>
  filter(year(Quarter) >= 1992)
train <- recent_production |>
  filter(year(Quarter) <= 2007)
beer_fit <- train |>
  model(
    Mean = MEAN(Beer),
    Naive = NAIVE(Beer),
    Seasonal_naive = SNAIVE(Beer),
    Drift = RW(Beer ~ drift())
  )
beer_fc <- beer_fit |>
  forecast(h = 10)


accuracy(beer_fit) |>
  arrange(.model) |>
  select(.model, .type, RMSE, MAE, MAPE, MASE, RMSSE)

accuracy(beer_fc, recent_production) |>
  arrange(.model) |>
  select(.model, .type, RMSE, MAE, MAPE, MASE, RMSSE)

#
# Graphical interpretation
#

recent_production <- aus_production |>
  filter(year(Quarter) >= 1992)
beer_train <- recent_production |>
  filter(year(Quarter) <= 2007)

beer_fit <- beer_train |>
  model(
    Mean = MEAN(Beer),
    `Naïve` = NAIVE(Beer),
    `Seasonal naïve` = SNAIVE(Beer),
    Drift = RW(Beer ~ drift())
  )

beer_fc <- beer_fit |>
  forecast(h = 10)

beer_fc |>
  autoplot(
    aus_production |> filter(year(Quarter) >= 1992),
    level = NULL
  ) +
  labs(
    y = "Megalitres",
    title = "Forecasts for quarterly beer production"
  ) +
  guides(colour = guide_legend(title = "Forecast"))

