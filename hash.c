#include <stdio.h>
#include <string.h>

/**
 * @brief Custom hashing algorithm.
 *
 * This function implements a simple custom hashing algorithm that takes each
 * character in the input string and updates the hash value.
 *
 * @param input The input string to be hashed.
 * @return The hash value generated from the input string.
 */
unsigned long customHash(const char *input) {
    unsigned long hash = 5381;
    int c;

    while ((c = *input++)) {
        hash = ((hash << 5) + hash) + c;
    }

    return hash;
}

/**
 * @brief Generates a 12-character hash from the input string.
 *
 * This function generates a hash using the customHash algorithm and maps the
 * resulting hash to uppercase letters and digits. The generated hash is then
 * printed along with the input string.
 *
 * @param input The input string to be hashed.
 */
void generateHash(const char *input) {
    unsigned long hash = customHash(input);
    char result[13];  // 12 characters for hash + null terminator

    // Map the hash to the allowed characters
    const char *characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    for (int i = 0; i < 12; ++i) {
        result[i] = characters[hash % 36];
        hash /= 36;
    }

    result[12] = '\0';  // Null terminator

    printf("Input: %s\nGenerated Hash: %s\n", input, result);
}

int main(int argc, char *argv[]) {
    // Check for correct number of command line arguments
    if (argc != 2) {
        printf("Syntax: %s <input_string>\n", argv[0]);
        return 1;
    }

    // Check for special commands
    if (strcmp(argv[1], "version") == 0) {
        printf("Hash Generator Version 1.0\n");
        return 0;
    } else if (strcmp(argv[1], "help") == 0) {
        printf("Read the README.md for more information.\n");
        return 0;
    }

    // Generate and print the hash for the input string
    generateHash(argv[1]);

    return 0;
}
