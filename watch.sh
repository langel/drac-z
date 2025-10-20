#!/bin/bash
onchange -v -p 250 './*.asm' './src/*.asm' './objs/*.asm' -- sh -c 'echo compiling && dasm drac-z.asm -Isrc -Iaudio -Ivisual -odrac-z.nes -f3 -v2 -llisting.txt && echo launching && cmd.exe /C start drac-z.nes'
# dasm -sromsym.txt will export symbol file
