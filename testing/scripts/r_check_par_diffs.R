#--check for parameter differences between model runs
#' @param dn_old - folder name with old model par file
#' @param dn_new - folder name with new model par file
check_par_diffs<-function(dn_old,dn_new){
  #--get base folder names
  dir_old = basename(dirname(dn_old));
  dir_new = basename(dirname(dn_new));
  
  nbad = 0;
  lstChk = list();
  
  #--read gmacs.par files
  dfrParOld = wtsGMACS::readParFile(file.path(dn_old,"gmacs.par")) |> dplyr::rename(old_val=value);
  dfrParNew = wtsGMACS::readParFile(file.path(dn_new,"gmacs.par")) |> dplyr::rename(new_val=value);
  chk = which(abs(dfrParOld$old_val-dfrParNew$new_val)>0.0001);
  nbad = nbad+length(chk)
  if (length(chk)>0) {
    dfrChk = dplyr::bind_cols(dfrParOld[chk,],
                              dfrParNew[chk,] |> dplyr::select(new_val)) |> 
               dplyr::mutate(diff_par=new_val-old_val);
    lstChk[["parameters"]] = dfrChk;
    warning(paste0("differences found in parameter estimates between ",dir_old," and ",dir_new,"."));
  } else {
    #--nothing to do?
  }
  
  #--read gmacs.std file (could look at std errors)
  #dfrStdOld = wtsGMACS::readStdFile(file.path(dn_old,"gmacs.std"));
  #dfrStdNew = wtsGMACS::readStdFile(file.path(dn_new,"gmacs.std"));
  
  passed = ifelse(nbad==0,"PASSED","FAILED");
  lstOut=list(dir_old=dir_old,dir_new=dir_new,passed=passed,lstChk=lstChk);
  wtsUtilities::saveObj(lstOut,file.path(dirname(dn_new),"rda_checks_for_different_param_values.RData"));
  return(passed);
}

#--run comparison----
dirThs = getwd();
dfrRuns = tibble::tribble(~old,~new,
                         file.path("runs_20260506_Katie_v.2.30.37"),
                         file.path("runs_20260729","BBRKC_v.2.20.42b"),
                         file.path("runs_20260514_Caitlin_v.2.20.37a"),
                         file.path("runs_20260729","NSRKC_v.2.20.42b"),
                         file.path("runs_20260729","SnowCrab_v.2.20.42"),
                         file.path("runs_20260729","SnowCrab_v.2.20.42b"),
                         file.path("runs_20260707_FMEY","TannerCrab_v.2.20.41"),
                         file.path("runs_20260729","TannerCrab_v.2.20.42b")
                         );
for (rw in 4:nrow(dfrRuns)){
  #--testing: rw = 1;
  dfrRun = dfrRuns[rw,];
  dn_old = file.path(dirThs,"..",dfrRun$old,"run_all");
  dn_new = file.path(dirThs,"..",dfrRun$new,"run_all");
  if (dir.exists(dn_old)){
    if (dir.exists(dn_new)){
      cat(paste0("Comparing models ",dfrRun$old," and ",dfrRun$new,".","\n"));
      res = check_par_diffs(dn_old,dn_new);
      cat(paste0("\tComparing models ",dfrRun$old," and ",dfrRun$new,". Result: ",res,"\n\n"));
    } else {
      cat("Folder",dn_new,"not found.\n\n")
    }
  } else {
    cat("Folder",dn_old,"not found.\n\n")
  }
}

