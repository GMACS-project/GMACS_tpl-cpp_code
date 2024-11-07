#--read model files and create R object
require(wtsGMACS);

dirPrj = rstudioapi::getActiveProject();
#--identify relative (from project folder) path and name for each model
fldrs = c("G24_02"="Models-GMACS/ModelRuns/TannerCrab24_02/best",
          "G24_02a"="Models-GMACS/ModelRuns/TannerCrab24_02a/best",
          "G24_03"="Models-GMACS/ModelRuns/TannerCrab24_03/best",
          "G24_04"="Models-GMACS/ModelRuns/TannerCrab24_04/best",
          "G24_05"="Models-GMACS/ModelRuns/TannerCrab24_05/best",
          "G24_06"="Models-GMACS/ModelRuns/TannerCrab24_06/best",
          "G24_07"="Models-GMACS/ModelRuns/TannerCrab24_07/best");
cases = names(fldrs);#--model names
#--create full paths, reassign model names
fldrs=file.path(dirPrj,fldrs); names(fldrs) = cases;
#--read model results (returns a `gmacs_reslst` object)
resLst = wtsGMACS::readModelResults(fldrs);

dirThs = dirname(rstudioapi::getActiveDocumentContext()$path);
wtsUtilities::saveObj(resLst,file.path(dirThs,"rda_ModelsResLst.RData"));

