set(VCPKG_USE_HEAD_VERSION ON)

# vcpkg_from_git(
#   OUT_SOURCE_PATH SOURCE_PATH
#   URL https://github.com/PazerOP/imgui_cmake.git
#   HEAD_REF main
# )

find_program(GIT git)
# vcpkg_execute_required_process(
# 	COMMAND "${GIT}" rev-parse FETCH_HEAD
# 	WORKING_DIRECTORY "${SOURCE_PATH}"
# 	LOGNAME imgui-cmake_rev-parse
# 	OUTPUT_VARIABLE IMGUI_CMAKE_HEAD_REF
# )
# vcpkg_execute_required_process(
# 	COMMAND "${GIT}" checkout --recurse-submodules ${IMGUI_CMAKE_HEAD_REF}
# 	WORKING_DIRECTORY "${SOURCE_PATH}"
# 	LOGNAME imgui-cmake_checkout
# )
# vcpkg_execute_required_process(
# 	COMMAND "${GIT}" submodule update --init --recursive
# 	WORKING_DIRECTORY "${SOURCE_PATH}"
# 	LOGNAME imgui-cmake_submodule_update
# )
set(SOURCE_PATH "${CURRENT_BUILDTREES_DIR}/src/head")
file(REMOVE_RECURSE "${SOURCE_PATH}")
file(MAKE_DIRECTORY "${SOURCE_PATH}")
vcpkg_execute_required_process(
	COMMAND "${GIT}" clone https://github.com/PazerOP/imgui_cmake.git . --depth 1 --recurse-submodules
	WORKING_DIRECTORY "${SOURCE_PATH}"
	LOGNAME imgui-cmake_git_clone
)

vcpkg_cmake_configure(
	SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_copy_pdbs()
vcpkg_cmake_build()
vcpkg_fixup_cmake_targets()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(
	INSTALL "${SOURCE_PATH}/LICENSE"
	DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
	RENAME copyright
)
