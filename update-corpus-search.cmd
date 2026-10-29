:: Install/update search-corpus
:: Written by: ian.mcquay@gmail.com
:: Date updated: 2026-10-30
@echo off
@set magenta=[35m
@set green=[32m
@set cyan=[36m
@set yellow=[33m
@set red=[31m
@set white=[37m
@set reset=[0m
set files=corpus-search.cmd corpus-search.hta README.md result.css search-present-corpus.xslt search.vbs
@echo %magenta%Updating the 'corpus-search' files from source files on Github.%reset%
echo.
set url-base=https://raw.githubusercontent.com/indiamcq/corpus-search/main
@echo %green%Attempting download files:%reset% %files%
@echo %green%    With line endings conversion from LF to CRLF %reset%
@echo %reset%
FOR %%s IN (%files%) DO call :curl %%s
echo %reset%
timeout 30
goto :eof

:curl
  if exist "old\%~1.old" del "old\%~1.old"
  ren "%~1" "old\%~1.old"
  echo %green%Downloading: %url-base%/%~1 %reset%
  @echo %cyan%call curl --ssl-no-revoke  %url-base%/%~1 ^| MORE /P > "%~1" %reset%
  @call curl --ssl-no-revoke  %url-base%/%~1 | MORE /P > "%~1"
  FOR /F "usebackq" %%A IN ('%~1') DO @set size=%%~zA
  @if "%size%" == "14" (
    @echo %redbg%Error: %~1 not found at %url-base%. Failed  with failed size = %size% %reset%
  ) else (
    @if exist "%~1" echo %green%Updated: %~1 %reset% with size = %size%
  )
  echo.
goto :eof


