#include "libasm.h"

#define BUFFER_SIZE 20
#define GREEN "\033[32m"
#define RED "\033[31m"
#define RESET "\033[0m"

int *get_errno_ptr(void)
{
	return &errno;
}

t_list *create_node(void *data)
{
    t_list *node = malloc(sizeof(t_list));
    if (!node)
        return NULL;
    node->data = data;
    node->next = NULL;
    return node;
}

void free_list(t_list *list)
{
    t_list *tmp;
    while (list)
    {
        tmp = list->next;
        free(list);
        list = tmp;
    }
}

void print_list(t_list *list, const char *prefix)
{
    printf("%s: ", prefix);
    if (!list)
    {
        printf("(null)\n");
        return;
    }

    while (list)
    {
        printf("[%s]", (char *)list->data);
        if (list->next)
            printf(" -> ");
        list = list->next;
    }
    printf("\n");
}

int list_size_ref(t_list *list)
{
    int size = 0;
    while (list)
    {
        size++;
        list = list->next;
    }
    return size;
}

void list_push_front_ref(t_list **list, void *data)
{
    t_list *new_node = create_node(data);
    if (!new_node)
        return;
    new_node->next = *list;
    *list = new_node;
}

int int_cmp(void *a, void *b)
{
    int ia = *(int *)a;
    int ib = *(int *)b;
    return (ia - ib);
}

int str_cmp(void *a, void *b)
{
    return strcmp((char *)a, (char *)b);
}

void list_sort_ref(t_list **list, int (*cmp)(void *, void *))
{
    if (!list || !*list || !(*list)->next)
        return;

    t_list *current, *index;
    void *temp;

    for (current = *list; current->next != NULL; current = current->next)
    {
        for (index = current->next; index != NULL; index = index->next)
        {
            if (cmp(current->data, index->data) > 0)
            {
                temp = current->data;
                current->data = index->data;
                index->data = temp;
            }
        }
    }
}

void list_remove_if_ref(t_list **list, void *data_ref, int (*cmp)(void *, void *), void (*free_fct)(void *))
{
    if (!list || !*list)
        return;

    t_list *current = *list;
    t_list *prev = NULL;

    while (current)
    {
        if (cmp(current->data, data_ref) == 0)
        {
            if (prev)
                prev->next = current->next;
            else
                *list = current->next;

            if (free_fct)
                free_fct(current->data);

            t_list *to_free = current;
            current = current->next;
            free(to_free);
        }
        else
        {
            prev = current;
            current = current->next;
        }
    }
}

void test_ft_list_push_front(const char *test_name, t_list *initial_list, void *data)
{
    printf("Test: %s\n", test_name);

    t_list *expected_list = NULL;
    t_list *current = initial_list;
    t_list **tail = &expected_list;

    while (current)
    {
        *tail = create_node(current->data);
        tail = &((*tail)->next);
        current = current->next;
    }

    t_list *test_list = NULL;
    current = initial_list;
    tail = &test_list;

    while (current)
    {
        *tail = create_node(current->data);
        tail = &((*tail)->next);
        current = current->next;
    }

    print_list(initial_list, "Initial list");
    printf("Data to push: %s\n", data ? (char *)data : "(null)");

    list_push_front_ref(&expected_list, data);
    ft_list_push_front(&test_list, data);

    print_list(expected_list, "Expected");
    print_list(test_list, "Got     ");

    int expected_size = list_size_ref(expected_list);
    int result_size = list_size_ref(test_list);

    int pass = (expected_size == result_size);
    if (pass && expected_list && test_list)
        pass = (expected_list->data == test_list->data);

    printf("Status: %s%s%s\n", pass ? GREEN "✓ PASS" : RED "✗ FAIL", RESET, "");
    printf("----------------------------------------\n");

    free_list(expected_list);
    free_list(test_list);
}

void test_ft_list_size(const char *test_name, t_list *list)
{
    printf("Test: %s\n", test_name);
    print_list(list, "List");

    int expected = list_size_ref(list);
    int result = ft_list_size(list);

    printf("Expected (list_size_ref): %d\n", expected);
    printf("Got (ft_list_size):       %d\n", result);

    if (result == expected) {
        printf("Status: " GREEN "✓ PASS" RESET "\n");
    } else {
        printf("Status: " RED "✗ FAIL" RESET "\n");
    }
    printf("----------------------------------------\n");
}

