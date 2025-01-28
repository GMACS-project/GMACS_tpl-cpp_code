#--script to run tests
#' 
#' @title Run tests
#' @description Function to run tests using models from the GMACS_Models repo
#' 
#' @param repoDir - path to GMACS_Models repo folder
#' @param exeDir - (absolute) path to `gmacs` execuatable
#' @param stocks - stocks to run tests for (default: NULL implies run all in repoDir/models-for_test.csv)
#' @param testDir - path to folder for running tests (default is current working directory)
#' @param scriptsDir - path to folder containing *this* file, relative to \code{testDir}
#' @param usePin - one of "par", "pin", or "none". Flag to use a pin file to initialize parameter values
#' @param compareWith - one of "par", "pin", or "none. Flag to make comparison with the original par file or the pin file used (or no comparison)
#' @param verbose - flag (FALSE, 0, 1,2 or 3) to override gmacs.dat verbose setting using commandline with specified value
#' @param printPathInfo - flag to print folder and file paths for debugging 
#' @param cleanup - flag to delete folders for individual tests
#' 
#' @return List with results of tests (also saved to RData file)
#' 
#' @details The GMACS_Models GitHub repository can be downloaded (or cloned) from https://github.com/GMACS-project/GMACS_Models. 
#' The "`repoDir`/models-for_testing.csv" specifies the models to be used for testing the GMACS model code. 
#' 
#' Using a par or pin file to initialize a model run (\code{usePin="par" or "pin"}) also sets the starting phase to 10. 
#' If the pin file is a copy of a 
#' par file from a previous converged model run, the model should converge almost immediately and the 
#' resulting par file will be identical to the pin file. However, this is frequently not the case if parameter values 
#' are near a bound in the pin file and thus the resulting par file values may not be identical to those in the 
#' pin file (i.e., the model converged to a slightly different place in parameter space). For the purpose of 
#' quickly testing the impact of changes to the code on previous model results, it 
#' is probably best to test the par file obtained using the new code run with the pin file 
#' against a par file from the old code that was the result of using the same pin file to initialize 
#' that model run.
#' 
#' @import dplyr 
#' 
#' @export
#' 
runTests<-function(repoDir,
                   exeDir,
                   stocks=NULL,
                   testDir=".",
                   scriptsDir="../scripts",
                   usePin=c("par","pin","none")[1],
                   compareWith=c("par","pin","none")[1],
                   verbose=FALSE,
                   printPathInfo=FALSE,
                   cleanup=TRUE){
  #--set testing folder----
  oldwd = setwd(testDir);
  on.exit(setwd(oldwd));
  if (printPathInfo) cat("working folder for testing: '",getwd(),"'\n",sep="");
  
  #--get testing repo info----
  if (printPathInfo) cat("testing repo dir: '",repoDir,"'\n",sep="");
  dfrTsts1 = readr::read_csv(file.path(repoDir,"models-for_testing.csv")) |> 
               dplyr::filter(current_model_folder!="") |> 
               dplyr::rename(path=current_model_folder);
  if (!is.null(stocks)) dfrTsts1 = dfrTsts1 |> dplyr::filter(stock %in% stocks);
  dfrTsts2 = readr::read_csv(file.path(repoDir,"models-all.csv")) |> 
               dplyr::inner_join(dfrTsts1,by="path");
  
  #--source required scripts----
  source(file.path(scriptsDir,"readParFile.R"));
  
  #--copy gmacs executable to testDir (current WD at this point)
  exeName = "gmacs";
  if (Sys.info()["sysname"]=="Windows") exeName = "gmacs.exe";
  res = file.copy(from=file.path(exeDir,exeName),to=exeName,overwrite=TRUE);
  if (!res) stop("Could not find gmacs executable in",exeDir);
  
  #--run tests----
  ##--set verbose level for model run----
  if (is.numeric(verbose)) {
    nverbose=verbose;#--will use as commandline input
    verbose=TRUE;
  } else {
    if (verbose){
      nverbose = 0;#--level not specified, set lowest
    }
  }
  tests = dfrTsts2$path;
  results = list();
  for (tst in tests){
    #--for testing: tst = tests[1];
    cat("#--Starting test '",tst,"'\n",sep='');
    if (!dir.exists(tst)) dir.create(tst);
    
    ##--copy gmacs executable to tst folder from testDir
    res = file.copy(from=exeName,to=file.path(tst,exeName),overwrite=TRUE);
    if (!res) stop("Could not copy",exeName,"to",tst);
  
    ##--copy/rename required files from repoDir/tst----
    dfrFNs = dfrTsts2 |> dplyr::filter(path==tst);
    res = TRUE;
    for (fn in c("gmacs_dat","dat_file","ctl_file","prj_file")){
        resfn = file.copy(from=file.path(repoDir,"all_models",tst,dfrFNs[1,fn]),to=tst,overwrite=TRUE);
        if (!resfn) warning("Could not copy",file.path(repoDir,"all_models",tst,dfrFNs[1,fn]),"\n",immediate.=TRUE);
        res = res && resfn;
    }
    if (!res) {
      ##--skipping test----
      warning("#--Missing files: skipping",tst,"----\n\n",immediate.=TRUE);
    } else {
      ##--proceeding with test----
      ###--if necessary, set up pin file----
      res = FALSE;
      if (usePin=="par"){
        fn = file.path(repoDir,"all_models",tst,dfrFNs$par_file[1]);
        if (file.exists(fn)){
          res=file.copy(from=fn,to=file.path(tst,"gmacs.pin"),overwrite=TRUE);
          if (!res) warning("Could not copy par file to pin file.");
        } else {
          warning("Cannot run using original par file as pin file--does not exist:\n\t",fn,immediate.=TRUE);
        }
      }
      if (usePin=="pin"){
        fn = file.path(repoDir,"all_models",tst,dfrFNs$pin_file[1]);
        if (file.exists(fn)){
          res=file.path(from=fn,to=file.path(tst,"gmacs.pin"),overwrite=TRUE);
          if (!res) warning("Could not copy pin file to pin file.",immediate.=TRUE);
        } else {
          warning("Connot run using original pin file--does not exist:\n\t",fn,immediate.=TRUE);
        }
      }
      if (usePin=="none") res = FALSE;
      usePin = res;
      
      ###--set up commandline file----
      scr = "zz_run_osx.sh";
      if (Sys.info()["sysname"]=="Windows") scr = "zz_run_win.bat";
      if (!file.exists(file.path(scriptsDir,scr))) {
        stp =paste0("Could not find ',scr,' in '",normalizePath(file.path(getwd(),scriptsDir)),"'");
        stop();
      } else {
        lns = readLines(file.path(scriptsDir,scr));
        xtr = "";
        if (usePin)  xtr = " -phase 10 -pin gmacs.pin ";
        if (verbose) xtr = paste(xtr,"-verbose",nverbose);
        lns = gsub("&&extra",xtr,lns,fixed=TRUE);
        writeLines(lns,con=file.path(tst,scr))
      }
      
      ###--run model----
      setwd(tst); #--changing current WD to `tst` here
      if (printPathInfo) cat("\nIn test '",tst,"'. \n\tworking folder for test: '",getwd(),"'\n",sep="");
      Sys.chmod(scr,mode='7777')
      if (Sys.info()["sysname"]=="Windows") {
        system(scr,wait=TRUE);
      } else {
        system(paste0("./",scr),wait=TRUE);
      }
        
      ###--compare parameter values from run for tst with "old" values---- 
      if (!compareWith=="none"){
        res = TRUE;
        pars_new = readParFile("gmacs.par");
        if (compareWith=="par")
          comp_file = file.path(repoDir,"all_models",tst,dfrFNs$par_file[1]);
        if (compareWith=="pin")
          comp_file = "gmacs.pin";
        if (!file.exists(comp_file)) {
          res = paste0(comp_file," does not exist for '",tst,"'. Can't test parameter values directly.")
          warning(res,immediate.=TRUE);
          res = NULL;
        } else {
          pars_old = readParFile(comp_file);
          if (nrow(pars_new)!=nrow(pars_old)){
            str = paste0("Comparing new, old par files: number of rows differ! ",nrow(pars_new)," ",nrow(pars_old));
            res = list(new=pars_new,old=pars_old);
            warning(str,immediate.=TRUE);
          } else {
            idx = which(abs(pars_new$value-pars_old$value) > 1.0e-5);
            if (length(idx)>0){ 
              res = dplyr::bind_cols(param=pars_new$name[idx],new=pars_new$value[idx],old=pars_old$value[idx]) |> 
                      dplyr::mutate(abs_dif=abs(new-old));
              str = paste0("Detected differences for ",paste(pars_new$name[idx],collapse=", "));
              warning(str,immediate.=TRUE);
            } else {
              str = paste0("'",tst,"' passed!");
              message(str);
            }
          }
        }
        res_pars = res;
      } else {
        res_pars = NULL;
      }
        
      ###--compare Gmacsall.out values from run for tst with "old" values----
      res = TRUE;
      fnNew = file.path("Gmacsall.out");
      fnOld = file.path(repoDir,"all_models",tst,"Gmacsall.out");
      if (file.exists(fnNew)) {
        tblNew <- read.table(fnNew,fill=T,comment="?",col.names=paste0("col",1:200));
      } else {
        warning(fnNew," does not exist.\n",immediate.=TRUE);
        res = FALSE;
      }
      if (file.exists(fnOld)) {
        tblOld <- read.table(fnOld,fill=T,comment="?",col.names=paste0("col",1:200));
      } else {
        warning(fnOld," does not exist.\n",immediate.=TRUE);
        res = FALSE;
      }
      if (!res){
        warning("#--Skipping Gmacsall.out comparisons.----\n\n",immediate.=TRUE);
        res = NULL;
        pg  = NULL;
      } else {
        Index <- which(tblNew[,1]=="Total:")
        Obj1 <- as.numeric(tblNew[Index,2])
        Index <- which(tblNew[,1]=="OFL(tot)")
        OFL1 <- as.numeric(tblNew[Index,3])
        Index <- which(tblOld[,1]=="Total:")
        Obj2 <- as.numeric(tblOld[Index,2])
        Index <- which(tblOld[,1]=="OFL(tot)")
        OFL2 <- as.numeric(tblOld[Index,3])
        Outcome <- "ALL_OK"
        if (abs(Obj2-Obj1)>0.001) Outcome <- "Not_OK"
        res1 = paste("Objective function value test:",Obj1,Obj2,Obj2-Obj1,Outcome,"\n");
        Outcome <- "ALL_OK"
        if (abs(OFL2-OFL1)>0.001) Outcome <- "Not_OK"
        res2 = paste("OFL value test:",OFL1,OFL2,(OFL2/OFL1-1)*100,Outcome,"\n");
        res = c(res1,res2);
        
        ####--make combined dataframe and plot----
        eods = which(tblOld[,1]==">EOD<");
        rdx1 = which(tblOld[,1]=="#Overall_summary")+2;
        rdx2 = min(eods[eods-rdx1>0])-1;
        cols = as.vector(t(as.matrix(tblOld[rdx1,])));
        cols = cols[!is.na(cols)];
        nc   = length(cols);
        if (any(stringr::str_count(cols,"female")>0))
          cols[13:14] = paste0(cols[13:14],"_female");
        dfrOld = tblOld[(rdx1+1):rdx2,1:nc];
        colnames(dfrOld) = cols;
        dfrOld = dfrOld |> 
                   dplyr::mutate(dplyr::across(where(is.character),as.numeric)) |> 
                   dplyr::mutate(model="old");
        eods = which(tblNew[,1]==">EOD<");
        rdx1 = which(tblNew[,1]=="#Overall_summary")+2;
        rdx2 = min(eods[eods-rdx1>0])-1;
        cols = as.vector(t(as.matrix(tblOld[rdx1,])));
        cols = cols[!is.na(cols)];
        nc   = length(cols);
        if (any(stringr::str_count(cols,"female")>0))
          cols[13:14] = paste0(cols[13:14],"_female");
        dfrNew = tblNew[(rdx1+1):rdx2,1:nc];
        colnames(dfrNew) = cols;
        dfrNew = dfrNew |> 
                   dplyr::mutate(dplyr::across(where(is.character),as.numeric)) |> 
                   dplyr::mutate(model="new");
        dfrComp = dplyr::bind_rows(dfrOld,dfrNew);
        
        makePlot<-function(dfr,var){
          require(ggplot2);
          p = ggplot(dfr,aes(x=Year,y={{var}},colour=model)) + 
                geom_line() + geom_point() + wtsPlots::getStdTheme() + 
                theme(legend.position="inside",
                      legend.position.inside=c(0.99,0.99),
                      legend.justification=c(1,1));
          return(p)
        }
        p1 = makePlot(dfrComp,Recruit_male)
        p2 = makePlot(dfrComp,SSB);
        p3 = makePlot(dfrComp,Total_mortality);
        p4 = makePlot(dfrComp,Retained_mortality);
        pg = cowplot::plot_grid(p1,p2,p3,p4,nrow=2);
      }
      res_allout = list(res=res,plot=pg);
      
      ###--add test results to results list----
      results[[tst]] = list(pars=res_pars,allout=res_allout,tblOld=tblOld,tblNew=tblNew);

      ###--move out of current run folder up a folder level to testDir----
      setwd("..");

      ###--clean up files----
      if (cleanup) {
          fns = list.files(path=tst,all.files=TRUE,no..=TRUE);
          if (printPathInfo) cat("cleaning up files",fns,"\n\t","from",tst,"\n")
          file.remove(file.path(tst,fns));
      }

      ###--clean up folder----
      if (cleanup) {
        if (printPathInfo) cat("Removing folder",tst,"\n")
        file.remove(tst);
      }
    }#--tst run
  }#--tst loop
  tstr = gsub("[[:punct:]*|[:blank:]*]","-",Sys.time(),fixed=FALSE);
  save(results,file=paste0("tesing_results_",tstr,".RData"));
  save(results,file=paste0("testing_results.RData"));
  file.remove(exeName);#--delete executable from testing directory
  return(results);
}

