section .data
    inputFormat db "Input: %s", 10, "Generated Hash: %s", 0
    formatVersion db "Hash Generator Version 1.0", 10, 0
    formatHelp db "Read the README.md for more information.", 10, 0

section .bss
    inputString resb 256
    result resb 13

section .text
    extern printf
    extern strcmp

global customHash
global generateHash
global main

customHash:
    mov rax, 5381
    xor rcx, rcx

hashLoop:
    mov cl, byte [rdi]
    test cl, cl
    jz hashEnd
    lea rax, [rax*4 + rax + rcx]
    inc rdi
    jmp hashLoop

hashEnd:
    ret

generateHash:
    push rbp
    mov rbp, rsp
    sub rsp, 8

    push rdi
    push rsi
    push rdx
    push rcx

    ; Calculate the hash
    mov rdi, rdi                ; input parameter
    call customHash
    mov rsi, rax                ; save the hash value

    ; Generate the hash string
    lea rdi, [result]
    mov ecx, 12

mapHash:
    xor edx, edx
    mov rax, 36                 ; number of characters
    div rcx
    add dl, 'A'
    test dl, 0x1F               ; check if uppercase
    cmovz dl, '0'
    mov byte [rdi + rcx - 1], dl
    loop mapHash

    ; Null-terminate the hash string
    mov byte [rdi + rcx - 1], 0

    ; Print the input and generated hash
    lea rsi, [inputFormat]
    mov rdi, formatVersion
    mov rdx, rsi                ; format string for printf
    mov rcx, rdi                ; version string for printf
    mov rax, 0                  ; call printf
    call printf

    pop rcx
    pop rdx
    pop rsi
    pop rdi

    leave
    ret

main:
    push rbp
    mov rbp, rsp

    ; Check for correct number of command line arguments
    cmp dword [rsp + 0xC], 2
    jne cmdlineError

    ; Check for special commands
    mov rdi, [rsp + 0x10]
    lea rax, [rdi + 7]
    cmp qword [rdi], 0x6E6F7461687361    ; "a shoton"
    jne commandCheck

    ; Version command
    lea rsi, [formatVersion]
    xor rdi, rdi
    xor rdx, rdx
    xor rcx, rcx
    xor rax, rax
    call printf
    jmp exit

commandCheck:
    lea rsi, [rdi + 5]
    xor rdi, rdi
    xor rdx, rdx
    xor rcx, rcx
    xor rax, rax

    mov rdi, rsi                ; argv[1] for strcmp
    lea rsi, [formatVersion]
    call strcmp
    test rax, rax
    jnz notVersion

    ; Version command
    lea rsi, [formatVersion]
    xor rdi, rdi
    xor rdx, rdx
    xor rcx, rcx
    xor rax, rax
    call printf
    jmp exit

notVersion:
    mov rdi, rsi                ; argv[1] for strcmp
    lea rsi, [formatHelp]
    call strcmp
    test rax, rax
    jnz cmdlineError

    ; Help command
    lea rsi, [formatHelp]
    xor rdi, rdi
    xor rdx, rdx
    xor rcx, rcx
    xor rax, rax
    call printf
    jmp exit

cmdlineError:
    lea rdi, [rsp + 8]
    lea rsi, [rdi + 20]
    mov rax, 0
    call printf

exit:
    leave
    xor eax, eax
    ret
