# houseblend.R

# code to generate igraph
# (not working)
source("codes/CAG2.R")

# list of facilities
cag.directory <- read.csv("data/Shops_kel.csv", stringsAsFactors = F)
rnr <- sort(cag.directory[which(cag.directory$Category == "R&R"),"ShopName"])
fnb <- sort(cag.directory[which(cag.directory$Category == "F&B"),"ShopName"])
shp <- sort(cag.directory[which(cag.directory$Category == "Shopping"),"ShopName"])

# biz rules
rules <- read.csv("data/Biz Rule1.csv", stringsAsFactors = F)

# function to match facilities with categories
MatchFacWithCate <- function(f){
    idx <- which(cag.directory$ShopName == f)
    return(cag.directory$Category[idx])
}

# list of flights
flights.df <- read.csv("data/flights.csv", stringsAsFactors = F)
