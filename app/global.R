#############################################
#                                           #    
#               APP SENDIS                  #
#  Author: F.Michel-Sendis                  #
#                                           #  
#############################################

if (system.file(package="DT") == "")          install.packages("DT")
if (system.file(package="data.table") == "")  install.packages("data.table")
if (system.file(package="dplyr") == "")       install.packages("dplyr")
if (system.file(package="shiny") == "")       install.packages("shiny")
if (system.file(package="stringr") == "")     install.packages("stringr")
if (system.file(package="plotly") == "")      install.packages("plotly")
if (system.file(package="ggplot2") == "")     install.packages("ggplot2")
if (system.file(package="shinydashboard") == "") install.packages("shinydashboard")
if (system.file(package="shinythemes") == "") install.packages("shinythemes")
if (system.file(package="shinyjs") == "")     install.packages("shinyjs")
if (system.file(package="splitstackshape") == "") install.packages("splitstackshape")
if (system.file(package="testthat") == "")    install.packages("testthat")
if (system.file(package="devtools") == "")    install.packages("devtools")  



suppressPackageStartupMessages({

library(DT)
library(data.table)
library(dplyr)
library(shiny) 
library(stringr)
library(plotly)
library(ggplot2)
library(shinydashboard)
library(shinythemes)
library(shinyjs)  
library(splitstackshape)
  
})
  
# library(testthat)
# library(devtools)
# 
# if (system.file(package="shinytest") == "")   install.packages("shinytest")
# library(shinytest)
# shinytest::installDependencies()
# library(shinytest)

source('libs/myfunctions.R')

#############################################
#                                           #
#  DATA INPUT, PREP DATA                    #
#                                           #  
#############################################

# source data 
  df_calcs<-fread('data/mydata.csv') 
  df_calcs$V1<-NULL
  df_calcs[df_calcs==""]<-NA 
#merging with expdata
  expdata<-fread('data/all_expdata.csv')
  expdata$V1<-NULL
  df<-merge(expdata, df_calcs, all=FALSE)
#RE-CREATE missing columns
  df<- df %>% mutate(
    COVERE=CALCVAL/EXPVAL,
    RESIDUAL = (CALCVAL-EXPVAL)/sqrt(EXPERR^2 + CALCERR^2))
  df$LIBVERA<-df$LIBVER
  df<-cSplit(as.data.table(df), "LIBVERA", "-")
  setnames(df, old=c("LIBVERA_1","LIBVERA_2"), new=c("LIB", "VER"))
#tidy up
  df<-df%>%arrange(INST, LIBVER, CASETYPE)
 



