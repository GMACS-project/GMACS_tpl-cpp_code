#--script to run tests
#' 
#' @title Run tests
#' @description Function to run tests from working directory testing/runs
#' 
#' @param test - character vector with input file folder names
#' @param testdir - folder for running tests (default is current working directory)
#' @param scriptsPath - path to scripts folder containing this file, relative to \code{testdir}
#' @param inputsPath - path to input_files folder containing this file, relative to \code{testdir}
#' @param usePin - flag to use gmacs.pin  as pin file to initialize parameter values
#' @param compareWithPin - flag to make comparison with pin file, not gmacs.par_old
#' @param verbose - flag to print diagnostic GMACS output to screen (not implemented yet)
#' @param printPathInfo - flag to print folder and file paths for debugging 
#' @param cleanup - flag to delete folders for individual tests
#' 
#' @return List with results of tests (also saved to RData file)
#' 
#' @details The easiest way to run tests is to **call this function with 'testing/runs' as working directory.** 
#' This is accomplished by using \code{setwd(path to testing/runs)}. If the working directory is not 
#' 'testing/runs', then the input parameters \code{testdir}, \code{scriptsPath}, and \code{inputsPath} need to 
#' be set appropriately.
#' 
#' Using the pin file to initialize a model run (\code{usePin=TRUE}) also sets the starting phase to 10. 
#' If all is well, the model should converge almost immediately if the pin file is a copy of a 
#' par file from a previous converged model run. Ideally, the model should converge immediately, with the 
#' resulting par file identical to the pin file. However, this is frequently not the case if parameter values 
#' are near a bound in the pin file and thus the resulting par file values may not be identical to those in the 
#' pin file (i.e., the model converged to a slightly different place in parameter space). For the purpose of 
#' quickly testing the impact of changes to the code on previous model results, it 
#' is probably best to test the par file obtained using the new code run with the pin file 
#' against a par file from the old code that was the result of using the same pin file to initialize 
#' that model run.
#' 
#' @importFrom dplyr 
#' @export
#' 
runTests<-function(tests=c("AIGKC_202401",
                           "BBRKC_202401",
                           "NSRKC_202401",
                           "SMBKC_202401",
                           "SnowCrab_202401",
                           "TannerCrab_MalesOnlyA",
                           "TannerCrab_MalesOnlyANew"),
                   testdir=".",
                   scriptsPath="../scripts",
                   inputsPath="../input_files",
                   usePin=TRUE,
                   compareWithPin=FALSE,
                   verbose=FALSE,
                   printPathInfo=FALSE,
                   cleanup=TRUE){
    oldwd = setwd(testdir);
    on.exit(setwd(oldwd));
    if (printPathInfo) cat("working folder for testing: '",getwd(),"'\n",sep="");
    source(file.path(scriptsPath,"readParFile.R"));
    if (is.logical(verbose)) verbose=as.numeric(verbose);
    results = list();
    for (tst in tests){
        cat("#--Starting test '",tst,"'\n",sep='');
        if (!dir.exists(tst)) dir.create(tst);
        fns = list.files(path=file.path(getwd(),inputsPath,tst));
        if (printPathInfo) cat("Copying files",fns,"to",tst,"\n\tfrom",normalizePath(file.path(getwd(),inputsPath,tst)),"\n");
        res = file.copy(from=file.path(getwd(),inputsPath,tst,fns),to=tst,overwrite=TRUE);
        if (any(!res)) {
          str = paste("Error: the following files were not copied to",tst,"\n",
                      paste(file.path(getwd(),inputsPath,tst,fns)[!res],collapse="\n"));
          stop(str);
        }
        scr = "zz_run_osx.sh";
        if (Sys.info()["sysname"]=="Windows") scr = "zz_run_win.bat";
        if (!file.exists(file.path(scriptsPath,scr))) {
          stp =paste0("Could not find ',scr,' in '",normalizePath(file.path(getwd(),scriptsPath)),"'");
          stop();
        } else {
          lns = readLines(file.path(scriptsPath,scr));
          xtr = "";
          if (usePin) xtr = " -phase 10 -pin gmacs.pin ";
          if (verbose>0) xtr = paste(xtr,"-verbose",verbose);
          lns = gsub("&&extra",xtr,lns,fixed=TRUE);
          writeLines(lns,con=file.path(tst,scr))
        }
        setwd(tst);
        if (printPathInfo) cat("\nIn test '",tst,"'. \n\tworking folder for test: '",getwd(),"'\n",sep="");
        Sys.chmod(scr,mode='7777')
        if (Sys.info()["sysname"]=="Windows") {
          system(scr,wait=TRUE);
        } else {
          system(paste0("./",scr),wait=TRUE);
        }
        
        #--compare run for test
        res = TRUE;
        pars_new = readParFile("gmacs.par");
        comp_file = "gmacs.par_old";
        if (compareWithPin) comp_file = "gmacs.pin";
        if (!file.exists(comp_file)) {
          res = paste0(comp_file," does not exist for '",tst,"'. Can't do test.")
          warning(res);
        } else {
          pars_old = readParFile(comp_file);
          if (nrow(pars_new)!=nrow(pars_old)){
            str = paste0("Comparing new, old par files: number of rows differ! ",nrow(pars_new)," ",nrow(pars_old));
            res = list(new=pars_new,old=pars_old);
            warning(str);
          } else {
            idx = which(abs(pars_new$value-pars_old$value) > 1.0e-5);
            if (length(idx)>0){ 
              res = dplyr::bind_cols(param=pars_new$name[idx],new=pars_new$value[idx],old=pars_old$value[idx]) |> 
                      dplyr::mutate(abs_dif=abs(new-old));
              str = paste0("Detected differences for ",paste(pars_new$name[idx],collapse=", "));
              warning(str);
            } else {
              str = paste0("'",tst,"' passed!");
              message(str);
            }
          }
        }
        results[[tst]] = res;

        #--move out of current run folder up a folder level to testdir
        setwd("..");

        #--clean up files
        if (cleanup) {
            fns = list.files(path=tst,all.files=TRUE,no..=TRUE);
            if (printPathInfo) cat("cleaning up files",fns,"\n\t","from",tst,"\n")
            file.remove(file.path(tst,fns));
        }

        #--clean up folder
        if (cleanup) {
          if (printPathInfo) cat("Removing folder",tst,"\n")
          file.remove(tst);
        }
    }#--tst loop
    tstr = gsub("[[:punct:]*|[:blank:]*]","-",Sys.time(),fixed=FALSE);
    save(results,file=paste0("results_",tstr,".RData"));
    return(results);
}

