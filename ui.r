ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(
    sidebarMenu(
      id = "sidebarID",
      menuItem("Top Sites", tabName = "home", icon = icon("th")),
      menuItem("Seasons", tabName = "seasons", icon = icon("calendar")),
      menuItem("Live Dashboard", tabName = "livedashboard", icon = icon("th"))
    )
  ),
  dashboardBody(
    
    ### changing theme
    shinyDashboardThemes(
      theme = "grey_dark"
    ),
    
    useShinyjs(),
    
    tabItems(
      
      # Home tab content
      tabItem(tabName = "home",
              fluidRow(
                
                column(12, align = "center",
                       actionButton("home_vic_button", "Victorian Road Crash Data(All Crashes)", style="color: #fff; background-color: #605ca8; border-color: #605ca8; padding-top:10px; padding-bottom:10px; padding-left:100px; padding-right:100px; font-size:120%"), 
                       actionButton("home_aus_button", "Australian Fatal Road Crash Data", style = "padding-top:10px; padding-bottom:10px; padding-left:100px; padding-right:100px; font-size:120%"))
                
              ),
              fluidRow(
                
                column(7,div(style = "height:875px; margin-top: 1%;",
                       
                       fluidRow(
                         
                         column(12,div(style = "height:438px; margin-bottom:20px; margin-top:20px;",
                                
                                       withSpinner(leafletOutput(outputId = "map", height = "45vh"))
                                
                                )),
                         column(12,div(style = "height:430px; background-color: #1f252c; margin-top:20px;",
                                       
                                column(3,div()),

                                column(6, div(style = "height:80px; width:400px; margin-top:10px;",
                                              
                                              withSpinner(plotOutput("season_circular_plot"))
                                              
                                              )
                                       ),      
                                       
                                column(3,div())
                                
                         ))
                       
                       )
                  )
                ),
                column(5,div(style = "height:875px; margin-top: 4%;", 
                             
                             fluidRow(
                               
                               column(12, div(style = "height:460px; background-color: #1f252c;",
                                              
                                              fluidRow(
                                                
                                                      column(12,div(style = "height:25px; width: 250px; margin:0 auto;",
                                                                    
                                                                    h3("TOP CRASH SITES")
                                                                    
                                                                    )
                                                            ),
                                                      
                                                      column(12,div(style = "height:400px;",
                                                                    
                                                                    withSpinner(plotOutput("top_crash_sites_plot"))
                                                                    
                                                                    )
                                                            )
                                                
                                                      )
                                              
                                              )
                                      
                                      ),
           
                               column(12, div(style = "height:410px; background-color: #1f252c; margin-top:10px;",
                                              
                                              fluidRow(
                                                
                                                      column(12,div(style = "height:25px; width: 450px; margin:0 auto;",
                                                                    
                                                                    h3("CRASHES EACH DAY OF THE WEEK")
                                                                    
                                                                    )
                                                            ),
                                                
                                                      column(12,div(style = "height:400px; align:center;",
                                                                    
                                                                    withSpinner(plotOutput("dow_crash_plot"))
                                                                    
                                                                    )
                                                            )
                                                
                                                        )
                                              
                                              )
                               
                                      ),
                               
                                  )
                             
                             )
                       
                       )          
                
              )
      ),
      
      # Seasons tab content
      tabItem(tabName = "seasons",
              fluidRow(
                
                column(12, align = "center",
                       actionButton("seasons_vic_button", "Victorian Road Crash Data(All Crashes)", style="color: #fff; background-color: #605ca8; border-color: #605ca8; padding-top:10px; padding-bottom:10px; padding-left:100px; padding-right:100px; font-size:120%"), 
                       actionButton("seasons_aus_button", "Australian Fatal Road Crash Data", style = "padding-top:10px; padding-bottom:10px; padding-left:100px; padding-right:100px; font-size:120%"))
                
              ),
              
              fluidRow(
                
                column(12,div(style = "height:637px; margin-top: 1%;",
                              
                              column(12,div(style = "height:625px; background-color: #1f252c;",
                                            
                                            fluidRow(
                                              
                                              column(12,div(style = "height:25px; width: 600px; margin:0 auto;",
                                                            
                                                            h3("CRASH COUNT EACH SITE IN EACH SEASON")
                                                            
                                                            )
                                                    ),
                                              column(12,div(style = "height:575px;",
                                                            
                                                            withSpinner(plotlyOutput("season_wise_site_crash_count"))
                                                            
                                                            )
                                                      )
                                              
                                            )
                                            
                                          )
                                    ),

                              )
                ),
                
                column(12,div(style = "height:800px; margin-top: 1%;",
                              
                              column(6,div(style = "height:720px; background-color: #1f252c;",
                                           
                                           fluidRow(
                                             
                                             column(12,div(style = "height:25px; width: 500px; margin:0 auto;",
                                                           
                                                           h3("ACCIDENT DISTRIBUTION OF CHOSEN LOCATION AND SEASON BY SPEED LIMIT")
                                                           
                                                          )
                                                   ),
                                             column(12,div(style = "height:475px; width: 500px; margin:0 auto; padding: 30px",
                                                           
                                                           fluidRow(
                                                            
                                                             withSpinner(plotOutput("season_wise_dow_speed_limit"))
            
                                                           )
                                                           
                                                          )
                                                   )
                                             
                                           )
                                           
                                        )
                              ),
                              
                              column(6,div(style = "height:720px; background-color: #1f252c;",
                                           
                                           fluidRow(
                                             
                                             column(12,div(style = "height:50px; width: 500px; margin:0 auto;",
                                                           
                                                           h3("ACCIDENT DISTRIBUTION OF CHOSEN LOCATION AND SEASON BY ROAD GEOMETRY / AGE GROUP")
                                                           
                                                          )
                                                   ),
                                             column(12,div(style = "height:450px; width: 500px; margin:0 auto; padding: 40px",
                                                           
                                                           fluidRow(
                                                             
                                                             withSpinner(plotOutput("season_wise_road_age"))
                                                             
                                                           )
                                                                 
                                                          )
                                                   )
                                             
                                           )
                                           
                                      )
                                  )
                              
                              )
                              
                          )
                
                    )
                    
      ),
      # livedashboard tab content
      tabItem(tabName = "livedashboard",
              fluidRow(
                
                column(12, div(style = "height:250px;",
                               
                               column(3, align = "center", div(style = "height:250px; background-color: #1f252c; padding: 5px",
                                                               
                                                               fluidRow(
                                                                 
                                                                 column(12, align = "center",
                                                                        
                                                                        h3("MOST ACCIDENTS (VIC)")
                                                                        
                                                                        ),
                                                                 column(10, 
                                                                        
                                                                        fluidRow(
                                                                          
                                                                          h1("", textOutput("top_vic"), style = "color: #ffffff; font-weight: bold; font-size: 90px;"),
                                                                          h3("MELBOURNE", style = "color: #6c718b")
                                                                          
                                                                        )
                                                                        
                                                                        ),
                                                                 column(2, div(style = "height:150px; background-color: #3700b3;"))
                                                                 
                                                               )
                                                               
                                                               )
                                      ),
                               
                               column(3, align = "center", div(style = "height:250px; background-color: #1f252c; padding: 5px",
                                                               
                                                               fluidRow(
                                                                 
                                                                 column(12, align = "center",
                                                                        
                                                                        h3("SEASON WITH MOST ACCIDENTS(VIC)")
                                                                        
                                                                 ),
                                                                 column(10, 
                                                                        
                                                                        fluidRow(
                                                                          
                                                                          h1("", textOutput("top_vic_seasons"), style = "color: #ffffff; font-weight: bold; font-size: 90px;"),
                                                                          h3("AUTUMN", style = "color: #6c718b")
                                                                          
                                                                        )
                                                                        
                                                                 ),
                                                                 column(2, div(style = "height:150px; background-color: #ffc107;"))
                                                                 
                                                               )
                                                               
                               )
                               ),
                               
                               column(3, align = "center", div(style = "height:250px; background-color: #1f252c; padding: 5px",
                                                               
                                                               fluidRow(
                                                                 
                                                                 column(12, align = "center",
                                                                        
                                                                        h3("TOTAL PEOPLE INVOLVED(VIC)")
                                                                        
                                                                 ),
                                                                 column(10, 
                                                                        
                                                                        fluidRow(
                                                                          
                                                                          h1("", textOutput("total_vic_acc_people"), style = "color: #ffffff; font-weight: bold; font-size: 90px;"),
                                                                          h3("ALL VICTORIA", style = "color: #6c718b")
                                                                          
                                                                        )
                                                                        
                                                                 ),
                                                                 column(2, div(style = "height:150px; background-color: #03dac6;"))
                                                                 
                                                               )
                                                               
                               )
                               ),
                               
                               column(3, align = "center", div(style = "height:250px; background-color: #1f252c; padding: 5px",
                                                               
                                                               fluidRow(
                                                                 
                                                                 column(12, align = "center",
                                                                        
                                                                        h3("TOTAL INJURED OR FATAL")
                                                                        
                                                                 ),
                                                                 column(10, 
                                                                        
                                                                        fluidRow(
                                                                          
                                                                          h1("", textOutput("tot_inj_fat"), style = "font-weight: bold; font-size: 90px;"),
                                                                          h3("ALL VICTORIA", style = "color: #6c718b")
                                                                          
                                                                        )
                                                                        
                                                                 ),
                                                                 column(2, div(style = "height:150px; background-color: #f05050;"))
                                                                 
                                                               )
                                                               
                               )
                               )
                               
                               )
                       
                                                
                       ),
                
                column(12, div(style = "height:250px; margin-top: 25px",
                               
                               column(3, align = "center", div(style = "height:250px; background-color: #1f252c; padding: 5px",
                                                               
                                                               fluidRow(
                                                                 
                                                                 column(12, align = "center",
                                                                        
                                                                        h3("MOST FATAL ACCIDENTS")
                                                                        
                                                                 ),
                                                                 column(10, 
                                                                        
                                                                        fluidRow(
                                                                          
                                                                          h1("", textOutput("top_state"), style = "color: #ffffff; font-weight: bold; font-size: 90px;"),
                                                                          h3("NEW SOUTH WALES", style = "color: #6c718b")
                                                                          
                                                                        )
                                                                        
                                                                 ),
                                                                 column(2, div(style = "height:150px; background-color: #3700b3;"))
                                                                 
                                                               )
                                                               
                               )
                               ),
                               
                               column(3, align = "center", div(style = "height:250px; background-color: #1f252c; padding: 5px",
                                                               
                                                               fluidRow(
                                                                 
                                                                 column(12, align = "center",
                                                                        
                                                                        h3("LEASET FATAL ACCIDENTS")
                                                                        
                                                                 ),
                                                                 column(10, 
                                                                        
                                                                        fluidRow(
                                                                          
                                                                          h1("", textOutput("least_state"), style = "color: #ffffff; font-weight: bold; font-size: 90px;"),
                                                                          h3("ACT", style = "color: #6c718b")
                                                                          
                                                                        )
                                                                        
                                                                 ),
                                                                 column(2, div(style = "height:150px; background-color: #ffc107;"))
                                                                 
                                                               )
                                                               
                               )
                               ),
                               
                               column(3, align = "center", div(style = "height:250px; background-color: #1f252c; padding: 5px",
                                                               
                                                               fluidRow(
                                                                 
                                                                 column(12, align = "center",
                                                                        
                                                                        h3("MOST ACCIDENTS PER DAY OF WEEK")
                                                                        
                                                                 ),
                                                                 column(10, 
                                                                        
                                                                        fluidRow(
                                                                          
                                                                          h1("", textOutput("dow_fat"), style = "color: #ffffff; font-weight: bold; font-size: 90px;"),
                                                                          h3("SATURDAY", style = "color: #6c718b")
                                                                          
                                                                        )
                                                                        
                                                                 ),
                                                                 column(2, div(style = "height:150px; background-color: #03dac6;"))
                                                                 
                                                               )
                                                               
                               )
                               ),
                               
                               column(3, align = "center", div(style = "height:250px; background-color: #1f252c; padding: 5px",
                                                               
                                                               fluidRow(
                                                                 
                                                                 column(12, align = "center",
                                                                        
                                                                        h3("TOTAL FATAL ACCIDENTS")
                                                                        
                                                                 ),
                                                                 column(10, 
                                                                        
                                                                        fluidRow(
                                                                          
                                                                          h1("", textOutput("tot_fat"), style = "font-weight: bold; font-size: 90px;"),
                                                                          h3("AUSTRALIA", style = "color: #6c718b")
                                                                          
                                                                        )
                                                                        
                                                                 ),
                                                                 column(2, div(style = "height:150px; background-color: #f05050;"))
                                                                 
                                                               )
                                                               
                               )
                               )
                               
                )
                
                
                ),
                
              )
              
      )
    )
  )
)