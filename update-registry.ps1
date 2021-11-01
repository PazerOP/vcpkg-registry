param(
	[Parameter(Mandatory=$true)]
	[string]$PortName,
	[Parameter(Mandatory=$true)]
	[string]$PortRef
)

$ErrorActionPreference = "Stop"

Write-Host -ForegroundColor Green "Removing any old installations of $PortName..."
vcpkg remove "$PortName"

$registryRoot = "vcpkg-registry"
# Write-Host -ForegroundColor Green "Checking out vcpkg registry..."
# Remove-Item -LiteralPath $registryRoot -Force -Recurse -ErrorAction Ignore
# git clone "https://github.com/PazerOP/vcpkg-registry.git" "$registryRoot"

# Figure out paths
$allPortsRoot = $registryRoot + "/ports/"
$allVersionsRoot = $registryRoot + "/versions/"
$portRoot = $allPortsRoot + $PortName
$portfilePath = $portRoot + "/portfile.cmake"
$portJsonPath = $portRoot + "/vcpkg.json"
$overlayPortsArg = "--overlay-ports=`"$allPortsRoot`""

Write-Host -ForegroundColor Green "Determining SHA512 hash for $PortName@$PortRef..."
$downloadedPortZip = Invoke-WebRequest -Uri "https://github.com/PazerOP/glad2-gl/archive/$PortRef.zip"
$refsha512 = (Get-FileHash -InputStream $downloadedPortZip.RawContentStream -Algorithm SHA512).Hash
Write-Host -ForegroundColor DarkGreen "`tSHA512 = $refsha512"

Write-Host -ForegroundColor Green "Updating port ref to $PortRef..."
$portfileContent = Get-Content $portfilePath -Raw -Encoding UTF8
# Set the ref to the ref that was passed to this cmdlet
$portfileContent = $portfileContent -replace '(vcpkg_from_github\((.|\n|\r)*)REF\s+([0-9a-fA-F]+)((.|\n|\r)*\))', "`$1REF $PortRef`$4"
# Update the sha512
$portfileContent = $portfileContent -replace '(vcpkg_from_github\((.|\n|\r)*)SHA512\s+([0-9a-fA-F]+)((.|\n|\r)*\))', "`$1SHA512 $refsha512`$4"
$portfileContent | Out-File -LiteralPath $portfilePath

# Write-Host -ForegroundColor Green "Determining new SHA512..."
# # https://stackoverflow.com/a/33002914/871842
# & vcpkg install "$PortName" $overlayPortsArg 2>&1 | tee -Variable sha512TestOutputAll
# $sha512TestOutputStderr = $sha512TestOutputAll | ?{ $_ -is [System.Management.Automation.ErrorRecord] }
# $sha512TestOutputStdout = $sha512TestOutputAll | ?{ $_ -isnot [System.Management.Automation.ErrorRecord] }
# $actualPortfileHash = $null
# foreach ($line in $sha512TestOutputStdout) {
# 	$lineMatch = $line -match 'Actual hash : \[ ([0-9a-fA-F]+) \]'
# 	if ($lineMatch) {
# 		Write-Host $Matches
# 		$actualPortfileHash = $Matches[1]
# 		break;
# 	}
# }

# if ($actualPortfileHash -eq $null)
# {
# 	Write-Error "Failed to determine real port hash"
# }

# Update the portfile with the real SHA512 hash
# Write-Host -ForegroundColor DarkGreen "`tSHA512 = $actualPortfileHash"
# $portfileContent = $portfileContent -replace '(vcpkg_from_github\((.|\n|\r)*)SHA512\s+([0-9a-fA-F]+)((.|\n|\r)*\))', "`$1SHA512 $actualPortfileHash`$4"
# $portfileContent | Out-File -LiteralPath $portfilePath

# Update the current date and port version in the port's vcpkg.json file
Write-Host -ForegroundColor Green "Updating $PortName/vcpkg.json..."
$vcpkgJson = Get-Content -LiteralPath $portJsonPath | ConvertFrom-Json -Depth 100
$currentDate = Get-Date -Format "yyyy-MM-dd" -AsUTC
if ($vcpkgJson."version-date" -ne $currentDate) {
	# Date doesn't match, set it to the current date and set the port version to 1
	$vcpkgJson."version-date" = $currentDate;
	$vcpkgJson."port-version" = 1;
} else {
	# Date matches, just increment the port version
	$vcpkgJson."port-version" = $vcpkgJson."port-version" + 1;
}
$vcpkgJson | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $portJsonPath;

# Make sure we can build
Write-Host -ForegroundColor Green "Testing build..."
vcpkg install "$PortName" --debug $overlayPortsArg
if ($LASTEXITCODE -ne 0) {
	Write-Error "Failed to build $PortName"
}

# Set-Location -LiteralPath $registryRoot

# Write-Host -ForegroundColor Green "Formatting all manifests..."
# vcpkg format-manifest --all --x-builtin-ports-root="ports/" --x-builtin-registry-versions-dir="versions/"
# if ($LASTEXITCODE -ne 0) {
# 	Write-Error "Failed to format all manifests"
# }

# Write-Host -ForegroundColor Green "Committing ports..."
# git add "ports/*"
# if ($LASTEXITCODE -ne 0) {
# 	Write-Error "Failed to git add ports"
# }
# git commit "ports/*" -m "Updated ports"
# if ($LASTEXITCODE -ne 0) {
# 	Write-Error "Failed to git commit ports"
# }

# Write-Host -ForegroundColor Green "Updating versions..."
# vcpkg x-add-version --all --overwrite-version --verbose --x-builtin-ports-root="ports/" --x-builtin-registry-versions-dir="versions/"
# if ($LASTEXITCODE -ne 0) {
# 	Write-Error "Failed to vcpkg update versions"
# }

# Write-Host -ForegroundColor Green "Committing versions..."
# git add "versions/*"
# if ($LASTEXITCODE -ne 0) {
# 	Write-Error "Failed to git add versions"
# }
# git commit "versions/*" -m "Updated versions"
# if ($LASTEXITCODE -ne 0) {
# 	Write-Error "Failed to git commit versions"
# }

# Write-Host -ForegroundColor Green "Pushing changes..."
# git push
# if ($LASTEXITCODE -ne 0) {
# 	Write-Error "Failed to git push"
# }

# Write-Host -ForegroundColor Green "Latest registry revision:"
# git rev-parse HEAD
# if ($LASTEXITCODE -ne 0) {
# 	Write-Error "Failed to fetch latest revision"
# }
