set(VCPKG_USE_HEAD_VERSION ON)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO PazerOP/stuff
  REF 8ef31153dce1c9593d59fe7fb731fca4d15f3fa6
  SHA512 EC321827F72C1D9498EEE3BEDFAFF18ECC8CAE67251CCAF95388BB22977FB4CFCFE3F20F148E7730481A3F110D7A620DEC396A486777442D92AC1DCDA22FB2C5
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


