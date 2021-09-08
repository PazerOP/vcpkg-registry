set(VCPKG_USE_HEAD_VERSION ON)

vcpkg_from_git(
  OUT_SOURCE_PATH SOURCE_PATH
  URL https://github.com/PazerOP/imgui_cmake.git
  HEAD_REF main
)

find_program(GIT git)
vcpkg_execute_required_process(
	COMMAND "${GIT}" submodule update --init --recursive
	WORKING_DIRECTORY "${SOURCE_PATH}"
	LOGNAME imgui-cmake_submodule_update
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
