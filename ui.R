shinyUI(fluidPage(
    
    theme = "lumen.css",
    
    titlePanel("In-transit app for CAG hackathon (need a name for our product)"),
    
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
            actionButton("_r&r", "Rest & Relax", icon = icon("pause", lib = "font-awesome")),
            actionButton("_f&b", "Food & Beverages", icon = icon("cutlery", lib = "font-awesome")),
            actionButton("_shopping", "Shopping", icon = icon("shopping-cart", lib = "font-awesome"))
            
        , width = 4),
        mainPanel()
    )
))