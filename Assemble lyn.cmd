@echo off

SET startDir=C:\devkitPro\devkitARM\bin\

@rem Assemble into an elf
SET as="%startDir%arm-none-eabi-as"
%as% -g -mcpu=arm7tdmi -mthumb-interwork %1 -o "%~n1.elf"

set "lyn=%~dp0Event Assembler\Tools\lyn.exe"

"%lyn%" "%~n1.elf" > "%~n1.lyn.event"
echo y | del "%~n1.elf"
pause
