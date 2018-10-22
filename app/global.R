#############################################
#                                           #    
#               APP SENDIS                  #
#  Author: F.Michel-Sendis                  #
#                                           #  
#############################################
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

source('../libs/myfunctions.R')

#############################################
#                                           #
#  DATA INPUT, PREP DATA                    #
#                                           #  
#############################################

# source data 
  df_calcs<-fread('../data/mydata.csv') 
  df_calcs$V1<-NULL
  df_calcs[df_calcs==""]<-NA 
#merging with expdata
  expdata<-fread('../data/all_expdata.csv')
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
 



