


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

################

plotCE_EALF <- function(df, output="png"){
  #select and prep data
  df1<-df%>%
    filter(INST=="NEA", FISS!="SPEC", FISS!="U233", FISS!= "MIX")%>%
    filter(LIBVER!="JEFF-3.0", LIBVER!="JEFF-3.1", LIBVER!="JEFF-3.2", LIBVER!="JEFF-3.1.2")%>%
    mutate(TOTERR=sqrt(CALCERR^2 + EXPERR^2))
  #prep plot
  g<-ggplot() +
    geom_ribbon(data=df1, aes(x= EALF, ymin = 1-EXPERR, ymax= 1+EXPERR), alpha=0.2) +
    geom_point(data=df1, aes(x=EALF, y=COVERE, colour=LIBVER, shape=FISS), alpha=0.8) +
    labs(x = "Average energy of neutron causing fission (eV)", y = "C/E")+
    # ylim(0.95, 1.03) +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b") +
    theme_bw()+ theme(legend.title = element_blank())
  
  #print the plot to a pdf and png files : 
  if(output=="pdf"){
    pdf("myplot.pdf", width = 7, height = 4)
    print(g)
  } 
  if(output=="png"){ 
    png("myplot.png", width = 15, height = 8, units = "cm", res=350)
    print(g)
  }
  if(output=="view"){ 
    g
  } 
  dev.off()
  return()
}
