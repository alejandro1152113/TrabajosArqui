@echo off
setlocal
set "ROOT=%~dp0"
if not exist "%ROOT%bin" mkdir "%ROOT%bin"

for %%P in (post1 post1c post1d post1e post2 post2b post2c post2d) do (
    nasm -f bin "%ROOT%src\%%P.asm" -o "%ROOT%bin\%%P.com"
    if errorlevel 1 exit /b 1
)

echo Los ocho programas se ensamblaron correctamente.
endlocal
