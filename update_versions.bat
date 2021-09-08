vcpkg format-manifest --all --x-builtin-ports-root=ports --x-builtin-registry-versions-dir=versions

vcpkg x-add-version --all --overwrite-version --verbose --x-builtin-ports-root=ports --x-builtin-registry-versions-dir=versions
