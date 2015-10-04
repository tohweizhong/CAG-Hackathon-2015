shinyUI(fluidPage(
    
    theme = "simplex.css",
    
    titlePanel(tags$h2(tags$strong("Genie: Towards Smart & Personalized Recommendations for Travellers In-Transit")),
               tags$head(tags$title("Genie"))),
    
    tags$hr(),
    
    sidebarLayout(
        
        sidebarPanel(
            # ==== 1. capture demographics ==== #
            tags$br(),
            uiOutput("selectNatl"),
            uiOutput("selectAge"),
            uiOutput("selectGender"),
            
            # ==== 2. capture flight number ==== #
            tags$br(),
            textInput("_flightNum", label = "Enter your flight number:", value = ""),
            tags$h5("Time to flight:"),
            #verbatimTextOutput("showFlightNum"),
            verbatimTextOutput("showTime"),
            
            # ==== 3. Select which broad category ==== #
            tags$h5("What would you like to do first?"),
            actionButton("_r&r", "Rest & Relax", icon = icon("pause", class = "fa-spin", lib = "font-awesome")),
            actionButton("_f&b", "Food & Beverages", icon = icon("cutlery", class = "fa-spin", lib = "font-awesome")),
            actionButton("_shopping", "Shopping", icon = icon("shopping-cart", class = "fa-spin", lib = "font-awesome")),
            tags$h5("You have selected:"),
            verbatimTextOutput("showWhichCate"),
            
            # ==== 4. Select root node ==== #
            tags$br(),
            selectInput("_root", "Where would you like to go first?", choices = ""),
            actionButton("_submit", "What does Genie recommend?", icon = icon("plane", lib = "font-awesome")),
            tags$br(),
            tags$br(),
            actionButton("_like", "Do you like Genie's recommendation?", icon = icon("thumbs-o-up", lib = "font-awesome")),
            tags$h6("© XGB-Protocol for CAG Hackathon 2015")
        ),
        
        mainPanel(
            # ==== 5. Display Markov recommendations and required information ==== #
            fluidRow(
                plotOutput("showMarkov"),
                textOutput("showLegend0"),
                tags$head(tags$style("#showLegend0{font-size: 24px; font-style: bold;}")),
                tags$br(),
                textOutput("showLegend1"),
                tags$head(tags$style("#showLegend1{color: #A16CC1; font-size: 16px; font-style: bold;}")),
                textOutput("showLegend2"),
                tags$head(tags$style("#showLegend2{color: #7FFFD4; font-size: 16px; font-style: bold;}")),
                textOutput("showLegend3"),
                tags$head(tags$style("#showLegend3{color: #F0E68C; font-size: 16px; font-style: bold;}"))
            ),
            tags$br(),
            fluidRow(
                textOutput("showLegend4"),
                tags$head(tags$style(" #showLegend4{font-size: 16px; font-style: bold;}")),
                textOutput("showLegend5"),
                tags$head(tags$style(" #showLegend5{font-size: 16px; font-style: bold;}"))
            )
        )
    )
))