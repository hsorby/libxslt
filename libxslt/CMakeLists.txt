
include(padstring)

set(LIB_SRCS
  attributes.c
  attrvt.c
  documents.c
  extensions.c
  extra.c
  functions.c
  imports.c
  keys.c
  namespaces.c
  numbers.c
  pattern.c
  preproc.c
  security.c
  templates.c
  transform.c
  variables.c
  xslt.c
  xsltlocale.c
  xsltutils.c
  )

set(LIB_INTERNAL_HDRS
  libxslt.h
  trio.h
  triodef.h
  )

set(LIB_API_HDRS
  attributes.h
  documents.h
  extensions.h
  extra.h
  functions.h
  imports.h
  keys.h
  namespaces.h
  numbersInternals.h
  pattern.h
  preproc.h
  security.h
  templates.h
  transform.h
  variables.h
  xslt.h
  xsltInternals.h
  xsltexports.h
  xsltlocale.h
  xsltutils.h
  )

if (WIN32)
  list(APPEND LIB_HDRS
    win32config.h
    xsltwin32config.h
    )
endif()

set(VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH})
pad_string(_PADDED_VERSION_MINOR 2 0 ${PROJECT_VERSION_MINOR})
pad_string(_PADDED_VERSION_PATCH 2 0 ${PROJECT_VERSION_PATCH})
set(LIBXSLT_VERSION_NUMBER ${PROJECT_VERSION_MAJOR}${_PADDED_VERSION_MINOR}${_PADDED_VERSION_PATCH})
set(WITH_XSLT_DEBUG 1)
set(WITH_MEM_DEBUG 0)
set(WITH_TRIO 0)
set(WITH_DEBUGGER 1)
if(WITHOUT_DEBUGGER)
  set(WITH_DEBUGGER 0)
endif()
set(WITH_PROFILER 1)
if(WITHOUT_PROFILER)
  set(WITH_PROFILER 0)
endif()
set(WITH_MODULES 1)
set(LIBXSLT_DEFAULT_PLUGINS_PATH ${CMAKE_INSTALL_PREFIX}/libxslt)
set(XSLT_CONFIG_HDR ${CMAKE_CURRENT_BINARY_DIR}/xsltconfig.h)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/xsltconfig.h.in ${XSLT_CONFIG_HDR} @ONLY)

add_library(xslt ${LIB_SRCS} ${LIB_INTERNAL_HDRS} ${LIB_API_HDRS} ${CONFIG_HDR} ${XSLT_CONFIG_HDR})
target_include_directories(xslt PRIVATE ${PROJECT_BINARY_DIR})
target_include_directories(xslt PUBLIC
  $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
  $<INSTALL_INTERFACE:include>
  )

if(TARGET xml2)
  target_link_libraries(xslt PUBLIC xml2)
else()
  target_include_directories(xslt PUBLIC ${LIBXML2_INCLUDE_DIR})
  target_link_libraries(xslt PUBLIC ${LIBXML2_LIBRARIES})
  target_compile_definitions(xslt PUBLIC ${LIBXML2_DEFINITIONS})
endif()

install(TARGETS xslt EXPORT libxslt-targets
  COMPONENT runtime
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)

install(FILES
  ${LIB_API_HDRS}
  ${XSLT_CONFIG_HDR}
  DESTINATION include/libxslt
  COMPONENT development
)
