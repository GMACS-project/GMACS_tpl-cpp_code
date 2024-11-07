require(ggplot2)
require(wtsGMACS)
dirPrj = rstudioapi::getActiveProject();
fnr = file.path(dirPrj,"Models-GMACS/ModelRuns/TannerCrab24_07/best/gmacs.rep1");
iln=1;
rep =  wtsGMACS::readGmacsRep1(fnr,verbose=FALSE);

#--model configuration----
zBs = rep$size_midpoints;
nZBs = length(zBs);

#--estimated parameters----
dfrEstPars = rep$`Estimated parameters` |> 
               dplyr::mutate(
                 dplyr::across(!par_type,as.numeric)
               );
View(dfrEstPars);
##--check parameters at bounds----
dfrPsAtBs = dfrEstPars |> 
              dplyr::filter((!is.na(status)) & (status!=0));
View(dfrPsAtBs)
##--check other parameters?----
dfrOthrPs = dfrEstPars |> 
              dplyr::filter(est_par_cnt==132);#--

#--estimated population quantities----
##--recruitment----
dfrR_y = rep$R_y |> 
           dplyr::mutate(dplyr::across(dplyr::everything(),as.numeric));
ggplot(dfrR_y,aes(x=year,y=est)) + 
  geom_point() + geom_line() + 
  scale_y_continuous(limits=c(0,NA)) + 
  labs(y="Recruitment (milions)") + 
  wtsPlots::getStdTheme();
##--size at recruitment----
dfrR_z=rep$R_z |> 
           dplyr::mutate(dplyr::across(2:3,as.numeric));
ggplot(dfrR_z,aes(x=size,y=est,colour=sex)) + 
  geom_line() + 
  labs(y="proportion") +
  wtsPlots::getStdTheme();
##--population numbers-at-population category-and-size----
dfrN_YXMSZ = rep$N_YXMSZ |> 
               tidyr::pivot_longer(cols=!c(year,sex,maturity,shell_con),
                                   names_to="size",
                                   values_to="est") |> 
               dplyr::mutate(dplyr::across(c(year,size,est),
                                           as.numeric)
                            );
###--initial population abundance by category and size----
dfrN0 = dfrN_YXMSZ |> 
          dplyr::filter(year==1982);
ggplot(dfrN0,aes(x=size,y=est,colour=maturity)) + 
  geom_point() + 
  geom_line() + 
  scale_y_continuous(limits=c(0,NA)) + 
  labs(y="Population Abdundance (millions)") + 
  facet_wrap(~sex,ncol=1) + 
  wtsPlots::getStdTheme();
###--final population abundance by category and size----
dfrNF = dfrN_YXMSZ |> 
          dplyr::filter(year==2023);
ggplot(dfrNF,aes(x=size,y=est,colour=maturity)) + 
  geom_point() + 
  geom_line() + 
  scale_y_continuous(limits=c(0,NA)) + 
  labs(y="Population Abdundance (millions)") + 
  facet_wrap(~sex,ncol=1) + 
  wtsPlots::getStdTheme();
###--population abundance by sex, maturity----
dfrN_YXM = dfrN_YXMSZ |> 
             dplyr::group_by(year,sex,maturity) |> 
             dplyr::summarize(est=sum(est)) |> 
             dplyr::ungroup();
ggplot(dfrN_YXM,aes(x=year,y=est,colour=maturity)) + 
  geom_point() + geom_line() + 
  scale_y_continuous(limits=c(0,NA)) + 
  labs(y="Population Abdundance (millions)") + 
  facet_wrap(~sex,ncol=1) + 
  wtsPlots::getStdTheme();

##--population biomass by population category and size----
dfrB_YXMSZ = rep$B_YXMSZ |> 
               tidyr::pivot_longer(cols=!c(year,sex,maturity,shell_con),
                                   names_to="size",
                                   values_to="est") |> 
               dplyr::mutate(dplyr::across(c(year,size,est),
                                           as.numeric)
                            );
###--initial population biomass by category and size----
dfrB0 = dfrB_YXMSZ |> 
          dplyr::filter(year==1982);
ggplot(dfrB0,aes(x=size,y=est,colour=maturity)) + 
  geom_point() + 
  geom_line() + 
  scale_y_continuous(limits=c(0,NA)) + 
  labs(y="Population Biomass (1,000's t)") + 
  facet_wrap(~sex,ncol=1) + 
  wtsPlots::getStdTheme();
###--final population biomass by category and size----
dfrBF = dfrB_YXMSZ |> 
          dplyr::filter(year==2023);
ggplot(dfrBF,aes(x=size,y=est,colour=maturity)) + 
  geom_point() + 
  geom_line() + 
  scale_y_continuous(limits=c(0,NA)) + 
  labs(y="Population Biomass (1,000's t)") + 
  facet_wrap(~sex,ncol=1) + 
  wtsPlots::getStdTheme();
