NAME = libasm.a
CC = gcc
NASM = nasm
NASM_FLAGS = -f elf64
CFLAGS = -Wall -Wextra -Werror

SRCS = ft_strlen.s ft_strcpy.s ft_strcmp.s ft_write.s ft_read.s ft_strdup.s
OBJS = $(SRCS:.s=.o)

BONUS_SRCS = ft_atoi_base_bonus.s ft_list_push_front_bonus.s ft_list_size_bonus.s \
             ft_list_sort_bonus.s ft_list_remove_if_bonus.s
BONUS_OBJS = $(BONUS_SRCS:.s=.o)


$(NAME): $(OBJS)
	ar rcs $(NAME) $(OBJS)


all: $(NAME)


clean:
	rm -f $(OBJS) $(BONUS_OBJS)


fclean: clean
	rm -f $(NAME) test_libasm


re: fclean all


bonus: $(OBJS) $(BONUS_OBJS)
	ar rcs $(NAME) $(OBJS) $(BONUS_OBJS)

%.o: %.s
	$(NASM) $(NASM_FLAGS) $< -o $@


.PHONY: all clean fclean re bonus test