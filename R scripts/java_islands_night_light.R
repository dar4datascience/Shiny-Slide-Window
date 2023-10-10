# # # Return Java Island’s Night Light as lower case
# # # SHINY SWIPE MAP: JAVA ISLAND NIGHTTIME LIGHTS
# # # SHOUTOUT TO MILOS PAPOVIC (https://github.com/milos-agathon)
# #
# #
# # # INSTALLING LIBRARY
# library(ggplot2)
# library(dplyr)
# library(sf)
# library(terra)
# #
# # # SET ROI
# #
# jawa_sf <- st_read("java island geometry/jawa.shp")
# #
# # # # GET DATA
# # ## if you get runtime error, just download and place it to your
# # ## working folder manually
# # #
#
#
# # LOAD DATA
#
# raster_files <- list.files(
#   path = here(
#     "Globe Lights"
#   ),
#   pattern = "npp",
#   full.names = T
# )
#
# globe_lights <- lapply(
#   raster_files,
#   terra::rast
# )
#
# # CROP DATA
#
# jawa_lights_list <- lapply(
#   globe_lights,
#   function(x){
#     terra::crop(
#       x,
#       terra::vect(jawa_sf),
#       snap = "in",
#       mask = T
#     )
#   }
# )
# rm(globe_lights)
# gc()
# # REMOVE ZEROS AND SUBZEROS
#
# jawa_lights_final <- lapply(
#   jawa_lights_list,
#   function(x){
#     terra::ifel(
#       x <= 0,
#       NA,
#       x
#     )
#   }
# )
#
# # # RASTER TO DF
# #
# # jawa_lights_df <- lapply(
# #   jawa_lights_final,
# #   function(x){
# #     as.data.frame(
# #       x,
# #       xy = T,
# #       na.rm = T
# #     )
# #   }
# # )
# #
# # str(jawa_lights_df)
# #
# # col_names <- c("x", "y", "value")
#
# jawa_lights_df <- lapply(
#   jawa_lights_df,
#   setNames,
#   col_names
# )
#
# # MAP
#
# color <- c("#1f4762", "#FFD966", "white")
#
# pal <- colorRampPalette(
#   color, bias = 8
# )(512)
#
# years <- c(2012, 2022)
#
# names(jawa_lights_df) <- years
#
# str(jawa_lights_df)
#
# map <- lapply(
#   names(jawa_lights_df),
#   function(df){
    # ggplot(
    #   data = jawa_lights_df[[1]]
    # ) +
    #   geom_sf(
    #     data = jawa_sf,
    #     fill = NA,
    #     color = color[[1]],
    #     size = .5
    #   ) +
    #   geom_tile(
    #     aes(
    #       x = x,
    #       y = y,
    #       fill = value
    #     )
    #   ) +
    #   scale_fill_gradientn(
    #     name = "",
    #     colors = pal,
    #     aesthetics = "fill"
    #   ) +
    #   theme_void() +
    #   theme(
    #     legend.position = "none",
    #     plot.title = element_text(
    #       size = 60,
    #       color = "white",
    #       hjust = .5,
    #       vjust = 0
    #     ),
    #     plot.margin = unit(
    #       c(
    #         t = 0, r = 0,
    #         l = 0, b = 0
    #       ), "lines"
    #     )
    #   ) #+
#       labs(title = df)
#   }
# )

# for (i in 1:2){
#   file_name = paste0(
#     "jawa_map_", i, ".png")
#   png(
#     file_name,
#     width = 800,
#     height = 800,
#     units = "px",
#     bg = "#182833"
#   )
#
#   print(map[[i]])
#   dev.off()
# }
#
# # MOVE IMAGES TO SHINY FOLDER
#
# .libPaths()
# current_dir <- getwd()
# shiny_dir <- "www"
# images_list <- list.files(
#   path = current_dir,
#   pattern = "jawa_map"
# )
#
# file.copy(
#   from = file.path(
#     current_dir,
#     images_list
#   ),
#   to = shiny_dir,
#   overwrite = T,
#   recursive = F,
#   copy.mode = T
# )
#
