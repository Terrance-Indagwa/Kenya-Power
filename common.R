library(tidyverse)
library(vroom)
library(shiny)
library(plotly)
library(leaflet)
library(tidygeocoder)

library(markdown)

library(flexdashboard)
#source(purl("Kenya Power.Rmd"))

setwd("/home/rwills/Rproject/Project-JULY/Kenya-Power")


#reading in the data sets
fossils <- vroom("fossils.csv")
geothermal <- vroom("geo.csv")
hydroelectric <- vroom("hydroelectric.csv")
solar <- vroom("solar.csv")
wind <- vroom("wind.csv")

general <- fossils %>%
  full_join(
    solar, by = c("station", "location", "capacity (mw)", "category")) %>%
  full_join(wind, by = c("station", "location", "capacity (mw)", "category")) %>%
  full_join(hydroelectric,by = c("station", "location", "capacity (mw)", "category")) %>% full_join(geothermal, by=c("station", "location", "capacity (mw)", "category")) %>%
  select( c("station", "location", "capacity (mw)", "category"))


wind$notes[is.na(wind$notes)] <-"Operational"

geothermal$notes[is.na(geothermal$notes)] <- "Operational"

InputCategory <- unique(general$category)

InputStation <- unique(general$station)
