cmake_minimum_required(VERSION 3.17)

include(CheckCXXSourceCompiles)

function(mh_check_cxx_unicode_support IS_SUPPORTED_OUT target)

	get_target_property(TARGET_CXX_OPTS ${target} COMPILE_OPTIONS)

	get_target_property(TARGET_TYPE ${target} TYPE)

	if (TARGET_TYPE STREQUAL "STATIC_LIBRARY")
		get_target_property(TARGET_LINK_OPTS ${target} STATIC_LIBRARY_OPTIONS)
	else()
		get_target_property(TARGET_LINK_OPTS ${target} LINK_OPTIONS)
	endif()

	if (TARGET_LINK_OPTS STREQUAL "TARGET_LINK_OPTS-NOTFOUND")
		set(TARGET_LINK_OPTS "")
	endif()

	message("TARGET_TYPE = ${TARGET_TYPE}, TARGET_CXX_OPTS = ${TARGET_CXX_OPTS}, TARGET_LINK_OPTS = ${TARGET_LINK_OPTS}")

	try_compile(IS_SUPPORTED
		${CMAKE_CURRENT_BINARY_DIR}
		"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/mh-CheckUnicodeSupport.cpp"
		CXX_STANDARD 20
		COMPILE_DEFINITIONS "${TARGET_CXX_OPTS}"
		LINK_OPTIONS "${TARGET_LINK_OPTS}"
		OUTPUT_VARIABLE TRY_COMPILE_OUTPUT)

	message("${CMAKE_CURRENT_FUNCTION} ${IS_SUPPORTED_OUT} = ${IS_SUPPORTED}")
	if (NOT IS_SUPPORTED)
		message("${CMAKE_CURRENT_FUNCTION} output = ${TRY_COMPILE_OUTPUT}")
	endif()

	set(${IS_SUPPORTED_OUT} ${IS_SUPPORTED} PARENT_SCOPE)

endfunction()
