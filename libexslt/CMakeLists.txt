

set(LIB_SRCS
  common.c
  date.c
  dynamic.c
  exslt.c
  functions.c
  math.c
  saxon.c
  sets.c
  strings.c
  )

set(LIB_HDRS
  exslt.h
  exsltexports.h
  libexslt.h
  )
if(WIN32 AND MSVC)
  set(EXSLT_CRYPTO_ENABLED TRUE)
endif()

if(EXSLT_CRYPTO_ENABLED)
  list(APPEND LIB_SRCS
    crypto.c
    )
endif()

set(LIBEXSLT_VERSION_MAJOR 0)
set(LIBEXSLT_VERSION_MINOR 8)
set(LIBEXSLT_VERSION_PATCH 20)
set(VERSION ${LIBEXSLT_VERSION_MAJOR}.${LIBEXSLT_VERSION_MINOR}.${LIBEXSLT_VERSION_PATCH})
pad_string(_PADDED_VERSION_MINOR 2 0 ${LIBEXSLT_VERSION_MINOR})
pad_string(_PADDED_VERSION_PATCH 2 0 ${LIBEXSLT_VERSION_PATCH})
set(LIBEXSLT_VERSION_NUMBER ${_PADDED_VERSION_MINOR}${_PADDED_VERSION_PATCH})
set(WITH_CRYPTO 0)
set(EXSLT_CONFIG_HDR ${CMAKE_CURRENT_BINARY_DIR}/exsltconfig.h)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/exsltconfig.h.in ${EXSLT_CONFIG_HDR} @ONLY)

add_library(exslt ${LIB_SRCS} ${LIB_HDRS})
target_include_directories(exslt PRIVATE ${PROJECT_BINARY_DIR})
target_include_directories(exslt PUBLIC
  $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
  $<INSTALL_INTERFACE:include>
  )
target_link_libraries(exslt PUBLIC xslt)

if(TARGET xml2)
  target_link_libraries(exslt PUBLIC xml2)
else()
  target_include_directories(exslt PUBLIC ${LIBXML2_INCLUDE_DIR})
  target_link_libraries(exslt PUBLIC ${LIBXML2_LIBRARIES})
  target_compile_definitions(exslt PUBLIC ${LIBXML2_DEFINITIONS})
endif()

install(TARGETS exslt EXPORT libxslt-targets
  COMPONENT runtime
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)

install(FILES
  exslt.h
  ${EXSLT_CONFIG_HDR}
  DESTINATION include/libexslt
  COMPONENT development
)

