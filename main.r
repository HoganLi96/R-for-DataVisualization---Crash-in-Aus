# Dataset
# Fatalities.csv: https://www.bitre.gov.au/statistics/safety/fatal_road_crash_database
# CrashSites.csv: https://www.kaggle.com/datasets/stevenrferrer/victoria-road-crash-statistics
# Seasons.csv: http://www.bom.gov.au/climate/glossary/seasons.shtml
# Locations.csv: https://developers.google.com/maps/documentation/geocoding/overview

# install.packages("shinythemes")
# install.packages("shinydashboard")
# install.packages("dashboardthemes")
# install.packages("shinyjs")
# install.packages("leaflet")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("gganimate")
# install.packages("gifski")
# install.packages("shinycssloaders")
# install.packages("plotly")
# install.packages("shinyWidgets")
# install.packages("treemapify")
# install.packages("packcircles")

library(shiny)
library(shinythemes)
library(shinydashboard)
library(dashboardthemes)
library(shinyjs)
library(leaflet)
library(dplyr)
library(ggplot2)
library(gganimate)
library(gifski)
library(shinycssloaders)
library(plotly)
library(shinyWidgets)
library(treemapify)
library(packcircles)

source('ui.r')
source('server.r')

# Shiny App
shinyApp(ui = ui, server = server, options = list(host = "0.0.0.0"))