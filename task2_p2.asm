section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	; save the main ebp
	push ebp

	; ignore old epb and return addr -> +8
	add esp, 8
	
	pop ecx ; string length is stored in ecx
	pop ebx ; string is stored in ebx
	
	; jump to local variable space on the stack
	sub esp, 16

	; if all paranthesis match the answer is 1
	push 1
	; index edi=0 to iterate through ebx string
	xor edi, edi

	; main idea:
	; -> '(' push 0
	; -> ')' pop 
	; if paranthesis don't match at some point eax will get 0
for:
	cmp byte[ebx], '('
	je open_paranthesis
	jmp close_paranthesis
open_paranthesis:
	push 0
	jmp next_instruction
		
	; if there are more ')' it will pop the 1 that is for good answer
	; but since for has not been completed it means that the output
	; should be 0 so eax should be decremented
close_paranthesis:
	pop eax
	cmp eax, 1
	je bad_output
next_instruction:
	inc edi
	add ebx, 1
	cmp ecx, edi
	jg for

	; get that 1 if everythink went smoothly
	pop eax
	jmp out
bad_output:
	dec eax
out:
	pop ebp
	ret
