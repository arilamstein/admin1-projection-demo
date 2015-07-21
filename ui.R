library(shiny)
library(choroplethr)
library(choroplethrAdmin1)

data(admin1.regions)
countries = unique(admin1.regions$country)
all_projections = c("none", "aitoff", "albers", "azequalarea", "azequidist", "bicentric",
                    "bonne", "conic", "cylequalarea", "cylindrical", "eisenlohr", "elliptic",
                    "fisheye", "gall", "gilbert", "guyou", "harrison", "hex", "homing",
                    "lagrange", "lambert", "laue", "lune", "mercator", "mollweide", "newyorker",
                    "orthographic", "perspective", "polyconic", "rectangular", "simpleconic",
                    "sinusoidal", "tetra", "trapezoidal")

projections_that_require_input = c("albers", "bicentric", "bonne",
  "conic", "cylequalarea", "elliptic", "fisheye", "gall", "harrison",
  "homing", "lambert", "laue", "lune", "newyorker", "perspective",
  "rectangular", "simpleconic", "trapezoidal")

projections = setdiff(all_projections, projections_that_require_input)

shinyUI(fluidPage(

  titlePanel("Administrative Level 1 Map and Projection Demo"),
  div(HTML("By <a href='http://www.arilamstein.com'>Ari Lamstein</a>. Blog post <a href='http://www.arilamstein.com/blog/2015/07/23/administrative-level-1-maps-and-projections/'>here</a>. Source code <a href='https://github.com/arilamstein/admin1-projection-demo'>here</a>.")),
  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Country", choices=countries, selected="japan"),
      selectInput("projection1", "Projection 1", choices=projections),
      selectInput("projection2", "Projection 2", choices=projections, selected="mercator")
    ),

    mainPanel(
      imageOutput("maps", width="640px", height="480px"),
      tableOutput("regions")
    )
  )
))
