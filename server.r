load_aus_data <- function(fatalities_dataset, seasons){
  
  fatalities_dataset$Speed.Limit <- as.character(fatalities_dataset$Speed.Limit)
  
  fatalities_dataset$Speed.Limit <- paste0(fatalities_dataset$Speed.Limit, " km/hr")
  
  fatalities_dataset$Speed.Limit[fatalities_dataset$Speed.Limit == "-9 km/hr"] <- "Unknown"
  
  fatalities_dataset[fatalities_dataset == -9] <- NA
  
  fatalities_dataset[fatalities_dataset == ""] <- NA
  
  fatalities_dataset$Season <- seasons$Season[match(fatalities_dataset$Month, seasons$Month)]
  
  return(fatalities_dataset)
  
}

load_vic_plot_points <- function(dataset){
  
  all_vic_LGA <- count(dataset, LGA_NAME_ALL)
  
  vic_average_location <- dataset %>% 
    group_by(LGA_NAME_ALL) %>%
    summarise(across(c("LATITUDE", "LONGITUDE"), mean))
  
  vic_average_location <- merge(all_vic_LGA, vic_average_location)
  
  vic_average_location <- setNames(vic_average_location, c("LGA_NAME_ALL","count","Lat","Lon"))
  
  vic_average_location$radius <- ifelse(vic_average_location$count > 50, 50, 
                                        ifelse(vic_average_location$count < 10, 10, vic_average_location$count))
  
  return(vic_average_location)
  
}

load_aus_plot_points <- function(fatalities_dataset, aus_states){
  
  all_aus_crash <- count(fatalities_dataset, State)
  
  all_aus_crash <- merge(all_aus_crash, aus_states)
  
  all_aus_crash <- setNames(all_aus_crash, c("State","count","Lat","Lon"))
  
  all_aus_crash$radius <- all_aus_crash$count/100
  
  all_aus_crash$radius <- ifelse(all_aus_crash$radius > 50, 50, 
                                 ifelse(all_aus_crash$radius < 10, 10, all_aus_crash$radius))
  
  return(all_aus_crash)
  
}

load_season_circular_plot_vic_data <- function(dataset){
  
  top_eight_LGA_vic <- count(dataset, Season, LGA_NAME_ALL)
  
  top_eight_LGA_vic <- top_eight_LGA_vic %>% group_by(Season) %>% arrange(Season, -n) %>% slice(1:8)
  
  top_eight_LGA_vic <- setNames(top_eight_LGA_vic, c("group", "individual","value"))
  
  return(top_eight_LGA_vic)
  
}

load_season_circular_plot_aus_data <- function(fatalities_dataset){
  
  season_wise <- 
    fatalities_dataset %>%
    count(Season, State)
  
  season_wise <- setNames(season_wise, c("group", "individual","value"))
  
  return(season_wise)
  
}

top_crash_sites_vic_data <- function(dataset){
  
  top_eight_LGA <- count(dataset, dataset$LGA_NAME_ALL)
  top_eight_LGA <- top_eight_LGA[order(-top_eight_LGA$n),]
  
  top_eight_LGA <- top_eight_LGA[1:8, ]
  
  top_eight_LGA <- setNames(top_eight_LGA, c("LGA_NAME_ALL","count"))
  
  return(top_eight_LGA)
  
}

top_crash_sites_aus_data <- function(fatalities_dataset){
  
  state_wise_crash <- count(fatalities_dataset, fatalities_dataset$State)
  
  state_wise_crash <- setNames(state_wise_crash, c("State","count"))
  
  return(state_wise_crash)
  
}

dow_crash_plot_vic_data <- function(dataset){
  
  day_of_week <- count(dataset, dataset$LGA_NAME_ALL, dataset$DAY_OF_WEEK)
  
  day_of_week <- setNames(day_of_week, c("LGA_NAME_ALL", "day_of_week","count"))
  
  day_of_week$day_of_week <- factor(day_of_week$day_of_week, 
                                    levels = c("Monday", "Tuesday", "Wednesday", "Thursday", 
                                               "Friday", "Saturday", "Sunday", "Unknown"))
  
  return(day_of_week)
  
}

dow_crash_plot_aus_data <- function(fatalities_dataset){
  
  day_of_week <- count(fatalities_dataset, fatalities_dataset$State, fatalities_dataset$Dayweek)
  
  day_of_week <- setNames(day_of_week, c("State", "day_of_week","count"))
  
  day_of_week$day_of_week <- factor(day_of_week$day_of_week, 
                                    levels = c("Monday", "Tuesday", "Wednesday", "Thursday", 
                                               "Friday", "Saturday", "Sunday", "Unknown"))
  
  return(day_of_week)
  
}

