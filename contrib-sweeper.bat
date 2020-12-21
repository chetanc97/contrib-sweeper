@ECHO OFF

REM We need to delay expansion, otherwise variables inside 'for' block will get replaced when the batch processor reads them in the 'for' loop, before it is executed.
REM See this link for details: https://stackoverflow.com/questions/5615206/windows-batch-files-setting-variable-in-for-loop
setlocal enabledelayedexpansion

SET /P STARTDATE=Starting date(MMDDYY): 
SET /P ENDDATE=Ending date(MMDDYY): 
Echo %STARTDATE%
SET /a c=0
SET /a diff=0
FOR /F %%d IN ('powershell -NoProfile -ExecutionPolicy Bypass -File daterange.ps1 %STARTDATE% %ENDDATE%') DO (
    set /a c=c+1
)

@ECHO !c!

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
set "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"
echo datestamp: "%datestamp%"
echo timestamp: "%timestamp%"
echo fullstamp: "%fullstamp%"
pause

set "mm = !MM!"
set "dd = !DD!"
set "yy = !YY!"
set "mmddyy=%MM%%DD%%YY%"

echo !mmddyy!

setlocal enabledelayedexpansion

FOR /F %%d IN ('powershell -NoProfile -ExecutionPolicy Bypass -File daterange.ps1 %STARTDATE% %mmddyy%') DO (
    set /a diff=diff+1
)


setlocal enabledelayedexpansion

SET /a diff=diff - 1
for /l %%x in (1, 1, %c%) do (
   echo %~dp0
   echo %%x
   echo !diff!
   git commit --allow-empty  --date="!diff! day ago" -m "made changes"
   set /a diff=diff-1
)
git push 

echo Press Enter...








REM ********* function *****************************
:strlen <resultVar> <stringVar>
(   
    setlocal EnableDelayedExpansion
    (set^ tmp=!%~2!)
    if defined tmp (
        set "len=1"
        for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
            if "!tmp:~%%P,1!" NEQ "" ( 
                set /a "len+=%%P"
                set "tmp=!tmp:~%%P!"
            )
        )
    ) ELSE (
        set len=0
    )
)
( 
    endlocal
    set "%~1=%len%"
    exit /b
)