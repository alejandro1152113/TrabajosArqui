@echo off
setlocal
set "ROOT=%~dp0"
if not exist "%ROOT%bin" mkdir "%ROOT%bin"

for %%P in (TECL POLL_T MULTI_ST ISR_KB MASK_KB ISR_CHAIN ISR_TIME) do (
    nasm -f bin "%ROOT%src\%%P.asm" -o "%ROOT%bin\%%P.com"
    if errorlevel 1 exit /b 1
)

nasm -f bin "%ROOT%src\LPT1_PORT.ASM" -o "%ROOT%bin\LPTTEST.com"
if errorlevel 1 exit /b 1

echo Los ocho programas se ensamblaron correctamente.
endlocal
