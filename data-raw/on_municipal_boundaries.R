## code to prepare `DATASET` dataset goes here
library(sf)
library(tidyverse)
library(rmapshaper)

import_municipal_boundary_file <- function(path) {
  sf::sf_use_s2(FALSE)
  sf::st_read(path) |> 
    dplyr::mutate(
      # Correct Gordon / Barrie Island MUNID to align with FIR
      MUNID = dplyr::case_when(
        MUNID == "51024" ~ 51025L, 
        TRUE ~ as.integer(MUNID)
      )
    ) |> 
    dplyr::mutate(
      tier_code = dplyr::case_when(
        MUN_TYPE_E == "Upper Tier Municipality" ~ "UT", 
        MUN_TYPE_E == "District" ~ "D",
        MUN_TYPE_E == "Lower Tier Municipality" ~ "LT",
        MUN_TYPE_E == "Single Tier Municipality" ~ "ST",
        TRUE ~ NA_character_
      ), 
      data_source = path |> 
        stringr::str_extract("[A-Z_]+(?=\\.shp$)")
    ) |> 
    dplyr::rename( 
      munid = MUNID, 
      municipality = NM_SHORT_E
    ) |> 
    rmapshaper::ms_simplify(keep = 0.001)
}

utd_basic <- utd |> ms_simplify(keep = 0.001)

utd_basic

utd |> 
  ggplot(aes(fill = municipality)) + 
  geom_sf()

utd_basic |> 
  ggplot(aes(fill = municipality)) + 
  geom_sf()

on_municipal_boundaries <- 
  dplyr::bind_rows(
    import_municipal_boundary_file("data-raw/LIO-2024-02-16/MUNIC_BND_UPPER_AND_DIST.shp"),
    import_municipal_boundary_file("data-raw/LIO-2024-02-21/MUNIC_BND_LOWER_AND_SINGLE.shp")
  ) 

on_municipal_boundaries_dry <- on_municipal_boundaries |>
  filter(EXT_TYPE_E != "Water") |> 
  group_by(munid, municipality, tier_code) |> 
  summarize(geometry = ms_dissolve(geometry))

on_municipal_boundaries_wet <- on_municipal_boundaries |> 
  group_by(munid, municipality, tier_code) |>
  summarize(geometry = ms_dissolve(geometry))

usethis::use_data(on_municipal_boundaries_wet, overwrite = TRUE)
usethis::use_data(on_municipal_boundaries_dry, overwrite = TRUE)
