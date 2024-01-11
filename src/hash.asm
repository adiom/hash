section .data
    characters db "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"  ; разрешенные символы для хеширования
    hello db "Hello, World!", 0

section .text
    global generateHash
    extern printf

generateHash:
    ; Входные параметры:
    ;   rdi - указатель на входную строку

    ; Инициализация хеша
    mov eax, 5381
    xor rdx, rdx  ; rdx будет использоваться для итерации по строке

hashLoop:
    movzx ecx, byte [rdi + rdx]  ; загрузка очередного символа строки в ecx
    test ecx, ecx
    jz hashDone  ; если символ нулевой, завершаем цикл

    ; Вычисление нового хеша
    imul eax, eax, 33
    add eax, ecx

    ; Увеличение индекса строки
    inc rdx
    jmp hashLoop

hashDone:
    ; Генерация хеша из символов
    mov ecx, 12  ; количество символов в хеше
    lea rdi, [rdi + 12]  ; rdi будет использоваться для хранения указателя на результат

charMapLoop:
    dec rdi  ; двигаемся в обратном порядке по результату
    xor rdx, rdx
    div ecx  ; деление eax на ecx, остаток будет использоваться как индекс символа

    ; Помещение символа в результат
    mov al, [characters + rdx]
    mov [rdi], al

    ; Проверка окончания генерации
    test eax, eax
    jnz charMapLoop

    ; Добавление завершающего нулевого байта
    mov byte [rdi], 0

    ; Вывод результата
    mov rdi, formatString
    lea rsi, [hello]  ; используем rsi для указателя на входную строку
    call printf

    ret

section .data
    formatString db "Input: %s\nGenerated Hash: %s\n", 0

section .text
    global main

main:
    ; вызов функции generateHash с аргументом "Hello, World!"
    lea rdi, [hello]
    call generateHash

    ; выход из программы
    mov rax, 60         ; системный вызов exit
    xor rdi, rdi        ; код возврата 0
    syscall
