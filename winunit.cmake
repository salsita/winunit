
# this script is used to create a unit test library

set(winunit_include "${CMAKE_CURRENT_LIST_DIR}/Include")

if(CMAKE_CL_64)
	file(TO_NATIVE_PATH "${CMAKE_CURRENT_LIST_DIR}/WinUnit64.exe" winunit_exe)
else(CMAKE_CL_64)
	file(TO_NATIVE_PATH "${CMAKE_CURRENT_LIST_DIR}/WinUnit32.exe" winunit_exe)
endif(CMAKE_CL_64)

macro(add_unittest_library libname)

	file(GLOB test_files *.cpp)

	add_library(${libname}-test SHARED "${test_files}")

	add_definitions("-D_CRT_SECURE_NO_WARNINGS -D_UNICODE")

	include_directories("${winunit_include}")

	target_link_libraries(${libname}-test ${libname})

	set_property(TARGET ${libname}-test PROPERTY RUNTIME_OUTPUT_DIRECTORY_RELEASE ${outdir_bin_release})
	set_property(TARGET ${libname}-test PROPERTY RUNTIME_OUTPUT_DIRECTORY_DEBUG ${outdir_bin_debug})
	set_property(TARGET ${libname}-test PROPERTY LIBRARY_OUTPUT_DIRECTORY_RELEASE ${outdir_bin_release})
	set_property(TARGET ${libname}-test PROPERTY LIBRARY_OUTPUT_DIRECTORY_DEBUG ${outdir_bin_debug})
	set_property(TARGET ${libname}-test PROPERTY ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${outdir_lib_release})
	set_property(TARGET ${libname}-test PROPERTY ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${outdir_lib_debug})

	add_custom_command(
		TARGET ${libname}-test
		POST_BUILD
		COMMAND ${winunit_exe} \"$(TargetPath)\"
	)

endmacro(add_unittest_library libname)