# generate static images of the "none-mercator" maps of all the countries

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

data("admin1.regions")
countries = unique(admin1.regions$country)

for (country in countries)
{
  # filenames are programmatic: countryName-projection1-projection2.png
  filename = paste0(gsub(" ", "", country, fixed = TRUE),
                    "-",
                    "none",
                    "-",
                    "mercator",
                    ".png")

  print(paste("Making", filename))
  
  regions = unique(admin1.regions[admin1.regions$country == country, "region"])
  df      = data.frame(region=regions, value=1:length(regions))
     
  base_map = get_base_map(country, df)
  map1 = base_map + get_projection("none") + get_title(country, "none")
  map2 = base_map + get_projection("mercator") + get_title(country, "mercator")
      
  print(paste('printing', filename))
  png(filename, width=640, height=480)
  grid.arrange(map1, map2, ncol=2)
  dev.off()
}