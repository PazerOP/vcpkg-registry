cmake_minimum_required(VERSION 3.17)

include(CheckCXXCompilerFlag)

function(mh_check_cxx_coroutine_support IS_SUPPORTED_OUT REQUIRED_FLAGS_OUT)
	set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

	# First, check if compiler supports coroutines natively without flags (modern compilers in 2025+)
	try_compile(COROUTINES_NATIVE_SUPPORT
		${CMAKE_CURRENT_BINARY_DIR}
		"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/mh-CheckCoroutineSupport.cpp"
		CXX_STANDARD 20
		OUTPUT_VARIABLE TRY_COMPILE_NATIVE_OUTPUT
	)

	set(REQUIRED_FLAGS "")
	
	# If native support is not available, check for needed flags
	if (NOT COROUTINES_NATIVE_SUPPORT)
		check_cxx_compiler_flag(-fcoroutines COROUTINES_FLAG_FCOROUTINES)
		if (NOT COROUTINES_FLAG_FCOROUTINES)
			check_cxx_compiler_flag(-fcoroutines-ts COROUTINES_FLAG_FCOROUTINES_TS)
		endif()

		if (COROUTINES_FLAG_FCOROUTINES)
			set(REQUIRED_FLAGS "-fcoroutines")
		elseif (COROUTINES_FLAG_FCOROUTINES_TS)
			set(REQUIRED_FLAGS "-fcoroutines-ts")
		endif()
	endif()

	get_directory_property(DIRECTORY_CXX_OPTS COMPILE_OPTIONS)
	get_directory_property(DIRECTORY_LINK_OPTS LINK_OPTIONS)

	# If native support is available, we already know it works
	if (COROUTINES_NATIVE_SUPPORT)
		set(IS_SUPPORTED TRUE)
	else()
		# Otherwise try with the required flags
		try_compile(IS_SUPPORTED
			${CMAKE_CURRENT_BINARY_DIR}
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/mh-CheckCoroutineSupport.cpp"
			CXX_STANDARD 20
			COMPILE_DEFINITIONS "${REQUIRED_FLAGS} ${DIRECTORY_CXX_OPTS}"
			LINK_OPTIONS ${DIRECTORY_LINK_OPTS}
			OUTPUT_VARIABLE TRY_COMPILE_OUTPUT
		)
	endif()

	if (NOT IS_SUPPORTED)
		message("${CMAKE_CURRENT_FUNCTION} output = ${TRY_COMPILE_OUTPUT}")
	endif()

	set(${IS_SUPPORTED_OUT} ${IS_SUPPORTED} PARENT_SCOPE)
	set(${REQUIRED_FLAGS_OUT} ${REQUIRED_FLAGS} PARENT_SCOPE)

endfunction()
