
myplot <- function(df, inst="NEA"){
#select and prep data
  df1<-df%>%
    filter(INST==inst, FISS!="SPEC")%>%
    mutate(TOTERR=sqrt(CALCERR^2 + EXPERR^2))
#prep plot
  g<-ggplot() +
    geom_ribbon(data=df1, aes(x= EALF, ymin = 1-EXPERR, ymax= 1+EXPERR), alpha=0.2) +
    geom_point(data=df1, aes(x=EALF, y=COVERE, colour=LIBVER, shape=FISS), alpha=0.8) +
    labs(x = "Average neutron energy causing fission (eV)", y = "C/E")+
    ylim(0.95, 1.03) +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "tb") +
    theme_bw()+ theme(legend.title = element_blank())
#print the plot to a pdf file
    pdf("myplot.pdf")
    print(g)
    dev.off()
return()
 }
