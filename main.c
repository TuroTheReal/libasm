#include "libasm.h"

#define BUFFER_SIZE 20
#define GREEN "\033[32m"
#define RED "\033[31m"
#define RESET "\033[0m"


int *get_errno_ptr(void)
{
    return &errno;
}

void test_ft_strlen(const char *test_name, const char *input)
{
    printf("Test: %s\n", test_name);
    printf("Input: \"%s\"\n", input ? input : "(null)");

    size_t expected = strlen(input);
    size_t result = ft_strlen(input);

    printf("Expected (strlen): %zu\n", expected);
    printf("Got (ft_strlen):   %zu\n", result);

    if (result == expected) {
        printf("Status: " GREEN "✓ PASS" RESET "\n");
    } else {
        printf("Status: " RED "✗ FAIL" RESET "\n");
    }
    printf("----------------------------------------\n");
}


void test_ft_strcpy(const char *test_name, const char *input)
{
    printf("Test: %s\n", test_name);
    printf("Input: \"%s\"\n", input ? input : "(null)");
  	if (!input){
		printf("Cannot test NULL\n");
		return;
	}

	ssize_t len = strlen(input) + 1;
    char* expected = malloc(len);
	char* result = malloc(len);

	strcpy(expected, input);
    ft_strcpy(result, input);

    printf("Expected (strcpy): %s\n", expected);
    printf("Got (ft_strcpy):   %s\n", result);

    if (strcmp(result, expected) == 0) {
        printf("Status: " GREEN "✓ PASS" RESET "\n");
    } else {
        printf("Status: " RED "✗ FAIL" RESET "\n");
    }
    printf("----------------------------------------\n");

	free(expected);
	free(result);
}

void test_ft_strcmp(const char *test_name, const char *s1, const char *s2)
{
    printf("Test: %s\n", test_name);
    printf("Input s1: \"%s\"\n", s1 ? s1 : "(null)");
    printf("Input s2: \"%s\"\n", s2 ? s2 : "(null)");

    int expected = strcmp(s1, s2);
    int result = ft_strcmp(s1, s2);

    printf("Expected (strcmp): %d\n", expected);
    printf("Got (ft_strcmp):   %d\n", result);

    if ((expected == 0 && result == 0) || (expected < 0 && result < 0) || (expected > 0 && result > 0)) {
        printf("Status: " GREEN "✓ PASS" RESET "\n");
    } else {
        printf("Status: " RED "✗ FAIL" RESET "\n");
    }
    printf("----------------------------------------\n");
}


void test_ft_write(const char *test_name, const char *str)
{
    printf("Test: %s\n", test_name);
    printf("Input str: \"%s\"\n", str ? str : "(null)");

    ssize_t expected = write(1, str, strlen(str));
    printf("\nExpected (write) returned: %zd\n", expected);

    ssize_t result = ft_write(1, str, strlen(str));
    printf("\nGot (ft_write) returned:   %zd\n", result);

    if ((expected == -1 && result == -1) || (expected == result)) {
        printf("Status: " GREEN "✓ PASS" RESET "\n");
    } else {
        printf("Status: " RED "✗ FAIL" RESET "\n");
    }
    printf("----------------------------------------\n");
}

void test_ft_read(const char *test_name, int fd)
{
    printf("Test: %s\n", test_name);

    char buf_expected[BUFFER_SIZE];
    char buf_result[BUFFER_SIZE];

    ssize_t expected = read(fd, buf_expected, BUFFER_SIZE - 1);
    if (expected >= 0)
        buf_expected[expected] = '\0';
    else
        buf_expected[0] = '\0';

    if (lseek(fd, 0, SEEK_SET) == -1)
        printf("Warning: cannot reset fd position\n");

    ssize_t result = ft_read(fd, buf_result, BUFFER_SIZE - 1);
    if (result >= 0)
        buf_result[result] = '\0';
    else
        buf_result[0] = '\0';

    printf("Expected (read) returned: %zd\n", expected);
    printf("Expected buffer: \"%s\"\n", buf_expected);

    printf("Got (ft_read) returned:   %zd\n", result);
    printf("Got buffer: \"%s\"\n", buf_result);

    if ((expected == -1 && result == -1) ||
        (expected == result && strcmp(buf_expected, buf_result) == 0)) {
        printf("Status: " GREEN "✓ PASS" RESET "\n");
    } else {
        printf("Status: " RED "✗ FAIL" RESET "\n");
    }
    printf("----------------------------------------\n");
}

int main(void)
{
    printf("=== Tests pour ft_strlen ===\n\n");

    test_ft_strlen("Chaîne simple", "Hello");
    test_ft_strlen("Chaîne vide", "");
    test_ft_strlen("Un seul caractère", "A");
    test_ft_strlen("Chaîne avec espaces", "Hello World");
    test_ft_strlen("Chaîne longue", "Cette chaîne est suffisamment longue pour tester les performances");
    test_ft_strlen("Caractères spéciaux", "!@#$%^&*()_+-={}[]|\\:;\"'<>,.?/");
    test_ft_strlen("Chiffres", "1234567890");


	printf("=== Tests pour ft_strcpy ===\n\n");

    test_ft_strcpy("Chaîne simple", "Hello");
    test_ft_strcpy("Chaîne vide", "");
    test_ft_strcpy("Un seul caractère", "A");
    test_ft_strcpy("Chaîne avec espaces", "Hello World");
    test_ft_strcpy("Chaîne longue", "Cette chaîne est suffisamment longue pour tester les performances");
    test_ft_strcpy("Caractères spéciaux", "!@#$%^&*()_+-={}[]|\\:;\"'<>,.?/");
    test_ft_strcpy("Chiffres", "1234567890");


	printf("=== Tests pour ft_strcmp ===\n\n");

    test_ft_strcmp("Chaîne simple", "Hello", "Hello");
    test_ft_strcmp("Chaîne vide", "", "");
    test_ft_strcmp("Un seul caractère égal", "A", "A");
    test_ft_strcmp("Un seul caractère différent", "A", "B");
    test_ft_strcmp("Chaîne avec espaces", "Hello World", "Hello World");
    test_ft_strcmp("Chaîne longue", "Cette chaîne est suffisamment longue", "Cette chaîne est suffisament longue");
    test_ft_strcmp("Caractères spéciaux", "!@#$%^&*()_+-={}", "!@#$%^&*()_+-={}");
    test_ft_strcmp("Chiffres", "1234567890", "1234567890");
    test_ft_strcmp("Différente taille", "Hello", "Hello World");


	printf("=== Tests pour ft_write ===\n\n");

    test_ft_write("Chaîne simple", "Hello");
    test_ft_write("Chaîne vide", "");
    test_ft_write("Un seul caractère", "A");
    test_ft_write("Chaîne avec espaces", "Hello World");
    test_ft_write("Chaîne longue", "Cette chaîne est suffisamment longue pour tester les performances");
    test_ft_write("Caractères spéciaux", "!@#$%^&*()_+-={}[]|\\:;\"'<>,.?/");
    test_ft_write("Chiffres", "1234567890");


	printf("=== Tests pour ft_read ===\n\n");

    int fd = open("Makefile", O_RDONLY);
    if (fd == -1) {
        perror("open Makefile");
    } else {
        test_ft_read("Lecture fichier Makefile", fd);
        close(fd);
    }

	int fd2 = open("rulesASM.txt", O_RDONLY);
    if (fd2 == -1) {
        perror("open Makefile");
    } else {
        test_ft_read("Lecture fichier rulesASM.txt", fd2);
        close(fd2);
    }
    return 0;
}