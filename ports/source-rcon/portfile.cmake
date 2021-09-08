set(VCPKG_USE_HEAD_VERSION ON)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO PazerOP/SourceRCON
  HEAD_REF master
)

vcpkg_cmake_configure(
	SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_build()
vcpkg_fixup_cmake_targets()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(
	INSTALL "${SOURCE_PATH}/LICENSE.txt"
	DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
	RENAME copyright
)
