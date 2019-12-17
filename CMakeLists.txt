
cmake_minimum_required(VERSION 3.10)

set(PROJECT_NAME libXslt)
project(${PROJECT_NAME} VERSION 1.1.34 LANGUAGES C)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

get_property(IS_MULTI_CONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

option(BUILD_SHARED_LIBS "Build libraries as shared objects if true." ON)
option(WITHOUT_DEBUGGER "Build without debuging output." OFF)
option(WITHOUT_PROFILER "Build without profilling support." ON)

set(_PARAM_ANNOTATION "Install path prefix, prepended onto install directories.")
set(LIBXSLT_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX} CACHE PATH ${_PARAM_ANNOTATION})
if(DEFINED INSTALL_PREFIX)
  set(LIBXSLT_INSTALL_PREFIX ${INSTALL_PREFIX} CACHE PATH ${_PARAM_ANNOTATION} FORCE)
endif()
unset(INSTALL_PREFIX CACHE)

if(NOT IS_MULTI_CONFIG)
  set(_PARAM_ANNOTATION "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release RelWithDebInfo MinSizeRel.")
  set(LIBXSLT_BUILD_TYPE "Debug" CACHE STRING ${_PARAM_ANNOTATION})
  if(DEFINED BUILD_TYPE)
    set(LIBXSLT_BUILD_TYPE ${BUILD_TYPE} CACHE STRING ${_PARAM_ANNOTATION} FORCE)
  endif()
  unset(BUILD_TYPE CACHE)
endif()

file(TO_CMAKE_PATH ${LIBXSLT_INSTALL_PREFIX} _CMAKE_INSTALL_PREFIX)
set(CMAKE_INSTALL_PREFIX ${_CMAKE_INSTALL_PREFIX} CACHE INTERNAL "Internalise CMAKE_INSTALL_PREFIX, manipulate via LIBXSLT_INSTALL_PREFIX" FORCE)
set(CMAKE_BUILD_TYPE ${LIBXSLT_BUILD_TYPE} CACHE INTERNAL "Internalise CMAKE_BUILD_TYPE, manipulate via LIBXSLT_BUILD_TYPE" FORCE)

mark_as_advanced(CMAKE_CONFIGURATION_TYPES)
mark_as_advanced(CMAKE_CODEBLOCKS_EXECUTABLE)
mark_as_advanced(QT_QMAKE_EXECUTABLE)
mark_as_advanced(CMAKE_EXECUTABLE_FORMAT)
mark_as_advanced(CMAKE_PREFIX_PATH)
if(APPLE)
  mark_as_advanced(CMAKE_OSX_ARCHITECTURES)
  mark_as_advanced(CMAKE_OSX_DEPLOYMENT_TARGET)
  mark_as_advanced(CMAKE_OSX_SYSROOT)
endif()

include(environmentchecks)

if(NOT WIN32 AND NOT MSVC)
  set(CONFIG_HDR ${CMAKE_CURRENT_BINARY_DIR}/config.h)
  configure_file(${PROJECT_SOURCE_DIR}/cmake/config.in.h ${CONFIG_HDR})
endif()

add_subdirectory(libxslt)
add_subdirectory(libexslt)
add_subdirectory(xsltproc)


include(CMakePackageConfigHelpers)

set(BUILD_TREE_CONFIG_DIR ${PROJECT_BINARY_DIR})
set(LIBXSLT_CONFIG_VERSION_FILE "${BUILD_TREE_CONFIG_DIR}/libxslt-config-version.cmake")
write_basic_package_version_file(
  ${LIBXSLT_CONFIG_VERSION_FILE}
  VERSION ${LIBXSLT_VERSION}
  COMPATIBILITY AnyNewerVersion
)

set(LIBXSLT_CONFIG_CMAKE_FILE "${BUILD_TREE_CONFIG_DIR}/libxslt-config.cmake")
file(WRITE "${LIBXSLT_CONFIG_CMAKE_FILE}" "include(\"\${CMAKE_CURRENT_LIST_DIR}/libxslt-targets.cmake\")\n")

set(LIBXSLT_TARGETS_FILE "${BUILD_TREE_CONFIG_DIR}/libxslt-targets.cmake")
export(EXPORT libxslt-targets FILE ${LIBXSLT_TARGETS_FILE})

if(WIN32)
  set(CONFIG_PACKAGE_LOCATION ${PROJECT_NAME}/CMake)
else()
  set(CONFIG_PACKAGE_LOCATION lib/cmake/${PROJECT_NAME})
endif()

install(FILES
  ${LIBXSLT_TARGETS_FILE}
  ${LIBXSLT_CONFIG_CMAKE_FILE}
  ${LIBXSLT_CONFIG_VERSION_FILE}
  DESTINATION ${CONFIG_PACKAGE_LOCATION}
  COMPONENT development
  )

include(packaging)
