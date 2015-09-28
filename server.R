shinyServer(function(input,output){
    
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
    params <- reactiveValues(whichCate = NULL)
    
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
    
    # ==== 3. Display Markov recommendations ==== #
    output$showMarkov <- renderImage({
        if(length(params$whichCate) == 0)
            list(src = "images/example_logo.png", alt = NULL, width = 600)
        
        else if(params$whichCate == "Rest & Relax")
            list(src = "images/example_markov.png", alt = NULL, width = 800)
    }, deleteFile = F)
})