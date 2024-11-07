#--read model files and create R object
require(wtsGMACS);

dirThs = dirname(rstudioapi::getActiveDocumentContext()$path);
dirPrj = rstudioapi::getActiveProject();
if (is.null(dirPrj)) dirPrj = dirThs;#--default to this script's folder

#--identify relative (from project folder) path and name for each model
fldrs = c("G24_02" ="../model_runs/TannerCrab24_02",
          "G24_02a"="../model_runs/TannerCrab24_02a");
cases = names(fldrs);#--model names
#--create full paths, reassign model names
fldrs=file.path(dirPrj,fldrs); names(fldrs) = cases;
#--read model results (returns a `gmacs_reslst` object)
resLst = wtsGMACS::readModelResults(fldrs);

wtsUtilities::saveObj(resLst,file.path(dirThs,"rda_ModelsResLst.RData"));

