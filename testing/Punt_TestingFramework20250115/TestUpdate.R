BasePath<- "C:/Research/gmacs/unified/"
RunPath<- paste0(BasePath,"Build/")

Species <- c("SMBKC/","AIGKC/","AIGKC/","BBRKC/")
Folder <- c("SMBKC_2024/","AIGKC_EAG/","AIGKC_WAG/","BBRKC_2024/")
BaseGmacsFile <- c("sm24","EAG_23_1c","WAG_23_1c","bbrkc211_24f")

Checkfit <- function(the.folder1,the.folder2,Yr1,Yr2,Ext)
 {
  Tab1 <- read.table(paste0(the.folder1,"/gmacsall.out"),fill=T,comment="?",col.names=paste0("col",1:200))
  Tab2 <- read.table(paste0(the.folder2,"/gmacsall",Ext,".out"),fill=T,comment="?",col.names=paste0("col",1:200))

  Index <- which(Tab1[,1]=="Total:")
  Obj1 <- as.numeric(Tab1[Index,2])
  Index <- which(Tab1[,1]=="OFL(tot)")
  OFL1 <- as.numeric(Tab1[Index,3])
  Index <- which(Tab2[,1]=="Total:")
  Obj2 <- as.numeric(Tab2[Index,2])
  Index <- which(Tab2[,1]=="OFL(tot)")
  OFL2 <- as.numeric(Tab2[Index,3])
  Outcome <- "ALL_OK"
  if (abs(Obj2-Obj1)>0.001) Outcome <- "Not_OK"
  cat(the.folder1,Obj1,Obj2,Obj2-Obj1,Outcome,"\n")
  Outcome <- "ALL_OK"
  if (abs(OFL2-OFL1)>0.001) Outcome <- "Not_OK"
  cat(the.folder1,OFL1,OFL2,(OFL2/OFL1-1)*100,Outcome,"\n")
  
  Nyears <- Yr2-Yr1+1
  Years <- Yr1:Yr2
  Index1 <- which(Tab1[,1]=="#Overall_summary")+2
  Index2 <- which(Tab2[,1]=="#Overall_summary")+2
  Summary <- matrix(0,nrow=(Yr2-Yr1+1),ncol=2)
  for (Iyr in 1:Nyears) Summary[Iyr,1] <- as.numeric(Tab1[Index1+Iyr,2])
  for (Iyr in 1:Nyears) Summary[Iyr,2] <- as.numeric(Tab2[Index2+Iyr,2])
  ymax <- max(Summary)*1.1
  plot(Years,Summary[,1],ylim=c(0,ymax),xlab="",ylab="")
  lines(Years,Summary[,2],lty=1,col="red") 
  title(the.folder2)
 }


Dotest <- function(Istock,EstOnly=T,Yr1=1900,Yr2=2000)
 {
  
  # Original folder
  OrigFolder <- paste0(BasePath,"Testing/input_files/",Folder[Istock])
  cat("Original folder =",OrigFolder,"\n")
  
  # Clean out the main folder
  TargetFolder <- paste0(RunPath,Species[Istock])
  cat("Trarget folder =",TargetFolder,"\n")
  setwd(TargetFolder)
  file.remove("gmacsall.out")
  file.remove("gmacs.par")
  file.remove("gmacs.dat")
  
  setwd(BasePath)  
  file.copy(from="gmacs.exe",to=paste0(RunPath,Species[Istock],"gmacs.exe"),overwrite =T)  
  file.copy(from=paste0(OrigFolder,BaseGmacsFile[Istock],".dat"),to=paste0(TargetFolder,BaseGmacsFile[Istock],".dat"),overwrite =T)  
  file.copy(from=paste0(OrigFolder,BaseGmacsFile[Istock],".ctl"),to=paste0(TargetFolder,BaseGmacsFile[Istock],".ctl"),overwrite =T)  
  file.copy(from=paste0(OrigFolder,BaseGmacsFile[Istock],".prj"),to=paste0(TargetFolder,BaseGmacsFile[Istock],".prj"),overwrite =T)  
  file.copy(from=paste0(OrigFolder,"gmacs.dat"),to=paste0(TargetFolder,"gmacs.dat"),overwrite =T)  
  setwd(TargetFolder)
  print("Running GMACS")
  if (EstOnly==T) aa <<- system("gmacs.exe -est",intern=T)
  if (EstOnly==F) aa <<- system("gmacs.exe",intern=T)
  print("Done the run")
  
  # Now produce the plot
  Checkfit(OrigFolder,TargetFolder,Yr1=Yr1,Yr2=Yr2,Ext="")
  
  return(aa) 
  
}

#par(mfrow=c(4,2),oma=c(2,2,1,1),mar=c(4,4,2,1))
Dotest(1,EstOnly=F,Yr1=1978,Yr2=2023)
#Dotest(2,EstOnly=T,Yr1=1960,Yr2=2022)
#Dotest(3,EstOnly=T,Yr1=1960,Yr2=2022)
#Dotest(4,EstOnly=T,Yr1=1975,Yr2=2023)
AA




OldMainFolder <- paste0(Drive,"/Research/gmacs/UnifiedZ/build/")
NewMainFolder <- paste0(Drive,"/Research/gmacs/UnifiedAM/build/")
Checkfit("SMBKC","SMBKC",1978,2021,"",add=1)
Checkfit("NSRKC","NSRKC",1976,2024,"",add=1)
Checkfit("AIGKC","AIGKC",1960,2022,"",add=1)
Checkfit("Snow_crab","Snow_crab",1982,2022,"",add=1)
Checkfit("BBRKC","BBRKC",1975,2021,"",add=1)
Checkfit("Snow_crabV2","Snow_crabV2",1982,2022,"",add=1)
Checkfit("BBRKCV2","BBRKCV2",1975,2021,"",add=1)
mtext("MMB (t)",side=2,outer=2)
mtext("Year",side=1,outer=2)

#AAA
print("Checking tst")
OldMainFolder <- paste0(Drive,"/Research/gmacs/UnifiedAM/build/")
NewMainFolder <- paste0(Drive,"/Research/gmacs/UnifiedAM/build/")
par(mfrow=c(5,2),oma=c(2,2,1,1),mar=c(4,4,2,1))
Checkfit("SMBKC","SMBKC/tst",1978,2021,"1",add=0)
Checkfit("SMBKC","SMBKC/tst",1978,2021,"2",add=0)
Checkfit("NSRKC","NSRKC/tst",1976,2024,"1",add=0)
Checkfit("NSRKC","NSRKC/tst",1976,2024,"2",add=0)
Checkfit("AIGKC","AIGKC/tst",1960,2022,"1",add=0)
Checkfit("AIGKC","AIGKC/tst",1960,2022,"2",add=0)
Checkfit("Snow_crab","Snow_crab/tst",1982,2022,"1",add=0)
Checkfit("Snow_crab","Snow_crab/tst",1982,2022,"2",add=0)
Checkfit("BBRKC","BBRKC/tst",1975,2021,"1",add=0)
Checkfit("BBRKC","BBRKC/tst",1975,2021,"2",add=0)
mtext("MMB (t)",side=2,outer=2)
mtext("Year",side=1,outer=2)
