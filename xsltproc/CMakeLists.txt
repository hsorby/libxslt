
add_executable(xsltproc xsltproc.c)
target_link_libraries(xsltproc PUBLIC exslt)
target_include_directories(xsltproc PRIVATE ${PROJECT_BINARY_DIR})

install(TARGETS xsltproc EXPORT libxslt-targets
  COMPONENT runtime
  RUNTIME DESTINATION bin
)