#--Examples----
##--run all
if (FALSE) {
  #
  #--NOTE: make sure all paths to directories/files are correct for your system
  #
  ##--the following assumes: 
  ###--1. the current testing folder is two levels below the GMACS_tpl-cpp-code folder
  ###-------e.g.: at "dirPrj/testing/current_test_runs"
  ###--2. the GMACS_Models repo is located at "~/Work/Programming/GMACS-project/GMACS_Models"
  ###--3. The gmacs executable is under the "dirPrj/_build" directory
  ###--4. The current directory (`getwd()`) is the top-level folder for the tests to run in (`testDir`)
  #
  dirPrj = normalizePath(file.path(dirname(rstudioapi::getActiveDocumentContext()$path),"../.."));
  exeDir = normalizePath(file.path(dirPrj,"_build"));#--change as necessary
  results = runTests(cleanup=FALSE,usePin="par",compareWith="par",
                     repoDir="~/Work/Programming/GMACS-project/GMACS_Models",
                     exeDir=exeDir,
                     testDir=".", #--current working directory
                     scriptsDir=file.path(dirPrj,"testing/scripts"),
                     verbose=0);
}

##--run Tanner crab only (on Mac)
if (FALSE) {
  #
  #--NOTE: make sure all paths to directories/files are correct for your system
  #
  ##--the following assumes: 
  ###--1. the current testing folder is two levels below the GMACS_tpl-cpp-code folder
  ###-------e.g.: at "dirPrj/testing/current_test_runs"
  ###--2. the GMACS_Models repo is located at "~/Work/Programming/GMACS-project/GMACS_Models"
  ###--3. The gmacs executable is under the "dirPrj/_build" directory
  ###--4. The current directory (`getwd()`) is the top-level folder for the tests to run in (`testDir`)
  #
  dirPrj = normalizePath(file.path(dirname(rstudioapi::getActiveDocumentContext()$path),"../.."));
  exeDir = file.path(dirPrj,"_build");
  #--run tests
  results = runTests(cleanup=FALSE,usePin="par",compareWith="par",
                     repoDir="~/Work/Programming/GMACS-project/GMACS_Models",
                     exeDir=file.path(dirPrj,"_build"),
                     stocks="TannerCrab",
                     testDir=".", #--current working directory
                     scriptsDir=file.path(dirPrj,"testing/scripts"),
                     verbose=0);
}

##--run Tanner crab only (on Windows)
if (FALSE) {
  #
  #--NOTE: make sure all paths to directories/files are correct for your system
  #
  ##--the following assumes: 
  ###--1. the current testing folder is two levels below the GMACS_tpl-cpp-code folder
  ###-------e.g.: at "dirPrj/testing/runs_windows"
  ###--2. the GMACS_Models repo is located at "~/Work/Programming/GMACS_Project/GMACS_Models"
  ###--3. The gmacs executable is under the "dirPrj/_build" directory
  ###--4. The current directory (`getwd()`) is the top-level folder for the tests to run in (`testDir`)
  #
  dirPrj = normalizePath(file.path(dirname(rstudioapi::getActiveDocumentContext()$path),"../.."));
  exeDir = file.path(dirPrj,"_build");
  #--run tests
  results = runTests(cleanup=FALSE,usePin="par",compareWith="par",
                     repoDir="~/Work/Programming/GMACS_Project/GMACS_Models",
                     exeDir=file.path(dirPrj,"_build"),
                     stocks="TannerCrab",
                     testDir=".", #--current working directory
                     scriptsDir=file.path(dirPrj,"testing/scripts"),
                     verbose=0);
}

