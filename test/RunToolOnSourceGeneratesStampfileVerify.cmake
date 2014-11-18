# /test/RunToolOnSourceGeneratesStampfileVerify.cmake
#
# Verifies that when we ran our tool on our source file, that
# stampfile ${CMAKE_CURRENT_BINARY_DIR}/Source.cpp.Tool.stamp was created
#
# See LICENCE.md for Copyright information

include (CMakeUnit)

assert_file_exists ("${CMAKE_CURRENT_BINARY_DIR}/Source.cpp.Tool.stamp")
