# Script to re-write the GMACS input files
# We read the old input file format and set up the new one which explicitly 
# indicates options and terminology in those inout files.
# Author: Matthieu VERON
# Last update: February 2024

rm(list = ls(all.names = TRUE)) 

# 1. set up ----

fsep <- .Platform$file.sep

# Load packages
library(gmr)
library(magrittr)

# Set directories
dir_Base <- file.path(here::here(), "testing", "input_files", fsep = fsep)
dir_TPL <- here::here()

# 2. local functions ----
.an <- function(x){return(as.numeric(x))}
.ac <- function(x){return(as.character(x))}
.af <- function(x){return(as.factor(x))}

write_NewInputFiles <- function(stock = NULL, Ass_year = 2023){
  
  # stock <- "TannerCrab_MalesOnlyANew"
  # Ass_year <- 2023
  
  # Stock of interest and specification of model names ----
  if (stock == "AIGKC_202401") {
    datfileName <- "EAG_23_1b.dat"
    ctlfileName <- "EAG_23_1b.ctl"
    prjfileName <- "EAG_23_1b.prj"
    
    datfileName_New <- "EAG_23_1b_M09.dat"
    ctlfileName_New <- "EAG_23_1b_M09.ctl"
    prjfileName_New <- "EAG_23_1b_M09.prj"
    
    model_name <- "22.1e2Update"
    
  } else if (stock == "SnowCrab_202401") {
    datfileName <- "snow.dat"
    ctlfileName <- "snow.ctl"
    prjfileName <- "snow.prj"
    
    datfileName_New <- "snow_M09.dat"
    ctlfileName_New <- "snow_M09.ctl"
    prjfileName_New <- "snow_M09.prj"
    
    model_name <- "model_23"
    
  } else if (stock == "BBRKC_202401") {
    datfileName <- "bbrkc211.dat"
    ctlfileName <- "bbrkc211.ctl"
    prjfileName <- "bbrkc21.prj"
    
    datfileName_New <- "bbrkc_21_1_M09.dat"
    ctlfileName_New <- "bbrkc_21_1_M09.ctl"
    prjfileName_New <- "bbrkc_21_1_M09.prj"
    
    model_name <- "model_21_1b"
    
  } else if (stock == "SMBKC_202401") {
    datfileName <- "sm22.dat"
    ctlfileName <- "sm22.ctl"
    prjfileName <- "sm22.prj"
    
    datfileName_New <- "sm_22_M09.dat"
    ctlfileName_New <- "sm_22_M09.ctl"
    prjfileName_New <- "sm_22_M09.prj"
    
    model_name <- "model_16_0"
    
  } else if (stock == "NSRKC_202401"){
    datfileName <- "nsrkc23.dat"
    ctlfileName <- "nsrkc23.ctl"
    prjfileName <- "nsrkc23.prj"
    
    datfileName_New <- "nsrkc_23_M09.dat"
    ctlfileName_New <- "nsrkc_23_M09.ctl"
    prjfileName_New <- "nsrkc_23_M09.prj"
    
    model_name <- "model_23_0" 
    
  } else if (stock == "TannerCrab_MalesOnlyA"){
    datfileName <- "tanner.dat"
    ctlfileName <- "tanner.ctl"
    prjfileName <- "tanner.prj"
    
    datfileName_New <- "tanner_23_M09.dat"
    ctlfileName_New <- "tanner_23_M09.ctl"
    prjfileName_New <- "tanner_23_M09.prj"
    
    model_name <- "model_23_0" 
  } else if (stock == "TannerCrab_MalesOnlyANew"){
    datfileName <- "tanner.dat"
    ctlfileName <- "tanner.ctl"
    prjfileName <- "tanner.prj"
    
    datfileName_New <- "tanner_23_M09.dat"
    ctlfileName_New <- "tanner_23_M09.ctl"
    prjfileName_New <- "tanner_23_M09.prj"
    
    model_name <- "model_23_0" 
  } else if (stock == "NSRKC_202401"){
    datfileName <- "tanner.dat"
    ctlfileName <- "tanner.ctl"
    prjfileName <- "tanner.prj"
    
    datfileName_New <- "tanner_23_M09.dat"
    ctlfileName_New <- "tanner_23_M09.ctl"
    prjfileName_New <- "tanner_23_M09.prj"
    
    model_name <- "model_23_0" 
  }
  
  # gmacs.dat file ----
  # read gmacs.dat
  fileName <- "gmacs.dat"
  fileName <- file.path(dir_Base, stock, fileName, fsep = fsep)
  GMACSdat <- readGMACS.dat(path = fileName, verbose = TRUE)
  
  # Data file ----
  # Read the data file
  datFile <- file.path(dir_Base, stock, datfileName, fsep = fsep)
  datFile <- readGMACSdat(FileName = datFile, verbose = T)
  
  # Write the data file
  writeGmacsdatfile(Dir = file.path(dir_Base, stock, fsep = fsep),
                    FileName = datfileName_New, 
                    overwrite = TRUE, 
                    DatFile = datFile, 
                    stock = stock,
                    model_name = model_name, 
                    Ass_Year = Ass_year,
                    DirTPL = dir_TPL)
  # Check for reading the new data file
  # datFile <- readGMACSdat(FileName = file.path(dir_Base, stock, datfileName_New, fsep = fsep), verbose = T)
  
  # Control file ----
  # Read the control file
  ctlFile <- file.path(dir_Base, stock, ctlfileName, fsep = fsep)
  ctlFile <- readGMACSctl(FileName = ctlFile,
                          verbose = T, 
                          DatFile = datFile, 
                          nyrRetro = GMACSdat$N_Year_Retro)
  
  # Write the control file
  writeGmacsctlfile(Dir = file.path(dir_Base, stock, fsep = fsep),
                    FileName = ctlfileName_New, 
                    CtlFile = ctlFile, 
                    DatFile = datFile, 
                    stock = stock, 
                    model_name = model_name, 
                    Ass_Year = Ass_year,
                    DirTPL = dir_TPL)
  
  
  # Projection file ----
  # Read the projection file
  fileName <- file.path(dir_Base, stock, prjfileName, fsep = fsep)
  prjfile <-  readGMACSprj(FileName = fileName,verbose = TRUE)
  
  # Write the projection file
  writeGmacsprjfile(Dir = file.path(dir_Base, stock, fsep = fsep),
                    FileName = prjfileName_New,
                    PrjFile = prjfile,
                    stock = stock,
                    model_name = model_name, 
                    Ass_Year = Ass_year,
                    DirTPL = dir_TPL)
  
  # Write the new gmacs.dat file
  if(!file.exists(file.path(dir_Base, stock, "gmacs_old.dat", fsep = fsep))){
    # Rename the old file
    file.rename(from = file.path(dir_Base, stock, "gmacs.dat", fsep = fsep), 
                to = file.path(dir_Base, stock, "gmacs_old.dat", fsep = fsep))
    # Update the name of the input files
    GMACSdat$DatFileName <- datfileName_New
    GMACSdat$CtlFileName <- ctlfileName_New
    GMACSdat$PrjFileName <- prjfileName_New
    # Write the new file
    writeGmacs.dat(Dir = file.path(dir_Base, stock, fsep = fsep),
                   FileName = "gmacs.dat",
                   gmacsDat = GMACSdat,
                   stock = stock,
                   model_name = model_name,
                   Ass_Year = Ass_year,
                   DirTPL = dir_TPL)
  }
  
  cat(paste0("********* ",stock, ": All the input files have been updated"," *********\n\n"))
  return("All files updated !")
}

# 3. Loop on stock to create the new files ---
stock_names <- list.files(dir_Base)
stock_names <- stock_names[!stock_names%in%c("AIGKC_EnvCovs", "NSRKC_202401")]
sapply(X = stock_names, FUN = write_NewInputFiles)
