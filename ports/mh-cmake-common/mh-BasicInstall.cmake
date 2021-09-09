cmake_minimum_required(VERSION 3.17)

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

function(mh_basic_install)
	cmake_parse_arguments(
		# arg variable prefix
		"arg"
		# options
		""
		# one value keywords
		"PROJ_NAME;PROJ_VERSION"
		# multi-value keywords
		"PROJ_INCLUDE_DIRS"
	)

	if (DEFINED arg_UNPARSED_ARGUMENTS)
		message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} was passed extra arguments (${arg_UNPARSED_ARGUMENTS})")
	endif()

	if (NOT DEFINED arg_PROJ_NAME)
		if (NOT DEFINED PROJECT_NAME)
			message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} was not passed PROJ_NAME argument, and PROJECT_NAME was not defined")
		endif()

		set(arg_PROJ_NAME "${PROJECT_NAME}")
	endif()

	if (NOT DEFINED arg_PROJ_VERSION)
		if (NOT DEFINED PROJECT_VERSION)
			message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} was not passed PROJ_VERSION argument, and PROJECT_VERSION was not defined")
		endif()

		set(arg_PROJ_VERSION "${PROJECT_VERSION}")
	endif()

	configure_package_config_file(
		"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/mh-BasicInstall_config.cmake.in"
		"${CMAKE_CURRENT_BINARY_DIR}/mh-BasicInstall_${arg_PROJ_NAME}_config.cmake"
		INSTALL_DESTINATION "${CMAKE_INSTALL_DATADIR}/${arg_PROJ_NAME}"
	)

	write_basic_package_version_file(
		"${CMAKE_CURRENT_BINARY_DIR}/${arg_PROJ_NAME}-config-version.cmake"
		VERSION ${arg_PROJ_VERSION}
		COMPATIBILITY SameMajorVersion
	)

	install(TARGETS ${arg_PROJ_NAME} EXPORT ${arg_PROJ_NAME}_targets)

	install(
		EXPORT ${arg_PROJ_NAME}_targets
		NAMESPACE mh::
		DESTINATION "${CMAKE_INSTALL_DATADIR}/${arg_PROJ_NAME}"
	)

	foreach (INCLUDE_DIR_ITER "${arg_PROJ_INCLUDE_DIRS}")
		install(DIRECTORY "${INCLUDE_DIR_ITER}" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")
	endforeach()

endfunction()
