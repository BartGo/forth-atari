@echo off
if "%ALTIRRA%"=="" (
  echo Set ALTIRRA to the full path of Altirra64.exe
  exit /b 1
)
if "%~1"=="" (
  echo Usage: scr2altirra.cmd source.ATR
  exit /b 1
)

if "%IDE_BOOT%"=="" (
  start /B "%ALTIRRA%" /disk "%~1"
) else (
  start /B "%ALTIRRA%" /disk "%IDE_BOOT%" /disk "%~1" /type "DR1 CR 1 LOAD ~"
)
