# set-up
source("codes/houseblend.R")

shinyServer(function(session, input, output){
    
    # ==== Reactive objects ==== #
    Profile <- reactive({
        profile <- paste(input$"_natl", ", ",
                         input$"_gender", ", ",
                         input$"_age", sep = "")
        profile <- gsub(x = profile, pattern = "<", replacement = "less")
        profile <- gsub(x = profile, pattern = ">", replacement = "more")
        
        return(profile)
    })
    
    Filename.png <- reactive({
        root <- input$"_root"
        # either one, or neither
        profile <- Profile()
        profile <- gsub(x = profile, pattern = "<", replacement = "less")
        profile <- gsub(x = profile, pattern = ">", replacement = "more")
        
        filename <- paste("images/network images/", root, "_", profile, ".png", sep = "")
        return(filename)
    })
    
    # ==== 1. capture demographics and flight number ==== #
    output$selectNatl <- renderUI({
        selectizeInput("_natl", "Select your nationality:",
                       c("Chinese" = "Chinese",
                         "Indonesian" = "Indonesian"))
    })
    
    output$selectAge <- renderUI({
        selectizeInput("_age", "Select your age group:",
                       c("<35yrs", "35-64yrs", ">64yrs"))
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
    
    # === 3. Select root node ==== # 
    observe({
        
        .choices <- ""
        
        # extract the selected category
        cate <- params$whichCate
        if(cate == "Rest & Relax") cate <- "R&R"
        else if(cate == "Food & Beverages") cate <- "F&B"
        
        # extract the profile
        profile <- Profile()
        
        # extract the corresponding indices
        idx <- which(rules$Profile == profile)
        
        # extract the corresponding popular facilities
        .choices <- union(rules$From[idx], rules$To[idx])
        .choices <- sort(.choices)
        
        # match the facilities with categories
        .choices.cate <- unlist(sapply(.choices, MatchFacWithCate))
        
        # extract the facilities in the category
        idx2 <- which(.choices.cate == cate)
        .choices <- .choices[idx2]
        .choices <- as.pairlist(.choices)
        
        updateSelectInput(session, "_root", choices = .choices)
        params$submitted <- FALSE
    })
    
    # ==== 4. Display Markov recommendations and other information ==== #
    output$showMarkov <- renderImage({
        if(params$submitted == FALSE)
            list(src = "images/logo3.png", alt = NULL, width = 600)
        
        else if(params$whichCate == "None")
            list(src = "images/logo3.png", alt = NULL, width = 600)
        
        else list(src = Filename.png(), alt = NULL, width = 600)
    }, deleteFile = F)
    
    # attempt to render plot
    output$showMarkov2 <- renderPlot({
        goPlot(CHOSEN = input$"_root", pfl = Profile())
    })
    
    output$showTime <- renderText({
        flightNum <- input$"_flightNum"
        
        if(flightNum != ""){
            idx <- which(flights.df$Flight.No == flightNum)
            flightTime <- flights.df$Time[idx]

            timeDiff <- strptime(flightTime, "%H%M") - Sys.time()
            idx2 <- gregexpr("[0-9,.]+", timeDiff)
            timeDiff <- as.numeric(unique(unlist(regmatches(timeDiff, idx2))))
            timeDiff <- round(timeDiff, 2)
            
            mins <- round((timeDiff %% 1) * 60)
            hrs <- timeDiff - timeDiff %% 1
            
            returnMe <- paste(hrs, " hrs and ", mins, " mins", sep = "")
            return(returnMe) 
        }
        return("")
    })
    
    output$showLegend0 <- renderText({
        if(params$submitted == TRUE){
            return("Legend:")
        }
    })
    
    output$showLegend1 <- renderText({
        if(params$submitted == TRUE){
            return("Purple: Rest & Relax")
        }
    })
    
    output$showLegend2 <- renderText({
        if(params$submitted == TRUE){
            return("Turquoise: Food & Beverages")
        }
    })
    
    output$showLegend3 <- renderText({
        if(params$submitted == TRUE){
            return("Orange: Shopping")
        }
    })
    
    output$showLegend4 <- renderText({
        if(params$submitted == TRUE){
            return("Size of shape: average time spent at shop")
        }
    })
    
    output$showLegend5 <- renderText({
        if(params$submitted == TRUE){
            return("Thickness of arrow: popularity of shop")
        }
    })
})