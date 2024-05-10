#
# 05/03/24 R notes
#

#
# AR simulations
#
set.seed(1)
p1 <- tsibble(idx = seq_len(100), sim = 10 + arima.sim(list(ar = -0.8), n = 100), index = idx) %>%
  autoplot(sim) + labs(y="", title  = "AR(1)")
p2 <- tsibble(idx = seq_len(100), sim = 20 + arima.sim(list(ar = c(1.3, -0.7)), n = 100), index = idx) %>%
  autoplot(sim) + labs(y="", title ="AR(2)")

#
# MA simulations
#
set.seed(2)
p1 <- tsibble(idx = seq_len(100), sim = 20 + arima.sim(list(ma = 0.8), n = 100), index = idx) |>
  autoplot(sim) + labs(y = "", title = "MA(1)")
p2 <- tsibble(idx = seq_len(100), sim = arima.sim(list(ma = c(-1, +0.8)), n = 100), index = idx) |>
  autoplot(sim) + labs(y = "", title = "MA(2)")

p1 | p2

#
# Egyptian Exports example
#
global_economy |>
  filter(Code == "EGY") |>
  autoplot(Exports) +
  labs(y = "% of GDP", title = "Egyptian Exports")

fit <- global_economy |>
  filter(Code == "EGY") |>
  model(ARIMA(Exports))
report(fit)

gg_tsresiduals(fit)

fit |>
  forecast(h = 10) |>
  autoplot(global_economy) +
  labs(y = "% of GDP", title = "Egyptian Exports")


