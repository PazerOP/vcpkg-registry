set(VCPKG_USE_HEAD_VERSION ON)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO PazerOP/imgui_cmake
  HEAD_REF main
)

find_program(GIT git)
vcpkg_execute_required_process(
	COMMAND "${GIT}" init-submodules --update --recursive
	WORKING_DIRECTORY "${SOURCE_PATH}"
)

vcpkg_configure_cmake(
	SOURCE_PATH "${SOURCE_PATH}"
	PREFER_NINJA
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(
	INSTALL "${SOURCE_PATH}/LICENSE"
	DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
	RENAME copyright
)
