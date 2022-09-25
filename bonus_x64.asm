section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	enter 0, 0
	
	; function should save these 3 registers
	push rbx
	push rdi
	push rsi

	; getting param from function signature
	mov qword[rbp - 8], rdi ; int *v1
	mov dword[rbp - 12], esi ; int n1
	mov qword[rbp - 20], rdx ; int *v2
	mov dword[rbp - 24], ecx ; int n2
	mov qword[rbp - 32], r8 ; int *v

	mov r10, 0 ; int i = 0 (traverse both *v1, *v2)
	mov r11, 0 ; int j = 0 (traverse *v)	
	
	; int dif = n1 - n2
	mov eax, dword[rbp - 12]
	sub eax, dword[rbp - 24]
	cmp eax, 0
	
	jle else
	jmp while1

add_elements1:
	lea rcx, [0 + r10 * 4] ; convert i index for int
	mov rax, qword[rbp - 8] ; rax = *v1
	add rax, rcx ; rax = *(v1 + i)
	lea rcx, [0 + r11 * 4] ; convert j index for int
	mov rdx, qword[rbp - 32] ; rdx = *v
	add rdx, rcx ; rdx = *(v + j)
		
	; v[j] = v1[i]
	mov eax, dword[rax]
	mov dword[rdx], eax

	;j++ for next add
	add r11, 1

    lea rcx, [0 + r10 * 4] ; convert i index for int
	mov rax, qword[rbp - 20] ; rax = *v2
	add rax, rcx ; rax = *(v2 + i)
    lea rcx, [0 + r11 * 4] ; convert j index for int
	mov rdx, qword[rbp - 32] ; rdx = *v
	add rdx, rcx ; rdx = *(v + j)

	; v[j] = v2[i]
	mov eax, dword[rax]
	mov dword[rdx], eax

	; j++, i++
	add r10, 1
	add r11, 1
while1:
	mov eax, dword[rbp - 24]
	movsx rax, eax
	cmp r10, rax ; while i < n2
	jl add_elements1
	jmp while2

add_the_rest1:
	lea rcx, [0 + r10 * 4] ; convert i for int
	mov rax, qword[rbp - 8] ; rax = *(v1)
	add rax, rcx ; rax = *(v1 + i) 
	lea rcx, [0 + r11 * 4] ; convert j for int
	mov rdx, qword[rbp - 32] ; rdx = *(v)
	add rdx, rcx ; rdx = *(v + j)

	; v[j] = v1[i]
	mov eax, dword[rax]
	mov dword[rdx], eax

	; j++, i++
	add r10, 1
	add r11, 1
while2:
	mov eax, dword[rbp - 12]
	movsx rax, eax
	cmp r10, rax ; while i < n1
	jl add_the_rest1
	jmp end

else:
add_elements2:
	lea rcx, [0 + r10 * 4] ; convert i for int
	mov rax, qword[rbp - 8] ; rax = *(v1)
	add rax, rcx ; rax = *(v1 + i) 
	lea rcx, [0 + r11 * 4] ; convert j for int
	mov rdx, qword[rbp - 32]; rdx = *(v)
	add rdx, rcx ; rdx = *(v + j)

	; v[j] = v1[i]
	mov eax, dword[rax]
	mov dword[rdx], eax

	; j++
	add r11, 1

	lea rcx, [0 + r10 * 4] ; convert i for int
	mov rax, qword[rbp - 20] ; rax = *(v2)
	add rax, rcx ; rax = *(v2 + i)
	lea rcx, [0 + r11 * 4] ; convert j for int
	mov rdx, qword[rbp - 32] ; rdx = *(v)
	add rdx, rcx ; rdx = *(v + j)
			
	; v[j] = v2[i]
	mov eax, dword[rax]
	mov dword[rdx], eax

	; j++, i++
	add r10, 1
	add r11, 1
while3:
	mov eax, dword[rbp - 12]
	movsx rax, eax
	cmp r10, rax ; while i < n1
	jl add_elements2
	jmp while4

add_the_rest2:
	lea rcx, [0 + r10 * 4] ; convert i for int
	mov rax, qword[rbp - 20] ; rax = *(v2)
	add rax, rcx ; rax = *(v2 + i)
	lea rcx, [0 + r11 * 4] ; convert j for int
	mov rdx, qword[rbp - 32] ; rdx = *(v)
	add rdx, rcx ; rdx = *(v + j)

	; v[j] = v2[i]
	mov eax, dword[rax]
	mov dword[rdx], eax

	; j++, i++
	add r10, 1
	add r11, 1
while4:
	mov eax, dword[rbp - 24]
	movsx rax, eax
	cmp r10, rax ; while i < n2
	jl add_the_rest2	
end:
	; restore the 3 registers that have been saved at the start of the function
	pop rsi
	pop rdi
	pop rbx

	leave
	ret