load_dow_data_vic <- function(dataset, Site){
  
  subset_dataset <- subset(dataset, LGA_NAME_ALL == Site)
  
  day_of_week <- count(subset_dataset, subset_dataset$DAY_OF_WEEK)
  
  day_of_week <- setNames(day_of_week, c("day_of_week","count"))
  
  day_of_week$day_of_week <- factor(day_of_week$day_of_week, 
                                    levels = c("Monday", "Tuesday", "Wednesday", "Thursday", 
                                               "Friday", "Saturday", "Sunday", "Unknown"))
  
  return(day_of_week)
  
}

load_dow_data_aus <- function(fatalities_dataset, Site){
  
  subset_dataset <- subset(fatalities_dataset, State == Site)
  
  day_of_week <- count(subset_dataset, subset_dataset$Dayweek)
  
  day_of_week <- setNames(day_of_week, c("day_of_week","count"))
  
  day_of_week$day_of_week <- factor(day_of_week$day_of_week, 
                                    levels = c("Monday", "Tuesday", "Wednesday", "Thursday", 
                                               "Friday", "Saturday", "Sunday", "Unknown"))
  
  return(day_of_week)
  
}

load_vic_speed_limit_plot_data <- function(dataset){
  
  top_eight_LGA_vic <- count(dataset, Season, LGA_NAME_ALL)
  
  top_eight_LGA_vic <- top_eight_LGA_vic %>% group_by(Season) %>% arrange(Season, -n) %>% slice(1:8)
  
  vic_speed_limit <- 
    dataset %>% count(LGA_NAME_ALL, Season, SPEED_ZONE) %>%
    filter(LGA_NAME_ALL %in% top_eight_LGA_vic$LGA_NAME_ALL)
  
  vic_speed_limit <- setNames(vic_speed_limit, c("Site", "Season", "speed_zone", "count"))
  
  return(vic_speed_limit)
  
}

load_aus_speed_limit_plot_data <- function(fatalities_dataset){
  
  state_crash_count <- count(fatalities_dataset, Season, State)
  
  state_crash_count <- state_crash_count %>% group_by(Season) %>% arrange(Season, -n)
  
  aus_speed_limit <- 
    fatalities_dataset %>% count(State, Season, Speed.Limit)
  
  aus_speed_limit <- setNames(aus_speed_limit, c("Site", "Season", "speed_zone", "count"))
  
  return(aus_speed_limit)
  
}

load_road_geometry_plot_data <- function(dataset){
  
  top_eight_LGA_vic <- count(dataset, Season, LGA_NAME_ALL)
  
  top_eight_LGA_vic <- top_eight_LGA_vic %>% group_by(Season) %>% arrange(Season, -n) %>% slice(1:8)
  
  vic_road_geometry <- 
    dataset %>% count(LGA_NAME_ALL, Season, ROAD_GEOMETRY) %>%
    filter(LGA_NAME_ALL %in% top_eight_LGA_vic$LGA_NAME_ALL)
  
  vic_road_geometry <- setNames(vic_road_geometry, c("Site", "Season", "road_geometry", "count"))
  
  return(vic_road_geometry)
  
}

load_age_group_plot_data <- function(fatalities_dataset){
  
  state_crash_count <- count(fatalities_dataset, Season, State)
  
  state_crash_count <- state_crash_count %>% group_by(Season) %>% arrange(Season, -n)
  
  aus_age_group <- 
    fatalities_dataset %>% count(State, Season, Age.Group)
  
  aus_age_group <- setNames(aus_age_group, c("Site", "Season", "road_geometry", "count"))
  
  return(aus_age_group)
  
}

