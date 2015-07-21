library(shiny)
library(choroplethr)
library(choroplethrAdmin1)
library(mapproj)
library(ggplot2)
library(gridExtra)

get_base_map = function(country, df)
{
  admin1_choropleth(country.name = country, 
                    df           = df,
                    num_colors   = 1)
}

get_projection = function(proj)
{
  if (proj == "none") {
    element_blank()
  } else {
    coord_map(proj)
  }
}

get_title = function(country, proj)
{
  ggtitle(paste0("Country: ", country, "\nProjection: ", proj))
}

shinyServer(function(input, output) {
  
  # return one country with 2 projections, side by side
  output$maps = renderImage({

    # add a progress bar
    progress = shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Creating image. Please wait.", value = 0)
    
    # filenames are programmatic: countryName-projection1-projection2.png
    filename = paste0(gsub(" ", "", input$country, fixed = TRUE),
                     "-",
                     input$projection1,
                     "-",
                     input$projection2,
                     ".png")

    if (file.exists(filename))
    {
      list(src         = filename,
           contentType = 'image/png',
           width       = 640,
           height      = 480,
           alt         = filename)
    } else {
      
      data(admin1.regions)
      country = input$country
      regions = unique(admin1.regions[admin1.regions$country == country, "region"])
      df      = data.frame(region=regions, value=1:length(regions))
      
      base_map = get_base_map(country, df)
      map1 = base_map + get_projection(input$projection1) + get_title(country, input$projection1)
      map2 = base_map + get_projection(input$projection2) + get_title(country, input$projection2)
      
      png(filename, width=640, height=480)
      grid.arrange(map1, map2, ncol=2)
      dev.off()
      
      list(src         = filename,
           contentType = 'image/png',
           width       = 640,
           height      = 480,
           alt         = filename)
    }
  }, deleteFile = FALSE)

  # return a data.frame listing the Administrative Level 1 regions of the selected country
  output$regions = renderTable({
    data(admin1.regions)
    country = input$country
    regions = unique(admin1.regions[admin1.regions$country == country, "region"])
    data.frame(region=regions, value=1:length(regions))
  })

})