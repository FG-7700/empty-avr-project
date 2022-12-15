#########################################################
# Bare Metal Arduino Makefile                           #
#########################################################
# call "make" to compile your program                   #
# call "make uplaod" to compile and upload your program #
# call "make clean" to clean the build directories      #
#########################################################
# Author: Portable-Navi (protable-navi@proton.me)       #
#########################################################


########################################
# Arduino Config                       #
########################################
# Set the Baudrate and Boardtype here. #
# atmega328p is a Arduino UNO.         #
########################################

BAUDRATE  := 115200
BOARDTYPE := atmega328p


########################################
# Compiler Config                      #
########################################
# Configure compile flags and the      #
# compiler here. The name of the       #
# output binary can also be changed    #
# here (TARGET_NAME)                   #
########################################

TARGET_NAME := main
CC = avr-gcc
CFLAGS := -Os -DF_CPU=1600000UL -mmcu=$(BOARDTYPE) -Wall


########################################
# Project Structure                    #
########################################
# All *.c files at SRC_PATH will be    #
# automaticly compiled.                #
# The resulting binary will be placed  #
# in BIN_PATH. You can change the      #
# default folders here, if you like.   #
# BIN_PATH and OBJ_PATH will be        #
# created automatically.               #
########################################

BIN_PATH := bin
SRC_PATH := src
OBJ_PATH := obj



########################################
# You most likely	dont need to change  #
# anything past this point...          #
########################################



TARGET := $(BIN_PATH)/$(TARGET_NAME)

# Collects alls source files from SRC_PATH
SRC := $(foreach x, $(SRC_PATH), $(wildcard $(addprefix $(x)/*,.c*)))

# Will list all object files to be compiled from SRC
OBJ := $(addprefix $(OBJ_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))

# Everything contained in this list will be cleaned on "make clean"
CLEAN_LIST := $(TARGET) $(OBJ)

# default rule
default: makedir all

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ)
	avr-objcopy -O ihex -R .eeprom $@ $@

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

# phony rules
.PHONY: makedir
makedir:
	@mkdir -p $(BIN_PATH) $(OBJ_PATH)

.PHONY: all
all: $(TARGET)

.PHONY: clean
clean:
	@echo cleaning...
	@rm -f $(CLEAN_LIST)

.PHONY: upload
upload: $(TARGET)
	sudo avrdude -F -V -c arduino -p $(BOARDTYPE) -P /dev/ttyACM0 -b $(BAUDRATE) -U flash:w:$<

