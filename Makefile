#******************************************************************************
#                                    MAIN                                     *
#******************************************************************************
NAME        = libasm.a
HEADER      = libasm.h
EXEC_NAME	= LEXECCCCCC

#******************************************************************************
#                                INSTRUCTIONS                                 *
#******************************************************************************
CC = gcc
NASM = nasm
NASM_FLAGS = -f elf64
CFLAGS = -fPIE -Wall -Wextra -Werror
AR = ar rcs
RM = rm -rf

#******************************************************************************
#                       SOURCES, OBJECTS & DEPENDENCIES                       *
#******************************************************************************
OBJ_DIR     = obj/
DEP_DIR     = $(OBJ_DIR)

SRCS = ft_strlen.s ft_strcpy.s ft_strcmp.s ft_write.s ft_read.s ft_strdup.s
OBJS = $(addprefix $(OBJ_DIR), $(SRCS:.s=.o))

BONUS_SRCS = ft_atoi_base_bonus.s ft_list_push_front_bonus.s ft_list_size_bonus.s \
             ft_list_sort_bonus.s ft_list_remove_if_bonus.s
BONUS_OBJS = $(addprefix $(OBJ_DIR), $(BONUS_SRCS:.s=.o))

MAIN_SRC = main.c
MAIN_OBJ = $(addprefix $(OBJ_DIR), $(MAIN_SRC:.c=.o))

BONUS_MAIN_SRC = main_bonus.c
BONUS_MAIN_OBJ = $(addprefix $(OBJ_DIR), $(BONUS_MAIN_SRC:.c=.o))

DEPS = $(OBJS:.o=.d) $(BONUS_OBJS:.o=.d) $(MAIN_OBJ:.o=.d)

ALL_OBJS = $(OBJS) $(BONUS_OBJS)

#******************************************************************************
#                                  COLORS                                     *
#******************************************************************************
RESET = \033[0m

COLOR_10 = \033[38;5;33m
COLOR_11 = \033[38;5;69m
COLOR_12 = \033[38;5;105m
COLOR_13 = \033[38;5;141m
COLOR_14 = \033[38;5;177m
COLOR_15 = \033[38;5;213m

ROSE = \033[1;38;5;225m
VIOLET = \033[1;38;5;55m
VERT = \033[1;38;5;85m
BLEU = \033[1;34m

#******************************************************************************
#                                COMPILATION                                  *
#******************************************************************************


all: $(NAME) test

bonus: $(ALL_OBJS)
	@$(AR) $(NAME) $(ALL_OBJS)
	@echo "$(ROSE)Library $(NAME) with bonus created$(RESET)"
	@$(MAKE) -s testbonus

$(NAME): $(OBJS)
	@$(AR) $(NAME) $(OBJS)
	@echo "$(ROSE)Library $(NAME) created$(RESET)"

test: $(NAME) $(MAIN_OBJ)
	@$(CC) $(CFLAGS) $(MAIN_OBJ) $(NAME) -o $(EXEC_NAME)
	@echo "$(ROSE)Executable "$(EXEC_NAME)" created$(RESET)"

testbonus: $(NAME) $(BONUS_MAIN_OBJ)
	@$(CC) $(CFLAGS) $(BONUS_MAIN_OBJ) $(NAME) -o $(EXEC_NAME)
	@echo "$(ROSE)Executable "$(EXEC_NAME)" created$(RESET)"

$(OBJ_DIR)%.o: %.s | $(OBJ_DIR)
	@mkdir -p $(dir $@)
	@$(NASM) $(NASM_FLAGS) $< -o $@
	@echo "$(BLEU)Assembling $< -> $@$(RESET)"

$(OBJ_DIR)%.o: %.c $(HEADER) | $(OBJ_DIR)
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -MMD -MP -c $< -o $@
	@echo "$(BLEU)Compiling $< -> $@$(RESET)"

$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)

clean:
	@$(RM) $(OBJ_DIR)
	@echo "$(VIOLET)Object files and dependencies removed$(RESET)"

fclean: clean
	@$(RM) $(NAME) $(EXEC_NAME)
	@echo "$(VERT)$(NAME) & $(EXEC_NAME) removed$(RESET)"

re: fclean all

-include $(DEPS)

.PHONY: all clean fclean re bonus test
