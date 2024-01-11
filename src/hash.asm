section .data
    hash_value dd 5381     ; Инициализация значения хеша

section .text
    global _start

_start:
    ; Получение аргумента командной строки
    mov eax, [esp + 4]     ; argv[0] - адрес программы, argv[1] - адрес аргумента

    ; Инициализация регистров
    mov esi, eax           ; esi - указатель на строку (аргумент)

hash_loop:
    movzx eax, byte [esi] ; Загрузка ASCII-значения символа в eax
    test al, al            ; Проверка на конец строки (нулевой символ)
    jz  hash_done          ; Если конец строки, завершаем цикл

    ; Обновление хеша по формуле: hash = ((hash << 5) + hash) + c
    shl dword [hash_value], 5
    add dword [hash_value], eax
    add dword [hash_value], eax

    inc esi                ; Переход к следующему символу
    jmp hash_loop

hash_done:
    ; Преобразование значения хеша в строку из 12 символов
    mov eax, [hash_value]
    mov ebx, 10            ; Для деления на 10 (получение остатка и частного)
    mov ecx, 12            ; Длина строки

convert_loop:
    xor edx, edx
    div ebx                ; edx:eax / ebx -> eax - частное, edx - остаток

    ; Преобразование остатка в ASCII и сохранение в обратном порядке
    add dl, '0'
    dec ecx
    mov [esi + ecx], dl

    ; Проверка на завершение преобразования
    test eax, eax
    jnz convert_loop

    ; Вывод хеш-значения
    mov eax, 4
    mov ebx, 1
    lea ecx, [esi]         ; Указатель на строку
    mov edx, 12            ; Длина строки
    int 0x80

    ; Завершение программы
    mov eax, 1
    xor ebx, ebx
    int 0x80
