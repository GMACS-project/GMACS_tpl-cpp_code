# GMACS_tpl-cpp_code

This is a repository with GMACS tpl and C++ source code only. The base code was distributed by Andre Punt on Jan. 18, 2024 following the January 2024 Crab Modeling Workshop in Anchorage, AK. This repository is a bit "cleaner" than the [GMACS_Assessment_code](https://github.com/GMACS-project/GMACS_Assessment_code) repository because it contains **only** the base tpl code, a template for the personal.tpl code, the src and include sub-folders with c++ code, and a platform-independent CMake file to make the gmacs executable. 

The intention of this repository is to restrict it to only the tpl and c++ code in the top-level folder, the `src` and `include` sub-folders, and a `testing` sub-folder. Developers should create branches off the main branch to develop and test code, then merge their changes back into the main branch after testing is successful. Please **DO NOT** create parallel folder structures on the main branch (as has been done in the GMACS_Assessment_code repository).

## Installation and compilation

GMACS uses the [AD Model Builder](http://www.admb-project.org) C++ libraries, so these must be installed prior to installing and using GMACS. GMACS also provides a script for platform-independent installation using CMake. 

For Windows users, it is recommended to install [RTools](https://cran.r-project.org/bin/windows/Rtools/rtools43/rtools.html) to provide compilers to build the ADMB libraries, a `cmake` executable, and unix-like shell functions for various file manipulation tasks. After installing RTools, the user should add the folder containing `g++.exe` to the front of their Windows PATH so that the RTools compiler/linker is found before any other version (this could be done on a per-terminal session basis). For RTools version 4.3, this would be `RTools`\x86_64-mingw32.static.posix\bin, where `RTools` is the top-level folder to which RTools was installed. In addition, add an environment variable `RToolsUsr` with the path to the `Rtools`\bin folder so that the unix-like shell commands are avaialable in the Windows Command Prompt window. User environment variables and their values can be created from Windows "Setttings" by searching for "environment variables", selecting "Edit environmental variables for your account", and adding them to the "User variables" section by selecting the "New" button. Users may also want to

For Mac OSX users, a `cmake` executable script and gui can be installed from https://cmake.org/download/.

Once ADMB has been compiled, create the user environment variable ADMB_HOME and set it equal to the path to the `admb` sub-folder of the `build` directory (i.e., the folder that contains `bin`, `include`, and `lib`). Also, copy (or rename) the libadmb-contrib-xxxx.a file in the `lib` sub-folder to libadmb-contrib.a.

If you have not already done so, clone a copy of this repository to a folder on your local machine.

To compile the GMACS executable, open a command prompt (Windows) or terminal window (Mac OSX) and change directory to the top-level GMACS directory (i.e., the one that contains the gmacsbase.TPL, personal.TPL, and CMakeLists.txt files). Then run the following commands:

  *  cmake -S . -B _build -G "Unix Makefiles"
  *  cmake --build _build

The first command creates the `_build` subfolder and the Makefile appropriate for the given platform ("Unix Makefiles" appears to be an appropriate value for the -G option when compiling with RTools under either OSX or Windows). The second command builds the project by running the Makefile and (if successful) copies the gmacsbase and personal tpl files to `_build`, concatenates them as gmacs.tpl, calls tpl2cpp on gmacs.tpl to create the associated .cpp and .htp files, and finally compiles the source and header files to create the gmacs executble in the `_build` folder (`gmacs` on Mac OSX and `gmacs.exe` on Windows).

Changes to the tpl or c++ files can be recompiled using "cmake --build _build", which will only update the compilation process for files changed since the last build (i.e., not recompiling everything). An alternative is to open a command prompt or terminal window and change directory to the "_build" folder, then run "make". 

To "start from scratch", you can either delete the _build folder and run the two commands above again or run "cmake --build _build --target clean" (which deletes the gmacs executable, gmacs.tpl, gmacs.cpp, gmacs.htp and all the object files under the `_build` folder, but not the CMake-associated files) followed by "cmake --build _build".

## Testing

### new approach (post-Jan 2025)

First, the "GMACS_Models" repository on GitHub (https://github.com/GMACS-project/GMACS_Models) should be cloned or downloaded. This repo contains subfolders in the "all_models" folder with files from the most recent assessment, as well as other models. The file "models-for_testing.csv" lists the subfolders to be used for testing (unless modified by the user, these will typically be the most recently-accepted assessment model). 

The `testing/scripts` folder contains an R script, `runTests1.R`, which can also be used to test (all or a subset of) the models identified in the "models-for_testing.csv" file. Ideally run in a separate suitably-named "runs" folder, this script runs the models in "models-for_testing.csv" and collates the results from the old and new model runs in an output file "testing_results.RData" in the folder used to run the tests. The tesing/scripts folder also contains a Quarto markdown file, "runTests_Report.qmd". When copied and rendered in the "runs" folder, it creates a report (pdf or html) that compares the new models results to the original results from the GMACS_Models repo using the respective par and the Gmacsall.out files. 

To run the tests:

  *  start an R session
  *  Create a `testing/runs` or other suitable `runs` folder (if it doesn't exist already)
  *  change the working directory to the `runs` folder
  *  source the "testing/scripts/runTests1.R" file
  *  run the function "runTests" for the models of interest to create "testing_results.RData"
      - set `repoDir` to the path to the GMACS_Models repo
      - set `exeDir` to the path to the gmacs executable
      - set `stocks` to the stocks of interest (as listed in "models-for_testing.csv", or NULL for all stocks)
      - set `testDir`, the top-level disctory for running the tests, to "." (because you changed the working directory to the "runs" folder)
      - set `scriptsDir`, the path to the scripts folder (from the `runs` folder, if a relative path)
      - set `usePin` as "par" or "pin" to use "gmacs.par" or "gmacs.pin" from the original model run as a pin file ("none" does not use a pin file)
      - set `compareWith` as "par" or "pin" to compare the new "gmacs.par" to the "gmacs.par" or "gmacs.pin" from the original model run ("none" does no comparison)

Example codes are given at the end of the "runTests1.R" file.

The results of the comparisons are returned as a R list, with element names corresponding to the stocks for the models tested. The returned list is also written to the testing folder as "testing_results.RData" (which will be overwritten in subsequent tests run in the same folder) and "testing_results_xxx.RData", where "xxx" indicates the date and time at which the tests finished. Each element in the returned list is also a list, with elements `lstFNs` (a list with input filenames),`pars`, `allOutNew`, and `allOutOld`. `pars` gives results from comparing the new par file with the original par (or pin) file, if the latter was available. `allOutNew` and `allOutOld` contain the lists obtained by running `wtsGMACS::readGmacsAllout` on the respective "Gmacsall.out" files.

After copying the "testing/scripts/runTests_Report.qmd" file into the testing directory: it can be rendered as a pdf or html file to provide a simple report of the comparisons. 

### old approach (pre-Jan 2025)

The `testing/scripts` folder contains an R script, `runTests.old.R`, which can also be used to test the models in a folder (the default is "../input_files" from the testing folder). To run the tests from "testing/runs" with input files in "testing/input_files": 

  *  start an R session
  *  Create a `testing/runs` folder (if it doesn't exist already)
  *  change the working directory to the `testing/runs` folder
  *  source the "testing/scripts/runTests.old.R" file
  *  run the function "runTests" for the models of interest 
      - set the `tests` input vector to the names of the subfolders containing the models you want to test
      - set the top-level directory for running the tests (the default is ".", i.e. the `testing/runs` folder)
      - set the `compareWithPin`, `verbose`, and `cleanup` flags as desired (`verbose` functionality is not yet implemented).

The function will run the models specified (copying the input files from relevant `testing/inut_files` subfolders). The output is a list with an element for each model tested. Each element indicates whether the test passed or, if not, where "substantial" differences (abs(new-old)>$10^{-5}$) occurred between the new par file and an old par file ("gmacs.par_old") or the pin file ("gmacs.pin") used to initialize the model.

## Which tools are available for working with GMACS?

Currently GMACS is linked to [`gmr`](gmacs-project.github.io/gmr/), an R package to work with GMACS in R, create plots of GMACS output, compare different models and prepare SAFE documents. Another R package which may be helpful is `wtsGMACS` (https://github.com/wStockhausen/wtsGMACS).

## Updates
### Through version 2.20.31 (2025-06-16)
 - Added gamma distribution likelihood type (`GROWTHINC_DATA_GAMMA`=4) for non-tagging molt increment data so likelihood is consistent with size transition matrices. Previous normal likelihood based on data CVs (`GROWTHINC_DATA_NORMAL`=1) is still available. 
 - Corrected logic error going back to 2.20.06 that prevented likelihood for non-tagging molt increment data from being calculated. 
 - Added option (`PWRLAW_GROWTHMODELALT`=5) and function to replicate Tanner crab mean molt increment calculations.
 - Added macro var `ZEROPOP` (=5) option to initialize numbers-at-size in start year at 0. The `logN0` array is set to -1.0e3.
 - Fixed incorrectly listed sex in gmacs_in.ctl and gmacs_out.ctl files for probability of maturing when two sex are specified. 
 - Fixed problem in `get_all_sdnr_MAR` when `d3_res_size_comps(k)` was missing (`nSizeComps(k=0)` because size comps were "extended").
 - Distinguished between tagging-related (`nloglike(5)`) and non-tagging-related growth data likelihoods (now `nloglike(6)`) in code and Gmacsall.out file. Non-tagging growth likelihoods are now output by individual observation in Gamcsall.out as a dataframe ("growth_data").
 - Added `grwthPosFun` to objective function to penalize negative growth (estimated `r`'s [shape factors] in growth-related gamma distribution).
 - Input size comps in "new" format now respect sex-specific numbers of columns: all input columns are repeated to gmacs_data (file "gmacs_in.dat"), but only the sex-specific number of columns is kept in the internal arrays.
 - Added `writeToRepFile1` flag to signal whether (=1) or not (otherwise) to write results in CheckBounds to RepFile1.
 - Added lines to `OutInpFile` noting where EXTRA PARS would be defined if they were needed (not obvious starting from a ctl file w/out EXTRA PARS).
 - Added commandline input option "-StopAfterFnCall xx" to override `StopAfterFnCall` setting in gmacs.dat file with value of "xx".
 - Converted "Double normal" as output label to "Double_normal" to be consistent w/ other output labels and facilitate parsing.
 - Added ascending normal selectivity function code to selex.hpp, `SELEX_ASCNORM`=14 to select it, and associated in/out ctl code .
 - Added survey info to gmacs_in.ctl and OutInpFile1 file output for q specification.
 - Found issue with RW parameters for selectivity when RW block group has multiple blocks. **Fixed for selectivity but may be an issue for other processes when RW parameters are specified.** 
 - Tracked down what turned out to be an uninitialized array problem (`nSizeCompRows`) that sent Windows runs off into NeverNeverLand.
 - Added logic to skip calculating length likelihoods for the size comps that are the "extended" part of other comps.
 - Revisions to enable blocks to work with catchability (`q`) parameters--many bits of code were based on assumption that q's were not blocked or time-varying. Now referring to "Relative Abundance Indices" (RAI's) and id's for such rather than "surveys" because the latter was confused between survey indices and catchability parameters. Rows for RAI's in the data file need to be appended with a `RAI id` in order to match changes in the `q` id with RAIs (might not be strictly necessary as the `q` id is given and `qToSurv(iq)` gives the id of the associated **non-mirrored** RAI; however, it doesn't give RAI's for mirrored q's).
 - Removed `CreateOutput_OldFormat`, because the revisions to enable blocks to work with catchability (`q`) parameters were inconsistent with the output.
 - Added `foffdevs_phz` vector to set phases for female offset F devs (`log_fdovs` phases had been set by `foff_phz`, but needed to be turned "off" when no female F devs were defined.) 
 - Changed `logN0` to -100 when `ZEROPOP` option is selected (had been -1000, but this proved problematic).
 - Added input for `recZ_flag` to CTL file as `model_controls(18)`. Flag determines the parameterization for recruitment size distribution in `calc_recruitment_size_distribution` (0=standard approach; 1=Tanner approach).
 - Reassigned `SELEX_UNIFORM0` and `SELX_UNIFORM1` values internally from (6,5) to (5,6) to agree with ctl file comments. 
 - **Changed usage of RW parameter definition value FOR SELECTIVITY PARAMETERS ONLY.** Was 0: RW devs off; >0: RW devs on. Now, **for selectivity parameters only**,: 
  * 0: RW devs off; 
  * 1: RW devs on w/ $newpar = refpar*exp(dev)$ [as previously]; 
  * 2: $newpar = refpar + dev$ [new option--this is the way to go for selectivity parameters that are log-transformed]. 
Also changed description for selectivity sections of output ctl files. For other parameter types, the behavior is the same as previously (**TODO: check if this behavior should be changed, as well**).
 - Added a check on the size of dataframe read in as `dSurveyData` when using original format to assure the RAI_id column has been added. After `dSurveyData` is read in, an integer `chk` is read from the input data file. **If this is not equal to 999, then an error is printed and the program exits.** 
 - Corrected an error reading parameter information for time-blocked "extra" growth parameters (this did not affect non-time-blocked growth parameters).
 - Cleaned up code in `update_population_numbers_at_length` related to recruitment, with a note for further changes. 
 - **Added note in `calc_initial_numbers_at_length` with reminder to change code if `logR0`, etc are redefined to apply to `totrecruits` (total recruits) rather than `recruits(h)` (sex-specific recruits).**
 - Renamed gmacs.rep1 output matrix from "Fully-selected_FM_by_season_sex_and_fishery" to "Fully-selected_capture_rate_by_season_sex_and_fishery" to better describe the content (which is the `ft` array). Note that $F(h,i,j)=ft(h,i,j) * vul$ is the size-specific **fishing mortality rate** (`vul` incorporates both retention mortality and discard mortality) while $F2(h,i,j) = ft(h,i,j) * sel$ is the size-specific **fishery capture rate**.
 - Added `pre_capbio` array and `calc_predicted_capture_biomass` function to facilitate export of predicted capture biomass by fishery in `CreateOutput` as "Predicted_capture_biomass-at-size". 
 - **Fixed inconsistency in how `Z` and `Z2` were assigned as `tempZ1` in `calc_predicted_catch`.**
 - Added output to gmacs.rep1 for predicted fishery capture abundance and biomass (`pre_capabd`, `pre_capbio`) by year, fleet, sex, and size from (new function) `calc_predicted_capture_abdbio`. 
 - Revised calculation of `log_q_catch` in `calc_predicted_catch` slightly, added some error checks to help debug.

 
#### Required changes to input files
 - gmacs.dat file: no changes
 - data file changes:
   * Relative Abundance Data: 
     + **If using the "old format"**, add "RAI_id" (relative abundance index id)  as the last column of the input matrix, where `RAI_id` indicates the integer id for the associated survey (note that this is not necessarily the same as the `q` id if multiple time blocks or RW behavior are specified for `q`).
     + **If using the "old format"**, append a row to the Relative Abundance Data matrix with the value 999 (the code will check for this, but doesn't otherwise use it).
 - ctl file: 
     * After the last row in "Other Controls" (the last year of bias-correction), add the recruitment size distribution option (0: standard way; 1: Tanner crab approach)
     * **If you specify selectivity types 5 or 6**, make sure they are set such that 5 = `SELEX_UNIFORM0` (sel or ret curve = 0 at all sizes) and 6 = `SELEX_UNIFORM1` (sel or ret curve = 1 at all sizes). This is consistent with how these types are described in the ctl file, but not how they were previously implemented in the GMACS TPL code.
 - prj file: no changes
 - pin file:
   * make sure `log_vn` (the vector of effective sample sizes) has the same length as the **max** index specified for the size composition aggregations specified in the ctl file
     


## NOAA Disclaimer

This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an 'as is' basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.

Software code created by U.S. Government employees is not subject to copyright in the United States (17 U.S.C. §105). The United States/Department of Commerce reserve all rights to seek and obtain copyright protection in countries other than the United States for Software authored in its entirety by the Department of Commerce. To this end, the Department of Commerce hereby grants to Recipient a royalty-free, nonexclusive license to use, copy, and create derivative works of the Software outside of the United States.

****************************

<img src="https://raw.githubusercontent.com/nmfs-general-modeling-tools/nmfspalette/main/man/figures/noaa-fisheries-rgb-2line-horizontal-small.png" height="75" alt="NOAA Fisheries">

[U.S. Department of Commerce](https://www.commerce.gov/) | [National Oceanographic and Atmospheric Administration](https://www.noaa.gov) | [NOAA Fisheries](https://www.fisheries.noaa.gov/)
