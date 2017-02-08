project(nheqminer)
set(APPLICATION_NAME "nheqminer")

cmake_minimum_required(VERSION 3.5)
set(CMAKE_COLOR_MAKEFILE ON)

## Extra cmake files
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")
message("-- Add LOCAL_CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")

## Lot of things has to be properly fixed/added or removed, this needs clean up.

set(CMAKE_CXX_FLAGS "-std=c++1z ${CMAKE_CXX_FLAGS} -Wall -Wextra -Wformat -Wformat-security -Wno-unused-parameter -pipe -g -Wstack-protector -fstack-protector-all -fPIE -fvisibility=hidden -fvisibility-inlines-hidden")

## Enable solvers here
#### older slower
option(USE_CPU_TROMP "USE CPU_TROMP" OFF)
option(USE_CUDA_TROMP "USE CUDA_TROMP" OFF)
#### faster
option(USE_CPU_XENONCAT "USE CPU_XENONCAT" ON)
option(USE_CUDA_DJEZO "USE CUDA_DJEZO" OFF)

## Add solvers here
if (USE_CPU_TROMP)
    add_definitions(-DUSE_CPU_TROMP)
    message("-- USE_CPU_TROMP DEFINED")
endif()
if (USE_CPU_XENONCAT)
    add_definitions(-DUSE_CPU_XENONCAT)
    message("-- USE_CPU_XENONCAT DEFINED")
endif()
if (USE_CUDA_TROMP)
    add_definitions(-DUSE_CUDA_TROMP)
    message("-- USE_CUDA_TROMP DEFINED")
endif()
if (USE_CUDA_DJEZO)
    add_definitions(-DUSE_CUDA_DJEZO)
    message("-- USE_CUDA_DJEZO DEFINED")
endif()

########
# LINUX
if(CMAKE_COMPILER_IS_GNUCXX)
  # use native cpu features
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=native -fPIC")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native -fPIC")

  # optimizations
  add_definitions(-g0 -Ofast)
endif()
########
# AppleClang
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    # use native cpu features
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-self-assign -march=native -fPIC")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-self-assign -march=native -fPIC")

    # optimizations
    add_definitions(-g0 -Ofast)
endif()

# Common
include_directories(${nheqminer_SOURCE_DIR}/nheqminer)

# BOOST
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
set(BUILD_SHARED_LIBRARIES OFF)

find_library(SSL_LIB libssl.a REQUIRED)
find_library(CRYPTO_LIB libcrypto.a REQUIRED)

set(sodium_USE_STATIC_LIBS ON)
find_package(Sodium REQUIRED)
if (sodium_FOUND)
  include_directories(SYSTEM ${sodium_INCLUDE_DIR})
  link_directories(${sodium_LIBRARY_DIRS})
else ()
  message("-- sodium NOT FOUND")
endif ()

set(Threads_USE_STATIC_LIBS ON)
find_package(Threads REQUIRED)
if (Threads_FOUND)
  include_directories(SYSTEM ${Threads_INCLUDE_DIR})
  link_directories(${Threads_LIBRARY_DIRS})
else ()
  message("-- Threads NOT FOUND")
endif ()

# compile boost staticaly
set(Boost_USE_STATIC_LIBS ON)
find_package(Boost REQUIRED COMPONENTS log_setup log date_time filesystem thread regex chrono atomic system)
if (Boost_FOUND)
  # From the offical documentation:
  # Add include directories to the build. [...] If the SYSTEM option is given,
  # the compiler will be told the directories are meant as system include
  # directories on some platforms (signalling this setting might achieve effects
  # such as the compiler skipping warnings [...])."
  include_directories(SYSTEM ${Boost_INCLUDE_DIR})

  # From the offical documentation:
  # "Specify directories in which the linker will look for libraries. [...] Note
  # that this command is rarely necessary. Library locations returned by
  # find_package() and find_library() are absolute paths. Pass these absolute
  # library file paths directly to the target_link_libraries() command. CMake
  # will ensure the linker finds them."
  link_directories(${Boost_LIBRARY_DIRS})
else()
    message("-- Boost NOT FOUND")
endif ()

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR}/../)

set(SOURCE_FILES
    # sources
    nheqminer/amount.cpp
    nheqminer/api.cpp
    nheqminer/arith_uint256.cpp
    nheqminer/crypto/sha256.cpp
    nheqminer/json/json_spirit_reader.cpp
    nheqminer/json/json_spirit_value.cpp
    nheqminer/json/json_spirit_writer.cpp
    nheqminer/libstratum/ZcashStratum.cpp
    nheqminer/main.cpp
    nheqminer/primitives/block.cpp
    nheqminer/speed.cpp
    nheqminer/uint256.cpp
    nheqminer/utilstrencodings.cpp
    # headers
    nheqminer/amount.h
    nheqminer/api.hpp
    nheqminer/arith_uint256.h
    nheqminer/crypto/sha256.h
    nheqminer/hash.h
    nheqminer/json/json_spirit.h
    nheqminer/json/json_spirit_error_position.h
    nheqminer/json/json_spirit_reader.h
    nheqminer/json/json_spirit_reader_template.h
    nheqminer/json/json_spirit_stream_reader.h
    nheqminer/json/json_spirit_utils.h
    nheqminer/json/json_spirit_value.h
    nheqminer/json/json_spirit_writer.h
    nheqminer/json/json_spirit_writer_template.h
    nheqminer/libstratum/StratumClient.cpp
    nheqminer/libstratum/StratumClient.h
    nheqminer/libstratum/ZcashStratum.cpp
    nheqminer/libstratum/ZcashStratum.h
    nheqminer/primitives/block.h
    nheqminer/primitives/transaction.h
    nheqminer/script/script.h
    nheqminer/serialize.h
    nheqminer/speed.hpp
    nheqminer/streams.h
    nheqminer/support/allocators/zeroafterfree.h
    nheqminer/threadsafety.h
    nheqminer/tinyformat.h
    nheqminer/uint252.h
    nheqminer/uint256.h
    nheqminer/utilstrencodings.h
    nheqminer/version.h
    nheqminer/zcash/JoinSplit.hpp
    nheqminer/zcash/NoteEncryption.hpp
    nheqminer/zcash/Proof.hpp
    nheqminer/zcash/Zcash.h
    nheqminer/SolverStub.h # just a stub

    nheqminer/AvailableSolvers.h
    nheqminer/ISolver.h
    nheqminer/Solver.h
    nheqminer/MinerFactory.h
    nheqminer/MinerFactory.cpp

    # make same path on windows
    #blake shared
    # src
    blake2/blake2bx.cpp
    # headers
    blake2/blake2.h
    blake2/blake2b-load-sse2.h
    blake2/blake2b-load-sse41.h
    blake2/blake2b-round.h
    blake2/blake2-config.h
    blake2/blake2-impl.h
    blake2/blake2-round.h
    )