void test_ft_list_sort(const char *test_name, t_list *list, int (*cmp)(void *, void *))
{
    printf("Test: %s\n", test_name);

    t_list *expected_list = NULL;
    t_list *current = list;
    t_list **tail = &expected_list;

    while (current)
    {
        *tail = create_node(current->data);
        tail = &((*tail)->next);
        current = current->next;
    }

    t_list *test_list = NULL;
    current = list;
    tail = &test_list;

    while (current)
    {
        *tail = create_node(current->data);
        tail = &((*tail)->next);
        current = current->next;
    }

    print_list(list, "Original");

    list_sort_ref(&expected_list, cmp);
    ft_list_sort(&test_list, cmp);

    print_list(expected_list, "Expected");
    print_list(test_list, "Got     ");

    int pass = 1;
    t_list *exp = expected_list;
    t_list *res = test_list;

    while (exp && res && pass)
    {
        if (cmp(exp->data, res->data) != 0)
            pass = 0;
        exp = exp->next;
        res = res->next;
    }
    if ((exp != NULL) != (res != NULL))
        pass = 0;

    printf("Status: %s%s%s\n", pass ? GREEN "✓ PASS" : RED "✗ FAIL", RESET, "");
    printf("----------------------------------------\n");

    free_list(expected_list);
    free_list(test_list);
}

void test_ft_list_remove_if(const char *test_name, t_list *list, void *data_ref, int (*cmp)(void *, void *))
{
    printf("Test: %s\n", test_name);

    t_list *expected_list = NULL;
    t_list *current = list;
    t_list **tail = &expected_list;

    while (current)
    {
        *tail = create_node(current->data);
        tail = &((*tail)->next);
        current = current->next;
    }

    t_list *test_list = NULL;
    current = list;
    tail = &test_list;

    while (current)
    {
        *tail = create_node(current->data);
        tail = &((*tail)->next);
        current = current->next;
    }

    print_list(list, "Original");
    printf("Data to remove: %s\n", data_ref ? (char *)data_ref : "(null)");

    list_remove_if_ref(&expected_list, data_ref, cmp, NULL);
    ft_list_remove_if(&test_list, data_ref, cmp, NULL);

    print_list(expected_list, "Expected");
    print_list(test_list, "Got     ");

    int expected_size = list_size_ref(expected_list);
    int result_size = list_size_ref(test_list);

    int pass = (expected_size == result_size);
    if (pass)
    {
        t_list *exp = expected_list;
        t_list *res = test_list;

        while (exp && res && pass)
        {
            if (cmp(exp->data, res->data) != 0)
                pass = 0;
            exp = exp->next;
            res = res->next;
        }
    }

    printf("Status: %s%s%s\n", pass ? GREEN "✓ PASS" : RED "✗ FAIL", RESET, "");
    printf("----------------------------------------\n");

    free_list(expected_list);
    free_list(test_list);
}

int ft_index(char c, const char *base)
{
	int i = 0;
	while (base[i])
	{
		if (base[i] == c)
			return i;
		i++;
	}
	return -1;
}

int validate_base(const char *base, int len)
{
	int i, j;

	if (len < 2)
		return 0;

	for (i = 0; i < len; i++)
	{
		if (base[i] == ' ' || base[i] == '\t' || base[i] == '\n' ||
			base[i] == '\v' || base[i] == '\f' || base[i] == '\r' ||
			base[i] == '+' || base[i] == '-')
			return 0;

		for (j = i + 1; j < len; j++)
		{
			if (base[i] == base[j])
				return 0;
		}
	}
	return 1;
}

int atoi_base(const char *str, const char *base)
{
	int result = 0;
	int sign = 1;
	int base_len = 0;
	int index;
	int sign_count = 0;

	while (base[base_len])
		base_len++;

	if (!validate_base(base, base_len))
		return 0;

	while (*str == ' ' || (*str >= 9 && *str <= 13))
		str++;

	while (*str == '-' || *str == '+')
	{
		sign_count++;
		if (sign_count > 1)
			return 0;

		if (*str == '-')
			sign *= -1;
		str++;
	}

	while ((index = ft_index(*str, base)) != -1)
	{
		result = result * base_len + index;
		str++;
	}

	return result * sign;
}


