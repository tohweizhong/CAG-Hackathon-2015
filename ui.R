shinyUI(fluidPage(
    
    theme = "lumen.css",
    
    titlePanel(tags$strong("Changi Recommends (do we have another name?)"),
               tags$head(tags$title("Changi Recommends"))),
    
    sidebarLayout(
        sidebarPanel(
            # ==== 1. capture demographics and flight number ==== #
            uiOutput("selectNatl"),
            uiOutput("selectAge"),
            uiOutput("selectGender"),
            textInput("_flightNum", label = "Enter your flight number"),
            tags$h5("You have entered:"),
            verbatimTextOutput("showFlightNum"),
            
            tags$hr(),
            
            # ==== 2. Select which broad category ==== #
            tags$h5("Select a category:"),
            actionButton("_r&r", "Rest & Relax", icon = icon("pause", class = "fa-spin", lib = "font-awesome")),
            actionButton("_f&b", "Food & Beverages", icon = icon("cutlery", class = "fa-spin", lib = "font-awesome")),
            actionButton("_shopping", "Shopping", icon = icon("shopping-cart", class = "fa-spin", lib = "font-awesome")),
            tags$h5("You have selected:"),
            verbatimTextOutput("showWhichCate"),
            tags$hr(),
            actionButton("_submit", "What does Changi recommend?", icon = icon("plane", lib = "font-awesome")),
            tags$br(),
            tags$h6("© XGB-Protocol for CAG Hackathon 2015")
            
        , width = 4),
        
        mainPanel(
            # ==== 3. Display Markov recommendations ==== #
            imageOutput("showMarkov")
        )
    )
))