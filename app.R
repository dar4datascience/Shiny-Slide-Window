library(shiny)
library(ggplot2)
library(bslib)
library(gridlayout)


ui <- page_navbar(
  title = "🌌Shiny Night Lights🌃",
  selected = "Home",
  collapsible = TRUE,
  theme = bslib::bs_theme(),
  sidebar = sidebar(
    title = "Data from X to Y",
    markdown(
      mds = c(
        "What is an Alcadia?"
      )
    ),
    radioButtons(
      inputId = "radio-cdmx",
      label = "Select View",
      choices = list("CDMX" = "cdmx", "Alcaldia" = "alcaldia"),
      width = "100%"
    ),
    selectInput(
      inputId = "alcaldia-selection",
      label = "Select Alcaldia",
      choices = list("choice a" = "a", "Value2" = "value2"),
      selected = "a"
    )
  ),
  tabPanel(
    title = "Home",
    markdown(
      mds = c(
        "hello _world_ ",
        "# hellow ",
        "## world"
      )
    )
  ),
  tabPanel(
    title = "Java Island",
    grid_container(
      layout = c(
        "num_chicks linePlots"
      ),
      row_sizes = c(
        "1fr"
      ),
      col_sizes = c(
        "190px",
        "1fr"
      ),
      gap_size = "10px",
      grid_card(
        area = "num_chicks",
        card_header("What are we Seeing?"),
        card_body(
          sliderInput(
            inputId = "zoom_level",
            label = "Zoom Level",
            min = 1,
            max = 15,
            value = 5,
            step = 1,
            width = "100%"
          )
        )
      ),
      grid_card_plot(area = "linePlots")
    )
  ),
  tabPanel(
    title = "Mexico City",
    grid_container(
      layout = c(
        "dists",
        "dists"
      ),
      row_sizes = c(
        "165px",
        "1fr"
      ),
      col_sizes = c(
        "1fr"
      ),
      gap_size = "10px",
      grid_card_plot(area = "dists")
    )
  )
)


server <- function(input, output) {
   
  output$linePlots <- renderPlot({
    obs_to_include <- as.integer(ChickWeight$Chick) <= input$zoom_level
    chicks <- ChickWeight[obs_to_include, ]
  
    ggplot(
      chicks,
      aes(
        x = Time,
        y = weight,
        group = Chick
      )
    ) +
      geom_line(alpha = 0.5) +
      ggtitle("Chick weights over time")
  })
  
  output$dists <- renderPlot({
    ggplot(
      ChickWeight,
      aes(x = weight)
    ) +
      facet_wrap(input$distFacet) +
      geom_density(fill = "#fa551b", color = "#ee6331") +
      ggtitle("Distribution of weights by diet")
  })
  
}

shinyApp(ui, server)
  