###--population biomass by sex, maturity----
dfrB_YXM = dfrB_YXMSZ |> 
             dplyr::group_by(year,sex,maturity) |> 
             dplyr::summarize(est=sum(est)) |> 
             dplyr::ungroup();
ggplot(dfrB_YXM,aes(x=year,y=est,colour=maturity)) + 
  geom_point() + geom_line() +
  scale_y_continuous(limits=c(0,NA)) + 
  labs(y="Population Biomass (1,000's t)") + 
  facet_wrap(~sex,ncol=1) + 
  wtsPlots::getStdTheme();

#--selectivity----
dfrSel = rep$selfcns |> 
           tidyr::pivot_longer(cols=4+(1:nZBs),names_to="size",values_to="est") |>
           dplyr::mutate(dplyr::across(c(2,5,6),as.numeric)); 
##--surveys----
fleets = c("NMFSAM","NMFSIF","NMFSMF");
tmp =  dfrSel |> dplyr::filter(fleet %in% fleets,type=="capture",year==1982)
ggplot(dfrSel |> dplyr::filter(fleet %in% fleets,type=="capture",year==1982),
       aes(x=size,y=est,colour=fleet)) + 
  geom_line() + 
  facet_wrap(~sex,ncol=1) + 
  scale_y_continuous(limits=c(0,NA)) + 
  wtsPlots::getStdTheme();
##--retained selectivity, directed fishery----
fleets = c("TCF");
tmp =  dfrSel |> dplyr::filter(fleet %in% fleets,type=="retained",year==1982)
ggplot(dfrSel |> dplyr::filter(fleet %in% fleets,type=="retained",year==1982),
       aes(x=size,y=est,colour=sex)) + 
  geom_point() + geom_line() + 
  scale_y_continuous(limits=c(0,NA)) + 
  facet_wrap(~fleet,ncol=1) + 
  labs(y="Retention") + 
  wtsPlots::getStdTheme()
##--capture selectivity, crab fisheries----
fleets = c("TCF","SCF","RKF");
tmp =  dfrSel |> dplyr::filter(fleet %in% fleets,type=="capture",year==1982)
ggplot(dfrSel |> dplyr::filter(fleet %in% fleets,type=="capture",year==1982),
       aes(x=size,y=est,colour=sex)) + 
  geom_point() + geom_line() + 
  scale_y_continuous(limits=c(0,NA)) + 
  facet_wrap(~fleet,ncol=1) + 
  labs(y="Capture Selectivity") + 
  wtsPlots::getStdTheme()
##--capture selectivity, groundfish fisheries----
fleets = c("GFT","GFF","GFA");
tmp =  dfrSel |> dplyr::filter(fleet %in% fleets,type=="capture",year %in% c(1982,2000))
ggplot(dfrSel |> dplyr::filter(fleet %in% fleets,type=="capture",year %in% c(1982,2000)),
       aes(x=size,y=est,colour=sex)) + 
  geom_point() + geom_line() + 
  facet_wrap(~fleet,ncol=1) + 
  labs(y="Capture Selectivity") + 
  wtsPlots::getStdTheme();

#--growth----
##--mean growth----
dfrMnGr = rep$`Mean growth` |> 
            dplyr::mutate(dplyr::across(3:5,as.numeric));
ggplot(dfrMnGr,aes(x=premolt_size,y=mean_postmolt_size,colour=block)) + 
  geom_line() + 
  geom_abline(slope=1,linetype=3) + 
  scale_y_continuous() + 
  labs(x="pre-molt size (mm CW)",y="mean post-molt size (mm CW}") + 
  facet_wrap(~sex,ncol=1) + 
  wtsPlots::getStdTheme()
##--growth matrices----
dfrPrGr = rep$growth_matrix |> 
            tidyr::pivot_longer(cols=!c(sex,block,premolt_size),
                                names_to="postmolt_size",values_to="est") |>
           dplyr::mutate(dplyr::across(3:5,as.numeric));
ggplot(dfrPrGr |> dplyr::filter(est>0.0001),
       aes(x=premolt_size,y=postmolt_size,size=est,fill=est)) + 
  geom_point(alpha=0.5,shape=21) + 
  scale_size_area() + 
  geom_line(aes(x=premolt_size,y=mean_postmolt_size),data=dfrMnGr,inherit.aes=FALSE) + 
  geom_abline(slope=1,linetype=3) + 
  scale_fill_viridis_c(option="magma") + 
  facet_wrap(~sex,ncol=1) + 
  labs(x="pre-molt size (mm CW)",y="postmolt size (mm CW)") + 
  wtsPlots::getStdTheme();
