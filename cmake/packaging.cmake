# Packaging information.
include(systemidentification)

set(CPACK_PACKAGE_NAME ${PROJECT_NAME})
set(LIBXSLT_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_VERSION "${LIBXSLT_PACKAGE_VERSION}")

get_system_name(LIBXSLT_SYSTEM)
string(TOLOWER ${LIBXSLT_SYSTEM} LIBXSLT_SYSTEM_LOWERCASE)

set(LIBXSLT_ARCHITECTURE ${CMAKE_SYSTEM_PROCESSOR})
if(WIN32)
  if(CMAKE_SIZEOF_VOID_P EQUAL 4)
    set(LIBXSLT_ARCHITECTURE x86)
  else()
    set(LIBXSLT_ARCHITECTURE x64)
  endif()
endif()

if(WIN32)
  set(CPACK_GENERATOR "ZIP")
  set(CPACK_NSIS_DISPLAY_NAME "${PROJECT_NAME}")
  set(CPACK_PACKAGE_INSTALL_DIRECTORY "${PROJECT_NAME}")
  if(NSIS_FOUND)
    if(CMAKE_SIZEOF_VOID_P EQUAL 4)
      list(APPEND CPACK_GENERATOR "NSIS")
    else()
      list(APPEND CPACK_GENERATOR "NSIS64")
      set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
      set(CPACK_NSIS_PACKAGE_NAME "${CPACK_PACKAGE_INSTALL_DIRECTORY} (${LIBXSLT_ARCHITECTURE})")
      set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${CPACK_PACKAGE_NAME} ${CPACK_PACKAGE_VERSION} (${LIBXSLT_ARCHITECTURE})")
    endif()
    set(CPACK_NSIS_MODIFY_PATH "ON")
  endif()
elseif(APPLE)
  # Preserve the CMAKE_INSTALL_PREFIX for the project and work with absolute install
  set(CPACK_SET_DESTDIR ON)

  set(CPACK_RESOURCE_FILE_WELCOME "${CMAKE_CURRENT_SOURCE_DIR}/distrib/osx/welcome.txt")

  set(LIBXSLT_ARCHITECTURE "universal")
  set(CPACK_GENERATOR  "TGZ" "productbuild")
elseif(UNIX)
  # Preserve the CMAKE_INSTALL_PREFIX for the project and work with absolute install
  set(CPACK_SET_DESTDIR ON)

  set(CPACK_GENERATOR "TGZ")
  debian_based(_DEB_SYSTEM)
  redhat_based(_RPM_SYSTEM)
  if(_DEB_SYSTEM)
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Some Developers") #required
    set(CPACK_DEBIAN_PACKAGE_DEPENDS "libxml2")
    list(APPEND CPACK_GENERATOR "DEB")
  endif()
  if(_RPM_SYSTEM)
    list(APPEND CPACK_GENERATOR "RPM")
  endif()
endif()

configure_file("${PROJECT_SOURCE_DIR}/Copyright" "${CMAKE_CURRENT_BINARY_DIR}/LICENSE.txt" COPYONLY)
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_BINARY_DIR}/LICENSE.txt")
configure_file("${PROJECT_SOURCE_DIR}/README" "${CMAKE_CURRENT_BINARY_DIR}/README.txt" COPYONLY)
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_BINARY_DIR}/README.txt")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/distrib/description.txt")
set(CPACK_PACKAGE_VENDOR "cellml.org")

set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${LIBXSLT_PACKAGE_VERSION}-${LIBXSLT_ARCHITECTURE}-${LIBXSLT_SYSTEM_LOWERCASE}")
set(CPACK_OUTPUT_FILE_PREFIX "dist")

include(CPack)