# # Return Java Island’s Night Light as lower case
# # SHINY SWIPE MAP: JAVA ISLAND NIGHTTIME LIGHTS
# # SHOUTOUT TO MILOS PAPOVIC (https://github.com/milos-agathon)
#
#
# # INSTALLING LIBRARY
library(ggplot2)
library(dplyr)
library(sf)
library(terra)
library(here)
library(tidyterra)
library(slickR)
library(svglite)
library(htmltools)
#
i_am("R scripts/cdmx_night_light.R")

source(
  here("R scripts", "utilities.R")
)

source(
  here("R scripts", "plotting_utilities.R")
)

# Get Mexico City Geometry ------------------------------------------------
#  Download marco geoestadistico from INEGI
# url_marco_geo_dic_22 <- "https://www.inegi.org.mx/contenidos/productos/prod_serv/contenidos/espanol/bvinegi/productos/geografia/marcogeo/889463770541_s.zip"

# Download and unzip
# download.file(url_marco_geo_dic_22, "mexico city geometries/marco_geo_dic_22.zip")

# Mexico City Geometry has lots of shape files
# we want only first Estate level data and then


# Read in Geometries ------------------------------------------------------


# SAVE
mx_city <- st_read(
  here("mexico city geometries",
       "09_ciudaddemexico",
       "conjunto_de_datos",
       "09ent.shp")
) |>
  # get main poligon
  vect()

#plot to see it
plot(mx_city)

# Get alcaldia / municipio data
alcadias_mx_city <- st_read(
  here("mexico city geometries",
       "09_ciudaddemexico",
       "conjunto_de_datos",
       "09mun.shp")
) |>
  # get main poligon
  vect()

#plot to see it
plot(alcadias_mx_city)

# decompose to have 1 alcaldia geometry into a list
# SAVE
alcaldias_mx_city_list <- alcadias_mx_city$NOMGEO |>
  purrr::map(
    function(alcadia){
      # dplyr functionality to terra objects via tidyterra package
      alcaldia_geometry = alcadias_mx_city |>
        filter(NOMGEO == alcadia)

      list_alcadia_info <- setNames(list(alcaldia_geometry), alcadia)

      return(list_alcadia_info)
    }
  ) |>
  purrr::list_c()

# See 1 alcadia geometry
alcaldias_mx_city_list |>
  simple_plot_mx_geometry("Xochimilco")


# .SlickR simple Geometries ------------------------------------------------
# append mx city to alcaldias list
full_cdmx_geometry_list <- c(alcaldias_mx_city_list,
                             list("Mexico City" = mx_city)
                             )


slick_cdmx_simple_geometries <- full_cdmx_geometry_list |>
  purrr::map2(
    names(full_cdmx_geometry_list),
    \(mx_geometry, name)
    xmlSVG({
      show(    # Create the ggplot object
        ggplot2::ggplot() +
          ggplot2::geom_sf(data = mx_geometry,
                           fill = "white",
                           color = "forestgreen") +
          ggplot2::theme_void() +
          theme(
            plot.title = element_text(color = "white",
                                      hjust = .5,
                                      size = 25,
                                      vjust = 0),
            plot.caption = element_text(color = "white"),
            plot.background = element_rect(fill = "#182833"),
            panel.border = element_rect(color = "#182833", fill = NA),
            panel.background = element_rect(fill = "#182833"),
            plot.subtitle = element_text(color = "white",
                                         hjust = 0.5)
          ) +
          labs(
            title = name,
            caption = "Source: INEGI Marco GEoestadistico 2022"
          )
        )
    },
    standalone = TRUE)
  )


slickR::slickR(slick_cdmx_simple_geometries, width = "95%") + settings(dots = TRUE)

# Get Nighttime Light CDMX ------------------------------------------------


mexico_city_night_lights_map_list_2012 <- full_cdmx_geometry_list |>
  purrr::map2(
    .y = names(full_cdmx_geometry_list),
    .f = function(mx_geometry, mx_geom_name){

      mx_raster <-     crop_global_nightime_lights_raster(
        mx_geometry = mx_geometry,
        year = 2012
      )

      mx_raster_list <- setNames(list(mx_raster), mx_geom_name)


      return(mx_raster_list)
    }
  ) |>
  purrr::list_c()

mexico_city_night_lights_map_list_2022 <- full_cdmx_geometry_list |>
  purrr::map2(
    .y = names(full_cdmx_geometry_list),
    .f = function(mx_geometry, mx_geom_name){

      mx_raster <-     crop_global_nightime_lights_raster(
        mx_geometry = mx_geometry,
        year = 2022
      )

      mx_raster_list <- setNames(list(mx_raster), mx_geom_name)


      return(mx_raster_list)
    }
  ) |>
  purrr::list_c()


# .Plot 1 -----------------------------------------------------------------
mexico_city_night_lights_map_list_2012[['Iztapalapa']] |>
  plot_mx_nighttime_light(full_cdmx_geometry_list[['Iztapalapa']], 2012,
                          area_title = 'Iztapalapa')


# .Plot All ---------------------------------------------------------------
# MY PLOTS LOOK FLAT CAUSE I HAVE NO ELEVATION DATA
maps_cdmx_2012_list <-  mexico_city_night_lights_map_list_2012 |>
  purrr::map2(
  .y = names(mexico_city_night_lights_map_list_2012),
  .f = function(mx_raster, mx_raster_name){
    mx_raster |>
      plot_mx_nighttime_light(full_cdmx_geometry_list[[mx_raster_name]], 2012,
                              area_title = mx_raster_name)
  }
)

maps_cdmx_2022_list <- mexico_city_night_lights_map_list_2022 |>
  purrr::map2(
    .y = names(mexico_city_night_lights_map_list_2022),
    .f = function(mx_raster, mx_raster_name){
      mx_raster |>
        plot_mx_nighttime_light(full_cdmx_geometry_list[[mx_raster_name]], 2022,
                                area_title = mx_raster_name)
    }
  )


# Slick Nighttime Images --------------------------------------------------

slick_night_maps_cdmx_2012 <- maps_cdmx_2012_list |>
  purrr::map(
    \(mx_geometry)
    xmlSVG({
     show(mx_geometry)
    },
    standalone = TRUE)
  )

slick_night_maps_cdmx_2022 <- maps_cdmx_2022_list |>
  purrr::map(
    \(mx_geometry)
    xmlSVG({
      show(mx_geometry)
    },
    standalone = TRUE)
  )

slick_2012 <- slickR(slick_night_maps_cdmx_2012, width = "95%") +
  settings(slidesToShow = 1, slidesToScroll = 1)

slick_2022 <- slickR(slick_night_maps_cdmx_2022, width = "95%") +
  settings(slidesToScroll = 1,
           centerMode = TRUE, focusOnSelect = TRUE)

slick_2012 %synch% slick_2022

# Save Images -------------------------------------------------------------
purrr::walk2(
  .x = maps_cdmx_2012_list,
  .y = names(maps_cdmx_2012_list),
  .f = function(map, name){
    map |>
      ggsave(
        filename =
          here(
            "MX City Lights",
            "2012",
            paste0(
          name,
          " NTL 2012",
          ".png"
        )
        ),
        width = 800,
        height = 800,
        units = "px"
      )
  }
)


purrr::walk2(
  .x = maps_cdmx_2022_list,
  .y = names(maps_cdmx_2022_list),
  .f = function(map, name){
    map |>
      ggsave(
        filename =
          here(
            "MX City Lights",
            "2022",
            paste0(
              name,
              " NTL 2022",
              ".png"
            )
          )
      )
  }
)

