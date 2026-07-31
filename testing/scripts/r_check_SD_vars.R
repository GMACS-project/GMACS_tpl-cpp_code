#--check sdreport values and standard error estimates

#--function to check values
#' @param dn - full path to run folder
check_sd_vars<-function(dn){
  #--get base folder name
  dirBase = basename(dirname(dn));
  
  #--read gmacs.std file
  dfrStdF = wtsGMACS::readStdFile(file.path(dn,"gmacs.std"));
  
  #--read gmacs.rep1 file
  assign("iln",1,envir=parent.frame(1));
  lstRep = wtsGMACS::readGmacsRep1(file.path(dn,"gmacs.rep1"));
  assign("iln",1,envir=parent.frame(1));
  
  nbad = 0;        #--count of disagreements
  lstChk = list(); #--list for check dataframes
  
  #--check parameters----
  ##--get parameters listed in gmacs.rep1 file
  dfrRep_Pars = lstRep[["Estimated_parameters"]] |> 
                 dplyr::filter(phz>0) |> 
                 dplyr::select(par_count,par_type,rep_est=est,rep_std=se) |> 
                 dplyr::mutate(rep_est=signif(as.numeric(rep_est),digits=5),
                               rep_std=signif(as.numeric(rep_std),5));
  npar = nrow(dfrRep_Pars);
  
  ##--get parameters listed in gmacs.std file
  dfrStd_Pars = dfrStdF[1:npar,];
  uStdParNames = unique(dfrStd_Pars$name);
  
  ##--check whether differences exist
  chk1 = which(abs(dfrStd_Pars$est - dfrRep_Pars$rep_est)>0.0001);#--estimates
  chk2 = which(abs(dfrStd_Pars$std - dfrRep_Pars$rep_std)>0.0001);#--std errors
  chk = sort(unique(c(chk1,chk2)));
  dfrChkP = dplyr::bind_cols(dfrStd_Pars[chk,],dfrRep_Pars[chk,]);#--will contain any mismatches
  if (nrow(dfrChkP)>0) {
    dfrChkP = dfrChkP |> dplyr::mutate(diff_est=est-rep_est,diff_std=std-rep_std);
    warning(paste0("differences found in parameter est or std values for ",dirBase));
  }
  nbad = nbad + nrow(dfrChkP);
  lstChk[["parameters"]] = dfrChkP;
  
  #--check some derived quantities-----
  ##--from rep1 file
  dfrRep_Drvd = lstRep[["Summary"]] |> 
                 dplyr::select(year,
                               rep_log_rec_est=`log(rec_male)`,rep_log_rec_std=`SD(log(rec_male))`,
                               rep_log_ssb_est=`log(SSB)`,     rep_log_ssb_std=`SD(log(SSB))`,
                               rep_log_db0_est=`log(DynB0)`,   rep_log_db0_std=`SD(log(DynB0))`,
                               rep_log_lgf_est=`log(f)`,       rep_log_lgf_std=`SD(log(f))`) |> 
                 dplyr::mutate(dplyr::across(2:9,as.numeric)) |> 
                 dplyr::mutate(dplyr::across(2:9,\(x)(signif(x,5))));
  ##--from std file
  dfrStd_Drvd = dfrStdF |> dplyr::filter(!(name %in% uStdParNames));
  uDNs = unique(dfrStd_Drvd$name);
  
  ##--compare log_recruits----
  nrw = length(dfrRep_Drvd$rep_log_rec_est);#--compare only for males
  chk1 = which(abs((dfrStd_Drvd |> dplyr::filter(name=="sd_log_recruits"))$est[1:nrw] - dfrRep_Drvd$rep_log_rec_est) >0.0001);
  chk2 = which(abs((dfrStd_Drvd |> dplyr::filter(name=="sd_log_recruits"))$std[1:nrw] - dfrRep_Drvd$rep_log_rec_std) >0.0001);
  chk = sort(unique(c(chk1,chk2)));
  dfrChk2 = dplyr::bind_cols((dfrStd_Drvd |> dplyr::filter(name=="sd_log_recruits"))[chk,],
                              dfrRep_Drvd[chk,c("rep_log_rec_est","rep_log_rec_std")]);#--will contain any mismatches
  if (nrow(dfrChk2)>0) {
    dfrChk2 = dfrChk2 |> dplyr::mutate(diff_est=est-rep_log_rec_est,diff_std=std-rep_log_rec_std);
    warning(paste0("differences found in sd_log_recruit est or std values for ",dirBase));
  }
  nbad = nbad + nrow(dfrChk2);
  lstChk[["sd_log_recruits"]] = dfrChk2;
  
  ##--compare log_ssb----
  nrw = length(dfrRep_Drvd$rep_log_ssb_est);#--compare only for males
  chk1 = which(abs((dfrStd_Drvd |> dplyr::filter(name=="sd_log_ssb"))$est[1:nrw] - dfrRep_Drvd$rep_log_ssb_est) >0.0001);
  chk2 = which(abs((dfrStd_Drvd |> dplyr::filter(name=="sd_log_ssb"))$std[1:nrw] - dfrRep_Drvd$rep_log_ssb_std) >0.0001);
  chk = sort(unique(c(chk1,chk2)));
  dfrChk2 = dplyr::bind_cols((dfrStd_Drvd |> dplyr::filter(name=="sd_log_ssb"))[chk,],
                              dfrRep_Drvd[chk,c("rep_log_ssb_est","rep_log_ssb_std")]);#--will contain any mismatches
  if (nrow(dfrChk2)>0) {
    dfrChk2 = dfrChk2 |> dplyr::mutate(diff_est=est-rep_log_ssb_est,diff_std=std-rep_log_ssb_std);
    warning(paste0("differences found in sd_log_ssb est or std values for ",dirBase));
  }
  nbad = nbad + nrow(dfrChk2);
  lstChk[["sd_log_ssb"]] = dfrChk2;
  
  passed = ifelse(nbad==0,"PASSED","FAILED");
  lstOut = list(dir=dirBase,passed=passed,lstChk=lstChk);
  wtsUtilities::saveObj(lstOut,file.path(dirname(dn),"rda_checks_for_different_sdreport_values.RData"));
  return(passed);
}

