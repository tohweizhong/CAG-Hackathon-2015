shinyServer(function(session, input, output){
    
    # ==== 1. capture demographics and flight number ==== #
    output$selectNatl <- renderUI({
        selectizeInput("_natl", "Select your nationality:",
                       c("Singapore" = "SG"))
    })
    
    output$selectAge <- renderUI({
        selectizeInput("_age", "Select your age group:",
                       c("10 - 20", "20 - 30", "30 - 40",
                         "40 - 50", "50 - 60", "60 - 70","70 - 80"))
    })
    
    output$selectGender <- renderUI({
        selectizeInput("_gender", "Select your gender:", c("M", "F"))
    })
    
    output$showFlightNum <- renderText({input$"_flightNum"})
    
    # ==== 2. Select which broad category ==== #
    params <- reactiveValues(whichCate = " ", submitted = FALSE)
    
    observeEvent(input$"_r&r",{
        params$whichCate <- "Rest & Relax"
    })
    
    observeEvent(input$"_f&b",{
        params$whichCate <- "Food & Beverages"
    })
    
    observeEvent(input$"_shopping",{
        params$whichCate <- "Shopping"
    })
    
    output$showWhichCate <- renderText({params$whichCate})
    
    observeEvent(input$"_submit",{
        params$submitted <- TRUE
    })
    
    # ==== 3. Display Markov recommendations ==== #
    output$showMarkov <- renderImage({
        if(params$submitted == FALSE)
            list(src = "images/logo2.png", alt = NULL, width = 600)
        
        else if(params$whichCate == "None")
            list(src = "images/logo2.png", alt = NULL, width = 600)
        
        else if(params$whichCate == "Rest & Relax")
            list(src = "images/example_markov.png", alt = NULL, width = 800)
    }, deleteFile = F)
    
    
    observe({
        .choices <- NULL
        
        if(params$whichCate == " ")
            .choices <- ""
        if(params$whichCate == "Rest & Relax")
            .choices <- c("Enchanted Garden", "Nap lounge", "Movie Theatre")
        else if(params$whichCate == "Food & Beverages")
            .choices <- c("McDonalds", "Swensens", "Ding Tai Fung")
        else if(params$whichCate == "Shopping")
            .choices <- c("Zara", "Braun Buffel", "Charles & Keith")
        
        .choices <- as.pairlist(.choices)
        
        updateSelectInput(session, "_root", choices = .choices)
    })
    
    output$showInfo <- renderDataTable({
        if(params$submitted == TRUE){
            df <- data.frame(matrix(99, nrow = 2, ncol = 2))
            colnames(df) <- c("Facility", "Location")
            return(df)
        }
    }, options = list(searching = F, paging = F))
    
})