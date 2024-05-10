#
# Class notes for 5/2/24
#

#
# Simulating common time series data with the simts package
#
library(simts)
help(gen_gts)
#
# Simulating and plotting 'white noise' normal distributions
#  (Note a difference time series appears each time we plot)
#
gen_gts(100, WN(sigma2 = 1))
myts3 <- gen_gts(100, WN(sigma2 = 1))
plot(myts3)

#
#  Plotting a simulated random walk
#
myts3 <- gen_gts(100, RW(gamma2 = 1))
plot(myts3)

#
# Plotting AR1 and MA1 time series with simts
#
model = AR1(phi = .7, sigma2 = .1) # + WN(sigma2=1)
x = gen_gts(300, model)
plot(x)

#
#  The Google differencing example
#

google_2018 <- gafa_stock |>
  filter(Symbol == "GOOG", year(Date) == 2018)

google_2018 |>
  autoplot(Close) +
  labs(y = "Closing stock price ($USD)")

google_2018 |>
  ACF(Close) |>
  autoplot()

#
# Plotting the differenced series
#
google_2018 |>
  autoplot(difference(Close)) +
  labs(y = "Change in Google closing stock price ($USD)")

google_2018 |>
  ACF(difference(Close)) |>
  autoplot()

#
# Example of the process of creating a stationary time series
# through:
#  1. a logarithmic transform to stabilize variance
#  2. a 12-month difference to remove seasonality
#  3. a 1-month difference to (hopefully) create a stationary series
#

PBS |>
  filter(ATC2 == "H02") |>
  summarise(Cost = sum(Cost)/1e6) |>
  transmute(
    `Sales ($million)` = Cost,
    `Log sales` = log(Cost),
    `Annual change in log sales` = difference(log(Cost), 12),
    `Doubly differenced log sales` =
      difference(difference(log(Cost), 12), 1)
  ) |>
  pivot_longer(-Month, names_to="Type", values_to="Sales") |>
  mutate(
    Type = factor(Type, levels = c(
      "Sales ($million)",
      "Log sales",
      "Annual change in log sales",
      "Doubly differenced log sales"))
  ) |>
  ggplot(aes(x = Month, y = Sales)) +
  geom_line() +
  facet_grid(vars(Type), scales = "free_y") +
  labs(title = "Corticosteroid drug sales", y = NULL)

#
# Testing Staionarity
#  with Google stock price

google_2018 <- gafa_stock |>
  filter(Symbol == "GOOG", year(Date) == 2018)

google_2018 |>
  autoplot(Close) +
  labs(y = "Closing stock price ($USD)")

google_2018 |>
  autoplot(difference(Close)) +
  labs(y = "Change in Google closing stock price ($USD)")

#
# KPSS test: H0: stationary (we reject in this case--this is non-stationary)
#
google_2018 %>%
  features(Close, unitroot_kpss)

#
#  The differenced series should be stationary, howerver
#
google_2018 %>%
  features(difference(Close), unitroot_kpss)

