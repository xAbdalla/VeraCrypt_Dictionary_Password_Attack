@echo off

REM Created By: Abdallah Hamdy
REM Github Repo: https://github.com/xAbdalla/VeraCrypt_Dictionary_Password_Attack

SETLOCAL ENABLEDELAYEDEXPANSION
Title VeraCrypt Dictionary Password Script By: Abdallah NouR ...
cd %~dp0

ECHO. & ECHO VeraCrypt Dictionary Password Script By: Abdallah Hamdy ... & ECHO. & ECHO.
echo How to use:
echo   [1] Put the script file in VeraCrypt folder
echo   [2] Create a word list file (name it word.list) and put it in VeraCrypt folder
echo   [3] Fill up the word.list with optional passwords
echo   [4] Make sure that Drive Q: isn't mounted already
echo   [5] Run this script file (in elevated command prompt if needed)
echo   [6] Enter the VeraCrypt encrypted full path file
echo   [7] If there are old log files (logs.log and password.txt) they will be renamed
echo   [8] The log file "logs.log" is created beside the the encrypted file 
echo   [9] The password file "password.txt" is created (if password found) beside the the encrypted file
ECHO. & ECHO.

SET dir=
SET yes=Y YES T TRUE
SET no=N NO F FALSE

if exist "veracrypt.exe" (
	if exist "word.list" (
			for %%A in ("word.list") do if %%~zA==0 (echo *** ERROR: word.list file is Empty *** & ECHO. & Pause & GOTO :eof)
			: Q1
			Echo Enter the VeraCrypt encrypted full path file:
			SET /p dir=""
			IF /I ["!dir!"] == ["q"] (echo Closing the script ... & ECHO. & Pause & GOTO :eof)
			IF NOT ["!dir!"] == [""] SET dir=!dir:"=!
			IF ["!dir!"] == [""] ( ECHO ***  ERROR: Empty Input Value --- "!dir!" *** & GOTO :Q1)
			IF NOT EXIST "!dir!" ( ECHO ***  ERROR: File Not Found --- "!dir!" *** & GOTO :Q1)
			FOR %%i IN ("!dir!") DO (
				SET ext=%%~xi
				if ["!ext!"] == [""] ( ECHO ***  ERROR: Not a File Path --- "!dir!" *** & GOTO :Q1)
			)
			for /f "delims=" %%A in ("!dir!") do ( set foldername=%%~dpA)
			
			veracrypt.exe /d Q /f /q /s
			
			ECHO. & Echo Trying Passwords:
			if exist "!foldername!logs.log" (MOVE /Y "!foldername!logs.log" "!foldername!old_logs_%date:~10,4%%date:~7,2%%date:~4,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log" >nul)
			if exist "!foldername!password.txt" (MOVE /Y "!foldername!password.txt" "!foldername!old_password_%date:~10,4%%date:~7,2%%date:~4,2%_%time:~0,2%%time:~3,2%%time:~6,2%.txt" >nul)
			set /a count=1
			for /f "tokens=*" %%a in (word.list)  do if not %%~zR gtr 0 (
				REM echo ---[new check]---
				echo|set /p="[!count!]  %%a"
				echo %%a>>"!foldername!logs.log"
				veracrypt.exe /v "!dir!" /l Q /a /p "%%a" /q /s
				if exist Q:\ (echo  - Success & echo %%a>"!foldername!password.txt" & GOTO :END) else (echo  - Fail)
				REM veracrypt.exe /d Q /s /q
				set /a count+=1
			)
			echo ---[Finished word.list and yet did not find the right password]---
			ECHO. & Pause & GOTO :eof
			: END
			SET ans=
			SET /p ans="Do you want to Disamount VeraCrypt Q: drive [Y/N]: "
			IF ["!ans!"] == [""] (SET ans=yes)
			FOR %%y IN (%yes%) DO ( 
				IF /I [!ans!] == [%%y] (
					veracrypt.exe /d Q /f /q /s
				)
			)
			echo ---[Finished]--- & ECHO.
	) else (echo *** ERROR: Create a word.list file in VeraCrypt folder *** & ECHO.)
) else (echo *** ERROR: Put the script file in VeraCrypt folder *** & ECHO.)
PAUSE
if exist "!foldername!password.txt" (start "" "!foldername!password.txt")