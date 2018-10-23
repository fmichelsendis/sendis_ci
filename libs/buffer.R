

myplot <- function(df, INST){

  library(ggplot2)
  
  df1<-df%>%
    filter(INST==INST, FISS!="SPEC")%>%
    mutate(TOTERR=sqrt(CALCERR^2 + EXPERR^2))
  
  g<-ggplot() +
    geom_ribbon(data=df1, aes(x= EALF, ymin = 1-EXPERR, ymax= 1+EXPERR), alpha=0.2) +
    geom_point(data=df1, aes(x=EALF, y=COVERE, colour=LIBVER, shape=FISS), alpha=0.8) +
    labs(x = "Average Neutron Energy", y = "C/E")+ 
    ylim(0.95, 1.03) +
    scale_x_log10()+ annotation_logticks()+
    theme_bw()+ theme(legend.title = element_blank()) 
  return(g)
 }

  

df1<-filter(df, FISS!="SPEC")%>%
  filter (VER!="3.3T1")%>%
  filter (VER!="3.0")%>%
  filter (VER!="3.1")%>%
  filter (VER!="3.1.2")%>%
  filter (VER!="3.2")%>%
  filter (VER!="3.3T2")%>%
  filter (VER!="3.3T3")%>%
  filter (VER!="3.3T2+")%>%
  arrange(FULLID)%>%
  mutate(TOTERR=sqrt(CALCERR^2 + EXPERR^2))


x_layout<-list(
  title='Benchmark Cases',
  type = "lin",
  zeroline = TRUE,
  showline = FALSE,
  showgrid = FALSE,
  showticklabels = FALSE,
  titlefont= list( family='Helvetica',
                   size='14',
                   color='gray')
)

y_layout<-list(
  range= c(0.95, 1.03),
  title='C/E',
  showticklabels = TRUE,
  ticks = "outside",
  tick0 = 0,
  titlefont= list( family='Helvetica',
                   size='14',
                   color='gray'))
  
  
plot_ly(df%>%arrange(FULLID), x=~FULLID,  y = ~COVERE, type='scatter', mode='markers+lines', 
        color= ~LIBVER)%>%layout(xaxis=x_layout, yaxis=y_layout)
                   
        
p <- ggplot(mp, aes(year, wow))+
  geom_point()+
  geom_line(data=predframe)+
  geom_ribbon(data=predframe,aes(ymin=lwr,ymax=upr),alpha=0.3)

library(ggplot2)
# Nuage de points simples
g<-ggplot() +
  geom_ribbon(data=df1, aes(x= EALF, ymin = 1-EXPERR, ymax= 1+EXPERR), alpha=0.2) +
  geom_point(data=df1, aes(x=EALF, y=COVERE, colour=LIBVER, shape=FISS), alpha=0.8) +
  labs(x = "Average Neutron Energy", y = "C/E")+ 
  ylim(0.95, 1.03) +
  scale_x_log10()+ annotation_logticks()+
  theme_bw()+ theme(legend.title = element_blank()) 
  
p<-ggplotly(g)
                    