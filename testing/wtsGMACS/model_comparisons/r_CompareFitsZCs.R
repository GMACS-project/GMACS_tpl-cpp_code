
compareFitsZCs<-function(dfr,
                         subtitle="",
                         xlab="size (mm CW)",
                         ylab="proportion",
                         useBars=FALSE,
                         usePins=FALSE,
                         usePinsAndPts=TRUE,
                         useLines=TRUE,
                         usePoints=FALSE,
                         plot1stObs=TRUE,
                         pinSize=0.2,
                         lineSize=0.5,
                         pointSize=0.4,
                         alpha=1){
  if (!("case" %in% names(dfr))) dfr$case = " ";
  sub_=subtitle;
  dfro = dfr |> dplyr::select(case,y=year,z=size,val=aggObs);
  dfrp = dfr |> dplyr::select(case,y=year,z=size,val=aggPrd);
  p  = ggplot(data=dfrp)
  if (plot1stObs) {
      if (useBars)       p = p + geom_bar(aes(x=z,y=val),         fill="black",  data=dfro,stat="identity",position='identity',alpha=0.5)
      if (usePins||
          usePinsAndPts) p = p + geom_linerange(aes(x=z,ymax=val),colour="black",data=dfro,stat="identity",position='identity',ymin=0.0,size=pinSize)
      if (usePinsAndPts) p = p + geom_point(aes(x=z,y=val),       colour="black",data=dfro,stat="identity",position='identity',size=0.5,alpha=1)
  } else {
      if (useBars)       p = p + geom_bar(aes(x=z,y=val,fill=case),           data=dfro,stat="identity",position='identity',alpha=0.5)
      if (usePins||
          usePinsAndPts) p = p + geom_linerange(aes(x=z,ymax=val,colour=case),data=dfro,stat="identity",position='identity',ymin=0.0,size=pinSize)
      if (usePinsAndPts) p = p + geom_point(aes(x=z,y=val,colour=case),       data=dfro,stat="identity",position='identity',size=0.5,alpha=1)
  }
  if (useLines)  p = p + geom_line(aes(x=z,y=val,colour=case),            data=dfrp,size=lineSize,alpha=alpha)
  if (usePoints) p = p + geom_point(aes(x=z,y=val,colour=case,shape=case),data=dfrp,size=pointSize)
#  p <- p + ylim(0,rng[2])
  p <- p + geom_hline(yintercept=0,colour='black',size=0.5)
  p <- p + labs(x=xlab,y=ylab)
  p <- p + facet_wrap(~y,ncol=ncol,dir='v')
  p <- p + labs(subtitle=sub_)
  p <- p + guides(fill=guide_legend('observed'),colour=guide_legend('predicted'),shape=guide_legend('predicted'))
  p = p + wtsPlots::getStdTheme();
  return(p)
}
print(compareFitsZCs(tmp))

