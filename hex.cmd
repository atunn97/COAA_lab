@echo off
setlocal
rem hex.cmd - dich file .c hoac .asm (8051, SDCC) ra .hex nam canh file goc.
rem Cach dung: keo-tha file len hex.cmd, hoac go:  hex.cmd duong\dan\bai.c
rem Lenh goc: C   = sdcc + packihx
rem           ASM = sdas8051 -losgff + sdld -i + packihx
rem Code C viet cho Keil (reg52.h, sbit X = P1^0, interrupt 1...) duoc keil2sdcc.ps1 tu doi truoc khi dich.
set "HERE=%~dp0"
rem dung SDCC 4.5.0 di kem repo (tools\sdcc): may nao clone ve cung dich duoc, khong can cai, ra cung mot .hex
set "PATH=%HERE%tools\sdcc\bin;%PATH%"
rem KHONG dat ten file vao trong khoi ( ... ): ten nhu "main (1).c" co dau ) se lam cmd hieu la dong khoi

if "%~1"=="" goto :usage
if not exist "%~f1" goto :nofile

cd /d "%~dp1"
set "N=%~n1"
if /i "%~x1"==".c" goto :c
if /i "%~x1"==".asm" goto :asm
echo [LOI] Chi nhan .c hoac .asm, file nay la %~x1
goto :end

:c
rem sdcc sinh ra %N%.asm - neu do la ban ASM viet tay thi se bi ghi de, chan lai
if not exist "%N%.asm" goto :c_ok
findstr /m /c:"File Created by SDCC" "%N%.asm" >nul && goto :c_ok
echo [DUNG] %N%.asm la ban ASM viet tay, dich %N%.c se ghi de mat no.
echo        Doi ten file ASM thanh %N%_asm.asm roi chay lai.
goto :end

:c_ok
rem xoa .hex cu truoc, de dich loi thi Proteus khong nap nham ban cu
del "%N%.hex" 2>nul
rem warning 283 = "void f()" thay vi "void f(void)", vo hai nhung lam roi man hinh
set "K51=%TEMP%\hex51_keil"
if exist "%K51%" rd /s /q "%K51%"
powershell -NoProfile -ExecutionPolicy Bypass -File "%HERE%keil2sdcc.ps1" "%~f1" "%K51%\%~nx1"
if errorlevel 2 goto :fail
if errorlevel 1 goto :keil
sdcc --disable-warning 283 "%~nx1" || goto :fail
goto :pack

:keil
rem dich ban da doi trong thu muc tam, roi chep ket qua ve canh file goc
pushd "%K51%"
sdcc --disable-warning 283 "%~nx1" || (popd & goto :fail)
for %%E in (asm lst rst sym rel map mem lk ihx) do if exist "%N%.%%E" copy /y "%N%.%%E" "%~dp1" >nul
popd
goto :pack

:asm
del "%N%.hex" 2>nul
sdas8051 -losgff "%~nx1" || goto :fail
sdld -i "%N%.rel" || goto :fail

:pack
rem thieu .ihx ma van chay packihx thi no de lai mot .hex RONG 0 byte
if not exist "%N%.ihx" goto :fail
packihx "%N%.ihx" > "%N%.hex" || goto :fail
rem Size = cong truong byte-count cua moi ban ghi du lieu (type 00) trong .hex
set /a SZ=0
for /f "usebackq delims=" %%L in ("%N%.hex") do call :count "%%L"
echo.
echo [OK] %~dp1%N%.hex
echo      Size = %SZ% byte
goto :end

:count
set "R=%~1"
if "%R:~7,2%"=="00" set /a SZ+=0x%R:~1,2%
exit /b

:usage
echo Cach dung: keo-tha file .c / .asm len hex.cmd, hoac go: hex.cmd bai.c
goto :end

:nofile
echo [LOI] Khong thay file: %~1
goto :end

:fail
del "%~dp1%N%.hex" 2>nul
echo.
echo [LOI] Dich khong qua - doc thong bao loi o tren. Khong tao .hex.

:end
rem keo-tha tu Explorer thi dung lai cho doc; chay trong terminal thi khong
if not defined TERM_PROGRAM if not defined WT_SESSION pause