##--size transition matrices----
dfrPrTr = rep$size_matrix |> 
            tidyr::pivot_longer(cols=!c(sex,block,premolt_size),
                                names_to="postmolt_size",values_to="est") |>
           dplyr::mutate(dplyr::across(3:5,as.numeric));
ggplot(dfrPrTr |> dplyr::filter(est>0.0001),
       aes(x=premolt_size,y=postmolt_size,size=est,fill=est)) + 
  geom_point(alpha=0.5,shape=21) + 
  scale_size_area() + 
  geom_line(aes(x=premolt_size,y=mean_postmolt_size),data=dfrMnGr,inherit.aes=FALSE) + 
  geom_abline(slope=1,linetype=3) + 
  scale_fill_viridis_c(option="magma") + 
  facet_wrap(~sex,ncol=1) + 
  labs(x="pre-molt size (mm CW)",y="postmolt size (mm CW)") + 
  wtsPlots::getStdTheme();

#----maturity----
dfrPrM2M = rep$prMature |> 
                tidyr::pivot_longer(cols=!c(year,sex),
                                    names_to="size",values_to="est") |> 
                dplyr::mutate(dplyr::across(c(year,size,est),as.numeric));
ggplot(dfrPrM2M |> dplyr::filter(year==1982),
       aes(x=size,y=est,colour=sex)) + 
  geom_point() + geom_line() + 
  scale_y_continuous(limits=c(0,NA))+ 
  labs(y="Estimated Pr(terminal molt)") + 
#  facet_wrap(~sex,ncol=1) + 
  wtsPlots::getStdTheme();

#--natural mortality----
dfrMbyYXMZ = rep$`Natural_mortality-by-class` |> 
              tidyr::pivot_longer(cols=!c(year,sex,maturity),
                                  names_to="size",values_to="est") |> 
              dplyr::mutate(dplyr::across(c(year,size,est),as.numeric));
ggplot(dfrMbyYXMZ |> dplyr::filter(year==1982),
       aes(x=size,y=est,colour=maturity)) + 
  geom_point() + 
  scale_y_continuous(limits=c(0,NA))+ 
  labs(y="Estimated M") + 
  facet_wrap(~sex,ncol=1) + 
  wtsPlots::getStdTheme();

#--fishing mortality-----
##--fully-selected fishing mortality rates----
dfrFMbyXFY = rep$`Fully-selected_FM_by_season_sex_and_fishery` |> 
              tidyr::pivot_longer(cols=!c("sex","fleet","year"),
                                  names_to="season",
                                  values_to="est") |> 
              dplyr::mutate(
                dplyr::across(c(year,est),as.numeric)
              ) |> 
              dplyr::group_by(fleet,season) |> 
              dplyr::filter(sum(est)>0) |> 
              dplyr::ungroup();
crbFshs = c("TCF","SCF","RKF")
ggplot(dfrFMbyXFY |> dplyr::filter(fleet=="TCF"),
       aes(x=year,y=est,colour=fleet)) + 
  geom_point() + geom_line() + 
  facet_wrap(~sex,ncol=1,scales="free_y") + 
  labs(y="Fully-selected Fishing Mortality") + 
  wtsPlots::getStdTheme();
ggplot(dfrFMbyXFY |> dplyr::filter(!(fleet %in% c("TCF","RKF"))),
       aes(x=year,y=est,colour=fleet)) + 
  geom_point() + geom_line() + 
  facet_wrap(~sex,ncol=1,scales="free_y") + 
  labs(y="Fully-selected Fishing Mortality") + 
  wtsPlots::getStdTheme();
ggplot(dfrFMbyXFY |> dplyr::filter(fleet=="RKF"),
       aes(x=year,y=est,colour=fleet)) + 
  geom_point() + geom_line() + 
  facet_wrap(~sex,ncol=1,scales="free_y") + 
  labs(y="Fully-selected Fishing Mortality") + 
  wtsPlots::getStdTheme();
dfrFMbyXFY |> dplyr::filter(fleet!="TCF",year==2020);

##--fishing mortality parameters----
dfrFPs = rep$logFM_parameters |> 
           dplyr::mutate(
             dplyr::across(c(index,est),as.numeric)
           );
surveys = c("NMFSAM","NMFSIF","NMFSMF");
ggplot() + 
  geom_point(data=dfrFPs |> dplyr::filter(!is.na(index),!(fleet %in% surveys)),
             mapping=aes(x=index,y=est,colour=fleet)) +
  geom_hline(yintercept=0,linetype=1,color="black") +
  geom_hline(data=dfrFPs |> dplyr::filter(is.na(index),!(fleet %in% surveys)),
             mapping=aes(yintercept=est,colour=fleet,linetype=sex)) +
  facet_wrap(~fleet,dir="v")

##--total mortality----
dfrTM = rep$`TM-by-size-class_(continuous)`