#--run function----
dirThs = getwd();
# paste(list.dirs(file.path(dirThs,"..","runs_20260707_FMEY"),full.names=FALSE,recursive=FALSE),collapse=", ")
# paste(list.dirs(file.path(dirThs,"..","runs_20260729"),full.names=FALSE,recursive=FALSE),collapse=", ")
dirRuns = c(file.path("runs_20260707_FMEY",
                      c("BBRKC_v2.20.41","BBRKC_v2.20.42","NSRKC_v.2.20.37a",
                        "NSRKC_v.2.20.41","NSRKC_v.2.20.42",
                        "TannerCrab_v.2.20.37","TannerCrab_v.2.20.41","TannerCrab_v.2.20.42")),
            file.path("runs_20260729",
                      c("BBRKC_v2.20.42b", "NSRKC_v.2.20.42b", "SnowCrab_v.2.20.42a", 
                        "TannerCrab_v.2.20.42", "TannerCrab_v.2.20.42b)"))
            );
dirRuns = file.path("runs_20260729",
                      c("BBRKC_v2.20.42b", "NSRKC_v.2.20.42b", "SnowCrab_v.2.20.42b","TannerCrab_v.2.20.42b"));
dirRun = file.path("runs_20260729","BBRKC_v2.20.42b");
for (dirRun in dirRuns){
  dn = file.path(dirThs,"..",dirRun,"run_all");
  if (dir.exists(dn)&&file.exists(file.path(dn,"gmacs.std"))&&file.exists(file.path(dn,"gmacs.rep1"))){
    cat(paste0("Checking ",dirRun,"\n"));
    res = check_sd_vars(dn);
    cat("\tModel",basename(dirRun),res,"\n\n");
  } else {
    cat(paste0("Skipping ",dirRun,". Folder or gmacs.std or gmacs.rep1 does not exist.\n\n"));
  }
}




