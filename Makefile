CC = gcc
WARNING_FLAGS = -Wall -Wextra
EXE = 537make
SCAN_BUILD_DIR = scan-build-out

all: driver.o linked_list.o graph.o constants.o traversal.o reader.o command_executor.o
	$(CC) -o $(EXE) driver.o linked_list.o graph.o constants.o traversal.o reader.o command_executor.o

clean:
	rm -f $(EXE) *.o
	rm -rf $(SCAN_BUILD_DIR)

driver.o: driver.c entities/linked_list.h entities/graph.h utils/constants.h target_executor/traversal.h
	$(CC) $(WARNING_FLAGS) -c driver.c

linked_list.o: entities/linked_list.c entities/linked_list.h
	$(CC) $(WARNING_FLAGS) -c entities/linked_list.c

graph.o: entities/graph.c entities/graph.h entities/linked_list.h utils/constants.h
	$(CC) $(WARNING_FLAGS) -c entities/graph.c

constants.o: utils/constants.c utils/constants.h
	$(CC) $(WARNING_FLAGS) -c utils/constants.c

reader.o: input_parser/reader.h input_parser/reader.c entities/linked_list.h utils/constants.h entities/graph.h
	$(CC) $(WARNING_FLAGS) -c input_parser/reader.c

traversal.o: target_executor/traversal.c target_executor/traversal.h entities/linked_list.h entities/graph.h
	$(CC) $(WARNING_FLAGS) -c target_executor/traversal.c

command_executor.o: target_executor/command_executor.c target_executor/command_executor.h target_executor/traversal.h utils/constants.h entities/graph.h
	$(CC) $(WARNING_FLAGS) -c target_executor/command_executor.c

#
# Run the Clang Static Analyzer
#
scan-build: clean
	scan-build -o $(SCAN_BUILD_DIR) make

#
# View the one scan available using firefox
#
scan-view: scan-build
	firefox -new-window $(SCAN_BUILD_DIR)/*/index.html