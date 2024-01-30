#--script to run tests
#' 
#' @title Run tests
#' @param test - character vector with input file folder names
#' @param testdir - folder for running tests (default is current working directory)
#' @param compareWithPin - flag to make comparison with pin file, not gmacs.par_old
#' @param cleanup - flag to delete folders for individual tests
#' @return List with results by test
#' @export
#' 
runTests<-function(tests=c("TannerCrab_MalesOnlyA",
                           "AIGKC_202401",
                           "BBRKC_202401"),
                   testdir=".",
                   compareWithPin=FALSE,
                   cleanup=TRUE){
    oldwd = getwd();
    odlwd = setwd(testdir);
    on.exit(setwd(oldwd));
    cat("working folder for testing: '",getwd(),"'\n",sep="");
    source("readParFile.R");
    results = list();
    for (tst in tests){
        if (!dir.exists(tst)) dir.create(tst);
        fns = list.files(path=file.path("../input_files",tst));
        file.copy(from=file.path("../input_files",tst,fns),to=tst,overwrite=TRUE);
        if (Sys.info()["sysname"]=="Windows") {
            scr = "zz_run_win.bat";
            if (!file.exists(scr)) {
              stp =paste0("Could not find ',scr,' in '",getwd(),"'");
              stop();
            } else {
              file.copy(from=scr,to=file.path(tst,scr),overwrite=TRUE);
            }
            setwd(tst);
            cat("\nIn test '",tst,"'. \n\t\tworking folder for test: '",getwd(),"'\n",sep="");
            Sys.chmod(scr,mode='7777')
            system(scr,wait=TRUE);
        } else {
            scr = "zz_run_osx.sh";
            if (!file.exists(scr)) {
              stp =paste0("Could not find ',scr,' in '",getwd(),"'");
              stop();
            } else {
              file.copy(from=scr,to=file.path(tst,scr),overwrite=TRUE);
            }
            setwd(tst);
            Sys.chmod(scr,mode='7777')
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
            str = paste0("Comparing new, old par files: number of rows differ! ",nrow(pars_new)," ",nrow(pars_old))
            res = list(new=pars_new,old=pars_old);
            warning(str);
          } else {
            idx = which(abs(pars_new$value-pars_old$value) > 1.0e-5);
            if (length(idx)>0){ 
              res = dplyr::bind_cols(pars_new[idx,],old=pars_old$value[idx]);
              str = paste0("Detected differences for ",paste(pars_new$name[idx],collapse=", "))
              warning(str);
            } else {
              str = paste0("'",tst,"' passed!")
              message(str);
            }
          }
        }
        results[[tst]] = res;

        #--clean up files
        if (cleanup) {
            fns = list.files(path="tst",all.files=TRUE)
            file.remove(fns);
        }

        #--move out of current run folder up a folder level to "run"
        setwd("..");

        #--clean up folder
        if (cleanup) file.remove(tst);
    }#--tst loop
    return(res);
}

#runTests("AIGKC_202401",cleanup=FALSE,compareWithPin=TRUE);
#runTests("BBRKC_202401",cleanup=FALSE,compareWithPin=TRUE);
