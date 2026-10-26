@echo off
set stype=%1
set sstring=%2
set nosp=%3
set target=%4
set output=%~5
echo %0
call :main
goto :eof

:main
  set green=[32m
  set blue=[34m
  set cyan=[36m
  set reset=[0m
 
  echo %green%Search corpus:%reset% %target%
  echo %green%Search string:%reset% %sstring%
  echo %green%Search type:%reset% %stype% 
  echo %green%Replace space:%reset% %nosp%
  rem copy /y source\%target%-corpus.xml source\corpus.xml
  set source=source\%target%-corpus.xml
  set search=tmp\search.xml
  set info2=on
  set safestring=%sstring:?=_%
  set htmlfile=output\%stype%-%target%-corpus-%safestring%.html
  set java=C:\programs\javafx\bin\java.exe
  set saxon=C:\programs\saxon\saxon12he.jar
  set timeout=60
  if exist %htmlfile% del %htmlfile%
  rem end setup
  rem call :xslt3js
  call :searchpresent
  if exist %htmlfile% (
  echo %green%Created: %htmlfile% %reset%
  start %htmlfile%
  )
  if '%errorlevel%' == '1' pause
  timeout 60
goto :eof

:xslt3js
  set xslt3he=D:\BaptistArchive\SaxonJS-Tutorial-2021-main\node\node_modules\.bin\xslt3.cmd
  @echo %cyan%%xslt3he% -xsl:search-present-corpus.sef.json -s:%source% -o:%htmlfile% type=%stype% searchword=%sstring% nosp=%nosp% target=%target% %reset%
  @call %xslt3he% -xsl:search-present-corpus.sef.json -s:%source% -o:%htmlfile% type=%stype% searchword=%sstring% nosp=%nosp% target=%target%
goto :eof

:search0
:: single XSLT now working, so not used.
  call :xslt searchXML.xslt %source% %search% "type=%stype% searchword='%sstring%'"
  call :xslt present.xslt %search% %htmlfile%  "searchword='%sstring%'"
goto :eof

:searchpresent
  rem echo %cyan%call :xslt search-present-target3.xslt %source% %htmlfile% "type=%stype% searchword='%sstring%' nosp=%nosp% target='%target%' output=%output%"%reset%
  @call :xslt search-present-corpus.xslt %source% %htmlfile% "type=%stype% searchword='%sstring%' nosp=%nosp% target='%target%' output=%output%"
goto :eof


:xslt
:: Description: Runs Java with saxon to process XSLT transformations.
:: Usage: call :xslt script.xslt [input.xml [output.xml [parameters]]]
:: Depends on: inccount, infile, outfile, fatal, funcend
:: External program1: java.exe https://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html
:: Java application: saxon9he.jar  https://sourceforge.net/projects/saxon/
:: External program2: Node-JS   https://nodejs.org/en/
:: Node application: XSLT3 https://www.saxonica.com/download/javascript.xml
:: Required variables: java saxon9
  set script=%~1
  set infile=%~2
  set outfile=%~3
  set params=%~4
  if not exist %infile% echo "infile not found!" & exit /b
  if defined params set params=%params:'="%
    @if defined info2 echo %cyan%%java% -jar "%saxon%" -o:%outfile% "%infile%" "%script%" %params%%reset%
    %java% -Xmx1024m  %suppressXsltNamespaceCheck% -jar "%saxon%" -o:"%outfile%" "%infile%" "%script%" %params%
  rem if exit %outfile% echo Info: Created %outfile%
goto :eof
