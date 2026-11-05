@echo off
setlocal
set "ROOT=%~dp0"
if not exist "%ROOT%bin" mkdir "%ROOT%bin"

for %%P in (post1 post1b post1c post1d post2a post2b post2c post2d post2e) do (
    nasm -f bin "%ROOT%src\%%P.asm" -o "%ROOT%bin\%%P.com"
    if errorlevel 1 exit /b 1
)

echo Los nueve programas se ensamblaron correctamente.
endlocal
