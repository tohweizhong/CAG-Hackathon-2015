# setup
install.packages("packrat")
if (!require("devtools")) install.packages("devtools")
devtools::install_github("rstudio/shinyapps")

shinyapps::setAccountInfo(name='tohweizhong', token='DF9614818065B5DAAF22AE7D78C38089', secret='uSZ0rCRf6/gKj2ltBXrGENb4kn0y8Cw2bZaA87zk')

devtools::install_github('rstudio/rsconnect')

library(rsconnect)

deployApp()

# =====

library(rsconnect)
library(packrat)
library(shinyapps)

deployApp()
