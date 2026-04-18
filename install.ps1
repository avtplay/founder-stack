# founder-stack — one-command install
# Claude will run this automatically when asked to install founder-stack

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
& "$scriptDir\scripts\setup-windows.ps1"
