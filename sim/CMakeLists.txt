cmake_minimum_required(VERSION 3.9)

project(MCSimSim)

if (NOT MSVC)
  message(FATAL_ERROR "Only MSVC is currently supported.")
endif ()

if (${CMAKE_SIZEOF_VOID_P} EQUAL "8")
  set (MCSIM_ARCH "x64")
else ()
  set (MCSIM_ARCH "x86")
endif ()

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/.)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/..)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../deps/gsl/${MCSIM_ARCH}/include)

link_directories(${CMAKE_CURRENT_SOURCE_DIR}/../deps/gsl/${MCSIM_ARCH}/lib)

add_definitions(
  -D_CRT_SECURE_NO_WARNINGS
  /wd4244 # 'conversion' conversion from 'type1' to 'type2', possible loss of data
  /wd4267 # 'var' : conversion from 'size_t' to 'type', possible loss of data
  )

set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} /NODEFAULTLIB:MSVCRT")

file(GLOB headers *.h)
file(GLOB source *.c)

add_executable(sim ${source} ${headers} ${CMAKE_CURRENT_SOURCE_DIR}/../deps/model/src/model.c)

target_link_libraries(sim gslcblas.lib gsl.lib)

install(TARGETS sim DESTINATION "${MCSIM_ARCH}")
set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/../bin")
