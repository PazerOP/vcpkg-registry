file(INSTALL
	"${CMAKE_CURRENT_LIST_DIR}/vcpkg-port-config.cmake"
	"${CMAKE_CURRENT_LIST_DIR}/mh-cmake-common-config.cmake"
    "${CMAKE_CURRENT_LIST_DIR}/mh-CheckCoroutineSupport.cmake"
    "${CMAKE_CURRENT_LIST_DIR}/mh-CheckCoroutineSupport.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/mh-CheckUnicodeSupport.cmake"
    "${CMAKE_CURRENT_LIST_DIR}/mh-CheckUnicodeSupport.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/mh-BasicInstall-config.cmake.in"
    "${CMAKE_CURRENT_LIST_DIR}/mh-BasicInstall.cmake"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

set(VCPKG_POLICY_EMPTY_PACKAGE enabled)
