@echo off
set LOGPREFIX_BASE=out
for /r %%i in (%LOGPREFIX_BASE%*.txt) do (
	if exist %%i (
		echo removing %%i
		del %%i
	)
)

set RESULT=result.txt
set RESULT_NG=result-NG.txt

if exist %RESULT% (
	del %RESULT%
)

if exist %RESULT_NG% (
	del %RESULT_NG%
)

for /r %%i in (LogLauncher*.exe) do (
	if exist %%i (
		echo %%i
		call :RUN_TEST %%i %~dp0
	)
)
for /r %%i in (LogLauncher*.exe) do (
	if exist %%i (
		echo %%i
		call :RUN_TEST2 %%i %RESULT% %RESULT_NG%
	)
)

if exist %RESULT% (
	type %RESULT%
)

if exist %RESULT_NG% (
	type %RESULT_NG%
	exit /b 1
) else (
	echo NO NG
)

GOTO :END

:RUN_TEST
	@echo off
	echo     %~dp1
	set EXE_PATH=%1
	set PARAM_DIR=%2
	set EXE_DIR=%~dp1
	set TEST_EXE=%EXE_DIR%test.exe
	set LOGPREFIX=%LOGPREFIX_BASE%-1

	if not exist %EXE_PATH% (
		goto :EOF
	)
	
	@rem to filter obj directory
	if not exist %TEST_EXE% (
		goto :EOF
	)

	@rem test case 1
	set CMD=%EXE_PATH%                                cmd.exe /c dir %PARAM_DIR%
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 1 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 2
	set CMD=%EXE_PATH%                             -- cmd.exe /c dir %PARAM_DIR%
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 2 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 3
	set CMD=%EXE_PATH%                             --
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 3 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 4
	set CMD=%EXE_PATH%   -t                        -- cmd.exe /c dir %PARAM_DIR%
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 4 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 5
	set CMD=%EXE_PATH%   -tz                       -- cmd.exe /c dir %PARAM_DIR%
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 5 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 6
	set CMD=%EXE_PATH%   -t  %EXE_DIR%%LOGPREFIX%-t.txt     -- cmd.exe /c dir %PARAM_DIR%
	echo %CMD%
	%CMD%
	if %errorlevel% == 0 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 6 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 7
	set CMD=%EXE_PATH%   -tz %EXE_DIR%%LOGPREFIX%-tz.txt    -- cmd.exe /c dir %PARAM_DIR%
	echo %CMD%
	%CMD%
	if %errorlevel% == 0 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 7 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 8
	set CMD=%EXE_PATH% -a -t  %EXE_DIR%%LOGPREFIX%-t-a.txt  -- cmd.exe /c dir %PARAM_DIR%
	echo %CMD%
	%CMD%
	if %errorlevel% == 0 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 8 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 9
	set CMD=%EXE_PATH% -a -t  %EXE_DIR%%LOGPREFIX%-t-a.txt  -- cmd.exe /c dir %PARAM_DIR%
	echo %CMD%
	%CMD%
	if %errorlevel% == 0 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 9 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 10
	set CMD=%EXE_PATH% -a -tz %EXE_DIR%%LOGPREFIX%-tz-a.txt -- cmd.exe /c dir %PARAM_DIR%
	echo %CMD%
	%CMD%
	if %errorlevel% == 0 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 10 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 11
	set CMD=%EXE_PATH% -a -tz %EXE_DIR%%LOGPREFIX%-tz-a.txt -- cmd.exe /c dir %PARAM_DIR%
	echo %CMD%
	%CMD%
	if %errorlevel% == 0 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 11 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)
	@echo off

goto :EOF


:RUN_TEST2
	@echo off
	echo     %~dp1
	set EXE_PATH=%1
	set RESULT=%2
	set RESULT_NG=%3
	set EXE_DIR=%~dp1
	set TEST_EXE=%EXE_DIR%test.exe
	set LOGPREFIX=%LOGPREFIX_BASE%-2

	if not exist %EXE_PATH% (
		goto :EOF
	)
	if not exist %TEST_EXE% (
		goto :EOF
	)

	@rem test case 1
	set CMD=%EXE_PATH%                                %TEST_EXE% 1
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 1 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 2
	set CMD=%EXE_PATH%                             -- %TEST_EXE% 0
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 2 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 3
	set CMD=%EXE_PATH%                             --
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 3 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 4
	set CMD=%EXE_PATH%   -t                        -- %TEST_EXE%
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 4 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 5
	set CMD=%EXE_PATH%   -tz                       -- %TEST_EXE%
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 5 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 6
	set CMD=%EXE_PATH%   -t  %EXE_DIR%%LOGPREFIX%-t.txt     -- %TEST_EXE%
	echo %CMD%
	%CMD%
	if %errorlevel% == 0 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 6 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 7
	set CMD=%EXE_PATH%   -tz %EXE_DIR%%LOGPREFIX%-tz.txt    -- %TEST_EXE%
	echo %CMD%
	%CMD%
	if %errorlevel% == 0 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 7 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 8
	set CMD=%EXE_PATH% -a -t  %EXE_DIR%%LOGPREFIX%-t-a.txt  -- %TEST_EXE%
	echo %CMD%
	%CMD%
	if %errorlevel% == 0 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 8 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 9
	set CMD=%EXE_PATH% -a -t  %EXE_DIR%%LOGPREFIX%-t-a.txt  -- %TEST_EXE%
	echo %CMD%
	%CMD%
	if %errorlevel% == 0 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 9 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 10
	set CMD=%EXE_PATH% -a -tz %EXE_DIR%%LOGPREFIX%-tz-a.txt -- %TEST_EXE%
	echo %CMD%
	%CMD%
	if %errorlevel% == 0 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 10 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 11
	set CMD=%EXE_PATH% -a -tz %EXE_DIR%%LOGPREFIX%-tz-a.txt -- %TEST_EXE%
	echo %CMD%
	%CMD%
	if %errorlevel% == 0 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 11 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)
	
	@rem test case 12
	set CMD=%EXE_PATH%   -t  %EXE_DIR%%LOGPREFIX%-t.txt     -- %TEST_EXE% 1
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 12 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 13
	set CMD=%EXE_PATH%   -tz %EXE_DIR%%LOGPREFIX%-tz.txt    -- %TEST_EXE% 1
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 13 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 14
	set CMD=%EXE_PATH% -a -t  %EXE_DIR%%LOGPREFIX%-t-a.txt  -- %TEST_EXE% 1
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 14 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 15
	set CMD=%EXE_PATH% -a -t  %EXE_DIR%%LOGPREFIX%-t-a.txt  -- %TEST_EXE% 1
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 15 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 16
	set CMD=%EXE_PATH% -a -tz %EXE_DIR%%LOGPREFIX%-tz-a.txt -- %TEST_EXE% 1
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 16 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)

	@rem test case 17
	set CMD=%EXE_PATH% -a -tz %EXE_DIR%%LOGPREFIX%-tz-a.txt -- %TEST_EXE% 1
	echo %CMD%
	%CMD%
	if %errorlevel% == 1 (
		echo OK %CMD%
		echo OK %CMD% >> %RESULT%
	) else (
		set CODE=%errorlevel%
		echo NG %CMD%
		echo NG %CMD% >> %RESULT%
		echo test case 17 >> %RESULT_NG%
		echo NG %CMD% >> %RESULT_NG%
		echo CODE = %CODE% >> %RESULT_NG%
	)
	@echo off

goto :EOF

:END
