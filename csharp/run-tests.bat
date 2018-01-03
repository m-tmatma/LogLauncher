@echo off
set LOGPREFIX=out
for /r %%i in (%LOGPREFIX%*.txt) do (
	if exist %%i (
		echo removing %%i
		del %%i
	)
)

for /r %%i in (LogLauncher*.exe) do (
	if exist %%i (
		echo %%i
		call :RUN_TEST %%i
	)
)

GOTO :END

:RUN_TEST
	@echo on
	echo     %~dp1
	set EXE_PATH=%1
	set EXE_DIR=%~dp1

	%EXE_PATH%                                cmd.exe /c dir c:\
	%EXE_PATH%                             -- cmd.exe /c dir c:\
	%EXE_PATH%                             --

	%EXE_PATH%   -t                        -- cmd.exe /c dir c:\
	%EXE_PATH%   -tz                       -- cmd.exe /c dir c:\

	%EXE_PATH%   -t  %EXE_DIR%%LOGPREFIX%-t.txt     -- cmd.exe /c dir c:\
	%EXE_PATH%   -tz %EXE_DIR%%LOGPREFIX%-tz.txt    -- cmd.exe /c dir c:\

	%EXE_PATH% -a -t  %EXE_DIR%%LOGPREFIX%-t-a.txt  -- cmd.exe /c dir c:\
	%EXE_PATH% -a -t  %EXE_DIR%%LOGPREFIX%-t-a.txt  -- cmd.exe /c dir c:\

	%EXE_PATH% -a -tz %EXE_DIR%%LOGPREFIX%-tz-a.txt -- cmd.exe /c dir c:\
	%EXE_PATH% -a -tz %EXE_DIR%%LOGPREFIX%-tz-a.txt -- cmd.exe /c dir c:\
	@echo off

goto :EOF

:END
