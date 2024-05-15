
mainC.exe : main.c
	gcc `pkg-config --cflags gtk4` main.c -o mainC.exe `pkg-config --libs gtk4`

mainC.S : main.c
	gcc -S `pkg-config --cflags gtk4` main.c -o mainC.S `pkg-config --libs gtk4`

mainAsm.exe : main.s
	gcc -fPIE `pkg-config --cflags gtk4` main.s -o mainAsm.exe `pkg-config --libs gtk4` 