@ECHO OFF
setlocal enabledelayedexpansion

REM Работа с FTP
REM V 1.00 - первая эксплуатационная версия.

REM==================================================
REM Использование
REM call "FTP-CONNECT.cmd" "lcd C:\flink\MTB\service\in\profit\dat" "cd ./PROFIT.EXPORT/dat" "mget *.dat"
REM минимально должен быть один параметр командной строки, например - mget *.dat
REM IP Login Pass записываются в файле FTP-Author.txt в данной последовательности, каждый с новой строки.

REM==================================================
ECHO .
ECHO %date% %time% - START FTP-CONNECT.cmd V 1.0

REM==================================================
REM Установка переменных
SET RUNDIR=%~dp0
	REM SET FTPAuthor=%RUNDIR%FTP-Author.txt
SET FTPAuthor=FTP-Author.txt
SET FCMD=%RUNDIR%FTP-COMMAND.txt
CD "%RUNDIR%"|| ECHO %date% %time% - ERROR CD %RUNDIR%

REM==================================================
REM Прочитаем данные для авторизации на FTP из файла %FTPAuthor%
REM FTPIP
REM FTPLogin
REM FTPPass

IF NOT EXIST "%FTPAuthor%" (
ECHO %date% %time% - WARNING FILE %FTPAuthor% NOT FOUND
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING %FTPAuthor% NOT FOUND"
	REM ECHO REPLACE THE ENTIRE STRING TO IP-ADRESS>>"%FTPAuthor%"
	REM ECHO REPLACE THE ENTIRE STRING TO LOGIN>>"%FTPAuthor%"
	REM ECHO REPLACE THE ENTIRE STRING TO PASSWORD>>"%FTPAuthor%"
EXIT /B 1
)

SET /A STRNUMBER=0
FOR /F %%G IN (%FTPAuthor%) DO (
if !STRNUMBER! == 0 SET FTPIP=%%G
if !STRNUMBER! == 1 SET FTPLogin=%%G
if !STRNUMBER! == 2 SET FTPPass=%%G
SET /A STRNUMBER=STRNUMBER+1
)

	REM ECHO %date% %time% - STRNUMBER=%STRNUMBER%
	REM ECHO %date% %time% - FTPIP=%FTPIP%=
	REM ECHO %date% %time% - FTPLogin=%FTPLogin%=
	REM ECHO %date% %time% - FTPPass=%FTPPass%=
	REM pause
	REM EXIT /B 1

REM==================================================
REM Проверки
REM==================================================
REM Проверка передачи параметра скрипту, обязателен только 1 параметр.
IF "%~1"=="" (
ECHO %date% %time% - WARNING COMMAND LINE PARAMETER 1 IS EMPTY
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING COMMAND LINE PARAMETER 1 IS EMPTY"
EXIT /B 1
)
REM==================================================
REM Проверка FTP IP-ADRESS
IF "%FTPIP%"=="" (
ECHO %date% %time% - WARNING FTP IP-ADRESS IS EMPTY
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING FTP IP-ADRESS IS EMPTY"
EXIT /B 1
)
REM==================================================
REM Проверка FTP Login
IF "%FTPLogin%"=="" (
ECHO %date% %time% - WARNING FTP Login IS EMPTY
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING FTP Login IS EMPTY"
EXIT /B 1
)
REM==================================================
REM Проверка FTP Pass
IF "%FTPPass%"=="" (
ECHO %date% %time% - WARNING FTP Pass IS EMPTY
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING FTP Pass IS EMPTY"
EXIT /B 1
)

REM==================================================
REM Удалим старый управляющий файл для FTP
IF EXIST "%FCMD%" DEL /Q "%FCMD%" || ECHO %date% %time% - WARNING ERROR DELETE %FCMD%

REM==================================================
REM Создадим новый управляющий файл для FTP
REM open FTPIP
REM FTPLogin
REM FTPPass
REM lcd C:\flink\MTB\service\in\dat 
REM cd  /temenos/t24/local/bnk.run/data.export/dat
REM binary
REM !:--- dir
REM !:--- ls
REM mget *.*
REM disconnect
REM bye

ECHO open %FTPIP%>>"%FCMD%"|| (
ECHO %date% %time% - WARNING ERROR WRITE TO FILE %FCMD%
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING ERROR WRITE TO FILE %FCMD%"
EXIT /B 1
)
ECHO %FTPLogin%>>"%FCMD%"|| (
ECHO %date% %time% - WARNING ERROR WRITE TO FILE %FCMD%
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING ERROR WRITE TO FILE %FCMD%"
EXIT /B 1
)
ECHO %FTPPass%>>"%FCMD%"|| (
ECHO %date% %time% - WARNING ERROR WRITE TO FILE %FCMD%
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING ERROR WRITE TO FILE %FCMD%"
EXIT /B 1
)
ECHO binary>>"%FCMD%"|| (
ECHO %date% %time% - WARNING ERROR WRITE TO FILE %FCMD%
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING ERROR WRITE TO FILE %FCMD%"
EXIT /B 1
)
IF NOT "%~1"=="" ECHO %~1>>"%FCMD%"|| (
ECHO %date% %time% - WARNING ERROR WRITE TO FILE %FCMD%
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING ERROR WRITE TO FILE %FCMD%"
EXIT /B 1
)
IF NOT "%~2"=="" ECHO %~2>>"%FCMD%"|| (
ECHO %date% %time% - WARNING ERROR WRITE TO FILE %FCMD%
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING ERROR WRITE TO FILE %FCMD%"
EXIT /B 1
)
IF NOT "%~3"=="" ECHO %~3>>"%FCMD%"|| (
ECHO %date% %time% - WARNING ERROR WRITE TO FILE %FCMD%
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING ERROR WRITE TO FILE %FCMD%"
EXIT /B 1
)

	REM ECHO lcd %RUNDIR%>>"%FCMD%"
	REM ECHO cd  ./data.export/dat>>"%FCMD%"
	REM ECHO dir * curr.txt>>"%FCMD%"

ECHO disconnect>>"%FCMD%"|| (
ECHO %date% %time% - WARNING ERROR WRITE TO FILE %FCMD%
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING ERROR WRITE TO FILE %FCMD%"
EXIT /B 1
)
ECHO bye>>"%FCMD%"|| (
ECHO %date% %time% - WARNING ERROR WRITE TO FILE %FCMD%
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING ERROR WRITE TO FILE %FCMD%"
EXIT /B 1
)

REM==================================================
REM Работаем с FTP
IF NOT EXIST "%FCMD%" (
ECHO %date% %time% - WARNING FILE %FCMD% NOT FOUND
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING %FCMD% NOT FOUND"
EXIT /B 1
)
ftp -s:"%FCMD%" -i|| (
ECHO %date% %time% - WARNING FTP ERROR
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING FTP ERROR"
EXIT /B 1
)

REM==================================================
REM Удалим управляющий файл для FTP
IF EXIST "%FCMD%" DEL /Q "%FCMD%" || ECHO %date% %time% - WARNING ERROR DELETE %FCMD%

REM==================================================
REM Успешный выход
ECHO %date% %time% - FTP OK
EXIT /B 0