if (CMAKE_COMPILER_IS_GNUCXX)
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -std=c++1z -lpthread -lssl -lcrypto -lsodium")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lboost_log_setup -lboost_log -lboost_date_time -lboost_filesystem -lboost_thread -lboost_regex -lboost_chrono -lboost_atomic -lboost_system")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static -static-libgcc -static-libstdc++")
endif ()
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -std=c++1z -lpthread  -lssl -lcrypto -lsodium")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lboost_log_setup-mt -lboost_log-mt -lboost_date_time-mt -lboost_filesystem-mt -lboost_thread-mt -lboost_regex-mt -lboost_chrono-mt -lboost_atomic-mt -lboost_system-mt")
endif ()
set(LIBS ${LIBS} ${SSL_LIB} ${CRYPTO_LIB} ${sodium_LIBRARY_RELEASE} ${Threads_LIBRARIES} ${Boost_LIBRARIES})

message("-- CXXFLAGS: ${CMAKE_CXX_FLAGS}")
message("-- LIBS: ${LIBS}")

if (USE_CPU_TROMP)
    add_subdirectory(cpu_tromp)
endif()
if (USE_CPU_XENONCAT)
    add_subdirectory(cpu_xenoncat)
endif()
if (USE_CUDA_TROMP)
    add_subdirectory(cuda_tromp)
endif()
if (USE_CUDA_DJEZO)
    add_subdirectory(cuda_djezo)
endif()

add_executable(${PROJECT_NAME} ${SOURCE_FILES})

#target_link_libraries(${PROJECT_NAME} ${LIBS} ${CUDA_LIBRARIES} )
target_link_libraries(${PROJECT_NAME} ${CMAKE_THREAD_LIBS_INIT} ${LIBS} )

# link libs
if (USE_CPU_TROMP)
    target_link_libraries(${PROJECT_NAME} cpu_tromp)
endif()

if (USE_CPU_XENONCAT)

  if(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
      set (CPU_XENONCAT_DIR "MacOSX")
  else()
      set (CPU_XENONCAT_DIR "asm_linux")
  endif()

      set(XENONCAT_BUILD_DIR "${CMAKE_CURRENT_SOURCE_DIR}/cpu_xenoncat/${CPU_XENONCAT_DIR}")
      message("${XENONCAT_BUILD_DIR}")
      set(XENONCAT_AVX1_OBJECT "${XENONCAT_BUILD_DIR}/equihash_avx1.o")
      set(XENONCAT_AVX2_OBJECT "${XENONCAT_BUILD_DIR}/equihash_avx2.o")

      add_custom_target(
          cpu_xenoncat_ojbects ALL
          #OUTPUT equihash_avx1.o
          #OUTPUT equihash_avx2.o
          COMMAND ${CMAKE_MAKE_PROGRAM}
          WORKING_DIRECTORY ${XENONCAT_BUILD_DIR}
          COMMENT "Building ASM CPU_XenonCat AVX Object files"
      )
      #add_library (xenoncat_avx1 STATIC equihash_avx1.o)
      add_library (xenoncat_avx1 SHARED IMPORTED GLOBAL)
      set_property(TARGET xenoncat_avx1 APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
      set_source_files_properties(
        equihash_avx1.o
        PROPERTIES
        EXTERNAL_OBJECT true
        GENERATED true
      )
      set_target_properties (
          xenoncat_avx1
          PROPERTIES
          LINKER_LANGUAGE CXX
          IMPORTED_LOCATION_NOCONFIG "${XENONCAT_AVX1_OBJECT}"
      )

      #add_library (xenoncat_avx2 STATIC equihash_avx2.o)
      add_library (xenoncat_avx2 SHARED IMPORTED GLOBAL)
      set_source_files_properties(
        equihash_avx2.o
        PROPERTIES
        EXTERNAL_OBJECT true
        GENERATED true
      )
      set_target_properties (
          xenoncat_avx2
          PROPERTIES
          LINKER_LANGUAGE CXX
          IMPORTED_LOCATION_NOCONFIG "${XENONCAT_AVX2_OBJECT}"
      )
      add_dependencies(xenoncat_avx1 xenoncat_avx2 cpu_xenoncat_ojbects)

    target_link_libraries(${PROJECT_NAME} cpu_xenoncat xenoncat_avx1 xenoncat_avx2)
endif()

if (USE_CUDA_TROMP)
    target_link_libraries(${PROJECT_NAME} cuda_tromp)
endif()
if (USE_CUDA_DJEZO)
    target_link_libraries(${PROJECT_NAME} cuda_djezo)
endif()
