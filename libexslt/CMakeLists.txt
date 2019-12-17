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

if(EXSLT_CRYPTO_ENABLED)
  list(APPEND LIB_SRCS
    crypto.c
    )
endif()

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
  DESTINATION include/libexslt
  COMPONENT development
)

