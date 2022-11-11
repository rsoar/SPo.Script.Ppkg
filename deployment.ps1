$package = "spfx-deployment-automation-web.sppkg"
$solutionJSON = "$(Get-Location)\config\package-solution.json"
$solutionPath = "$(Get-Location)\sharepoint\solution\"
$backupPath = "$(Get-Location)\DEPLOY\backup\"

try {
  set NODE_OPTIONS=--max_old_space_size=8192
  gulp clean
  gulp bundle --ship --max_old_space_size=8192
  gulp package-solution --ship
  $pkgSolution = Get-Content $solutionJSON | Out-String | ConvertFrom-Json
  New-Item -Path ("{0}{1}" -f $backupPath,$pkgSolution.solution.version) -ItemType Directory
  Copy-Item ("{0}{1}" -f $solutionPath,$package) -Destination ("{0}{1}" -f $backupPath,$pkgSolution.solution.version)
  invoke-item $solutionPath
}
catch [System.Net.WebException] {
  Write-Output "Deploy fails"
}
