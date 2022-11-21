library(GetBCBData)
library(tidyverse)
library(lubridate)
dolar <- gbcbd_get_series(id = 1, 
                          first.date = "1994-07-01",
                          last.date = Sys.Date())
sm <- gbcbd_get_series(id = 1619, 
                       first.date = "1994-07-01",
                       last.date = Sys.Date())
dados <- 
  dolar |> 
  select(ref.date, dolar = value) |>  
  left_join(select(sm, ref.date, sm = value), by = "ref.date") |> 
  fill(sm, .direction = "down") |> 
  mutate(sm_dolarizado = sm/dolar) |> 
  mutate(ref.date = ymd(ref.date))
ggplot(dados, aes(x = ref.date, y = sm_dolarizado)) +
  geom_line() +
  labs(x = "Data", y = "Salário Mínimo em US$", caption = "marcusnunes.me") +
  scale_x_date(
    breaks = seq.Date(from = ymd("1995-01-01"),
                      to = Sys.Date(),
                      by = "4 year"),
    date_labels = "%Y"
  ) +
  scale_y_continuous(breaks = seq(50, 350, 50), minor_breaks = NULL) +
  theme_bw()
