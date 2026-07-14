# Creates or updates GitHub issues M01-M36 with standard template body
# Requires: gh auth login

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
python "$scriptDir\create-github-issues.py" @args
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
