library(shiny)
library(choroplethr)
library(choroplethrAdmin1)
library(mapproj)
library(ggplot2)
library(gridExtra)

renderMap = function(country, df, proj)
{
  title = paste0("Country: ", country, "\nProjection: ", proj)
  map   = admin1_choropleth(country.name = country, 
                            df           = df, 
                            title        = title, 
                            num_colors   = 1)

  if (proj != "none") {
    map = map + coord_map(proj)
  }
  
  map
}

shinyServer(function(input, output) {
  
  # return one country with 2 projections, side by side
  output$maps = renderPlot({

    data(admin1.regions)
    country = input$country
    regions = unique(admin1.regions[admin1.regions$country == country, "region"])
    df      = data.frame(region=regions, value=1:length(regions))
    
    map1 = renderMap(country, df, input$projection1)
    map2 = renderMap(country, df, input$projection2)
    
    grid.arrange(map1, map2, ncol=2)
  })

  # return a data.frame listing the Administrative Level 1 regions of the selected country
  output$regions = renderTable({
    data(admin1.regions)
    country = input$country
    regions = unique(admin1.regions[admin1.regions$country == country, "region"])
    data.frame(region=regions, value=1:length(regions))
  })

})