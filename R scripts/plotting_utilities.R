library(scales) # Additional library for labels
library(ggplot2)


simple_plot_mx_geometry <- function(alcaldias_list, alcadia_name) {
  # Ensure necessary libraries are loaded
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("ggplot2 package is required but not installed.")
  }
  if (!requireNamespace("sf", quietly = TRUE)) {
    stop("sf package is required but not installed.")
  }

  # Check if the alcadia_name exists in the list
  if (!alcadia_name %in% names(alcaldias_list)) {
    stop(paste("Alcadia", alcadia_name, "not found in the provided list."))
  }

  # Create the ggplot object
  plot_obj <- ggplot2::ggplot() +
    ggplot2::geom_sf(data = alcaldias_list[[alcadia_name]],
                     fill = "white",
                     color = "black") +
    ggplot2::theme_void()

  return(plot_obj)
}

# Usage:
# plot_alcadia(alcaldias_mx_city_list, "Xochimilco")

plot_mx_nighttime_light <-
  function(mx_ntl_df, mx_vector_geometry, year, area_title) {
    # Ensure necessary libraries are loaded
    if (!requireNamespace("ggplot2", quietly = TRUE)) {
      stop("ggplot2 package is required but not installed.")
    }
    if (!requireNamespace("sf", quietly = TRUE)) {
      stop("raster package is required but not installed.")
    }
    if (!requireNamespace("tidyterra", quietly = TRUE)) {
      stop("raster package is required but not installed.")
    }

    # dataframe form for tiling
    mx_ntl_df <- as.data.frame(
      mx_ntl_df,
          xy = T,
          na.rm = T
        )

    colnames(mx_ntl_df) <- c("x", "y", "value")


    # Color Ramp
    color <- c("#1f4762", "#FFD966", "white")

    pal <- colorRampPalette(
      color,
      bias = 8
    )(512)

    # get tif file by year
    globe_lights_file <- select_globe_file_by_year(year)

    # Get the raster
    globe_lights <- terra::rast(globe_lights_file)

    # get globe lights crs
    globe_ligts_crs <- terra::crs(globe_lights)

    #project mx geometry to globe crs
    projected_mx_geometry <- terra::project(
      mx_vector_geometry,
      globe_ligts_crs
    )

    # Create the ggplot object
    raster_plot <- ggplot(
      data = mx_ntl_df
    ) +
      geom_sf(
        data = projected_mx_geometry,
        fill = NA,
        color = "white",
        size = .5
      ) +
      geom_tile(
        aes(
          x = x,
          y = y,
          fill = value
        )
      ) +
            scale_fill_gradientn(
              name = "",
              colors = viridisLite::turbo(8),
              aesthetics = "fill"
            ) +
      theme_void() +
      theme(
                plot.title = element_text(
                  color = "white",
                  hjust = .5,
                  vjust = 0
                ),
                plot.margin = unit(
                  c(
                    t = 0, r = 0,
                    l = 0, b = 0
                  ),
                  "lines"
                ),
                plot.caption = element_text(color = "white"),
        plot.background = element_rect(fill = "#182833"),
        panel.border = element_rect(color = "#182833", fill = NA),
        panel.background = element_rect(fill = "#182833"),
        plot.subtitle = element_text(color = "white",
                                     hjust = 0.5),
        legend.title = element_text(color = "white"),
        legend.text = element_text(color = "white")        # Set legend text color to white
       ) +
      labs(
        title = glue::glue("Nighttime Lights in {area_title}"),
        subtitle = glue::glue("Average radiance in {year}"),
        caption = "Source: NOAA"
      )


    return(raster_plot)
  }

# # RASTER TO DF
#
# jawa_lights_df <- lapply(
#   jawa_lights_final,
#   function(x){

#   }
# )
#
# str(jawa_lights_df)
#
# col_names <- c("x", "y", "value")


# MAP



