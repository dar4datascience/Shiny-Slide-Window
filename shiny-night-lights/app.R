library(shiny)
library(ggplot2)
library(gridlayout)
library(bslib)
library(htmltools)
library(shiny)
library(bsicons)
library(plotly)

sparkline <- plot_ly(economics) %>%
  add_lines(
    x = ~date, y = ~psavert,
    color = I("white"), span = I(1),
    fill = 'tozeroy', alpha = 0.2
  ) %>%
  layout(
    xaxis = list(visible = F, showgrid = F, title = ""),
    yaxis = list(visible = F, showgrid = F, title = ""),
    hovermode = "x",
    margin = list(t = 0, r = 0, l = 0, b = 0),
    font = list(color = "white"),
    paper_bgcolor = "transparent",
    plot_bgcolor = "transparent"
  ) %>%
  config(displayModeBar = F) %>%
  htmlwidgets::onRender(
    "function(el) {
      var ro = new ResizeObserver(function() {
         var visible = el.offsetHeight > 200;
         Plotly.relayout(el, {'xaxis.visible': visible});
      });
      ro.observe(el);
    }"
  )




css <- HTML("div#comparison {
width: 80vw;
height: 80vw;
max-width: 800px;
max-height: 800px;
overflow: hidden; }
div#comparison figure {
background-image: url('jawa_map_1.png');
background-size: cover;
position: relative;
font-size: 0;
width: 100%;
height: 100%;
margin: 0;
}
div#comparison figure > img {
    position: relative;
    width: 100%;
    max-width: 100%; /* Ensure the image doesn't grow beyond its container */
    height: auto; /* Maintain the image's aspect ratio */
}

div#comparison figure div {
background-image: url('jawa_map_2.png');
background-size: cover;
position: absolute;
width: 50%;
box-shadow: 0 5px 10px -2px rgba(0,0,0,0.3);
overflow: hidden;
bottom: 0;
height: 100%;
}

input[type=range] {
    max-width: 100%;  /* To ensure the slider does not go beyond its container */
    width: 100%;
  -webkit-appearance:none;
  -moz-appearance:none;
  position: relative;
  top: -2rem; left: -2%;
  background-color: rgba(255,255,255,0.1);
  width: 102%;
}
input[type=range]:focus {
  outline: none;
}
input[type=range]:active {
  outline: none;
}

input[type=range]::-moz-range-track {
  -moz-appearance:none;
  height:15px;
  width: 98%;
  background-color: rgba(255,255,255,0.1);
  position: relative;
  outline: none;
}
input[type=range]::active {
  border: none;
  outline: none;
}
input[type=range]::-webkit-slider-thumb {
  -webkit-appearance:none;
  width: 20px; height: 15px;
  background: #fff;
    border-radius: 0;
}
input[type=range]::-moz-range-thumb {
  -moz-appearance: none;
  width: 20px;
  height: 15px;
  background: #fff;
    border-radius: 0;
}
input[type=range]:focus::-webkit-slider-thumb {
  background: rgba(255,255,255,0.5);
}
input[type=range]:focus::-moz-range-thumb {
  background: rgba(255,255,255,0.5);
}"
)


# JS
js <- HTML('
function moveDivisor() {
    divisor.style.width = slider.value + "%";
}

// If youre using Shiny
$(document).on("shiny:connected", function(event) {
  var divisor = document.getElementById("divisor");
  var slider = document.getElementById("slider");

  slider.addEventListener("input", moveDivisor);

  // Optional: Prevent user zooming using meta viewport tag
  // Note: This is sometimes considered bad UX.
  var metaTag = document.createElement("meta");
  metaTag.name = "viewport";
  metaTag.content = "width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no";
  document.getElementsByTagName("head")[0].appendChild(metaTag);
});

'
)

ui <- page_navbar(
  title = "Shiny Nigth Lights 🌌🌃🌉",
  selected = "Line Plots",
  collapsible = TRUE,
  theme = bslib::bs_theme(preset = "quartz", version = 5),
  tags$head(tags$style(css)),
  tags$head(tags$script(js)),
  tabPanel(
    title = "Home",
    markdown(
      mds = c(
        "# Hello World",
        "",
        "## Shiny Night Lights Here",
        "## 🌌🌃🌉"
      )
    )
  ),
  tabPanel(
    title = "Java Island",
    grid_container(
      layout = c(
        "java_controls java_slide"
      ),
      row_sizes = c(
        "1fr"
      ),
      col_sizes = c(
        "1fr"
      ),
      gap_size = "10px",
      grid_card(
        area = "java_controls",
        card_header(h5("Fun Facts")),
        card_body(
            card_body(
              value_box(
                title = "Pending Indonesia Eco Growth",
                value = "7.6%",
                p("Started at 12.6%"),
                p("Averaged 8.6% over that period"),
                p("Peaked 17.3% in May 1975"),
                showcase = sparkline,
                full_screen = TRUE,
                theme = "success"
              ),
              value_box(
                title = "Population (2020)",
                value = "139,686,700",
                showcase = bsicons::bs_icon("person-badge"),
                p("Area including nearby islands, 49,976 square miles (129,438 square km).", bs_icon("heart-fill")),
                p("Java is composed of three propinsi (or provinsi; provinces)—West Java (Jawa Barat), Central Java (Jawa Tengah), and East Java (Jawa Timur)—as well as Jakarta Raya (Greater Jakarta) daerah khusus lbukota (special capital district) and Yogyakarta daerah istimewa (special district)", bs_icon("globe-central-south-asia"))
              )
            ),
            card_footer(
              HTML('<a href="https://www.britannica.com/place/Java-island-Indonesia">Source Enciclopedia Britanica Non-Ironically</a>
')
              )
          )
      ),
      grid_card(
        area = "java_slide",
                  card_header("Java Island Change in 10 years X to Y"),
                  card_body(
                    page_fillable(
                      HTML(
                        '<div id="comparison">
                        <figure>
                        <div id="divisor"></div>
                    </figure>
                    <input type="range" min="0" max="100" value="50" id="slider" oninput="moveDivisor()">
                    </div>'
                      )
                    )
                  )
      )
    )
  ),
  tabPanel(
    title = "Mexico City",
    grid_container(
      row_sizes = c(
        "165px",
        "1fr"
      ),
      col_sizes = c(
        "1fr"
      ),
      gap_size = "10px",
      layout = c(
        "facetOption",
        "dists"
      ),
      grid_card_plot(area = "dists"),
      grid_card(
        area = "facetOption",
        card_header("Distribution Plot Options"),
        card_body(
          radioButtons(
            inputId = "distFacet",
            label = "Facet distribution by",
            choices = list("Diet Option" = "Diet", "Measure Time" = "Time")
          )
        )
      )
    )
  )
)


server <- function(input, output) {

  output$linePlots <- renderPlot({
    obs_to_include <- as.integer(ChickWeight$Chick) <= input$zoomlevel
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


