select_globe_file_by_year <- function(year) {

  globe_light_files <- fs::dir_ls(
    path = here("Globe Lights")
  )

  # Define the file paths
  files <- list(
    "2012" = globe_light_files[1],
    "2022" = globe_light_files[2]
  )

  # Check if the provided year is available
  if (!as.character(year) %in% names(files)) {
    stop("Year not available. Please choose 2012 or 2022.")
  }

  # Return the corresponding file path
  return(files[[as.character(year)]])
}


# Make a function to crop the globe lights by a provided geometry of mx city or its alcadias
crop_global_nightime_lights_raster <- function(mx_geometry, year){
  # get tif file by year
  globe_lights_file <- select_globe_file_by_year(year)

  # Get the raster
  globe_lights <- terra::rast(globe_lights_file)

  # get globe lights crs
  globe_ligts_crs <- terra::crs(globe_lights)

  #project mx geometry to globe crs
  projected_mx_geometry <- terra::project(
    mx_geometry,
    globe_ligts_crs
  )

  # Crop the raster
  mx_lights <- terra::crop(
    globe_lights,
    projected_mx_geometry,
    snap = "in",
    mask = TRUE
  )

  # Remove zeros and subzeros
  mx_lights <- terra::ifel(
    mx_lights <= 0,
    NA,
    mx_lights
  )

  return(mx_lights)
}
