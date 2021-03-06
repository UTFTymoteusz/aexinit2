BIN_NAME = aexinit

CC = x86_64-aex2-elf-gcc
LD  = ld

MKDIR = mkdir -p

BIN      := /tmp/aex2/bin/$(BIN_NAME)/
DEP_DEST := $(BIN)dep/
OBJ_DEST := $(BIN)obj/

CFILES  := $(shell find . -type f -name '*.c')
HFILES  := $(shell find . -type f -name '*.h')
OBJS      := $(patsubst %.o, $(OBJ_DEST)%.o, $(CFILES:.c=.c.o))

BIN_OBJ = $(BIN)$(BIN_NAME)

GFLAGS = -O3 -pipe

INCLUDES := -I. -Iinclude/

CFLAGS := $(GFLAGS) \
	$(INCLUDES)

ASFLAGS := -felf64

LDFLAGS := $(GFLAGS)        \
	-ffreestanding          \
	-z max-page-size=0x1000 \
	-no-pie

format:
	@$(MKDIR) $(BIN)
	clang-format -style=file -i ${CFILES} ${HFILES}

all: $(OBJS)
	@$(MKDIR) $(BIN)
	$(CC) $(CFLAGS) -o $(BIN_OBJ) $(OBJS)

include $(shell find $(DEP_DEST) -type f -name *.d)

copy:
	@cp $(BIN_OBJ) "$(COPY_DIR)"

clean:
	rm -rf $(BIN)

$(OBJ_DEST)%.c.o : %.c
	@$(MKDIR) ${@D}
	@$(MKDIR) $(dir $(DEP_DEST)$*)
	$(CC) $(CFLAGS) -c $< -o $@ -MMD -MT $@ -MF $(DEP_DEST)$*.cpp.d