load_home_vic_data <- function(input, output, session){
  
  
  # loading and preparing all the datasets
  seasons <- read.csv("Seasons.csv")
  
  vic_dataset <- read.csv("CrashSites.csv")
  
  vic_dataset$LGA_NAME_ALL <- as.character(vic_dataset$LGA_NAME_ALL)
  vic_dataset$Season <- seasons$Season[match(as.integer(strftime(vic_dataset$ACCIDENT_DATE,"%m")), seasons$Month)]
  
  vic_sites_plot_points <- load_vic_plot_points(vic_dataset)
  
  season_circular_plot_vic <- load_season_circular_plot_vic_data(vic_dataset)
  
  top_crash_sites_vic <- top_crash_sites_vic_data(vic_dataset)
  
  dow_crash_plot_vic <- dow_crash_plot_vic_data(vic_dataset)
  
  #leaflet map output
  output$map <- renderLeaflet({
    
    leaflet(data = vic_sites_plot_points) %>% addTiles() %>%
      addCircleMarkers(lng=~Lon, lat=~Lat, layerId = vic_sites_plot_points$LGA_NAME_ALL, popup = paste(vic_sites_plot_points$LGA_NAME_ALL, "(", vic_sites_plot_points$count, ")"),
                       radius = (vic_sites_plot_points$radius), 
                       color = "#f39c12", stroke = FALSE, fillOpacity = 0.7) %>%
      setView(lng=144.9646, lat=-37.02010, zoom=9)
    
  })
  
  #on site click, change day of the week data
  observeEvent(input$map_marker_click, {
    click <- input$map_marker_click
    if(is.null(click))
      return()
    
    dow <- load_dow_data_vic(vic_dataset, click$id)
    
    output$dow_crash_plot <- renderPlot({
      
      ggplot(dow, aes(x = day_of_week, y = count)) + geom_bar(stat = "identity") + 
        geom_col(aes(fill = day_of_week)) + 
        theme(plot.background = element_rect(fill = "#1f252c", colour="#1f252c"), legend.position='',
              panel.background = element_rect(fill = "#1f252c", colour="#1f252c"),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              axis.title.x = element_text(colour = "white"),
              axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, colour = "white"),
              axis.title.y = element_text(colour = "white"),
              axis.text.y = element_blank()) + 
        geom_text(aes(label=count, colour = "white"), position=position_dodge(width=0.9), vjust=-0.25) +
        labs(x = "Day of the week", y = "Crash count")
      
    })
    
  }, ignoreInit = TRUE)
  
  #circular bar chart with top 8 sites
  output$season_circular_plot <- renderPlot({
    
    data <- season_circular_plot_vic
    
    data$lable <- paste(data$individual, data$value)
    
    # Set a number of 'empty bar' to add at the end of each group
    empty_bar <- 4
    to_add <- data.frame( matrix(NA, empty_bar*nlevels(data$group), ncol(data)) )
    colnames(to_add) <- colnames(data)
    to_add$group <- rep(levels(data$group), each=empty_bar)
    to_add <- data.frame(to_add)
    data <- data.frame(data)
    data <- rbind(data, to_add)
    data <- data %>% arrange(group)
    data$id <- seq(1, nrow(data))
    
    # Get the name and the y position of each label
    label_data <- data
    number_of_bar <- nrow(label_data)
    angle <- 90 - 360 * (label_data$id-0.5) /number_of_bar     # I substract 0.5 because the letter must have the angle of the center of the bars. Not extreme right(1) or extreme left (0)
    label_data$hjust <- ifelse( angle < -90, 1.25, -0.25)
    label_data$angle <- ifelse(angle < -90, angle+180, angle)
    
    # prepare a data frame for base lines
    base_data <- data %>% 
      group_by(group) %>% 
      summarize(start=min(id), end=max(id) - empty_bar) %>% 
      rowwise() %>% 
      mutate(title=mean(c(start, end)))
    
    MyColour <- c("#3498db", "#c8c8c8", "#f39c12", "#d81b60") 
    names(MyColour) <- c("Autumn", "Spring", "Summer", "Winter")
    
    # Make the plot
    ggplot(data, aes(x=as.factor(id), y=value, fill=group)) +       # Note that id is a factor. If x is numeric, there is some space between the first bar
      
      scale_fill_manual("legend", values = MyColour) +
      geom_bar(stat= 'identity' ) +
      ylim(-1000,3000) +
      theme_minimal() +
      theme(
        legend.position = "none",
        axis.text = element_blank(),
        axis.title = element_blank(),
        panel.grid = element_blank(),
        plot.margin = unit(rep(-1,4), "cm"),
        plot.background = element_rect(fill = "#1f252c", colour="#1f252c"),
      ) +
      coord_polar() + 
      geom_text(data=label_data, aes(x=id, y=value+10, label=lable, hjust=hjust), color="white", 
                fontface="bold",alpha=0.6, size=2.5, angle= label_data$angle, inherit.aes = FALSE ) +
      
      # Add base line information
      geom_segment(data=base_data, aes(x = start, y = -5, xend = end, yend = -5), colour = "white", alpha=0.8, size=0.6 , inherit.aes = FALSE )  +
      geom_text(data=base_data, aes(x = title, y = -18, label=group), hjust=c(0.5,1,0.1,-0.25), colour = "white", alpha=0.8, size=3, fontface="bold", inherit.aes = FALSE)
    
  })
  
  #bar chart of top crash sites
  output$top_crash_sites_plot <- renderImage({
    
    this_plot <- ggplot(top_crash_sites_vic, aes(x = LGA_NAME_ALL, y = count)) + geom_bar(stat = "identity") + 
      geom_col(aes(fill = LGA_NAME_ALL)) + 
      theme(plot.background = element_rect(fill = "#1f252c", colour="#1f252c"), legend.position='',
            panel.background = element_rect(fill = "#1f252c", colour="#1f252c"),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.title.x = element_text(colour = "white"),
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, colour = "white"),
            axis.title.y = element_text(colour = "white"),
            axis.text.y = element_blank()) + 
      geom_text(aes(label=count, colour = "white"), position=position_dodge(width=0.9), vjust=-0.25) +
      labs(x = "Sites", y = "Crash count")  +
      transition_states(LGA_NAME_ALL, wrap = FALSE, transition_length = 5) + shadow_mark(alpha = 1) +
      enter_fade() + enter_drift(x_mod = 0, y_mod = -max(top_crash_sites_vic$count))
    
    animate(this_plot, render = gifski_renderer(loop = FALSE), duration = 5, fps = 10)
    
    anim_save('top_crash_sites_plot_vic.gif')
    
    list(src = "top_crash_sites_plot_vic.gif", height = "400px", width = "650px")
    
  }, deleteFile = FALSE)
  
  #bar chart of day of the week crashes
  output$dow_crash_plot <- renderPlot({
    
    ggplot(dow_crash_plot_vic[1:7,], aes(x = day_of_week, y = count)) + geom_bar(stat = "identity") + 
      geom_col(aes(fill = day_of_week)) + 
      theme(plot.background = element_rect(fill = "#1f252c", colour="#1f252c"), legend.position='',
            panel.background = element_rect(fill = "#1f252c", colour="#1f252c"),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.title.x = element_text(colour = "white"),
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, colour = "white"),
            axis.title.y = element_text(colour = "white"),
            axis.text.y = element_blank()) + 
      geom_text(aes(label=count, colour = "white"), position=position_dodge(width=0.9), vjust=-0.25) +
      labs(x = "Day of the week", y = "Crash count")
    
  })
  
}