#--fits to data----
##--catch data----
dfrCatFit = rep$Catch_fit_summary |> 
              dplyr::mutate(
                dplyr::across(c(year,obs,cv,effort,HM,prd,rsd),
                              as.numeric)
              );
crbFshs = c("TCF","SCF","RKF")
ggplot(dfrCatFit |> dplyr::filter(fleet %in% crbFshs,type=="retained"),
       aes(x=year)) + 
  geom_point(aes(y=obs)) + 
  # geom_ribbon(aes(ymin=lba,ymax=uba),fill="blue",alpha=0.3) + 
  # geom_ribbon(aes(ymin=lbo,ymax=ubo),fill="green",alpha=0.3) + 
  geom_line(aes(y=prd)) + 
  scale_y_continuous(limits=c(0,NA)) + 
  labs(y="Retained Catch (1,000's t)") + 
  facet_wrap(~fleet,ncol=1,scales="free_y") + 
  wtsPlots::getStdTheme();
ggplot(dfrCatFit |> dplyr::filter(fleet %in% crbFshs),
       aes(x=year,colour=type)) + 
  geom_point(aes(y=obs)) + 
  # geom_ribbon(aes(ymin=lba,ymax=uba),fill="blue",alpha=0.3) + 
  # geom_ribbon(aes(ymin=lbo,ymax=ubo),fill="green",alpha=0.3) + 
  geom_line(aes(y=prd)) + 
  scale_y_continuous(limits=c(0,NA)) + 
  labs(y="Catch (1,000's t)") + 
  facet_wrap(~fleet,ncol=1,scales="free_y") + 
  wtsPlots::getStdTheme();
ggplot(dfrCatFit |> dplyr::filter(!(fleet %in% crbFshs)),
       aes(x=year,colour=type)) + 
  geom_point(aes(y=obs)) + 
  # geom_ribbon(aes(ymin=lba,ymax=uba),fill="blue",alpha=0.3) + 
  # geom_ribbon(aes(ymin=lbo,ymax=ubo),fill="green",alpha=0.3) + 
  geom_line(aes(y=prd)) + 
  scale_y_continuous(limits=c(0,NA)) + 
  labs(y="Catch (1,000's t)") + 
  facet_wrap(~fleet,ncol=1,scales="free_y") + 
  wtsPlots::getStdTheme();

##--index data----
dfrIndxFit = rep$Index_fit_summary |> 
               dplyr::mutate(
                 dplyr::across(c(year,obs,base_CV,actual_CV,q,prd,prsn_res),
                               as.numeric)
               ) |> 
               dplyr::mutate(lbo=qlnorm(0.10,log(obs),sqrt(log(1+base_CV^2))),
                             ubo=qlnorm(0.10,log(obs),sqrt(log(1+base_CV^2)),lower.tail=FALSE),
                             lba=qlnorm(0.10,log(obs),sqrt(log(1+actual_CV^2))),
                             uba=qlnorm(0.10,log(obs),sqrt(log(1+actual_CV^2)),lower.tail=FALSE)
                            );
ggplot(dfrIndxFit,aes(x=year)) + 
  geom_point(aes(y=obs)) + 
  geom_ribbon(aes(ymin=lba,ymax=uba),fill="blue",alpha=0.3) + 
  geom_ribbon(aes(ymin=lbo,ymax=ubo),fill="green",alpha=0.3) + 
  geom_line(aes(y=prd)) + 
  facet_wrap(~fleet,ncol=1,scales="free_y") + 
  labs(y="NMFS Survey Biomass (1,000's t)") + 
  wtsPlots::getStdTheme();

##--size comps----
dfrZCs = rep$Size_fit_summary |> 
           dplyr::mutate(
             dplyr::across(c(year,size,inpSS,inpN,aggObs,aggPrd,aggRes),
                           as.numeric)
           );
dfrUIDs = dfrZCs |> dplyr::distinct(aggID,origID);
for (ir in 1:nrow(dfrUIDs)){
  #--test: ir = 1;
  aID = dfrUIDs$aggID[ir];
  oID  = dfrUIDs$origID[ir]
  tmp = dfrZCs |> dplyr::filter(aggID==aID,origID==oID);
  dfrUC = tmp |> dplyr::distinct(fleet,comp_type,sex,maturity,shell_cond);
  str = paste(dfrUC$fleet,dfrUC$comp_type);
  if (dfrUC$sex       !="undetermined") str = paste(str,dfrUC$sex);
  if (dfrUC$maturity  !="undetermined") str = paste(str,dfrUC$maturity);
  if (dfrUC$shell_cond!="undetermined") str = paste(str,dfrUC$shell_cond);
  p = compareFitsZCs(tmp,subtitle=str);
  print(p+theme(legend.position="none"));
}


