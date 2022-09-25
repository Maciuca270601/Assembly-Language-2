global get_words
global compare_func
global sort

section .text
extern qsort
extern strcmp

compare:
    enter 0, 0

    ; save these 3 registers
    push ebx
    push esi
    push edi

    mov edx, dword[ebp + 8] ; first string address
    
    mov ecx, dword[edx] ; first string 
    xor eax, eax ; counter for strlen function
    xor edx, edx ; for saving different [bytes]characters
my_strlen1:
    mov dl, byte[ecx]
    test dl, dl ; test if char is null
    je my_strlen1_end
    inc ecx
    inc eax
    jmp my_strlen1
my_strlen1_end:
    push eax ; save first string size
    mov edx, dword[ebp + 12] ; second string address
    mov ecx, dword[edx] ; second string
    xor eax, eax ; counter for strlen function
    xor edx, edx ; for saving different [bytes]characters

my_strlen2:
    mov dl, byte[ecx]
    test dl, dl ; test if char is null
    je my_strlen2_end
    inc ecx
    inc eax
    jmp my_strlen2
my_strlen2_end:
    pop ecx ; get first string size
    sub ecx, eax ; compare the sizes
    mov eax, ecx ; compare result is saved in eax

    cmp eax, 0 ; if strings were identical
    je sort_lexicographically
    jmp end_compare
sort_lexicographically:
    mov edx, dword[ebp + 12]
    mov ecx, dword[edx] ; first string
    push ecx ; push param for strcmp
    mov edx, dword[ebp + 8]
    mov ecx, dword[edx] ; second string
    push ecx ; push param for strcmp
    call strcmp ; call strcmp and result is saved in eax
    add esp, 8
end_compare:
    ; restore these 3 registers
    pop edi 
    pop esi
    pop ebx

    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0

    ; save these 3 register
    push ebx
    push edi
    push esi

    mov edx, dword[ebp + 8] ; array of words
    mov ecx, dword[ebp + 12] ; number of words
    mov eax, dword[ebp + 16] ; words size

    push compare ; push compare function for qsort
    push eax ; push words size for qsort
    push ecx ; push number of words for qsort
    push edx ; push array of words for qsort
    call qsort
    add esp, 16

    ; restore these 3 registers
    pop esi
    pop edi
    pop ebx

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

    ; save these 3 registers
    push ebx
    push esi
    push edi

    mov ebx, dword[ebp + 8] ; text
    mov edx, dword[ebp + 12] ; array of words
    mov ecx, dword[ebp + 16] ; number of words

    mov esi, 1 ; counter for words

    ; get word from array of words
    mov edi, dword[edx]
for:
    ;compare to comma
    cmp byte[ebx], ','
    je jump_char

    ;compare to space
    cmp byte[ebx], ' '
    je next_word
        
    ;compare to point
    cmp byte[ebx], '.'
    je jump_char

    ;compare to newline
    cmp byte[ebx], 10
    je jump_char

    ;compare to nullterminator
    cmp byte[ebx], 0
    je end

    ;transfer character
    mov al, byte[ebx]
    mov byte[edi], al
    ;get to next char
    add edi, 1
    add ebx, 1
    jmp compare_again

next_word:
    ;move to next word in words
    add edx, 4
    mov edi, dword[edx]
    ;jump over separator for next word
    add ebx, 1
    inc esi
    jmp compare_again
jump_char:
    add edi, 1
    add ebx, 1
compare_again:
    cmp esi, ecx
    jle for
end:
    ; restore those 3 registers
    pop edi
    pop esi
    pop ebx

    leave
    ret
