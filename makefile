# Makefile written by Gaetan PELTE
# Uses the same workflow as Visual Studio's C++ project
# Settings based on "The Cherno"'s recommended settings. (https://www.youtube.com/channel/UCQ-W1KE9EYfdxhL6S4twUNw)
# Version 1.0

# C++ compiler and flags
CXX=g++
CXX_COMPILING_FLAGS=-Wall -std=c++11
CXX_LINKING_FLAGS=$(CXX_COMPILING_FLAGS)

# Project settings
PROJECT_NAME=Slicer
PLATFORM=Linux

# Configuration is either Debug or Release
CONFIGURATION=Debug

# Paths to sources, binaries and intermediates files
SOURCES_DIR=src
BINARIES_DIR=bin
BINARIES_OUTPUT_DIR=$(BINARIES_DIR)/$(PLATFORM)/$(CONFIGURATION)
INTERMEDIATES_DIR=$(BINARIES_DIR)/intermediates/$(PLATFORM)/$(CONFIGURATION)

# Object file to compile, use .o suffix
OBJECT_FILES=Main.o Printer.o Seance_1.o Functions.o Seance_2.o

# Source files for intermediates and debug purposes
SOURCE_FILES=$(patsubst %.o, %.cpp, $(OBJECT_FILES))

# Add optimization options in the Release configuration
ifeq ($(CONFIGURATION), Release)
	CXX_LINKING_FLAGS += -O2
	else
	# Assume the configuration is Debug
	CONFIGURATION=Debug
	# Add debug symbols in the Debug configuration
	CXX_LINKING_FLAGS += -g
endif

$(info Compiling in $(CONFIGURATION) configuration for the $(PLATFORM) platform.)
$(info Intermediates folder is $(INTERMEDIATES_DIR).)
$(info Binaries folder is $(BINARIES_OUTPUT_DIR).)

# Handling the compilation of object files to the intermediate folder
%.o: %.cpp
	$(info $(shell mkdir -p $(INTERMEDIATES_DIR)))
	$(CXX) -c $< -o $(addprefix $(INTERMEDIATES_DIR)/, $(notdir $@)) $(CXX_COMPILING_FLAGS)

$(PROJECT_NAME): $(addprefix $(SOURCES_DIR)/, $(OBJECT_FILES))
	$(info $(shell mkdir -p $(BINARIES_OUTPUT_DIR)))
	$(CXX) $(addprefix $(INTERMEDIATES_DIR)/, $(notdir $^)) -o $(BINARIES_OUTPUT_DIR)/$@ $(CXX_LINKING_FLAGS)

.PHONY: clean intermediates

# HACK: Overengineered rule, do not modify. Use at your own risk.
intermediates: $(addprefix $(SOURCES_DIR)/, $(SOURCE_FILES))

	$(info $(shell mkdir -p $(INTERMEDIATES_DIR)))

	$(foreach source, $(addprefix $(INTERMEDIATES_DIR)/, $(notdir $(addsuffix .i, $(basename $^)))), $(shell $(CXX) -E $(addprefix $(SOURCES_DIR)/, $(addsuffix .cpp, $(basename $(notdir $(source))))) -o $(source) $(CXX_COMPILING_FLAGS) ))
	$(foreach source, $(addprefix $(INTERMEDIATES_DIR)/, $(notdir $(addsuffix .asm, $(basename $^)))), $(shell $(CXX) -S $(addprefix $(SOURCES_DIR)/, $(addsuffix .cpp, $(basename $(notdir $(source))))) -o $(source) $(CXX_COMPILING_FLAGS) ))

	# $(CXX) -E $^ -o $(addprefix $(INTERMEDIATES_DIR)/, $(notdir $(addsuffix .i, $(basename $<)))) $(CXX_COMPILING_FLAGS)
	# $(CXX) -S $(patsubst %.o, %.cpp, $(SOURCES_DIR)/$(OBJECT_FILES)) -o  $(INTERMEDIATES_DIR)/$(basename $(notdir $^)).asm $(CXX_COMPILING_FLAGS)

clean:
	rm -rf $(addprefix ./, $(BINARIES_DIR))
	clear

# Automatically generating output directories if they don't exit yet.
# https://stackoverflow.com/questions/1950926/create-directories-using-make-file/45048948#45048948
