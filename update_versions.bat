@ECHO OFF

SETLOCAL

	SET COMMON_ARGS=--x-builtin-ports-root=../my_vcpkg_repo/ports/ --x-builtin-registry-versions-dir=../my_vcpkg_repo/versions/

	ECHO Formatting manifests...
	vcpkg format-manifest --all %COMMON_ARGS%

	ECHO Updating versions...
	vcpkg x-add-version --all --overwrite-version --verbose %COMMON_ARGS%

ENDLOCAL
