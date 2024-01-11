// пока что попытка не очень
// какой-то вариант  лежил в chatGPT 
// но все равно лучше самому дописать


function customHash(input) {
    let hash = 5381;

    for (let i = 0; i < input.length; i++) {
        const charCode = input.charCodeAt(i);
        hash = ((hash << 5) + hash) + charCode;
    }

    return hash;
}

/**
 * @brief Generates a 12-character hash from the input string.
 *
 * This function generates a hash using the customHash algorithm and maps the
 * resulting hash to uppercase letters and digits. The generated hash is then
 * returned along with the input string.
 *
 * @param input The input string to be hashed.
 * @return An object containing the input string and the generated hash.
 */
function generateHash(input) {
    let hash = customHash(input);
    let result = '';

    // Map the hash to the allowed characters
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    for (let i = 0; i < 12; ++i) {
        result += characters[hash % 36];
        hash = Math.floor(hash / 36);
    }

    return { input, hash: result };
}

/*module.exports = customHash;*/
module.exports = generateHash;

/* здесь проблема с кириллцей и adiomtimur не хешируется" */