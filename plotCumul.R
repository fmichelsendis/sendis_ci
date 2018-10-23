#' plot cumulative Chi-square function
#' 
#' @param df dataframe to consider (no default)
#' @export
#' @examples 
#' plotCumul()


plotCumul<- function(df){
  
  y_layout<-list(
    title='Chi2 build-up',
    showticklabels = TRUE,
    ticks = "outside",
    tick0 = 0,
    titlefont= list( family='Helvetica',
                     size='14',
                     color='gray')
  )
  x_layout<-list(
    title='Benchmark Cases (arbitrary progression)',
    zeroline = TRUE,
    showline = FALSE,
    showgrid = FALSE,
    showticklabels = FALSE,
    titlefont= list( family='Helvetica',
                     size='14',
                     color='gray')
  )
  m <- list(l = 100,r = 0,b = 20,t = 50,pad = 0)
  
  #create a vector for number of cases calculated for each LIBVER 
  d<-count(df, INST, LIBVER)  # d has 3 columns : INST, LIBVER and n
  d$NCASES<-d$n  #change name of computed n to NCASES
  d$n<-NULL
  
  #merge to put NCASES in df2, then mutate:
  df2<-df%>%
    merge(d)%>%
    select(INST, LIBVER, CASETYPE, CASE, FULLID, RESIDUAL, NCASES)%>%
    arrange(INST, LIBVER, CASETYPE, CASE, FULLID)%>%
    group_by(INST, LIBVER)%>%
    mutate(
      CUMUL=cumsum(RESIDUAL^2/NCASES), 
      CHISQ= sum (RESIDUAL^2/NCASES)) 
  
  #plot 
  p<-plot_ly(df2, x=~FULLID, y=~CUMUL, color=~LIBVER, type='scatter', mode='markers+lines')%>%
    layout(margin=m, xaxis=x_layout, yaxis=y_layout, showlegend=TRUE)%>%
    config(displayModeBar = 'hover',showLink=FALSE,senddata=FALSE,editable=FALSE, 
           displaylogo=FALSE, collaborate=FALSE, cloud=FALSE, 
           modeBarButtonsToRemove=c('select2d', 'lasso2d','hoverClosestCartesian','hoverCompareCartesian'))
  p
}