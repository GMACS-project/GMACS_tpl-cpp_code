cmake_minimum_required(VERSION 3.24)

project(
    gmacs
    LANGUAGES CXX
    VERSION 2.01.08
    DESCRIPTION "CMake script to build GMACS"
)

set(CMAKE_VERBOSE_MAKEFILE TRUE)

message(" Using CMAKE version ${CMAKE_VERSION}")

#--set some local variables (relative paths relative to the build directory)
set(ADMB_HOME $ENV{ADMB_HOME})
set(TPL "gmacs")
set(TPL_BASE "../${TPL}base.TPL")
set(TPL_PERSONAL "../personal.TPL")
set(GMACS_INCLUDE "include")
set(GMACS_SRC "src")
set(myCXX_FLAGS "-DUSE_ADMB_CONTRIBS")

#--print some informative messages
message("  Project:   '${PROJECT_NAME}'")
message("  Source:    '${PROJECT_SOURCE_DIR}'")
message("  Binary:    '${PROJECT_BINARY_DIR}'")
message("  Version:   '${PROJECT_VERSION}'")
message("  Host:      '${CMAKE_HOST_SYSTEM_NAME}'")
message("  C:         '${CMAKE_C_COMPILER}'")
message("  C++:       '${CMAKE_CXX_COMPILER}'")
message("  ADMB_HOME: '${ADMB_HOME}'")

#--set some host-specific commands
set(CAT "cat")
if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")
    set(CP "$ENV{RToolsUsr}/bin/cat")
endif()

message(" --Concatenate command: '${CAT}'")

#--add directory-wide compile options (all compiler languages)
add_compile_options(
   -Wall
   -Wno-unused-variable 
   -Wno-unused-but-set-variable
)

#--add external executables; set associated locations
add_executable(tpl2cpp IMPORTED)
set_property(
    TARGET tpl2cpp
    PROPERTY IMPORTED_LOCATION 
        "${ADMB_HOME}/bin/tpl2cpp"
)
add_executable(tpl2rem IMPORTED)
set_property(
    TARGET tpl2rem 
    PROPERTY IMPORTED_LOCATION 
        "${ADMB_HOME}/bin/tpl2rem"
)

#--add external libraries
add_library(libadmb STATIC IMPORTED)
set_property(
    TARGET libadmb 
    PROPERTY IMPORTED_LOCATION 
        "${ADMB_HOME}/lib/libadmb-contrib.a"
)
include_directories(
    "${PROJECT_BINARY_DIR}"         #--for gmacs.htp
    "${ADMB_HOME}/include"
    "${ADMB_HOME}/include/contrib"
    #"${GMACS_INCLUDE}"
    "${PROJECT_SOURCE_DIR}"
)

#--add target to create gmacs.tpl 
add_custom_command(
    OUTPUT ${TPL}.tpl
    COMMAND ${CAT}  ${TPL_BASE} ${TPL_PERSONAL} > ${TPL}.tpl        
    DEPENDS "${TPL_BASE}"
            "${TPL_PERSONAL}"
    COMMENT "Creating ${TPL}.tpl from ${TPL_BASE} and ${TPL_PERSONAL}."
)

#--add target to create .ccp and .htp files from tpl (TODO?: add logic for tpl2rem)
add_custom_command(
    OUTPUT ${TPL}.cpp ${TPL}.htp
    COMMAND tpl2cpp "${TPL}"
    DEPENDS "${TPL}.tpl"
    COMMENT "Creating ${TPL}.cpp and ${TPL}.htp from ${TPL}.tpl using tpl2cpp."
)

add_executable(${TPL} ${TPL}.cpp ${TPL}.htp)
#--add preprocessor flags (no -D)
target_compile_definitions(${TPL} 
    PUBLIC USE_ADMB_CONTRIBS
    PUBLIC _USE_MATH_DEFINES
    PUBLIC USE_ALT_CTL_FILE
)
#--add compiler flags
target_compile_options(${TPL} 
    PUBLIC -O3
    PUBLIC -Wno-unused-variable 
    PUBLIC -Wno-unused-but-set-variable
)
#--add compiler features
target_compile_features(${TPL} PUBLIC cxx_std_17)
#--add target include directories 
#--NOTE: (${GMACS_INCLUDE} already in global include_directories)
# target_include_directories(${TPL} PUBLIC xxx)
#--add additional sources to target 
#--TODO?: could move this to CMakeLists file in ${GMACS_SRC}??
target_sources(${TPL} 
    PUBLIC "${GMACS_SRC}/DatFileReader.cpp"
    PUBLIC "${GMACS_SRC}/dirichlet.cpp"
    PUBLIC "${GMACS_SRC}/equilibrium.cpp"
    PUBLIC "${GMACS_SRC}/moltIncrement.cpp"
    PUBLIC "${GMACS_SRC}/multinomial.cpp"
    PUBLIC "${GMACS_SRC}/nloglike.cpp"
    PUBLIC "${GMACS_SRC}/robust_multi.cpp"
    PUBLIC "${GMACS_SRC}/spr.cpp"
    PUBLIC "${GMACS_SRC}/tailcompression.cpp"
)

target_link_libraries(${TPL} PUBLIC libadmb)