load_home_aus_data <- function(input, output, session){
  
  
  # loading and preparing all the datasets
  seasons <- read.csv("Seasons.csv")
  
  aus_states <- read.csv("Locations.csv")
  
  aus_dataset <- read.csv("Fatalities.csv")
  
  aus_dataset <- load_aus_data(aus_dataset, seasons)
  
  aus_sites_plot_points <- load_aus_plot_points(aus_dataset, aus_states)
  
  season_circular_plot_aus <- load_season_circular_plot_aus_data(aus_dataset)
  
  top_crash_sites_aus <- top_crash_sites_aus_data(aus_dataset)
  
  dow_crash_plot_aus <- dow_crash_plot_aus_data(aus_dataset)
  
  #leaflet map output
  output$map <- renderLeaflet({
    
    leaflet(data = aus_sites_plot_points) %>% addTiles() %>%
      addCircleMarkers(lng=~Lon, lat=~Lat, layerId = aus_sites_plot_points$State, popup = paste(aus_sites_plot_points$State, "(", aus_sites_plot_points$count, ")"),
                       radius = (aus_sites_plot_points$radius), 
                       color = "#f39c12", stroke = FALSE, fillOpacity = 0.7) %>%
      setView(lng=135.37702805606094, lat=-24.74935371055296, zoom=5)
    
  })
  
  #on site click, change day of the week data
  observeEvent(input$map_marker_click, {
    click <- input$map_marker_click
    if(is.null(click))
      return()
    
    dow <- load_dow_data_aus(aus_dataset, click$id)
    
    output$dow_crash_plot <- renderPlot({
      
      ggplot(dow, aes(x = day_of_week, y = count)) + geom_bar(stat = "identity") + 
        geom_col(aes(fill = day_of_week)) + 
        theme(plot.background = element_rect(fill = "#1f252c", colour="#1f252c"), legend.position='',
              panel.background = element_rect(fill = "#1f252c", colour="#1f252c"),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              axis.title.x = element_text(colour = "white"),
              axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, colour = "white"),
              axis.title.y = element_text(colour = "white"),
              axis.text.y = element_blank()) + 
        geom_text(aes(label=count, colour = "white"), position=position_dodge(width=0.9), vjust=-0.25) +
        labs(x = "Day of the week", y = "Crash count")
      
    })
    
  }, ignoreInit = TRUE)
  
  #circular bar chart with top 8 sites
  output$season_circular_plot <- renderPlot({
    
    data <- season_circular_plot_aus
    
    data$lable <- paste(data$individual, data$value)
    
    # Set a number of 'empty bar' to add at the end of each group
    empty_bar <- 4
    to_add <- data.frame( matrix(NA, empty_bar*nlevels(data$group), ncol(data)) )
    colnames(to_add) <- colnames(data)
    to_add$group <- rep(levels(data$group), each=empty_bar)
    to_add <- data.frame(to_add)
    data <- data.frame(data)
    data <- rbind(data, to_add)
    data <- data %>% arrange(group)
    data$id <- seq(1, nrow(data))
    
    # Get the name and the y position of each label
    label_data <- data
    number_of_bar <- nrow(label_data)
    angle <- 90 - 360 * (label_data$id-0.5) /number_of_bar     # I substract 0.5 because the letter must have the angle of the center of the bars. Not extreme right(1) or extreme left (0)
    label_data$hjust <- ifelse( angle < -90, 1.25, -0.25)
    label_data$angle <- ifelse(angle < -90, angle+180, angle)
    
    # prepare a data frame for base lines
    base_data <- data %>% 
      group_by(group) %>% 
      summarize(start=min(id), end=max(id) - empty_bar) %>% 
      rowwise() %>% 
      mutate(title=mean(c(start, end)))
    
    MyColour <- c("#3498db", "#c8c8c8", "#f39c12", "#d81b60") 
    names(MyColour) <- c("Autumn", "Spring", "Summer", "Winter")
    
    # Make the plot
    ggplot(data, aes(x=as.factor(id), y=value, fill=group)) +       # Note that id is a factor. If x is numeric, there is some space between the first bar
      
      scale_fill_manual("legend", values = MyColour) +
      geom_bar(stat= 'identity' ) +
      ylim(-2000,5000) +
      theme_minimal() +
      theme(
        legend.position = "none",
        axis.text = element_blank(),
        axis.title = element_blank(),
        panel.grid = element_blank(),
        plot.margin = unit(rep(-1,4), "cm"),
        plot.background = element_rect(fill = "#1f252c", colour="#1f252c"),
      ) +
      coord_polar() + 
      geom_text(data=label_data, aes(x=id, y=value+10, label=lable, hjust=hjust), color="white", 
                fontface="bold",alpha=0.6, size=2.5, angle= label_data$angle, inherit.aes = FALSE ) +
      
      # Add base line information
      geom_segment(data=base_data, aes(x = start, y = -5, xend = end, yend = -5), colour = "white", alpha=0.8, size=0.6 , inherit.aes = FALSE )  +
      geom_text(data=base_data, aes(x = title, y = -18, label=group), hjust=c(0.5,1,0.1,-0.25), colour = "white", alpha=0.8, size=3, fontface="bold", inherit.aes = FALSE)
    
  })
  
  #bar chart of top crash sites
  output$top_crash_sites_plot <- renderImage({
    
    this_plot <- ggplot(top_crash_sites_aus, aes(x = State, y = count)) + geom_bar(stat = "identity") + 
      geom_col(aes(fill = State)) + 
      theme(plot.background = element_rect(fill = "#1f252c", colour="#1f252c"), legend.position='',
            panel.background = element_rect(fill = "#1f252c", colour="#1f252c"),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.title.x = element_text(colour = "white"),
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, colour = "white"),
            axis.title.y = element_text(colour = "white"),
            axis.text.y = element_blank()) + 
      geom_text(aes(label=count, colour = "white"), position=position_dodge(width=0.9), vjust=-0.25) +
      labs(x = "Sites", y = "Crash count")  +
      transition_states(State, wrap = FALSE, transition_length = 5) + shadow_mark(alpha = 1) +
      enter_fade() + enter_drift(x_mod = 0, y_mod = -max(top_crash_sites_aus$count))
    
    animate(this_plot, render = gifski_renderer(loop = FALSE), duration = 5, fps = 10)
    
    anim_save('top_crash_sites_plot_aus.gif')
    
    list(src = "top_crash_sites_plot_aus.gif", height = "400px", width = "650px")
    
  }, deleteFile = FALSE)
  
  #bar chart of day of the week crashes
  output$dow_crash_plot <- renderPlot({
    
    ggplot(dow_crash_plot_aus[1:7,], aes(x = day_of_week, y = count)) + geom_bar(stat = "identity") + 
      geom_col(aes(fill = day_of_week)) + 
      theme(plot.background = element_rect(fill = "#1f252c", colour="#1f252c"), legend.position='',
            panel.background = element_rect(fill = "#1f252c", colour="#1f252c"),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.title.x = element_text(colour = "white"),
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, colour = "white"),
            axis.title.y = element_text(colour = "white"),
            axis.text.y = element_blank()) + 
      geom_text(aes(label=count, colour = "white"), position=position_dodge(width=0.9), vjust=-0.25) +
      labs(x = "Day of the week", y = "Crash count")
    
  })
  
}