void test_ft_atoi_base(const char *test_name, char *input, char *base)
{
	printf("Test: %s\n", test_name);
	printf("Input: \"%s\"\n", input ? input : "(null)");
  	if (!input){
		printf("Cannot test NULL\n");
		return;
	}

	int expected = atoi_base(input, base);
	int result = ft_atoi_base(input, base);

	printf("Expected (atoi_base): %d\n", expected);
	printf("Got (ft_atoi_base):   %d\n", result);

	if (result == expected) {
		printf("Status: " GREEN "✓ PASS" RESET "\n");
	} else {
		printf("Status: " RED "✗ FAIL" RESET "\n");
	}
	printf("----------------------------------------\n");
}

int main(void) // BONUS PART
{

	printf("========= Tests pour ft_atoi_base =========\n\n");

	test_ft_atoi_base("Base 10", "10", "0123456789");
	test_ft_atoi_base("Base 02", "10", "01");
	test_ft_atoi_base("Base 16", "15", "0123456789abcdef");
	test_ft_atoi_base("-Base 10", "-10", "0123456789");
	test_ft_atoi_base("-Base 02", "-10", "01");
	test_ft_atoi_base("-Base 16", "-15", "0123456789abcdef");
	test_ft_atoi_base("Chaîne vide", "", "0123456789");
	test_ft_atoi_base("Base vide", "12", "");
	test_ft_atoi_base("Trop de signe", "--12", "0123456789");
	test_ft_atoi_base("Caractère invalide", "*12", "0123456789");
	test_ft_atoi_base("Base invalide", "12", "01123456789");


	printf("========= Tests pour ft_list_push_front =========\n\n");

    test_ft_list_push_front("Liste vide", NULL, "first");

    t_list *single = create_node("existing");
    test_ft_list_push_front("Liste avec un élément", single, "new_first");
    free_list(single);

    t_list *multi = create_node("third");
    multi->next = create_node("fourth");
    multi->next->next = create_node("fifth");
    test_ft_list_push_front("Liste avec plusieurs éléments", multi, "new_first");
    free_list(multi);

    printf("========= Tests pour ft_list_size =========\n\n");

    test_ft_list_size("Liste vide", NULL);

    single = create_node("only");
    test_ft_list_size("Liste avec un élément", single);
    free_list(single);

    multi = create_node("first");
    multi->next = create_node("second");
    multi->next->next = create_node("third");
    multi->next->next->next = create_node("fourth");
    test_ft_list_size("Liste avec 4 éléments", multi);
    free_list(multi);

    printf("========= Tests pour ft_list_sort =========\n\n");

    test_ft_list_sort("Liste vide", NULL, str_cmp);

    single = create_node("only");
    test_ft_list_sort("Liste avec un élément", single, str_cmp);
    free_list(single);

    multi = create_node("apple");
    multi->next = create_node("banana");
    multi->next->next = create_node("cherry");
    test_ft_list_sort("Liste déjà triée", multi, str_cmp);
    free_list(multi);

    multi = create_node("zebra");
    multi->next = create_node("yellow");
    multi->next->next = create_node("apple");
    test_ft_list_sort("Liste inversée", multi, str_cmp);
    free_list(multi);

    printf("========= Tests pour ft_list_remove_if =========\n\n");

    test_ft_list_remove_if("Liste vide", NULL, "nothing", str_cmp);

    multi = create_node("remove_me");
    multi->next = create_node("keep");
    multi->next->next = create_node("also_keep");
    test_ft_list_remove_if("Suppression premier élément", multi, "remove_me", str_cmp);
    free_list(multi);

    multi = create_node("keep");
    multi->next = create_node("remove_me");
    multi->next->next = create_node("also_keep");
    test_ft_list_remove_if("Suppression élément milieu", multi, "remove_me", str_cmp);
    free_list(multi);

    multi = create_node("remove");
    multi->next = create_node("keep");
    multi->next->next = create_node("remove");
    multi->next->next->next = create_node("also_keep");
    multi->next->next->next->next = create_node("remove");
    test_ft_list_remove_if("Suppression multiples occurrences", multi, "remove", str_cmp);
    free_list(multi);

    multi = create_node("first");
    multi->next = create_node("second");
    multi->next->next = create_node("third");
    test_ft_list_remove_if("Élément inexistant", multi, "not_found", str_cmp);
    free_list(multi);

	return 0;
}