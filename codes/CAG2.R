#setwd("C:\\Users\\kelvinlim\\Desktop\\CAG")
#library(rJava)
#library(xlsxjars)
#library(openxlsx)
library(plyr)
#library(ggplot2)
library(lubridate)
library(igraph)
library(arules)
#library(datasets)
library(arulesViz)

#data=subset(data, select=c("From","To","Profile"))
#data=read.csv("CAG fake data2.csv")
#Vdata=read.csv("Vdata.csv")



# CHOSEN = "Movie Theatre"#"Ippudo Express"#"ZARA"#"Dnata Lounge"
# pfl = "Chinese, M, >64yrs"
# 
# 
# goPlot(CHOSEN,pfl)

goPlot<-function(CHOSEN,pfl)
{
    
    data=read.csv("data/Biz Rule1.csv")
    Vdata=read.csv("data/Shops_kel.csv")
    
    str(data)
    print(head(data))
    
  data=data[data$Profile==pfl,][,c("From","To")]
rules.all <-apriori(data,
                    parameter= list(supp=0.00000000000000025, conf=0.00000000000025,minlen=2,target = "rules"))
rules.all <- subset(rules.all, subset = rhs %pin% "To")

## subsetting rules
rules.1 <- subset(rules.all, subset = lhs %pin% CHOSEN)

# if(length(rules.1)>3)
# rules.1 <- rules.1[1:3,]

ruledf = data.frame(
  lhs = labels(lhs(rules.1))$elements,
  rhs = labels(rhs(rules.1))$elements, 
  rules.1@quality)

ruledf$lhs<-substr(as.character(ruledf$lhs),7,nchar(as.character(ruledf$lhs))-1)
ruledf$rhs<-substr(as.character(ruledf$rhs),5,nchar(as.character(ruledf$rhs))-1)

l2<-ruledf$rhs

if(length(l2)>=3)
  rules.2<-subset(rules.all, subset = lhs %pin% CHOSEN | lhs %pin% l2[1] | lhs %pin% l2[2] | lhs %pin% l2[3])

if(length(l2)==2)
  rules.2<-subset(rules.all, subset = lhs %pin% CHOSEN | lhs %pin% l2[1] | lhs %pin% l2[2] )

if(length(l2)==1)
  rules.2<-subset(rules.all, subset = lhs %pin% CHOSEN | lhs %pin% l2[1] )


ruledf = data.frame(
  lhs = labels(lhs(rules.2))$elements,
  rhs = labels(rhs(rules.2))$elements, 
  rules.2@quality)

ruledf$lhs<-substr(as.character(ruledf$lhs),7,nchar(as.character(ruledf$lhs))-1)
ruledf$rhs<-substr(as.character(ruledf$rhs),5,nchar(as.character(ruledf$rhs))-1)

g<-graph.data.frame(ruledf,directed=TRUE)

Vdata1=Vdata[Vdata$ShopName %in% V(g)$name,]
Vdata1=Vdata1[match(V(g)$name,Vdata1$ShopName),]
V(g)$color=as.character(Vdata1$Colour)
V(g)$pop=as.numeric(Vdata1$AvgTime)



#calculate edge distance
ruledf <- (merge(Vdata1[,c("ShopName","posX","posY")], ruledf, by.x = 'ShopName',by.y="lhs"))
colnames(ruledf)[1]<-"lhs"
colnames(ruledf)[2]<-"lhs.x"
colnames(ruledf)[3]<-"lhs.y"
ruledf <- (merge(Vdata1[,c("ShopName","posX","posY")], ruledf, by.x = 'ShopName',by.y="rhs"))
colnames(ruledf)[1]<-"rhs"
colnames(ruledf)[2]<-"rhs.x"
colnames(ruledf)[3]<-"rhs.y"
ruledf$distance=sqrt((ruledf$rhs.x-ruledf$lhs.x)^2+(ruledf$rhs.y-ruledf$lhs.y)^2)

#calculate edge duration
ruledf <- merge(Vdata1[,c("ShopName","AvgTime")], ruledf, by.x = 'ShopName',by.y="lhs")
colnames(ruledf)[1]<-"lhs"
colnames(ruledf)[2]<-"lhs.AvgTime"
ruledf <- merge(Vdata1[,c("ShopName","AvgTime")], ruledf, by.x = 'ShopName',by.y="rhs")
colnames(ruledf)[1]<-"rhs"
colnames(ruledf)[2]<-"rhs.AvgTime"
ruledf$duration=ruledf$lhs.AvgTime+ruledf$rhs.AvgTime

ruledf<-subset(ruledf,select=c( "lhs", "rhs" ,        "rhs.AvgTime" ,         "lhs.AvgTime", "rhs.x" ,"rhs.y"  ,"lhs.x" , "lhs.y"   ,"support", "confidence", "lift"  ,"distance" ,"duration" ))
g<-graph.data.frame(ruledf,directed=TRUE)
#ruledf<-ruledf[1:30,]

## Trying this block here too. OK
Vdata1=Vdata[Vdata$ShopName %in% V(g)$name,]
Vdata1=Vdata1[match(V(g)$name,Vdata1$ShopName),]
V(g)$color=as.character(Vdata1$Colour)
V(g)$pop=as.numeric(Vdata1$AvgTime)




for(i in 1:length(V(g)))
{
  if(V(g)$name[i]==CHOSEN)
    V(g)$pshape[i]="rectangle"
  if(V(g)$name[i]!=CHOSEN)
    V(g)$pshape[i]="circle"
}

for(i in 1:length(V(g)))
{
  if(V(g)$name[i]==CHOSEN)
    V(g)$pweight[i]=2
  if(V(g)$name[i]!=CHOSEN)
    V(g)$pweight[i]=1
}


par(mai=c(0,0,0,0)) 

# E(g)$weight<-seq(1,15.5,by=0.5)
# V(g)$pop<-seq(1,19,by=0.5)
set.seed(190)

plot(g, 
      edge.width=((5-1)*(E(g)$support-min(E(g)$support))/(max(E(g)$support)-min(E(g)$support)))+1,
      edge.arrow.size=0.45,
      edge.color="pink",
      edge.curved = F,
      edge.label=paste0(round(E(g)$distance,0),"m"),
     #edge.label=paste0(round(E(g)$support,4)*100,"%"),
      edge.label.color="black",
      #edge.label.dist = 0.2,
      vertex.label = V(g)$name, 
      vertex.label.color = "black",
      vertex.label.dist=0,
      vertex.label.cex=V(g)$pweight,
      vertex.label.font=20,
      vertex.frame.color=V(g)$color,
      vertex.color=V(g)$color,
      vertex.shape = V(g)$pshape,
      #vertex.size = V(g)$pop,
      vertex.size = ((25-8)*(V(g)$pop-min(V(g)$pop))/(max(V(g)$pop)-min(V(g)$pop)))+8 
     )

print(V(g)$name)

} #end of function
# tkplot(g, 
#             #edge.width=c(1,1,1,1),
#             edge.arrow.size=c(0.3),
#             edge.color="pink",
#             edge.curved = T,
#             vertex.label = V(g)$name, 
#             vertex.label.color = "dark blue",
#             vertex.label.dist=0,
#             vertex.label.cex=0.88,
#             #vertex.label.font=20,
#             vertex.frame.color='yellow',
#             vertex.label.color='black',
#             vertex.color=c("yellow","orange","green"),
#             vertex.shape = "rectangle",
#             vertex.size = 10,
#             vertex.size2 = 10 )

# E(g)$support*10
# ((E(g)$support-min(E(g)$support))/(max(E(g)$support)-min(E(g)$support)))/2
# 
# 
# g <- make_ring(10)

