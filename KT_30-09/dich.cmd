@echo off
rem dich.cmd - dich file .asm cu phap CUA THAY (ORG/END/0FFH) bang ASEM-51 cua Proteus ra .hex
rem Cach dung: keo-tha file .asm len dich.cmd
if "%~1"=="" (echo Keo-tha file .asm len dich.cmd & pause & exit /b 1)
cd /d "%~dp1"
if exist "%~n1.hex" del "%~n1.hex"
"C:\Program Files (x86)\Labcenter Electronics\Proteus 8 Professional\Tools\ASEM51\ASEM.EXE" "%~nx1"
if exist "%~n1.hex" (echo. & echo [OK] Da tao %~n1.hex - chon file nay trong Program File cua U1) else (echo. & echo [LOI] Xem thong bao loi o tren, so dong la dong trong file .asm)
pause