load_seasons_tab <- function(input, output, session, flag){
  
  seasons <- read.csv("Seasons.csv")
  
  if(flag == 0){
    
    vic_dataset <- read.csv("CrashSites.csv")
    
    vic_dataset$LGA_NAME_ALL <- as.character(vic_dataset$LGA_NAME_ALL)
    vic_dataset$Season <- seasons$Season[match(as.integer(strftime(vic_dataset$ACCIDENT_DATE,"%m")), seasons$Month)]
    
    top_eight_LGA_vic <- count(vic_dataset, Season, LGA_NAME_ALL)
    
    top_eight_LGA_vic <- top_eight_LGA_vic %>% group_by(Season) %>% arrange(Season, -n) %>% slice(1:8)
    
    top_eight_LGA_vic <- setNames(top_eight_LGA_vic, c("Season", "Site","count"))
    
    season_wise_plot_data <- top_eight_LGA_vic 
    
    speed_limit_plot_data <- load_vic_speed_limit_plot_data(vic_dataset)
    
    road_geometry_plot_data <- load_road_geometry_plot_data(vic_dataset)
    
  }else{
    
    aus_states <- read.csv("Locations.csv")
    
    aus_dataset <- read.csv("Fatalities.csv")
    
    aus_dataset <- load_aus_data(aus_dataset, seasons)
    
    state_crash_count <- count(aus_dataset, Season, State)
    
    state_crash_count <- state_crash_count %>% group_by(Season) %>% arrange(Season, -n)
    
    state_crash_count <- setNames(state_crash_count, c("Season", "Site","count"))
    
    season_wise_plot_data <- state_crash_count
    
    speed_limit_plot_data <- load_aus_speed_limit_plot_data(aus_dataset)
    
    road_geometry_plot_data <- load_age_group_plot_data(aus_dataset)
    
    print(paste0("inside aus location fool!"))
    
  }
  
  output$season_wise_site_crash_count <- renderPlotly({
    
    season_wise_plot <- ggplot(season_wise_plot_data, aes(x=Season, y=count, group=Site, color=Site, key = paste0(Site, ",", Season))) +
      geom_line() + expand_limits(x = 0, y = 800) + 
      geom_point(data = season_wise_plot_data, aes(x=Season, y=count, group=Site, 
                                                   color=Site, size = 5, 
                                                   text = paste0("Season: ", Season, "\n", "Site: ", Site, 
                                                                 "\n", "Crash count: ", count)), 
                 show.legend = FALSE) +
      theme(plot.background = element_rect(fill = "#1f252c", colour="#1f252c"), 
            panel.background = element_rect(fill = "#1f252c", colour="#1f252c"),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.title.x = element_text(colour = "white"),
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, colour = "white"),
            axis.title.y = element_text(colour = "white"),
            axis.text.y = element_text(colour = "white")) + 
      geom_text(aes(label=count, colour = "white"), position=position_dodge(width=0.9), vjust=-0.25) +
      labs(x = "Season", y = "Crash count", color='Sites')
    
    ggplotly(season_wise_plot, tooltip = "text") %>% layout(height = 575)
    
  })
  
  output$season_wise_dow_speed_limit <- renderPlot(bg = "#1f252c",{
    
    if(flag == 0){
      
      speed_limit_plot_data <- subset(speed_limit_plot_data, Site == "BRIMBANK")
      speed_limit_plot_data <- subset(speed_limit_plot_data, Season == "Autumn")
      
    }else{
      
      speed_limit_plot_data <- subset(speed_limit_plot_data, Site == "ACT")
      speed_limit_plot_data <- subset(speed_limit_plot_data, Season == "Autumn")
      
      print(paste0("inside aus season_wise_dow_speed_limit fool!"))
      
    }

    data <- speed_limit_plot_data
    
    data <- setNames(data, c("Site", "Season", "group", "value"))
    
    # Generate the layout. This function return a dataframe with one line per bubble. 
    # It gives its center (x and y) and its radius, proportional of the value
    packing <- circleProgressiveLayout(data$value, sizetype='area')
    
    # We can add these packing information to the initial data frame
    data <- cbind(data, packing)
    
    # Check that radius is proportional to value. We don't want a linear relationship, since it is the AREA that must be proportionnal to the value
    # plot(data$radius, data$value)
    
    # The next step is to go from one center + a radius to the coordinates of a circle that
    # is drawn by a multitude of straight lines.
    dat.gg <- circleLayoutVertices(packing, npoints=50)
    
    # Make the plot
    ggplot() + 
      
        # Make the bubbles
        geom_polygon(data = dat.gg, aes(x, y, group = id, fill=as.factor(id)), colour = "black", alpha = 0.6) +
                  
        # Add text in the center of each bubble + control its size
        geom_text(data = data, aes(x, y, size=value, label = paste0(group, "\n", value)), colour="white") +
        scale_size_continuous(range = c(1,4)) +
                  
        # General theme:
        theme_void() + 
        theme(legend.position="none") +
        coord_equal()
    
    
  })
  
  output$season_wise_road_age <- renderPlot(bg = "#1f252c",{ 
    
    if(flag == 0){
      
      road_geometry_plot_data <- subset(road_geometry_plot_data, Site == "BRIMBANK")
      road_geometry_plot_data <- subset(road_geometry_plot_data, Season == "Autumn")
      
    }else{
      
      road_geometry_plot_data <- subset(road_geometry_plot_data, Site == "ACT")
      road_geometry_plot_data <- subset(road_geometry_plot_data, Season == "Autumn")
      
      print(paste0("inside aus season_wise_road_age fool!"))
      
    }
    
  
    sample <- road_geometry_plot_data
    
    sample$lable <- paste(sample$road_geometry,"\n", sample$count)
    
    ggplot(sample, aes(area = count, fill = count, label = lable)) +
      theme(plot.background = element_rect(fill = "#1f252c", colour="#1f252c"), 
            panel.background = element_rect(fill = "#1f252c", colour="#1f252c")) +
      geom_treemap() +
      geom_treemap_text(colour = "white",
                        place = "centre",
                        size = 5,
                        grow = TRUE)
    
  })
  
  
  
  observeEvent(event_data("plotly_click"),{
    click <- event_data("plotly_click")
    if(is.null(click))
      return()
    
    current_speed_limit <- as.character(click$key)
    
    current_speed_limit <- strsplit(current_speed_limit, ",",fixed=TRUE)
    
    current_site <- current_speed_limit[[1]][1]
    
    current_season <- current_speed_limit[[1]][2]
    
    print(paste0(""))
    
    print(paste0("You have chosen site: ", current_site))
    
    print(paste0("You have chosen season: ", current_season))
    
    
    output$season_wise_dow_speed_limit <- renderPlot(bg = "#1f252c",{
      
      speed_limit_plot_data <- subset(speed_limit_plot_data, Site == current_site)
      speed_limit_plot_data <- subset(speed_limit_plot_data, Season == current_season)
      
      data <- speed_limit_plot_data
      
      data <- setNames(data, c("Site", "Season", "group", "value"))
      
      packing <- circleProgressiveLayout(data$value, sizetype='area')
      
      data <- cbind(data, packing)

      dat.gg <- circleLayoutVertices(packing, npoints=50)

      ggplot() + 

        geom_polygon(data = dat.gg, aes(x, y, group = id, fill=as.factor(id)), colour = "black", alpha = 0.6) +

        geom_text(data = data, aes(x, y, size=value, label = paste0(group, "\n", value)), colour="white") +
        scale_size_continuous(range = c(1,4)) +

        theme_void() + 
        theme(legend.position="none") +
        coord_equal()
      
      
    })
    
    output$season_wise_road_age <- renderPlot(bg = "#1f252c",{ 
      
      road_geometry_plot_data <- subset(road_geometry_plot_data, Site == current_site)
      road_geometry_plot_data <- subset(road_geometry_plot_data, Season == current_season)
      
      sample <- road_geometry_plot_data
      
      sample$lable <- paste(sample$road_geometry,"\n", sample$count)
      
      ggplot(sample, aes(area = count, fill = count, label = lable)) +
        theme(plot.background = element_rect(fill = "#1f252c", colour="#1f252c"), 
              panel.background = element_rect(fill = "#1f252c", colour="#1f252c")) +
        geom_treemap() +
        geom_treemap_text(colour = "white",
                          place = "centre",
                          size = 5,
                          grow = TRUE)
      
    })
    
    
  }, ignoreInit = TRUE)
  
  
}


