
library(shiny)
# SHINY SLIDER
# CSS

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

input[type=range]{
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
	divisor.style.width = slider.value+"%";
}

$(document).on("shiny:connected", function(event){
var divisor = document.getElementById("divisor"),
slider = document.getElementById("slider");
});
'
)

# HTML
ui <- shiny::fluidPage(
  tags$head(tags$style(css)),
  tags$head(tags$script(js)),

  HTML(
    '<div id="comparison">
        <figure>
        <div id="divisor"></div>
    </figure>
    <input type="range" min="0" max="100" value="50" id="slider" oninput="moveDivisor()">
    </div>'
  )
)

server <- function(input, output, session){}

shiny::shinyApp(ui, server)
