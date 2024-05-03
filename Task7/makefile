main.exe : main.cpp strcopy.s
	g++ main.cpp strcopy.s -o main.exe -O0 -Werror -Wpedantic -Wall -Wno-vla

main.s : main.cpp
	g++ -S main.cpp -o main.s -Werror -Wpedantic -Wall -Wno-vla

.Phony: run
run: main.exe main.cpp strcopy.s
	./main.exe