load_livedashboard_tab <- function(input, output, session){
  
  vals = reactiveValues(i=0)
  output$top_vic <- renderText({
    
    if(vals$i < 5929){
      
      vals$i
      
    }else{
      
      o$destroy()
      5929
      
    }
 
    })
    o <-  observe({
          invalidateLater(100)
          isolate(vals$i <- vals$i + 50)
        })
    
    output$top_vic_seasons <- renderText({
      
      if(vals$i < 11069){
        
        vals$i
        
      }else{
        
        o$destroy()
        11069
        
      }
      
    })
    o <-  observe({
      invalidateLater(100)
      isolate(vals$i <- vals$i + 100)
    })
    
    output$total_vic_acc_people <- renderText({
      
      if(vals$i < 293205){
        
        vals$i
        
      }else{
        
        o$destroy()
        293205
        
      }
      
    })
    o <-  observe({
      invalidateLater(100)
      isolate(vals$i <- vals$i + 1000)
    })
    
    output$tot_inj_fat <- renderText({
      
      if(vals$i < 157846){
        
        vals$i
        
      }else{
        
        o$destroy()
        157846
        
      }
      
    })
    o <-  observe({
      invalidateLater(100)
      isolate(vals$i <- vals$i + 1000)
    })
    
    output$top_state <- renderText({
      
      if(vals$i < 16395){
        
        vals$i
        
      }else{
        
        o$destroy()
        16395
        
      }
      
    })
    o <-  observe({
      invalidateLater(100)
      isolate(vals$i <- vals$i + 100)
    })
    
    output$least_state <- renderText({
      
      if(vals$i < 482){
        
        vals$i
        
      }else{
        
        o$destroy()
        482
        
      }
      
    })
    o <-  observe({
      invalidateLater(100)
      isolate(vals$i <- vals$i + 10)
    })
    
    output$dow_fat <- renderText({
      
      if(vals$i < 9752){
        
        vals$i
        
      }else{
        
        o$destroy()
        9752
        
      }
      
    })
    o <-  observe({
      invalidateLater(100)
      isolate(vals$i <- vals$i + 100)
    })
    
    output$tot_fat <- renderText({
      
      if(vals$i < 53232){
        
        vals$i
        
      }else{
        
        o$destroy()
        53232
        
      }
      
    })
    o <-  observe({
      invalidateLater(100)
      isolate(vals$i <- vals$i + 100)
    })
    
    
  
}

