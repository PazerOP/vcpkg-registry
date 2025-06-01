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

	# Try to compile a simple program first to check if Unicode support works
	set(TEST_CODE "
	#include <string>
	#include <cuchar>
	#include <cstddef>

	int main() {
		std::u16string test = u\"Hello\";
		
		// Test mbrtoc32 function which is problematic on some compilers (Apple Clang 17+)
		char32_t c32;
		char s[5] = \"test\";
		std::mbstate_t ps{};
		std::size_t result = std::mbrtoc32(&c32, s, 5, &ps);
		
		return 0;
	}")
	
	check_cxx_source_compiles("${TEST_CODE}" IS_SUPPORTED)

	message("${CMAKE_CURRENT_FUNCTION} ${IS_SUPPORTED_OUT} = ${IS_SUPPORTED}")
	
	# Set result in parent scope
	set(${IS_SUPPORTED_OUT} ${IS_SUPPORTED} PARENT_SCOPE)
	
	# If Unicode support is broken, set the MH_BROKEN_UNICODE flag
	if(NOT IS_SUPPORTED)
		message(STATUS "Unicode support is broken - setting MH_BROKEN_UNICODE=1")
		add_compile_definitions(MH_BROKEN_UNICODE=1)
	endif()

endfunction()
