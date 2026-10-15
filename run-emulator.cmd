@echo off
setlocal
rem Double-click for Edge 530, or run: run-emulator.cmd edge1040 -Build
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\run-emulator.ps1" %*
set "struktur_exit=%errorlevel%"
if not "%struktur_exit%"=="0" pause
exit /b %struktur_exit%
