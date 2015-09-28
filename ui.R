shinyUI(fluidPage(
    
    theme = "lumen.css",
    
    titlePanel("Changi Recommends (do we have another name for our product?)"),
    
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
            verbatimTextOutput("showWhichCate")
            
        , width = 4),
        
        mainPanel(
            # ==== 3. Display Markov recommendations ==== #
            imageOutput("showMarkov")
        )
    )
))