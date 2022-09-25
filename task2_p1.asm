section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	; save the main ebp
	push ebp

	; ignore old epb and return addr -> +8
	add esp, 8

	; extract a and b, and save them for later operations since a and b
	; will be destroyed during the cmmdc algorithm.
	pop ebx
	push ebx
	add esp, 4
	pop ecx
	push ecx

	;cmmdc algorithm
while:
	cmp ecx, ebx
	jl lower
	jg upper
	je out
lower:
	sub ebx, ecx
	jmp next
upper:
	sub ecx, ebx
next:
	jmp while
out:
	; cmmdc result is saved in ecx
	; extract unchanged a and b
	sub esp, 4
	pop eax
	pop ebx
	
	; solve cmmmc = (a*b)/x
	imul ebx; edx:eax (a*b)
	idiv ecx

	; go back to main's ebp
	sub esp, 16
	pop ebp

	ret
