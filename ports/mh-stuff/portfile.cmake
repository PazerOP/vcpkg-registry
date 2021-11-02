set(VCPKG_USE_HEAD_VERSION ON)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO PazerOP/stuff
  REF 57724f298723da2387105845245a0a29a61b00e3
  SHA512 2987FC9B31650BAED581415AB8142EB93880C7A34B267459CD14D963ECED900582F627997C580D8DD6A2E10CC21BD5A267B88E086A4599450EA2702760E0CC88
)

vcpkg_cmake_configure(
	SOURCE_PATH "${SOURCE_PATH}"
	OPTIONS -DBUILD_SHARED_LIBS=ON;-DBUILD_TESTING=OFF
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