server <- function(input, output, session) {
  
  # default display
  load_home_vic_data(input, output, session) 
  
  observeEvent(input$sidebarID,{  
    
    if(input$sidebarID == "home"){
      
      print(paste0("inside home!"))
      
      # default display
      load_home_vic_data(input, output, session) 
      
    }else if(input$sidebarID == "seasons"){
      
      print(paste0("inside seasons!"))
      
      load_seasons_tab(input, output, session, 0)
      
    }else if(input$sidebarID == "livedashboard"){
      
      print(paste0("inside livedashboard!"))
      
      load_livedashboard_tab(input, output, session)
      
    }
    
  }, ignoreInit = TRUE)
  
  observeEvent(input$home_vic_button,{   
    
    runjs('document.getElementById("home_vic_button").style.backgroundColor = "#605ca8";')
    runjs('document.getElementById("home_vic_button").style.borderColor = "#605ca8";')
    runjs('document.getElementById("home_vic_button").style.color = "#ffffff";')
    
    runjs('document.getElementById("home_aus_button").style.backgroundColor = "#ffffff";')
    runjs('document.getElementById("home_aus_button").style.borderColor = "#000000";')
    runjs('document.getElementById("home_aus_button").style.color = "#000000";')
    
    load_home_vic_data(input, output, session) 
    
  })  
  
  observeEvent(input$home_aus_button,{                                                                                                                                 
 
    runjs('document.getElementById("home_aus_button").style.backgroundColor = "#605ca8";')
    runjs('document.getElementById("home_aus_button").style.borderColor = "#605ca8";')
    runjs('document.getElementById("home_aus_button").style.color = "#ffffff";')
    
    runjs('document.getElementById("home_vic_button").style.backgroundColor = "#ffffff";')
    runjs('document.getElementById("home_vic_button").style.borderColor = "#000000";')
    runjs('document.getElementById("home_vic_button").style.color = "#000000";')
    
    load_home_aus_data(input, output, session) 
       
  })
  
  #Season tab functionality
  
  observeEvent(input$seasons_vic_button,{   
    
    runjs('document.getElementById("seasons_vic_button").style.backgroundColor = "#605ca8";')
    runjs('document.getElementById("seasons_vic_button").style.borderColor = "#605ca8";')
    runjs('document.getElementById("seasons_vic_button").style.color = "#ffffff";')
    
    runjs('document.getElementById("seasons_aus_button").style.backgroundColor = "#ffffff";')
    runjs('document.getElementById("seasons_aus_button").style.borderColor = "#000000";')
    runjs('document.getElementById("seasons_aus_button").style.color = "#000000";')
    
    load_seasons_tab(input, output, session, 0)
    
  })  
  
  observeEvent(input$seasons_aus_button,{                                                                                                                                 
    
    runjs('document.getElementById("seasons_aus_button").style.backgroundColor = "#605ca8";')
    runjs('document.getElementById("seasons_aus_button").style.borderColor = "#605ca8";')
    runjs('document.getElementById("seasons_aus_button").style.color = "#ffffff";')
    
    runjs('document.getElementById("seasons_vic_button").style.backgroundColor = "#ffffff";')
    runjs('document.getElementById("seasons_vic_button").style.borderColor = "#000000";')
    runjs('document.getElementById("seasons_vic_button").style.color = "#000000";')
    
    load_seasons_tab(input, output, session, 1)
    
  })
  
}