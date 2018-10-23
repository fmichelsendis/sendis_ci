#############################################
#                                           #
#   SERVER SENDIS                           #
#                                           #  
#############################################

server <- function(input, output, session){
  addClass(selector = "body", class = "sidebar-collapse")

##################

output$plot_cumul<-renderPlotly({ 
    
    # y_layout<-list(
    #   title='Chi2 build-up',
    #   showticklabels = TRUE,
    #   ticks = "outside",
    #   tick0 = 0,
    #   titlefont= list( family='Helvetica',
    #                    size='14',
    #                    color='gray')
    #   )
    # x_layout<-list(
    #   title='Benchmark Cases (arbitrary progression)',
    #   zeroline = TRUE,
    #   showline = FALSE,
    #   showgrid = FALSE,
    #   showticklabels = FALSE,
    #   titlefont= list( family='Helvetica',
    #                    size='14',
    #                    color='gray')
    #   )
    # m <- list(l = 100,r = 0,b = 20,t = 50,pad = 0)
    # 
    
# selecting data 
    if("All" %in% input$CASETYPE3) df<-filter(df, INST==input$INST3, LIBVER %in% input$LIB3)
    else df<-filter(df, INST==input$INST3, LIBVER %in% input$LIB3, CASETYPE%in% input$CASETYPE3)
    df<-filter(df, df$RESIDUAL<= input$MAXRES)
    
    plotCumul(df)
    
# #create a vector for number of cases calculated for each LIBVER 
#     d<-count(df, INST, LIBVER)  # d has 3 columns : INST, LIBVER and n
#     d$NCASES<-d$n  #change name of computed n to NCASES
#     d$n<-NULL
#     
# #merge to put NCASES in df2, then mutate:
#     df2<-df%>%
#       merge(d)%>%
#       select(INST, LIBVER, CASETYPE, CASE, FULLID, RESIDUAL, NCASES)%>%
#       arrange(INST, LIBVER, CASETYPE, CASE, FULLID)%>%
#       group_by(INST, LIBVER)%>%
#       mutate(
#         CUMUL=cumsum(RESIDUAL^2/NCASES), 
#         CHISQ= sum (RESIDUAL^2/NCASES)) 
# 
# #plot 
#     plot_ly(df2, x=~FULLID, y=~CUMUL, color=~LIBVER, type='scatter', mode='markers+lines')%>%
#       layout(margin=m, xaxis=x_layout, yaxis=y_layout, showlegend=TRUE)%>%
#       config(displayModeBar = 'hover',showLink=FALSE,senddata=FALSE,editable=FALSE, 
#                   displaylogo=FALSE, collaborate=FALSE, cloud=FALSE, 
#                   modeBarButtonsToRemove=c('select2d', 'lasso2d','hoverClosestCartesian','hoverCompareCartesian'))
#     
    })
    
#####################
  
  output$libs<-renderText({
    
    df1<-filter(df, INST==input$INST4)
    df1<- df1[order(df1$LIBVER),]
    text<-paste(unique(df1$LIBVER), " ; ")
    text
  })
  
  #########################################################################
  
  output$plot_histo<-renderPlotly({ 
    df1<-filter(df, INST==input$INST4, LIBVER==input$LIBVER4)
    # validate(
    #    need(dim(df1)[1]>0,"No entries found for this combination of libraries and institution")
    #  )
    m <- list(
      l = 140,
      r = 20,
      b = 00,
      t = 100,
      pad = 3
    )
    titlefont<-list( family='Helvetica',
                     size='12',
                     color='gray')
   

    if(dim(df1)[1]>0){
      N<-dim(df1)[1]
      title<-paste(N,"different cases in", input$INST4,"suite", "<br> Distribution per case family", sep=" ")
      
    p<-plot_ly(df1, y=~CASETYPE) %>%
      layout(margin = m, yaxis=list(title=''),title=title, font=titlefont)%>% 
      config(displayModeBar = FALSE)
    p 
    }
    else plotly_empty()
  })
  
  ###################################################
  
  output$table<-renderDataTable({ 
    
    df1<-filter(df, INST==input$INST4, LIBVER==input$LIBVER4)
    df2<-subset(df1, select=c('FULLID', 'MODEL', 'EXPVAL', 'EXPERR', 'CALCVAL', 'CALCERR', 'COVERE'))
    validate(
      need(dim(df2)[1]>0,"No entries found for this combination of library and institution")
    )
    df2<-arrange(df2, FULLID)
    
    if(dim(df2)[1]>0) datatable(df2, options=list(columnDefs = list(list(visible=FALSE, targets=c(0))))) 
    df2
  })
 

session$onSessionEnded(stopApp)
 
} #end of server function

 