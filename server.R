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
    
    
    
    
})