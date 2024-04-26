
CC:=g++
CPP_FLAGS:= -Werror -Wall -O0

PART1_SRC = Part1/src
PART1_INC = Part1/inc
PART1_OBJ = Part1/obj

PART2_SRC = Part2/src
PART2_INC = Part2/inc
PART2_OBJ = Part2/obj

# REPEATS=50
part1_sources = $(wildcard $(PART1_SRC)/*.cpp)
part1_objs = $(part1_sources:.cpp=.o)

part2_sources = $(wildcard $(PART2_SRC)/*.cpp)
part2_objs = $(part2_sources:.cpp=.o)


# part1.exe : $(if $(value REPEATS),,$(error asdasdasd)) 
part1.exe : CPP_FLAGS += -DREPEATS=$(REPEATS)
part1.exe : CPP_FLAGS += -mfpmath=387 -mhard-float
part1.exe : $(patsubst $(PART1_SRC)%, $(PART1_OBJ)%, $(part1_objs)) 
	$(CC) $(CPP_FLAGS) $^ -o $@

$(PART1_OBJ)/%.o : CPP_FLAGS += -I$(PART1_INC)

$(PART1_OBJ)/%.o : $(PART1_SRC)/%.cpp $(PART1_INC)/*.h
	mkdir $(PART1_OBJ) 2> /dev/null || true
	$(CC) -c $(CPP_FLAGS) $< -o $@

part1.disasm : part1.exe
	objdump -d $<  > $@

part2.exe : $(patsubst $(PART2_SRC)%, $(PART2_OBJ)%, $(part2_objs)) 
	$(CC) $(CPP_FLAGS) $^ -o $@

$(PART2_OBJ)/%.o : CPP_FLAGS += -I$(PART2_INC)

$(PART2_OBJ)/%.o : $(PART2_SRC)/%.cpp $(PART2_INC)/*.h
	mkdir $(PART2_OBJ) 2> /dev/null || true
	$(CC) -c $(CPP_FLAGS) $< -o $@
