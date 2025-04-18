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

Currently GMACS is linked to [`gmr`](gmacs-project.github.io/gmr/), an R package to work with GMACS in R, create plots of GMACS output, compare different models and prepare SAFE documents.

## NOAA Disclaimer

This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an 'as is' basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.

Software code created by U.S. Government employees is not subject to copyright in the United States (17 U.S.C. §105). The United States/Department of Commerce reserve all rights to seek and obtain copyright protection in countries other than the United States for Software authored in its entirety by the Department of Commerce. To this end, the Department of Commerce hereby grants to Recipient a royalty-free, nonexclusive license to use, copy, and create derivative works of the Software outside of the United States.

****************************

<img src="https://raw.githubusercontent.com/nmfs-general-modeling-tools/nmfspalette/main/man/figures/noaa-fisheries-rgb-2line-horizontal-small.png" height="75" alt="NOAA Fisheries">

[U.S. Department of Commerce](https://www.commerce.gov/) | [National Oceanographic and Atmospheric Administration](https://www.noaa.gov) | [NOAA Fisheries](https://www.fisheries.noaa.gov/)
