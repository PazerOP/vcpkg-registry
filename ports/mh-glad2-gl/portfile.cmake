vcpkg_check_linkage(ONLY_STATIC_LIBRARY)
set(VCPKG_USE_HEAD_VERSION ON)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO PazerOP/glad2-gl
  HEAD_REF main
)

vcpkg_cmake_configure(
	SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_copy_pdbs()
vcpkg_cmake_install()
vcpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(
	INSTALL "${SOURCE_PATH}/LICENSE"
	DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
	RENAME copyright
)
