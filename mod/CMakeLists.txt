cmake_minimum_required(VERSION 3.9)

project(MCSimMod)

if (NOT MSVC)
  message(FATAL_ERROR "Only MSVC is currently supported.")
endif ()

if (${CMAKE_SIZEOF_VOID_P} EQUAL "8")
  set (MCSIM_ARCH "x64")
else ()
  set (MCSIM_ARCH "x86")
endif ()

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/..)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../deps/libSBML/${MCSIM_ARCH}/include)

link_directories(${CMAKE_CURRENT_SOURCE_DIR}/../deps/libSBML/${MCSIM_ARCH}/lib)

add_definitions(-DLIBSBML_STATIC) # NB: it must be static lib with non-static MSVC runtime

add_definitions(
  -D_CRT_SECURE_NO_WARNINGS
  /wd4018 # 'expression' : signed/unsigned mismatch 
  /wd4267 # 'var' : conversion from 'size_t' to 'type', possible loss of data
  /wd4311 # 'variable' : pointer truncation from 'type' to 'type'
  /wd4312 # 'operation' : conversion from 'type1' to 'type2' of greater size 
  /wd4700 # uninitialized local variable 'name' used  ('pvm' in modisbml.c:754,1174)
  )

file(GLOB headers *.h)
file(GLOB source *.c)

add_executable(mod ${source} ${headers})

target_link_libraries(mod expat.lib libbz2.lib libcheck.lib libiconv.lib libsbml-static.lib libxml2.lib xerces-c_3.lib zdll.lib Ws2_32.lib)

install(TARGETS mod DESTINATION "${MCSIM_ARCH}")
set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/../bin")
