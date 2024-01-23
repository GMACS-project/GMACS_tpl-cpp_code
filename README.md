# GMACS_tpl-cpp_code

This is a repository with GMACS tpl and C++ source code only. The base code was distributed by Andre Punt on Jan. 18, 2024 following the Jnauary 2024 Crab Modeling Workshop in Anchorage, AK. This repository is a bit "cleaner" than the [GMACS_Assessment_code](https://github.com/GMACS-project/GMACS_Assessment_code) repository because it contains **only** the base tpl code, a template for the personal.tpl code, the src and include sub-folders with c++ code, and a platform-independent CMake file to make the gmacs executable. 

The intention of this repository is to restrict it to only the tpl and c++ code in the top-level folder, the `src` and `include` sub-folders, and a `tests` sub-folder. Developers should create branches off the main branch to develop and test code, then merge their changes back into the main branch after testing is successful. **DO NOT** create parallel folder structures on the main branch (as in the GMACS_Assessment_code repository).

## Installation and compilation

GMACS uses the [AD Model Builder](http://www.admb-project.org) C++ libraries, so these must be installed prior to installing and using GMACS. GMACS also provides a script for platform-independent installation using CMake. 

For Windows users, it is recommended to install [RTools](https://cran.r-project.org/bin/windows/Rtools/rtools43/rtools.html) to provide compilers to build the ADMB libraries, a cmake executable, and unix-like shell functions for various file manipulation tasks. After installing RTools, the user should add the folder containing `g++.exe` to their Windows PATH and add an environment variable `RToolsUsr` with the path to the `Rtools`/bin folder (where `RTools` is the top-level folder to which RTools was installed).

For Mac OSX users, a cmake executable script and gui can be installed from https://cmake.org/download/.

Once ADMB has been compiled, create the environment variable ADMB_HOME and set it equal to the path to the `admb` sub-folder of the `build` directory (i.e., the folder that contains `bin`, `include`, and `lib`). Also, copy (or rename) the libadm-contrib.xxxx.a file in the `lib` sub-folder to libadmb-contrib.a.

To compile the GMACS executable, open a command prompt (Windows) or terminal widow (Mac OSX) and change directory to the top-level GMACS directory (i.e., the one that contains the gmacsbase.tpl, personal.tpl, and CMakeLists.txt files). Then run the following commands:

    * cmake -S . -B _build
    * cmake --build _build

The first command creates the `_build` subfolder and the Makefile appropriate for the given platform. The second command builds the project by running the Makefile and (if successful) copies the gmacsbase and personal tpl files to `_build`, concatenates them as gmacs.tpl, calls tpl2cpp on gmacs.tpl to create the associated .cpp and .htp files, and finally compiles the source and header files to create the gmacs executble in the `_build` folder (`gmacs` on Mac OSX and `gmacs.exe` on Windows).

## Which tools are available for working with GMACS?

Currently GMACS is linked to [`gmr`](gmacs-project.github.io/gmr/), an R package to work with GMACS in R, create plots of GMACS output, compare different models and prepare SAFE documents.

## NOAA Disclaimer

This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an 'as is' basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.

Software code created by U.S. Government employees is not subject to copyright in the United States (17 U.S.C. §105). The United States/Department of Commerce reserve all rights to seek and obtain copyright protection in countries other than the United States for Software authored in its entirety by the Department of Commerce. To this end, the Department of Commerce hereby grants to Recipient a royalty-free, nonexclusive license to use, copy, and create derivative works of the Software outside of the United States.

****************************

<img src="https://raw.githubusercontent.com/nmfs-general-modeling-tools/nmfspalette/main/man/figures/noaa-fisheries-rgb-2line-horizontal-small.png" height="75" alt="NOAA Fisheries">

[U.S. Department of Commerce](https://www.commerce.gov/) | [National Oceanographic and Atmospheric Administration](https://www.noaa.gov) | [NOAA Fisheries](https://www.fisheries.noaa.gov/)
