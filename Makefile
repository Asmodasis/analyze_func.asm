#=======================================================================================
#
#FILE:              Makefile
#
#DESCRIPTION:       Nasm makefile using 8086 assembly
#
#ASSEMBLER:         NASM Assembler
#COMPILER:          Linux gcc compiler
#NOTES:             32bit machine code
#
#MODIFICATION HISTORY:
#
#Author                  Date               Version
#---------------         ----------         --------------
#Shawn Ray              2018-03-26         Version 1.0 started Makefile
#Shawn Ray              2018-03-26         Version 1.1 added nostdlib to ignore _start from gcc
#Shawn Ray              2018-04-04         Version 1.2 added macro objects to make 
#Shawn Ray              2018-04-25         Version 1.3 changed make clean object targets
#Shawn Ray              2018-04-25         Version 1.4 added cs219_io.o dependency 
#=========================================================================================

ASSEMBLER = nasm
ASXXFLAGS = -f elf32

OUTPUT = analyze_func

CC = gcc
CXXFLAGS = -nostdlib -m32 -Wall -pedantic       
						# compiler flags
                                                # no standard library because
                                                # _start is defined in gcc
MACRO = cs219_io

OBJS = $(OUTPUT).o                              # non-classes
DEPS = $(MACRO).o				# dependant objects		
#
#
#
#

#all: $(OUTPUT)

$(OUTPUT): $(OBJS) $(DEPS)
	$(CC) $(CXXFLAGS) $(OBJS) $(DEPS) -o $(OUTPUT)


$(OUTPUT).o: $(OUTPUT).asm 
	$(ASSEMBLER) $(ASXXFLAGS) $(OUTPUT).asm

#
#
#
#
#

clean:
	rm -f $(OUTPUT)
	rm -f $(OUTPUT).o
#
	reset
	@echo Make clean, removed object and executable files ...
	@echo Contents in this Directory ...
	ls -la
#
#
#
#



