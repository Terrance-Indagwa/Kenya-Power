---
title: "Kenya Power"
author: "Dir.Terrance"
date: "8/12/2021"
output: html_document
---




```r
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
```

```
## ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
## ✓ tibble  3.1.3     ✓ dplyr   1.0.7
## ✓ tidyr   1.1.3     ✓ stringr 1.4.0
## ✓ readr   1.4.0     ✓ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
library(rvest)
```

```
## 
## Attaching package: 'rvest'
```

```
## The following object is masked from 'package:readr':
## 
##     guess_encoding
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
```

```
## Error in UseMethod("xml_find_all"): no applicable method for 'xml_find_all' applied to an object of class "function"
```

```r
geothermal <- raw%>% 
  html_table(.) %>% 
  .[[2]]
```

```
## Error in UseMethod("html_table"): no applicable method for 'html_table' applied to an object of class "function"
```

```r
hydroelectric <- raw %>% 
  html_table() %>% 
  .[[3]]
```

```
## Error in UseMethod("html_table"): no applicable method for 'html_table' applied to an object of class "function"
```

```r
fossils <- raw %>% 
  html_table(.) %>% 
  .[[4]]
```

```
## Error in UseMethod("html_table"): no applicable method for 'html_table' applied to an object of class "function"
```

```r
wind <- raw %>% 
  html_table(.) %>% 
  .[[5]]
```

```
## Error in UseMethod("html_table"): no applicable method for 'html_table' applied to an object of class "function"
```

```r
solar <- raw %>% 
  html_table(.) %>% 
  .[[6]]
```

```
## Error in UseMethod("html_table"): no applicable method for 'html_table' applied to an object of class "function"
```

# Data Cleaning {#janitor}

## Geothermal

```r
#changing colnames to lower case
colnames(geothermal) <- str_to_lower(colnames(geothermal))
```

```
## Error in is.data.frame(x): object 'geothermal' not found
```

```r
#just selecting the first coordinates of the power plants.
geothermal$location <- geothermal$location %>% 
 str_split_fixed( "/", n=2) %>% 
  .[nrow(geothermal), 1] 
```

```
## Error in stri_split_regex(string, pattern, n = n, simplify = simplify, : object 'geothermal' not found
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
## Error in mutate(., station = str_remove_all(station, "\\[.\\]"), `capacity (mw)` = str_remove_all(`capacity (mw)`, : object 'geothermal' not found
```



## Hydroelectric


```r
#changing colnames to lower case
colnames(hydroelectric) <- str_to_lower(colnames(hydroelectric))
```

```
## Error in is.data.frame(x): object 'hydroelectric' not found
```

```r
#just selecting the first coordinates of the power plants.
hydroelectric$location <- hydroelectric$location %>% 
 str_split_fixed( "/", n=2) %>% 
  .[1:15, 1]
```

```
## Error in stri_split_regex(string, pattern, n = n, simplify = simplify, : object 'hydroelectric' not found
```

```r
hydroelectric <- hydroelectric %>% 
  mutate(
    station=str_remove_all(station, "\\[..\\]"),
    location=str_remove_all(location, "\\[..\\]"),
    type=str_remove_all(type, "\\[..\\]"),
    `capacity (mw)`=str_remove_all(`capacity (mw)`, "\\[..\\]"),
   commissioned=str_remove_all(commissioned, "\\[..\\]")
  )
```

```
## Error in mutate(., station = str_remove_all(station, "\\[..\\]"), location = str_remove_all(location, : object 'hydroelectric' not found
```

## Fossils


```r
#changing colnames to lower case
colnames(fossils) <- str_to_lower(colnames(fossils))
```

```
## Error in is.data.frame(x): object 'fossils' not found
```

```r
#just selecting the first coordinates of the power plants.
fossils$location <- fossils$location %>% 
 str_split_fixed( "/", n=2) %>% 
  .[1:10, 1]
```

```
## Error in stri_split_regex(string, pattern, n = n, simplify = simplify, : object 'fossils' not found
```

```r
fossils <- fossils %>% 
   mutate(
    station=str_remove_all(station, "\\[..\\]"),
    location=str_remove_all(location, "\\[..\\]"),
    type=str_remove_all(type, "\\[..\\]"),
    `capacity (mw)`=str_remove_all(`capacity (mw)`, "\\[..\\]"),
   commissioned=str_remove_all(commissioned, "\\[..\\]")
  )
```

```
## Error in mutate(., station = str_remove_all(station, "\\[..\\]"), location = str_remove_all(location, : object 'fossils' not found
```

## Solar


```r
#changing colnames to lower case
colnames(solar) <- str_to_lower(colnames(solar))
```

```
## Error in is.data.frame(x): object 'solar' not found
```

```r
#just selecting the first coordinates of the power plants.
solar$location <- solar$coordinates %>% 
 str_split_fixed( "/", n=2) %>% 
  .[1, 1]
```

```
## Error in stri_split_regex(string, pattern, n = n, simplify = simplify, : object 'solar' not found
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
## Error in mutate(., station = str_remove_all(`solar power station`, "\\[..\\]"), : object 'solar' not found
```

## Wind


```r
#changing colnames to lower case
colnames(wind) <- str_to_lower(colnames(wind))
```

```
## Error in is.data.frame(x): object 'wind' not found
```

```r
#just selecting the first coordinates of the power plants.
wind$location <- wind$location %>% 
 str_split_fixed( "/", n=2) %>% 
  .[1:5, 1]
```

```
## Error in stri_split_regex(string, pattern, n = n, simplify = simplify, : object 'wind' not found
```

```r
wind <- wind %>% 
  mutate(
    station=str_remove_all(station, "\\[..\\]"),
    location=str_remove_all(location, "\\[..\\]"),
    notes=str_remove_all(notes, "\\[..\\]"),
    `capacity (mw)`=str_remove_all(`capacity (mw)`, "\\[..\\]"),
   commissioned=str_remove_all(commissioned, "\\[..\\]")
  )
```

```
## Error in mutate(., station = str_remove_all(station, "\\[..\\]"), location = str_remove_all(location, : object 'wind' not found
```

