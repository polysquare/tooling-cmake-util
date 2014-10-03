# /tests/CMakeLists.txt
# Main entry point for the tooling-cmake-util tests.
#
# See LICENCE.md for Copyright information

if (POLICY CMP0025)

    cmake_policy (SET CMP0025 NEW)

endif (POLICY CMP0025)

project (PolysquareToolingUtilTests)
cmake_minimum_required (VERSION 2.8)

# We assume that it is one-above us
set (POLYSQUARE_RELATIVE_CMAKE_DIRECTORY
     ${CMAKE_CURRENT_SOURCE_DIR}/..)
get_filename_component (POLYSQUARE_TOOLING_CMAKE_DIRECTORY
                        ${POLYSQUARE_RELATIVE_CMAKE_DIRECTORY}
                        ABSOLUTE)

set (CMAKE_UNIT_DIRECTORY
     ${POLYSQUARE_TOOLING_CMAKE_DIRECTORY}/cmake-unit)

# Put our directories into the cache as well as the parameters for the
# Google Test distribution.
set (POLYSQUARE_INITIAL_CACHE_CONTENTS
     "set (POLYSQUARE_TOOLING_CMAKE_DIRECTORY\n"
     "     ${POLYSQUARE_TOOLING_CMAKE_DIRECTORY}\n"
     "     CACHE STRING \"\" FORCE)\n"
     "set (POLYSQUARE_TOOLING_CMAKE_TESTS_DIRECTORY\n"
     "     ${CMAKE_UNIT_DIRECTORY}\n"
     "     CACHE STRING \"\" FORCE)\n"
     "set (CMAKE_C_COMPILER\n"
     "     ${CMAKE_C_COMPILER}\n"
     "     CACHE STRING \"\" FORCE)\n"
     "set (CMAKE_CXX_COMPILER\n"
     "     ${CMAKE_CXX_COMPILER}\n"
     "     CACHE STRING \"\" FORCE)\n")

set (CMAKE_MODULE_PATH
     ${CMAKE_UNIT_DIRECTORY}
     ${CMAKE_MODULE_PATH})

include (CMakeUnitRunner)

bootstrap_cmake_unit (INITIAL_CACHE_CONTENTS
                      POLYSQUARE_INITIAL_CACHE_CONTENTS)

add_cmake_test (FilterOutGeneratedSources)
add_cmake_test (HandleCheckGeneratedOptionFilter)
add_cmake_test (HandleCheckGeneratedOptionNoFilter)
add_cmake_test (StripAddCustomTargetSources)
add_cmake_test (GetTargetAttachPointForBinaryPreLink)
add_cmake_test (GetTargetAttachPointForLibraryPreLink)
add_cmake_test (GetTargetAttachPointForUtilityPreBuild)
add_cmake_test (SortCSourcesToC)
add_cmake_test (SortCXXSourcesToCXX)
add_cmake_test (SortHeadersToHeaders)
add_cmake_test (SortCHeadersToC)
add_cmake_test (SortCXXHeadersToCXX)
add_cmake_test (SortCHeadersToCXXForceLanguage)
add_cmake_test (SortCHeadersToCXXAndCWithCPPIdentifiers)
add_cmake_test (ForwardMultivarArgs)
add_cmake_test (ForwardSinglevarArgs)
add_cmake_test (ForwardOptionArgs)
add_cmake_test (AddSwitchOn)
add_cmake_test (AddSwitchOff)
add_cmake_test (AppendEachToOptionsWithPrefix)
add_cmake_test (AppendEachToGlobalProperty)
add_cmake_test (AppendEachToGlobalPropertyUnique)
add_cmake_test (GetListIntersection)
add_cmake_test (SpecialCompilationDBDefines)
add_cmake_test (SpecialCompilationDBIncludes)
add_cmake_test (SpecialCompilationDBUseCCompilerForCHeader)
add_cmake_test (SpecialCompilationDBUseCFlagsForCHeader)
add_cmake_test (SpecialCompilationDBUseCLanguageOptForCHeader)
add_cmake_test (SpecialCompilationDBUseCXXCompilerForCPPHeader)
add_cmake_test (SpecialCompilationDBUseCXXFlagsForCPPHeader)
add_cmake_test (SpecialCompilationDBUseCXXLanguageOptForCPPHeader)