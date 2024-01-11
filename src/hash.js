// main.js

const generateHash = require('./hashGenerator');

const inputString = process.argv[2];

if (!inputString) {
    console.log('Syntax: node main.js <input_string>');
    process.exit(1);
}

// Check for special commands
if (inputString === 'version') {
    console.log('Hash Generator Version 1.0');
} else if (inputString === 'help') {
    console.log('Read the README.md for more information.');
} else {
    // Generate and print the hash for the input string
    const { input, hash } = generateHash(inputString);
    console.log(`Input: ${input}\nGenerated Hash: ${hash}`);
}
