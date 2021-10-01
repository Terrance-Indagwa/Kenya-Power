
library(dplyr)
library(rvest)




raw <- read_html("https://en.wikipedia.org/wiki/List_of_power_stations_in_Kenya")

raw <- raw %>%
  html_elements("table")
geothermal <- raw%>%
  html_table(.) %>%
  .[[2]]

hydroelectric <- raw %>%
  html_table() %>%
  .[[3]]

fossils <- raw %>%
  html_table(.) %>%
  .[[4]]

wind <- raw %>%
  html_table(.) %>%
  .[[5]]

solar <- raw %>%
  html_table(.) %>%
  .[[6]]


# Data Cleaning {#janitor}

## Geothermal

#changing colnames to lower case
colnames(geothermal) <- str_to_lower(colnames(geothermal))

#just selecting the first coordinates of the power plants.
geothermal$location <- geothermal$location %>%
  str_split_fixed( "/", n=2) %>%
  .[nrow(geothermal), 1]

#removing cells index numbers that got pooled by mistake
geothermal <- geothermal %>%
  mutate(
    station=str_remove_all(station,"\\[.\\]"),
    `capacity (mw)`=str_remove_all(`capacity (mw)`, "\\[.\\]"),
    notes=str_remove_all(notes, "\\[.\\]"),
    category=rep("geothermal", nrow(geothermal)))

  write.csv(geothermal, "data/geothermal.csv")




## Hydroelectric


#changing colnames to lower case
colnames(hydroelectric) <- str_to_lower(colnames(hydroelectric))

#just selecting the first coordinates of the power plants.
hydroelectric$location <- hydroelectric$location %>%
  str_split_fixed( "/", n=2) %>%
  .[1:15, 1]

hydroelectric <- hydroelectric %>%
  mutate(
    station=str_remove_all(station, "\\[..\\]"),
    location=str_remove_all(location, "\\[..\\]"),
    type=str_remove_all(type, "\\[..\\]"),
    `capacity (mw)`=str_remove_all(`capacity (mw)`, "\\[..\\]"),
    commissioned=str_remove_all(commissioned, "\\[..\\]"),
    category=rep("hydroelectric", nrow(hydroelectric))
  )

  write.csv(hydroelectric, "data/hydroelectric.csv")


## Fossils


#changing colnames to lower case
colnames(fossils) <- str_to_lower(colnames(fossils))

#just selecting the first coordinates of the power plants.
fossils$location <- fossils$location %>%
  str_split_fixed( "/", n=2) %>%
  .[1:10, 1]

fossils <- fossils %>%
  mutate(
    station=str_remove_all(station, "\\[..\\]"),
    location=str_remove_all(location, "\\[..\\]"),
    type=str_remove_all(type, "\\[..\\]"),
    `capacity (mw)`=str_remove_all(`capacity (mw)`, "\\[..\\]"),
    commissioned=str_remove_all(commissioned, "\\[..\\]"),
    category=rep("fossils", nrow(fossils))
  )


#Adding mini projects

mini <- data.frame(
  station= c("Dave Flower Farm", "Simbi Roses, Thika", "Oilvado Company ltd", "Pine Power ltd", "James Finlays ltd","Dagoreti Slaughter House"),
  capacity=c(0.1, 0.055, 1.34, 1.15, 1.16, .23),
  commissioned=c("in development", "in development", "operational", "operational","operational", "operational"),
  type=rep("Biogas", 6)
)

fossils <- fossils %>%
  full_join(mini, by=c("station", "capacity (mw)", "commissioned", "type")) %>%
  mutate(category=rep("fossils", 16))
  write.csv(fossils, "data/fossils.csv")





## Solar


#changing colnames to lower case
colnames(solar) <- str_to_lower(colnames(solar))

#just selecting the first coordinates of the power plants.
solar$location <- solar$coordinates %>%
  str_split_fixed( "/", n=2) %>%
  .[1, 1]

solar <- solar %>%
  mutate(
    station=str_remove_all(`solar power station`, "\\[..\\]"),
    location=str_remove_all(location, "\\[..\\]"),
    `capacity (mw)`=str_remove_all(`capacity (megawatts)`, "\\[..\\]"),
    commissioned=str_remove_all(`year completed`, "\\[..\\]"),
    category=rep("solar", nrow(solar))
  ) %>%
  select(c(station, location, `capacity (mw)`, commissioned, category))


  write.csv(solar, "data/solar.csv")


## Wind



#changing colnames to lower case
colnames(wind) <- str_to_lower(colnames(wind))

#just selecting the first coordinates of the power plants.
wind$location <- wind$location %>%
  str_split_fixed( "/", n=2) %>%
  .[1:5, 1]

wind <- wind %>%
  mutate(
    station=str_remove_all(station, "\\[..\\]"),
    location=str_remove_all(location, "\\[..\\]"),
    notes=str_remove_all(notes, "\\[..\\]"),
    `capacity (mw)`=str_remove_all(`capacity (mw)`, "\\[..\\]"),
    commissioned=str_remove_all(commissioned, "\\[..\\]"),
    category=rep("wind", nrow(wind))
  )

  write.csv(wind, "data/wind.csv")





