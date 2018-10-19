
myplot <- function(df, output="png"){
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
