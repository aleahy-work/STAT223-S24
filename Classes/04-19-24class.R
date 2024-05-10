library(fpp3)

#
#  Overview
#

us_retail_employment

us_retail_employment |>
  autoplot(Employed) 

us_retail_employment |>
  model(stl = STL(Employed))

dcmp <- us_retail_employment |>
  model(stl = STL(Employed))
components(dcmp)

components(dcmp) |> autoplot()

#
# MA3 and MA5 examples 
#

global_economy |> filter(Country == "Australia") |>
  autoplot(Exports) 

aus_exports <- global_economy |>
  filter(Country == "Australia") |>
  transmute(Exports, `3-MA` = slider::slide_dbl(Exports, mean,.before = 1, .after = 1, .complete = TRUE))

aus_exports |> 
  autoplot(Exports) +
  autolayer(aus_exports,`3-MA`, color = "#D55E00") +
  labs(y = "% of GDP",
       title = "Total Australian exports: 3-MA") +
  guides(colour = guide_legend(title = "series")) 

aus_exports <- global_economy |>
  filter(Country == "Australia") |>
  transmute(Exports, `5-MA` = slider::slide_dbl(Exports, mean,.before = 2, .after = 2, .complete = TRUE))

aus_exports |> 
  autoplot(Exports) +
  autolayer(aus_exports,`5-MA`, color = "#D55E00") +
  labs(y = "% of GDP",
       title = "Total Australian exports: 5-MA") +
  guides(colour = guide_legend(title = "series")) 
#
#  STL decomposition: the modern approach
#

us_retail_employment |>
  model(STL(Employed ~ season(window = 15) + trend(window = 15), robust = TRUE)) |>
  components() |>
  autoplot() + labs(title = "STL decomposition: US retail employment")

