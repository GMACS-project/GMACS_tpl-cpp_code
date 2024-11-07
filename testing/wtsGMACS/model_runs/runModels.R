#--do multiple model runs
require(wtsGMACS);

dirThs = dirname(rstudioapi::getActiveDocumentContext()$path)
#--path to executable
p2e = "~/Work/StockAssessments-Crab/AssessmentModelDevelopment/VS_Code/GMACS_tpl-cpp_code/_build";

#--list of model run info
lst = list(
        list(pth2dat=file.path(dirThs,"../input_files/SMBKC_2024Asmt"),
             pth2run="./SMBKC_2024Asmt"),
        list(pth2dat=file.path(dirThs,"../input_files/TannerCrab24_02"),
             pth2run="./TannerCrab24_02"),
        list(pth2dat=file.path(dirThs,"../input_files/TannerCrab24_02a"),
             pth2run="./TannerCrab24_02a")
      );
for (r in 1:length(lst)){
  #--testing: r = 1;
  lst1 = lst[[r]];
  runGMACS(runpath=lst1$pth2run,
           runCmds=list(os="osx",
                        path2exe=p2e,
                        path2dat=lst1$pth2dat,
                        pinFile=file.path(lst1$pth2dat,"gmacs.pin"),
                        minPhase=10,maxPhase=10,
                        cleanup=FALSE,
                        verbose=4),
           test=FALSE)
}

