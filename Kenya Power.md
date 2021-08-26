---
title: "Kenya Power"
author: "Dir.Terrance"
date: "8/12/2021"
output: html_document
---




```r
library(tidyverse)
library(rvest)
```


```r
raw <- read_html("https://en.wikipedia.org/wiki/List_of_power_stations_in_Kenya")
```

```
## Error in open.connection(x, "rb"): Could not resolve host: en.wikipedia.org
```

```r
raw <- raw %>% 
  html_elements("table") 
geothermal <- raw%>% 
  html_table(.) %>% 
  .[[2]]

hydroelectric <- raw %>% 
  html_table() %>% 
  .[[3]]
```

```
## Error in .[[3]]: subscript out of bounds
```

```r
fossils <- raw %>% 
  html_table(.) %>% 
  .[[4]]
```

```
## Error in .[[4]]: subscript out of bounds
```

```r
wind <- raw %>% 
  html_table(.) %>% 
  .[[5]]
```

```
## Error in .[[5]]: subscript out of bounds
```

```r
solar <- raw %>% 
  html_table(.) %>% 
  .[[6]]
```

```
## Error in .[[6]]: subscript out of bounds
```

# Data Cleaning {#janitor}

## Geothermal

```r
#changing colnames to lower case
colnames(geothermal) <- str_to_lower(colnames(geothermal))

#just selecting the first coordinates of the power plants.
geothermal$location <- geothermal$location %>% 
 str_split_fixed( "/", n=2) %>% 
  .[nrow(geothermal), 1] 
```

```
## Warning: Unknown or uninitialised column: `location`.
```

```
## Error in .[nrow(geothermal), 1]: subscript out of bounds
```

```r
#removing cells index numbers that got pooled by mistake
geothermal <- geothermal %>%
  mutate(
  station=str_remove_all(station,"\\[.\\]"),
  `capacity (mw)`=str_remove_all(`capacity (mw)`, "\\[.\\]"),
  notes=str_remove_all(notes, "\\[.\\]"))
```

```
## Error: Problem with `mutate()` column `station`.
## ℹ `station = str_remove_all(station, "\\[.\\]")`.
## x object 'station' not found
```



## Hydroelectric


```r
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
   commissioned=str_remove_all(commissioned, "\\[..\\]")
  )
```

## Fossils


```r
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
   commissioned=str_remove_all(commissioned, "\\[..\\]")
  )
```

## Solar


```r
#changing colnames to lower case
colnames(solar) <- str_to_lower(colnames(solar))

#just selecting the first coordinates of the power plants.
solar$location <- solar$coordinates %>% 
 str_split_fixed( "/", n=2) %>% 
  .[1, 1]
```

```
## Warning: Unknown or uninitialised column: `coordinates`.
```

```
## Error in .[1, 1]: subscript out of bounds
```

```r
solar <- solar %>% 
   mutate(
    station=str_remove_all(`solar power station`, "\\[..\\]"),
    location=str_remove_all(location, "\\[..\\]"),
    `capacity (mw)`=str_remove_all(`capacity (megawatts)`, "\\[..\\]"),
   commissioned=str_remove_all(`year completed`, "\\[..\\]")
  ) %>% 
  select(c(station, location, `capacity (mw)`, commissioned))
```

```
## Error: Problem with `mutate()` column `station`.
## ℹ `station = str_remove_all(`solar power station`, "\\[..\\]")`.
## x object 'solar power station' not found
```

## Wind


```r
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
   commissioned=str_remove_all(commissioned, "\\[..\\]")
  )
```

