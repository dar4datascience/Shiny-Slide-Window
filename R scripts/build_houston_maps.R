
# Get Location Midpoint ---------------------------------------------------
library(googleway)
key <- Sys.getenv("GMAP_KEY")
set_key(key = key)
google_keys()

df <- google_geocode(address = "Houston, Texas, USA",
                     simplify = TRUE)

# Build Artsy Map ---------------------------------------------------------


## -----------------------------------
library(sf)
library(ggplot2)
library(dplyr)
library(osmdata)
library(crsuggest)
library(sysfonts)
library(showtext)


## -----------------------------------
#define your midpoint coordinates and radius
# Moscow
# lat <- 55.753846
# lon <- 37.620935
lat <- df$results$geometry$location$lat
lon <- df$results$geometry$location$lng
r <- 5000 #10000
crs <- 4326

midpoint <- st_point(c(lon,lat)) %>%
  st_sfc() %>%
  st_set_crs(crs)

circle_mask <- st_buffer(midpoint, dist = r)

#define the bounding box for overpass query
bbox <- st_bbox(circle_mask)

#set API call
query <- opq(bbox = bbox)



## -----------------------------------

#  Water layer
water <- query %>%
  add_osm_feature(key = "natural",
                  value = "water") %>%
  osmdata_sf()

# Roads layer
pedestrian <- query %>%
  add_osm_feature(key = "highway",
                  value = c("footway", "pedestrian")) %>%
  osmdata_sf()

minor_roads <- query %>%
  add_osm_feature(key = "highway",
                  value = c("secondary","tertiary",
                            "residential","trunk_link",
                            "primary_link","motorway_link",
                            "secondary_link","tertiary_link")) %>%
  osmdata_sf()

main_roads <- query %>%
  add_osm_feature(key = "highway",
                  value = c("primary","trunk","motorway")) %>%
  osmdata_sf()

# Woods layer
woods <- query %>%
  add_osm_features(list(
    "natural" = "wood",
    "leisure" = "park")) %>%
  osmdata_sf()


## -----------------------------------
ggplot() +
  geom_sf(data = water$osm_polygons,
          color = NA,
          fill = "steelblue")+

  geom_sf(data = woods$osm_polygons,
          color = "forestgreen")+

  geom_sf(data = pedestrian$osm_lines,
          color = "purple")+

  geom_sf(data = minor_roads$osm_lines,
          color = "blue")+

  geom_sf(data = main_roads$osm_lines,
          color = "violet")+

  geom_sf(data = circle_mask,
          fill = NA,
          color = "red") +

  theme_void()




## -----------------------------------
# pull the list of suggested EPSG projections for your midpoint coordinates
# alternatively you can use any of your loaded OSM geometries
suggest_crs(midpoint)


## -----------------------------------
#convert all layers to the appropriate CRS and trim to mask
plot_crs <- 6588 # this is the suggested CRS for greater houston area
midpoint <- midpoint %>% st_transform(crs = plot_crs)
r <- # fits houston 20000 #medium 10000 #small: 5000 #10000

circle_mask <- st_buffer(midpoint, dist = r)


water_circle_masked <- water$osm_polygons %>%
  st_transform(crs = plot_crs) %>%
  st_intersection(circle_mask)

woods_circle_masked <- woods$osm_polygons %>%
  st_make_valid() %>% #add in case you face 'geom is invalid' error
  st_transform(crs = plot_crs) %>%
  st_intersection(circle_mask)

pedestrian_circle_masked <- pedestrian$osm_lines %>%
  st_transform(crs = plot_crs) %>%
  st_intersection(circle_mask)

minor_roads_circle_masked <- minor_roads$osm_lines %>%
  st_transform(crs = plot_crs) %>%
  st_intersection(circle_mask)

main_roads_circle_masked <- main_roads$osm_lines %>%
  st_transform(crs = plot_crs) %>%
  st_intersection(circle_mask)



## -----------------------------------
#set your color palette
background_fill <-"#292929"
pedestrian_fill <-"purple"
forest_fill <- "forestgreen"
key_color <- "#dcdcdc"
water_fill <- "darkred"
minor_roads_fill <- "#39b9b4"
mayor_roads_fill <- "violet"


#add fonts
font_add_google("Poiret One", "poiret")
showtext_auto()

#Plot
circle_map <- ggplot()+

  geom_sf(data = circle_mask,
          fill = background_fill,
          color = NA)+

  #water
  geom_sf(data = water_circle_masked,
          fill = water_fill,
          color = NA
  )+

  #woods
  geom_sf(data = woods_circle_masked,
          fill = forest_fill,
          color = NA)+

  #roads
  geom_sf(data = pedestrian_circle_masked,
          color= pedestrian_fill,
          linewidth = .3,
          alpha = .3
  )+

  geom_sf(data = minor_roads_circle_masked,
          color = minor_roads_fill,
          linewidth = .4,
          alpha = .8
  )+

  geom_sf(data = main_roads_circle_masked,
          color= mayor_roads_fill,
          linewidth = .8
  )+
  geom_sf(data = circle_mask,
          fill = NA,
          color = key_color,
          linewidth = .8)+

  labs(caption = "Houston")+
  theme_void()+


  theme(plot.caption = element_text(family = "poiret",
                                    color = key_color,
                                    size=24,
                                    hjust=0.5),
        plot.margin = unit(c(0.5,0.7,0.5,0.7),"in"),
        plot.background = element_rect(fill = background_fill,
                                       color = NA))

circle_map

ggsave(
  "houston_city_circle_map.svg",
  scale = 1,
  width = 1500,
  height = 1500,
  units = "px",
  dpi = "retina"
)

## -----------------------------------
#
# ggsave("city_map.png", plot = last_plot(),
#        scale = 1, width = 1500, height = 1500, units = "px",
#        dpi = 300)
#
