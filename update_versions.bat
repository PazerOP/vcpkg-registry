@ECHO OFF

SETLOCAL

	SET COMMON_ARGS=--x-builtin-ports-root=../my_vcpkg_repo/ports/ --x-builtin-registry-versions-dir=../my_vcpkg_repo/versions/

	ECHO Formatting manifests...
	vcpkg format-manifest --all %COMMON_ARGS% || EXIT /b %ERRORLEVEL%

	ECHO Committing ports...
	git add ports/* || EXIT /b %ERRORLEVEL%
	git commit ports/* -m "Updated ports"

	ECHO Updating versions...
	vcpkg x-add-version --all --overwrite-version --verbose %COMMON_ARGS% || EXIT /b %ERRORLEVEL%

	ECHO Committing versions...
	git add versions/* || EXIT /b %ERRORLEVEL%
	git commit versions/* -m "Updated versions" || EXIT /b %ERRORLEVEL%
	git push || EXIT /b %ERRORLEVEL%

	ECHO Latest revision:
	git rev-parse HEAD || EXIT /b %ERRORLEVEL%

ENDLOCAL
