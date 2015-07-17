library(shiny)
library(choroplethr)
library(choroplethrAdmin1)

data(admin1.regions)
countries = unique(admin1.regions$country)

shinyUI(fluidPage(

  titlePanel("Administrative Level 1 Map and Projection Demo"),
  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Country:", choices = countries, selected = "japan")
    ),

    mainPanel(
      plotOutput("map"),
      tableOutput("regions")
    )
  )
))
