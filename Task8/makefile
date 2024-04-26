
CC:=g++
CPP_FLAGS:= -Werror -Wall -O0

PART1_SRC = Part1/src
PART1_INC = Part1/inc
PART1_OBJ = Part1/obj

PART2_SRC = Part2/src
PART2_INC = Part2/inc
PART2_OBJ = Part2/obj

PART3_SRC = Part3/src
PART3_INC = Part3/inc
PART3_OBJ = Part3/obj

# REPEATS=50
part1_sources = $(wildcard $(PART1_SRC)/*.cpp)
part1_objs = $(part1_sources:.cpp=.o)

part2_sources = $(wildcard $(PART2_SRC)/*.cpp)
part2_objs = $(part2_sources:.cpp=.o)

part3_sources = $(wildcard $(PART3_SRC)/*.cpp)
part3_objs = $(part3_sources:.cpp=.o)


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


part3.exe : $(patsubst $(PART3_SRC)%, $(PART3_OBJ)%, $(part3_objs)) 
	$(CC) $(CPP_FLAGS) $^ -o $@

$(PART3_OBJ)/%.o : CPP_FLAGS += -I$(PART3_INC)

$(PART3_OBJ)/%.o : $(PART3_SRC)/%.cpp $(PART3_INC)/*.h
	mkdir $(PART3_OBJ) 2> /dev/null || true
	$(CC) -c $(CPP_FLAGS) $< -o $@





