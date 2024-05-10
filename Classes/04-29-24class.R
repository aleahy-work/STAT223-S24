#
#  Notes for 4/29/24
#

#
#  A single variable example
#

us_change |>
  pivot_longer(c(Consumption, Income), names_to="Series") |>
  autoplot(value) +
  labs(y="% change")

us_change |>
  ggplot(aes(x = Income, y = Consumption)) +
  labs(y = "Consumption (quarterly % change)",
       x = "Income (quarterly % change)") +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE)

fit_cons <- us_change |>
  model(lm = TSLM(Consumption ~ Income))
report(fit_cons)

#
# A Multivariable Example
#

us_change |>
  gather("Measure", "Change", Consumption, Income, Production, Savings, Unemployment) |>
  ggplot(aes(x = Quarter, y = Change, colour = Measure)) +
  geom_line() +
  facet_grid(vars(Measure), scales = "free_y") +
  labs(y = "") +
  guides(colour = "none")

#
# install.packages("GGally")
#

us_change |>
  as_tibble() |>
  select(-Quarter) |>
  GGally::ggpairs()

fit_consMR <- us_change |>
  model(lm = TSLM(Consumption ~ Income + Production + Unemployment + Savings))
report(fit_consMR)

augment(fit_consMR) |>
  ggplot(aes(x = Quarter)) +
  geom_line(aes(y = Consumption, colour = "Data")) +
  geom_line(aes(y = .fitted, colour = "Fitted")) +
  labs(y = NULL, title = "Percent change in US consumption expenditure") +
  scale_colour_manual(values = c(Data = "black", Fitted = "#D55E00")) +
  guides(colour = guide_legend(title = NULL))

augment(fit_consMR) |>
  ggplot(aes(y = .fitted, x = Consumption)) +
  geom_point() +
  labs(
    y = "Fitted (predicted values)",
    x = "Data (actual values)",
    title = "Percentage change in US consumption expenditure"
  ) +
  geom_abline(intercept = 0, slope = 1)


fit_consMR |> gg_tsresiduals()

us_change |>
  left_join(residuals(fit_consMR), by = "Quarter") |>
  pivot_longer(Income:Unemployment,
               names_to = "regressor", values_to = "x") |>
  ggplot(aes(x = x, y = .resid)) +
  geom_point() +
  facet_wrap(. ~ regressor, scales = "free_x") +
  labs(y = "Residuals", x = "")

augment(fit_consMR) |>
  ggplot(aes(x = .fitted, y = .resid)) +
  geom_point() + labs(x = "Fitted", y = "Residuals")

#
# Linear Trend and Beer Production
#

fit_beer <- recent_production |> model(TSLM(Beer ~ trend() + season()))
report(fit_beer)

augment(fit_beer) |>
  ggplot(aes(x = Quarter)) +
  geom_line(aes(y = Beer, colour = "Data")) +
  geom_line(aes(y = .fitted, colour = "Fitted")) +
  labs(y = "Megalitres", title = "Australian quarterly beer production") +
  scale_colour_manual(values = c(Data = "black", Fitted = "#D55E00"))

augment(fit_beer) |>
  ggplot(aes(x = Beer, y = .fitted, colour = factor(quarter(Quarter)))) +
  geom_point() +
  labs(y = "Fitted", x = "Actual values", title = "Quarterly beer production") +
  scale_colour_brewer(palette = "Dark2", name = "Quarter") +
  geom_abline(intercept = 0, slope = 1)

fit_beer |> gg_tsresiduals()

fit_beer |>
  forecast() |>
  autoplot(recent_production)