##--run all
if (FALSE) {
  dirThs = normalizePath(file.path(dirname(rstudioapi::getActiveDocumentContext()$path),"../.."));
  results = runTests(cleanup=FALSE,usePin=TRUE,compareWithPin=TRUE,
                     testdir=file.path(dirThs,"testing/runs"));
}

#--run old format
if (FALSE){
  dirThs = normalizePath(file.path(dirname(rstudioapi::getActiveDocumentContext()$path),"../.."));
  tests_old=c("AIGKC_202401","BBRKC_202401","NSRKC_202401","SMBKC_202401","SnowCrab_202401","TannerCrab_MalesOnlyA");
  results = runTests(tests=tests_old,cleanup=FALSE,usePin=TRUE,compareWithPin=TRUE,
                     testdir=file.path(dirThs,"testing/runs"));
}

#--run new format
if (FALSE) {
  dirThs = normalizePath(file.path(dirname(rstudioapi::getActiveDocumentContext()$path),"../.."));
  results = runTests("TannerCrab_MalesOnlyANew",cleanup=FALSE,usePin=TRUE,compareWithPin=TRUE,
                     testdir=file.path(dirThs,"testing/runs"),
                     verbose=100);
}

#--run new format
if (FALSE) {
  dirThs = normalizePath(file.path(dirname(rstudioapi::getActiveDocumentContext()$path),"../.."));
  results = runTests("SnowCrab_20240304",cleanup=FALSE,usePin=TRUE,compareWithPin=TRUE,
                     testdir=file.path(dirThs,"testing/runs"),
                     verbose=100);
}

if (FALSE) {
  dirThs = normalizePath(file.path(dirname(rstudioapi::getActiveDocumentContext()$path),"../.."));
  results = runTests("SnowCrab_20240328",cleanup=FALSE,usePin=FALSE,compareWithPin=FALSE,
                     testdir=file.path(dirThs,"testing/runs"),
                     verbose=0);
}
