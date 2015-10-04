# TODO

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
    
#     Terminal <- reactive({
#         if(input$"_flightNum" != ""){
#             flightNum <- input$"_flightNum"
#             idx <- which(flights.df$Flight.No == flightNum)
#             terminal <- flights.df[idx]
#             return(terminal)
#         }
#         else return("")
#     })
    
    Filename.png <- reactive({
        root <- input$"_root"
        # either one, or neither
        profile <- Profile()
        profile <- gsub(x = profile, pattern = "<", replacement = "less")
        profile <- gsub(x = profile, pattern = ">", replacement = "more")
        
#         if(input$"_flightNum" != ""){
#             
#             # extract terminal
#             flightNum <- input$"_flightNum"
#             idx <- which(flights.df$Flight.No == flightNum)
#             terminal <- flights.df$Terminal[idx]
#             filename <- paste("images/network images/NEW network images/", terminal, " images/", root, "_", profile, ".png", sep = "")
#         }
#         else{
#             filename <- paste("images/network images/", root, "_", profile, ".png", sep = "") 
#         }
#         print(filename)
        
        filename <- paste("images/network images/", root, "_", profile, ".png", sep = "")
        print(filename)
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

    
#     Profile2Facilities <- reactive({
#         
#         # extract the selected category
#         this.cate <- params$whichCate
#         if(this.cate == "Rest & Relax") this.cate <- "R&R"
#         else if(this.cate == "Food & Beverages") this.cate <- "F&B"
#         
#         # extract the profile
#         this.profile <- paste(input$"_natl", ", ",
#                          input$"_gender", ", ",
#                          input$"_age", sep = "")
#         
#         # extract the corresponding indices
#         this.idx <- which(rules$Profile == this.profile)
#         
#         # extract the corresponding popular facilities
#         this.facilities <- union(rules$From[idx], rules$To[idx])
#         this.facilities <- sort(this.facilities)
#         
#         # match the facilities with categories
#         this.facilities.cate <- unlist(sapply(this.facilities, MatchFacWithCate))
#         
#         # extract the facilities in the category
#         this.idx2 <- which(this.facilities.cate == this.cate)
#         this.facilities <- this.facilities[this.idx2]
#         
#         returnMe <- data.frame(cbind(this.facilities, this.facilities.cate),
#                                stringsAsFactors = F)
#         colnames(returnMe) <- c("Facility", "Category")
#         
#         return(returnMe)
#     })
    
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
        print(.choices)
        
        # extract facilities from the correct terminal
#         if(input$"_flightNum" != ""){
#             
#             # extract terminal
#             flightNum <- input$"_flightNum"
#             idx <- which(flights.df$Flight.No == flightNum)
#             terminal <- flights.df$Terminal[idx]
#             print(terminal)
#             # subset facilities based on terminal
#             idx <- which(cag.directory$Location == terminal)
#             print(idx)
#             .choices <- intersect(.choices, cag.directory$ShopName[idx])
#             print(.choices)
#         }
#         
#         if(params$whichCate == " ")
#             .choices <- ""
#         if(params$whichCate == "Rest & Relax"){
#             tmp.df <- Profile2Facilities()
#             idx <- which(tmp.df$Category == "Rest & Relax")
#             .choices <- tmp.df$Facility[idx]
#             
#         }
#         else if(params$whichCate == "Food & Beverages")
#             .choices <- c("1")
#         else if(params$whichCate == "Shopping")
#             .choices <- c("2")
        
        .choices <- as.pairlist(.choices)
        
        updateSelectInput(session, "_root", choices = .choices)
        
        params$submitted <- FALSE
    })
    
    # ==== 4. Display Markov recommendations and other information ==== #
    # this is where the rendering images with if else
    output$showMarkov <- renderImage({
        
        if(params$submitted == FALSE)
            list(src = "images/logo3.png", alt = NULL, width = 600)
        
        else if(params$whichCate == "None")
            list(src = "images/logo3.png", alt = NULL, width = 600)
        
        ###
        
        else
            
            list(src = Filename.png(), alt = NULL, width = 600)
        
#         else if(params$whichCate == "Rest & Relax")
#             list(src = "images/TWG Tea Boutique_Chinese, F, more64yrs.png", alt = NULL, width = 800)
#         
#         else if(params$whichCate == "Shopping" && input$"_root" == "Guardian")
#             list(src = "images/example_guardian.png", alt = NULL, width = 800)
#         
#         else if(params$whichCate == "Shopping" && input$"_root" == "Longchamp")
#             list(src = "images/example_longchamp.png", alt = NULL, width = 800)
#         
#         else if(params$whichCate == "Food & Beverages" && input$"_root" == "Ippudo Express")
#             list(src = "images/example_longchamp.png", alt = NULL, width = 800)
    }, deleteFile = F)
    
    
    # attempt to render plot
    output$showMarkov2 <- renderPlot({
        goPlot(CHOSEN = input$"_root", pfl = Profile())
    })
    
    
#     output$showInfo <- renderDataTable({
#         if(params$submitted == TRUE){
#             df <- data.frame(matrix(99, nrow = 2, ncol = 2))
#             colnames(df) <- c("Facility", "Location")
#             return(df)
#         }
#     }, options = list(searching = FALSE, paging = FALSE))
    
    output$showTime <- renderText({
        
        flightNum <- input$"_flightNum"
        
        if(flightNum != ""){
            idx <- which(flights.df$Flight.No == flightNum)
            flightTime <- flights.df$Time[idx]
            
            #flightDate <- flights$Date
            #datetime <- paste()
            
            timeDiff <- strptime(flightTime, "%H%M") - Sys.time()
            idx2 <- gregexpr("[0-9,.]+", timeDiff)
            timeDiff <- as.numeric(unique(unlist(regmatches(timeDiff, idx2))))
            timeDiff <- round(timeDiff, 2)
            
            mins <- round((timeDiff %% 1) * 60)
            hrs <- timeDiff - timeDiff %% 1
            
            #returnMe <- paste("Time to flight: ", hrs, "hrs and ", mins, " mins.", sep = "")
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
            legend <- "Purple: Rest & Relax"
            return(legend)
        }
    })
    
    output$showLegend2 <- renderText({
        if(params$submitted == TRUE){
            legend <- "Orange: Food & Beverages"
            return(legend)
        }
        
    })
    
    output$showLegend3 <- renderText({
        if(params$submitted == TRUE){
            legend <- "Turquoise: Shopping"
            return(legend)
        }
    })
    
    output$showLegend4 <- renderText({
        if(params$submitted == TRUE){
            legend <- "Size of shape: overall popularity of shop"
            return(legend)
        }
    })
    
    output$showLegend5 <- renderText({
        if(params$submitted == TRUE){
            legend <- "Thickness of arrow: popularity of 
                      visiting a given shop when originating 
                      from another shop"
            return(legend)
        }
    })
})