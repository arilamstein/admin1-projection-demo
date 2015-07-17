library(shiny)
library(choroplethr)
library(choroplethrAdmin1)
library(mapproj)
library(ggplot2)

shinyServer(function(input, output) {

  output$map = renderPlot({

    data(admin1.regions)
    country = input$country
    regions = unique(admin1.regions[admin1.regions$country == country, "region"])
    df = data.frame(region=regions, value=1:length(regions))
                         
    admin1_choropleth(country.name = country, 
                      df           = df,
                      num_colors   = 1)

  })
  
  output$regions = renderTable({
    data(admin1.regions)
    country = input$country
    regions = unique(admin1.regions[admin1.regions$country == country, "region"])
    df = data.frame(region=regions, value=1:length(regions))
    print(df)
  })

})
