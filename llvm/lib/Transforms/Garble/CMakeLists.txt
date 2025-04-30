cmake_minimum_required (VERSION 3.20)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_FLAGS "-O3 -fexceptions -pthread -Wall -Wextra -march=native -msse4.1 -mavx2 -g")

find_package(OpenSSL REQUIRED)

# EMP-tool
find_library(EMP-TOOL_LIBRARY emp-tool PATHS /usr/local/lib REQUIRED)
find_path(EMP-TOOL_INCLUDE_DIR emp-tool.h PATHS /usr/local/include)

# EMP-OT
find_path(EMP-OT_INCLUDE_DIR emp-ot/emp-ot.h PATHS /usr/local/include)


set(EPIGRAM_PATH "/workspaces/llvm-project/GAR/epigram")

include_directories(${EPIGRAM_PATH}/src)

# add_subdirectory(${EPIGRAM_PATH}/test/doctest ${EPIGRAM_PATH}/test/doctest/bin)
# add_subdirectory(${EPIGRAM_PATH}/test/rapidcheck ${EPIGRAM_PATH}/test/rapidcheck/bin)


set(EPISOURCES
  ${EPIGRAM_PATH}/src/mode.cc
  ${EPIGRAM_PATH}/src/resource.cc
  ${EPIGRAM_PATH}/src/bit.cc
  ${EPIGRAM_PATH}/src/byte.cc
  ${EPIGRAM_PATH}/src/bitstring.cc
  ${EPIGRAM_PATH}/src/arithmetic.cc
  ${EPIGRAM_PATH}/src/onehot.cc
  ${EPIGRAM_PATH}/src/permute.cc
  ${EPIGRAM_PATH}/src/stack.cc
  ${EPIGRAM_PATH}/src/simplestack.cc
  ${EPIGRAM_PATH}/src/linearscan.cc
  ${EPIGRAM_PATH}/src/epigram.cc
  ${EPIGRAM_PATH}/src/cpu.cc
)

add_llvm_component_library(LLVMGarble
  Garble.cpp
  AsParse.cpp
  Arithmetic.cc
  Bit.cpp
  Bit32.cpp
  Const.cpp
  SGCUtils.cpp
  Prf.cc

  ${EPISOURCES}

  ADDITIONAL_HEADER_DIRS
  # /workspaces/llvm-project/GAR/cryptographic_primitives
  ${LLVM_MAIN_INCLUDE_DIR}/llvm/Transforms
  ${LLVM_MAIN_INCLUDE_DIR}/llvm/Transforms/Garble
  ${EPIGRAM_PATH}/src
  # ${EPIGRAM_PATH}/test/doctest/doctest
  # ${RAPIDCHECK_INCLUDE_DIR}
  ${EMP-TOOL_INCLUDE_DIR}
  ${EMP-OT_INCLUDE_DIR}
  ${OPENSSL_INCLUDE_DIR}

  DEPENDS

  LINK_COMPONENTS
  Analysis
  Core
  Support
  TransformUtils
  # doctest
  # rapidcheck
  LINK_LIBS
  # ${PRIMITIVES}
  ${EMP-TOOL_LIBRARY}
  ${OPENSSL_LIBRARIES}
)

target_compile_options(LLVMGarble PRIVATE -fexceptions -fPIC)



  
