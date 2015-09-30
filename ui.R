shinyUI(fluidPage(
    
    theme = "simplex.css",
    
    titlePanel(tags$h2(tags$strong("Genie - A Recommendation App for Travellers In-Transit")),
               tags$head(tags$title("Genie"))),
    
    tags$hr(),
    
    fluidRow(
        
        # ==== 1. capture demographics ==== #
        column(2,
               tags$br(),
               uiOutput("selectNatl"),
               uiOutput("selectAge"),
               uiOutput("selectGender")
        ),
        
        # ==== 2. capture flight number ==== #
        column(2,
               tags$br(),
               textInput("_flightNum", label = "Enter your flight number:", value = " "),
               tags$h5("You have entered:"),
               verbatimTextOutput("showFlightNum")
        ),
        
        # ==== 3. Select which broad category ==== #
        column(4,
               tags$h5("What would you like to do first?"),
               actionButton("_r&r", "Rest & Relax", icon = icon("pause", class = "fa-spin", lib = "font-awesome")),
               actionButton("_f&b", "Food & Beverages", icon = icon("cutlery", class = "fa-spin", lib = "font-awesome")),
               actionButton("_shopping", "Shopping", icon = icon("shopping-cart", class = "fa-spin", lib = "font-awesome")),
               tags$h5("You have selected:"),
               verbatimTextOutput("showWhichCate")
        ),
        
        # ==== 4. Select root node ==== #
        column(3,
               tags$br(),
               selectInput("_root", "Where would you like to go first?", choices = c('a1'='1','b2'='2')),
               actionButton("_submit", "What does Genie recommend?", icon = icon("plane", lib = "font-awesome")),
               tags$br(),
               tags$h6("© XGB-Protocol for CAG Hackathon 2015")
        )
    ),
    
    # ==== 5. Display Markov recommendations and required information ==== #
    fluidRow(
        
        column(8, imageOutput("showMarkov")),
        column(3, dataTableOutput("showInfo"),
               tags$br(),
               textOutput("showLegend"))
    )
    
))