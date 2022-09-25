section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0
	
	; save these 3 registers
	push ebx
	push edi
	push esi

	mov ecx, [ebp + 8] ; length of the array
	mov ebx, [ebp + 12] ; array of nodes

for_nodes:
	;search the ecx node
for:
	cmp ecx, dword[ebx]
	je found
	add ebx, 8
	jmp for
found:
	;search the ecx-1 node
	dec ecx
	mov eax, dword[ebp + 12]
for2:
	cmp ecx, dword[eax]
	je found2
	add eax, 8
	jmp for2
found2:
	mov dword[eax + 4], ebx ; assign next value
	mov ebx, [ebp + 12] ; reset the array for next search
	cmp ecx, 0
	jg for_nodes

	;find the head of the list
	mov ecx, 1
	mov eax, dword[ebp + 12]
for3:
	cmp ecx, dword[eax]
	je out
	add eax, 8
	jmp for3

out:
	; restore the 3 registers saved at the start
	pop esi 
	pop edi
	pop ebx

	leave
	ret
