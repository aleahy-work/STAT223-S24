#
# R notes for 4/22/24
#
bricks <- aus_production |>
  filter(!is.na(Bricks)) |>
  mutate(average = mean(Bricks))

bricks |>
  filter(!is.na(Bricks)) |>
  model(NAIVE(Bricks)) |>
  forecast(h = "5 years") |>
  autoplot(filter(bricks, year(Quarter) > 1990), level = NULL) +
  geom_point(data = slice(bricks, n()), aes(y = Bricks), colour = "#0072B2") +
  labs(title = "Clay brick production in Australia")


bricks |>
  model(SNAIVE(Bricks ~ lag("year"))) |>
  forecast(h = "5 years") |>
  autoplot(filter(bricks, year(Quarter) > 1990), level = NULL) +
  geom_point(data = slice(bricks, (n() - 3):n()), aes(y = Bricks), colour = "#0072B2") +
  labs(title = "Clay brick production in Australia")


aus_production |>
  filter(!is.na(Bricks)) |>
  model(RW(Bricks ~ drift())) |>
  forecast(h = "5 years") |>
  autoplot(aus_production, level = NULL) +
  geom_line(
    data = slice(aus_production, range(cumsum(!is.na(Bricks)))),
    aes(y = Bricks), linetype = "dashed", colour = "#0072B2") +
  labs(title = "Clay brick production in Australia")

# 
# The process
#

brick_fit <- aus_production |>
  filter(!is.na(Bricks)) |>
  model(
    Seasonal_naive = SNAIVE(Bricks),
    Naive = NAIVE(Bricks),
    Drift = RW(Bricks ~ drift()),
    Mean = MEAN(Bricks)
  )

brick_fc <- brick_fit |>
  forecast(h = "5 years")

brick_fc |>
  autoplot(aus_production, level = NULL) +
  labs(title = "Clay brick production in Australia",
       y = "Millions of bricks") +
  guides(colour = guide_legend(title = "Forecast"))

#
#  Facebook example
#

fb_stock <- gafa_stock |>
  filter(Symbol == "FB") |>
  mutate(trading_day = row_number()) |>
  update_tsibble(index = trading_day, regular = TRUE)

fb_stock |> autoplot(Close)

fit <- fb_stock |> model(NAIVE(Close))
augment(fit)

augment(fit) |>
  autoplot(.resid) +
  labs(y = "$US",
       title = "Residuals from naïve method")

augment(fit) |>
  ggplot(aes(x = .resid)) +
  geom_histogram(bins = 150) +
  labs(title = "Histogram of residuals")

augment(fit) |>
  ACF(.resid) |>
  autoplot() + labs(title = "ACF of residuals")

gg_tsresiduals(fit)



